<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="1.0"
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:user="urn:my-scripts">

	<!-- El prefijo msxsl está enlazado al identificador URI del espacio de nombres urn:schemas-microsoft-com:xslt, -->
	<!-- por esto se incluye la declaración de este espacio de nombres --> 
	<!-- El espacio de nombres xmlns:user="urn:my-scripts" se declara para tener un espacio de nombre -->
	<!-- donde definir las funciones propias -->
		
	<!-- Al utilizar el elemento msxsl:script, se recomienda que el script se coloque dentro de -->
	<!-- una sección CDATA, puesto que puede contener operadores, identificadores o delimitadores, -->
	<!-- que podrán interpretarse erróneamente como XML. -->
	<msxsl:script language="JScript" implements-prefix="user">
	<![CDATA[
    var count = 0;
	function increment(pInitialize) {
		if(pInitialize == 'true'){
			count = 0;
		}
		else{
			count++;
		}
		return count;
	}
	]]>
	</msxsl:script>

<xsl:output method="html"/> 

<!--========================================================================-->
<!-- Reemplazo cadenas                                                      -->
<xsl:variable name="escape" select='&apos;\&apos;' />
<xsl:variable name="doblequote" select='&apos;"&apos;' />
<xsl:variable name="maxCountLines" select="8" />

<xsl:template name="ReplaceString">
  <xsl:param name="outputString"/>
  <xsl:param name="target"/>
  <xsl:param name="replacement"/>
  <xsl:choose>
    <xsl:when test="contains($outputString,$target)">
   
      <xsl:value-of select=
        "concat(substring-before($outputString,$target),
               $replacement)"/>
      <xsl:call-template name="ReplaceString">
        <xsl:with-param name="outputString" 
             select="substring-after($outputString,$target)"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replacement" 
             select="$replacement"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$outputString"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<!--FIN Reemplazo cadena -->
<!--========================================================================-->


<!--========================================================================-->
<!-- M�dulo principal. -->
<xsl:template match="*">
    <!-- Aplicación del template Data.-->
    <xsl:apply-templates select="Data"></xsl:apply-templates>	
    <!-- FIN Aplicación del template Data.-->

    <!-- Aplicación del template Task.-->
    <xsl:apply-templates select="Task"></xsl:apply-templates>
    <!-- FIN Aplicación del template Task.-->

    <!-- Aplicación del template Error.-->
    <xsl:apply-templates select="Error"></xsl:apply-templates>
    <!-- FIN Aplicación del template Error.-->

</xsl:template>
<!-- FIN Módulo principal.                                                  -->
<!--========================================================================-->


<!--========================================================================-->
<!-- Template Data. Primera pantalla para selección de trámites.            -->
<xsl:template match="Data">
	
	<LINK href="lib/css/CENTROHOSPUCE-MultiLevelLineSelectionBase.css" type="text/css" rel="stylesheet"></LINK>						

    <!--========================================================================-->
    <script language="javascript" src="lib/js/build/yuiloader/yuiloader-min.js" type="text/javascript"></script>
	<script language="javascript" src="lib/js/jQuery/jquery-1.9.1.js" type="text/javascript"></script>
	<script language="javascript" src="lib/js/build/SSUI/UtilityText.js" type="text/javascript"></script>
    <script language="javascript" src="lib/js/build/SSUI/General-Loader.js" type="text/javascript"></script>
    <script language="javascript" src="lib/js/build/SSUI/TouchScreen-Loader.js" type="text/javascript"></script>
	<script language="javascript" type="text/javascript" src="lib/js/build/SSUI/Json2.js"></script>
	<script language="javascript" src="lib/js/build/SSUI/CENTROHOSPUCE-MultiLevelLineSelection-Loader.js" type="text/javascript"></script>	
		
    <xsl:if test="//VMStyleSheetPath">
        <LINK  type="text/css" rel="stylesheet"><xsl:attribute name="href"><xsl:value-of select='//VMStyleSheetPath'/></xsl:attribute></LINK>
    </xsl:if>
    <!--========================================================================-->
    
    <!-- Funciones JScript de la página.-->
    <script languaje="javascript">
    	
        var mTTL = <xsl:value-of select='//TTL'/>;
        var postbackMark = '';
        var callback = null; // Para el manejo de la respuesta del servidor por parte de YAHOO.util.Connect.asyncRequest.
       <xsl:if test="//ModelView">	
		    var mConfiguration = <xsl:value-of select='//ModelView' />;

		</xsl:if>
		 <xsl:if test="not(//ModelView)">	
			// Formacion de objeto con fomato JSON para simular el comportamiento con modelo
			
			// Configuracion de valores fijos 
			var mLineFormat1 = '{ "AbstractLineDes":  "",  "AbstractLineId":  "",  "ClientTypes": null,  "ConstraintCode":  "NULL",  "ConstraintDes":  "Ninguna",  "ConstraintOrder":  "1",  "CustomValue": null,  "IsPublic":  "True",  "LineAlias":  "",  "LineDes":  ';
			var mLineFormat7 = '"LineId":';
			var mLineFormat2 = '"Mu":  "",  "OpenTime":  "", "Parameters": {"Parameter": { "name":  "OrientationMessage" } },  "SectionLineSortOrder":  "1",  "SortOrder":  ';
			var mLineFormat5 = '}';
			var mLineFormatIdFinal = '';
			var mPreChain1 = '{ "ModelView": { "Groups": null, "Lines": 	{ "Line": [ ';
			var mPreChain2 = '] },  "ModelViewId":  "0" }}';
			
			<xsl:for-each select="//Line">
				// Obtencion de valores de tramite 
				var mLineId= <xsl:value-of select="LineId" />;
				var mSortOrder= <xsl:value-of select="SortOrder" />;
				var mLineDes = '<xsl:value-of select="LineDes" />';
				mLineFormat3 = '"' + mLineId + '",';
				mLineFormat4 = '"' + mSortOrder + '"';
				mLineFormat6 = '"' + mLineDes + '",';
				
				// Formacion de cadena conteniendo al tramite con formato JSON
				mLineFormatIdFinal =  mLineFormatIdFinal + mLineFormat1 + mLineFormat6 + mLineFormat7 + mLineFormat3 + mLineFormat2 + mLineFormat4 + mLineFormat5 + ",";
					
			</xsl:for-each>	
			
			 // se retire el ultimo caracter para que quede bien formada la cadena
			 mLineFormatIdFinal= mLineFormatIdFinal.substr(0,mLineFormatIdFinal.length -1);
			 // Se arma la cadena completa 
			 mConfiguration = mPreChain1+mLineFormatIdFinal+mPreChain2;
			 // se parsea la cadena para que se tome como un objeto con formato JSON
			 mConfiguration = JSON.parse(mConfiguration);
			 
			
		 </xsl:if>
           
            // ========================================================================
            //VARIABLES DE CONFIGURACIón DEL MODELO DE VISUALIZACION
            // ========================================================================
            // cSELECTLINE_TYPE
            // Indica el tipo de seleccion de tramites
            // valores: 
            // singleline : Permite la seleccion de un solo trámite
            // multiline  : Permite la seleccion de mas de un tramite
            var cSELECTLINE_TYPE = "singleline"; 
            // ========================================================================

            // cSHOW_PRINTBUTTON
            // Indica si se incluye el boton  "IMPRIMIR TICKET" (Tiene validez solo para funcionamiento monotramite)
            // valores:
            // true  : Se muestra el boton y se imprime el ticket a traves del mismo
            // false : No se muestra el boton y se imprime cuando se hace click en el tramite
            var cSHOW_PRINTBUTTON = false; 
            // ========================================================================
        
        <!-- Se coloca el código JScript dentro de un CDATA para simplificar su sintaxis -->

        <![CDATA[
                
	        // Inicializa la pagina.
            function pageInit() {
			  
				Glass.hidden();
			
			    SSUI_GENERAL_LOADER.setBase("./lib/js/build/");
			    // Declara la funcion onSuccess global a todos los modulos cargados
			    SSUI_GENERAL_LOADER.registerOnSuccess(pageLoad);
			    // Inserta los modulos
			    SSUI_GENERAL_LOADER.insert();
							
			 }
			 
			function pageLoad() {
			
				if (mPCActive != false) {
					try {
						SSUI.uicontrols.uicontrol.printerStatus.checkStatus();
					} catch (bEx) {
						// No hace nada, puesto que no puede provocar errores
					}
			    }
				window_onload();
			}

            // Ejecución cuando se carga la página.
	        function window_onload()
	        {  
			
	        	Glass.show();
						
	            document.onselectstart=function()
				{
					return false;
				}
				// establecemos la información de QA
				setQualityAssuranceFullData(getUrlParamValue("FullData"));
				//Traido de Profamilia    
				var mClientTypeId = getUrlParamValue("ClientTypeId");
				if (mClientTypeId != ""){
					renderTouchByClientTypeId(mClientTypeId);
				}
				else{
					renderTouchByClientTypeId(0);
				}
				Glass.hidden();

            }

            // Realización del submit del formulario.
            function doSubmit() {
		        if (!hasClicked) // Control de Doble Submit.
		        {
			        hasClicked = true;
			        getElementById('Touchscreen2').submit();
		        }
            }
            
            // Marca la variable postbackMark para indicar que es un postback
            function markPostback() {
                 postbackMark = '*';
            }
            
            function getElementById(aID){ 
               return YAHOO.util.Dom.get(aID);
            }
            
            function checkSessionClose() {
            
                if (postbackMark != '*' && mInFrame == false)
                {
                    YAHOO.util.Connect.asyncRequest('GET', './CerrarTurnoAuto.aspx', callback, null);
                }
            }
			
			/**
			  * Obtiene el valor de un parametro de la URL
			  */
			function getUrlParamValue(pParamName){
			
				var mParamValue = new String();
				var mFound = false;
				var mIndex = 0;
				
				// si existen parametros
				if(location.search.substr(1) != ""){
				
					// obtenemos un array con los parametros
					var mArrayParams = location.search.substr(1).split("&");
					
					while(mIndex < mArrayParams.length &&
						  !mFound)
					{
						// si el nombre del parametro es igual al nombre buscado
						if(mArrayParams[mIndex].split("=")[0] == pParamName)
						{
							mParamValue = mArrayParams[mIndex].split("=")[1];
							mFound = true;
						}
						
						mIndex++;
					}
				}
				
				return mParamValue;
			}
			
			
			/**
			  * Recupera la informacion de QA si existe
			  */
			function setQualityAssuranceFullData(pFullData){
				
				getElementById("QualityAssuranceEmissionFullData").value = pFullData;
			};
			
			/**
			  * Captura el inicio de la emision
			  */
			function setQualityAssuranceEmissionStart()
			{
				var mDate = new Date();
				var mString = new String();
				
				//	Al mes se le suma uno pues inicia en cero
				mString = mDate.getFullYear() + "/" + (mDate.getMonth()+1) + "/" + mDate.getDate() + " " + mDate.getHours() + ":" + mDate.getMinutes() + ":" + mDate.getSeconds() + "." + mDate.getMilliseconds();
				
				getElementById("QualityAssuranceEmissionStart").value = mString;
			};
			function renderTouchByClientTypeId(pClientTypeId){

				// instanciamos el presentador
				var mCurrentModelViewPresenter = new YAHOO.uicontrols.emission.utils.Presenter();
				// inicializamos el touchscreen
				YAHOO.uicontrols.emission.Touchscreen.init(mConfiguration.ModelView, 
														   mCurrentModelViewPresenter, 
														   cSELECTLINE_TYPE, 
														   cSHOW_PRINTBUTTON, 
														   mEmissionPage,
														   pClientTypeId);
				// renderizamos el touch
				YAHOO.uicontrols.emission.Touchscreen.render();		
			}
        ]]>

	</script>
    <!-- FIN Funciones JScript de la página.-->

    <!-- Dibujo de la página propiamente dicho.-->
   
	<body MS_POSITIONING="GridLayout" 
	      onload="pageInit();"
	      onbeforeunload="checkSessionClose();"
		  class="dvTouchScreenClass">
	     
        <form id="Touchscreen2" action="TouchScreen.aspx" method="post">
            <!-- Datos de control de calidad -->
			<input name="QualityAssuranceEmissionStart" id="QualityAssuranceEmissionStart" type="hidden"/>
			<input name="QualityAssuranceEmissionFullData" id="QualityAssuranceEmissionFullData" type="hidden"/>
			<input type="hidden" name="ClientTypeId" id="ClientTypeId"></input>
            <!-- Aplicación del template //Data/DTE.-->
	        <xsl:apply-templates select="//Data/DTE">
	        </xsl:apply-templates>
	        <!-- FIN Aplicación del template //Data/DTE.-->
	        
	        <!-- FIN Aplicación del template //Data/DTE.-->
		<div id="dvBodyTask" style="WIDTH:100%;HEIGHT:100%"></div>
	    </form>
		<!-- Pre carga de imagenes -->
		<div class="LineBaseDown" style="display:none;"></div>
		<div class="AcceptDown" style="display:none;"></div>
    </body>
<script language="javascript" src="lib/js/build/SSUI/UtilityGlass.js" type="text/javascript"></script>

</xsl:template>	
<!-- FIN Template Data. Primera pantalla para selección de trámites.        -->
<!--========================================================================-->



<!--========================================================================-->
<!-- Template //Data/DTE.                                                   -->
<xsl:template match="//Data/DTE">
    <xsl:if test="ViewTypeCode = 2">
        <input type="hidden" name="SectionId" id="SectionId">
            <xsl:attribute name="value">
                <xsl:value-of select="ProcessTemplates/ProcessTemplate/SectionId" />
            </xsl:attribute>
        </input>
    </xsl:if>
</xsl:template>
<!-- FIN Template //Data/DTE.                                               -->
<!--========================================================================-->



<!--========================================================================-->
<!-- Template Task. Pantalla de información al usuario e impresión.         -->
<xsl:template match="Task">		
    
    <style type="text/css">
        .texto {
            font-family: "Trebuchet MS", Tahoma, Arial, Helvetica;
            font-size: 26px;
            color: #000000;
        }
    </style>
    
    <!-- Funciones JScript de la página.-->
    <script language="javascript" src="NCRPrinterConstants.js"></script>
	<script language="javascript">
	
		/**
		  * Inicializa los formateadores que se van a sobreescribir
		  */
		function initFormatter(){	
		
			this.FormmaterEstimatedDelay = function(){
				
				/**
				  * Constructor
				  */
				{
					//Llamamos al constructor de la superclase
					this.constructor.superclass.constructor.call(this);
				}

				this.getFormatterPrintLine = function(pLegend){
					return "Espera aproximada: " +  Math.ceil(pLegend/60) + " min.";
				}
			};	
			
			// Implementa herencia
			SSUI.lang.extend(this.FormmaterEstimatedDelay, 
							 SSUI.uicontrols.uicontrol.AbstractFormatterPrintLine);
							 
		    /**
        * Formateador de Logo
        */
        this.FormmaterLogo = function () {
            // Logo
            // Nota: La ruta de la imagen debe ser local
            // Atencion: No se permiten imagenes TIFF o PNG
            // Cuando se indique el path de acceso las "\" deben cambiarse por "\\", caso contrario se produce un error
            var LOGO_PATH = "C:\\Sidesys\\e-flow\\view_configuration\\CENTROHOSPUCE\\images\\logo-ticket.bmp";
			  var LOGO_X = 350;
			  var LOGO_Y = 50;
			  var LOGO_WIDTH = 3500;
			  var LOGO_HEIGHT = 1150;


            /**
            * Constructor
            */
            {
                //Llamamos al constructor de la superclase
                this.constructor.superclass.constructor.call(this);
            }

            this.getPrintParams = function (pPrintKind) {
                var mPrintParams;

                if (pPrintKind == "NCR") {
                    // creamos el objeto que contiene los parametros para la impresora NCR
                    mPrintParams = new SSUI.uicontrols.uicontrol.PrintNCRParams();
                    mPrintParams.setPrintData(LOGO_PATH);
                    mPrintParams.setStation(PTR_S_RECEIPT);
                    mPrintParams.setWidth(PTR_BM_ASIS);
                    mPrintParams.setAlignment(PTR_BM_CENTER);
                }
                else if (pPrintKind == "Standard") {
                    // creamos el objeto que contiene los parametros para el Logo
                    mPrintParams = new SSUI.uicontrols.uicontrol.PrintStandardParams();
                    mPrintParams.setPrintData(LOGO_PATH);
                    mPrintParams.setLogoX(LOGO_X);
                    mPrintParams.setLogoY(LOGO_Y);
                    mPrintParams.setWidth(LOGO_WIDTH);
                    mPrintParams.setHeight(LOGO_HEIGHT);
                }

                return mPrintParams;
            }

        }

        // Implementa herencia
        SSUI.lang.extend(this.FormmaterLogo,
      SSUI.uicontrols.uicontrol.AbstractFormatterPrintLine);
	  
		/**
		  * Formateador de OrganizationDes
		  */  
		this.FormmaterOrganizationDes = function(){
			/**
			  * Constructor
			  */
			{
				//Llamamos al constructor de la superclase
				this.constructor.superclass.constructor.call(this);
			}
			/**
			  * Devuelve la leyenda formateada
			  */
			this.getFormatterPrintLine = function(pLegend){
				
				return "Centro Hospitalario";
			};
			/**
			  * Agrega leyendas anteriores a la linea
			  */
			this.addAfterLine = function(pLinesArray){
				pLinesArray[pLinesArray.length] = new String();
			};
			/**
			  * Devuelve la leyenda formateada
			  */
			this.getFontStyle = function(){		
				
				var mNormalFontStyle = this.iFontStyleManager.getFontStyle(cHEADER_STYLE);
				mNormalFontStyle.setFontSize(14);
				return mNormalFontStyle;
			};
					
		}
		// Implementa herencia
		SSUI.lang.extend(this.FormmaterOrganizationDes, 
				 SSUI.uicontrols.uicontrol.AbstractFormatterPrintLine);		
			
		}
		
	</script>
    <!-- <script language="javascript" type="text/javascript" src="../lib/js/build/yahoo-dom-event/yahoo-dom-event.js"></script> -->
    <script language="javascript">
        // Este parametro determina el tipo de impresion, valores posible
		// "PrintStandard" para impresion estandar 
		// "PrintNCR" para impresion con impresora NCR
		var mPrintKind = "<xsl:value-of select="Ticket/Printer/Type"/>";		
		var mAborted   = <xsl:value-of select="Ticket/Printer/AbortOnError"/>;
		
		var mDeviceName = "<xsl:value-of select="PrinterName"/>";
		var mTTL        = "<xsl:value-of select="TTL" />";
		
		// Ancho del ticket
		var cPAGE_WIDTH = 4100;
		
		var mOrganizationCode   = 	"<xsl:call-template name="ReplaceString">
										<xsl:with-param name="outputString" select="OrganizationCode"/>
										<xsl:with-param name="target" select="$doblequote"/>
										<xsl:with-param name="replacement" select="concat($escape,$doblequote)"/>
									</xsl:call-template>";		
		var mTaskId				= "<xsl:value-of select="TaskId" />";		
		var mDate				= "<xsl:value-of select="Fecha" />";		
		var mLineInscription;
		
		// Datos utilizados para configurar el ticket.
		var cPRINTING_CONFIGURATION = {	pageWidth		         : cPAGE_WIDTH,
										printKind		         : mPrintKind,
										deviceName				 : mDeviceName
									  }
									  
        // QA
		var mQAEmissionStart	= new String("<xsl:call-template name="ReplaceString">
			                                    <xsl:with-param name="outputString" select="QAEmissionStart"/>
			                                    <xsl:with-param name="target" select="$doblequote"/>
			                                    <xsl:with-param name="replacement" select="concat($escape,$doblequote)"/>
		                                     </xsl:call-template>");
		var mQAEmissionEnd = new String();
		
		var mPintLineArray = new Array();
		
		// para cada linea del modelo del ticket
		<xsl:for-each select="Ticket/Visualization/Line">
			
			var mPrintLineValue = new Array();
			
			// obtenemos el codigo de la linea y lo establecemos en una variable xsl
			<xsl:variable name="code"><xsl:value-of select="Text/Parameters/Parameter/@Code" /></xsl:variable>
			
			<xsl:for-each select="Text/Parameters/Parameter[@Code=$code]/Values/Value">
			
				// obtenemos los valores de la linea
				mPrintLineValue[mPrintLineValue.length] = '<xsl:value-of select="." />';
			
			</xsl:for-each>
			
			// creamos la linea de impresion
			var mPrintLine = {printLineCode: '<xsl:value-of select="Text/Parameters/Parameter/@Code" />',
							  printLineValue: mPrintLineValue,
							  printLineOrder: '<xsl:value-of select="@Order" />'};
			
			// agregamos la linea de impresion a la lista
			mPintLineArray[mPintLineArray.length] = mPrintLine;
			
        </xsl:for-each>
		
        <!-- Se coloca el código JScript dentro de un CDATA para simplificar su sintaxis -->

        <![CDATA[
			
            /**
			  *	Imprime el ticket
			  */
            function printTicket()
            {
				try
				{
					try
					{
						// creamos la instancia de impresion NCR
						var mPrinting = new SSUI.uicontrols.uicontrol.PrintManager(cPRINTING_CONFIGURATION);
					
					}catch(bError)
					{
						throw new Error("Error al crear Objeto de impresión");
					}
					
					// obtenemos el maneger de estrategias de formatos
					var mFormatterStrategiesManager = new SSUI.uicontrols.uicontrol.FormatterStrategiesManager();
					
					
					// obtenemos los objeto que contiene los formateadores a sobreescribir
					var mFormatter = new initFormatter();
					// sobreescribimos el formateador
					
					mFormatterStrategiesManager.OverrideFormmater(cESTIMATED_DELAY,
																  new mFormatter.FormmaterEstimatedDelay());
					mFormatterStrategiesManager.OverrideFormmater(cLOGO,
																  new mFormatter.FormmaterLogo());
					mFormatterStrategiesManager.OverrideFormmater(cORGANIZATION_DES,
																  new mFormatter.FormmaterOrganizationDes());
					// para cada linea de impresion
					for(var bIndex = 0; bIndex < mPintLineArray.length; bIndex++)
					{
						// obtenemos el formateador
						var mFormatter = mFormatterStrategiesManager.getStrategy(mPintLineArray[bIndex].printLineCode);
						
						// agregamos la linea para imprimir
						mPrinting.addPrintLine(mPintLineArray[bIndex], mFormatter);
					}
					
					if(mPrinting.getPrintType() == "NCR"){
						// agregamos lineas en blanco al final para que imprima todo el contenido
						
						// obtenemos el formateador
						var mFormatter = mFormatterStrategiesManager.getStrategy(cDEFAULT_FORMATTER);
						
						// creamos la linea de impresion
						var mPrintLine = {printLineCode: cDEFAULT_FORMATTER,
										  printLineValue: new Array(new String("\n"), new String("\n")),
										  printLineOrder: mPintLineArray.length};
						
						// agregamos la linea para imprimir
						mPrinting.addPrintLine(mPrintLine, mFormatter);
					}
					
					// imprimimos el ticket
					mPrinting.print();
				}
				catch(bError){
				
					throw new Error(bError.message);
				
				}
            }
            
            /**
			  * Vuelve a la botonera
			  */
			function goBack(){
				
				// Retorna al inicio pasando como parametro la informacion de QA
				window.navigate("../" + mEmissionPage +"?FullData=" + parseQualityAssuranceFullData());
			}

			function errorHandler(sOrigen, sError)
			{
				try
				{
					// llenamos los valores de las cajas de texto de informacion
					document.forms['AbortTask'].elements['taskId'].value = mTaskId;
					document.forms['AbortTask'].elements['errorMessage'].value = sError;
					
					/* ABORTADO DE TURNO */
					
					if (mAborted)
					{
						var bTaskInfoDiv     = YAHOO.util.Dom.get("dvTaskInfo");
						var bPrinterErrorDiv = YAHOO.util.Dom.get("dvPrinterError");
						
						if (bTaskInfoDiv     &&
						    bPrinterErrorDiv &&
						    bTaskInfoDiv.style.display == "") {
						    
						    bTaskInfoDiv.style.display     = "none";
							bPrinterErrorDiv.style.display = "";
                        
                        }
						
						YAHOO.util.Connect.asyncRequest("GET", "AbortTask.aspx?taskId=" + mTaskId + "&errorMessage=" + sError, null);
						window.setTimeout("redirectToInitialPage()",
										  mTTL * 1000);
					}
					else
					{
						goBack();
					}
					
					/* FIN ABORTADO DE TURNO */

							
	            }
				catch(ex)
				{
					alert(ex);
				}
			}
			
			function redirectToInitialPage(){
				window.navigate("../" + mEmissionPage);
			}
			
			
			// Inicializa la pagina.
            function pageInit() {
			    //SSUI_GENERAL_LOADER.base = "../lib/js/build/";
			    // Declara la funcion onSuccess global a todos los modulos cargados
			    SSUI_GENERAL_LOADER.registerOnSuccess(pageLoad);
			    // Inserta los modulos
			    SSUI_GENERAL_LOADER.insert();
			 }
			 
			function pageLoad(){
				// iniciamos los formateadores
				SSUI.util.Event.onDOMReady(initFormatter);
				window_onload();
			}
			
			function window_onload(){
            	
				try
				{   
					Glass.hidden();
					printTicket();
					goBack();
		        }catch(bError)
                {
					errorHandler("window_onload", bError.message);
				}
				document.onselectstart=function()
				{
					return false;
				}
				
			}
			
			/**
			  *	Captura el fin de la emision
			  */
			function getQualityAssuranceEmissionEnd()
			{
				var mDate = new Date();
				var mString = new String();
				
				// al mes se le suma uno pues inicia en cero
				mString = mDate.getFullYear() + "/" + (mDate.getMonth()+1) + "/" + mDate.getDate() + " " + mDate.getHours() + ":" + mDate.getMinutes() + ":" + mDate.getSeconds() + "." + mDate.getMilliseconds();
				return mString;
			};
			
			/**
			  * Captura la informacion de control de calidad y la integra
			  */
			function parseQualityAssuranceFullData()
			{
				/*
					Captura la informacion enviada por el inicio de emision y armar una estructura del tipo:
					<QAEmission>
						<OrganizationCode></OrganizationCode>
						<TaskId></TaskId>
						<EmissionStart></EmissionStart>
						<EmissionEnd></EmissionEnd>
					</QAEmission>
					Esta estructura es persistida en el proximo paso por NewTask.aspx, por lo tanto siempre se pierde el ultimo valor
				*/

                // Captura la fecha de fin de emision (impresion)
				mQAEmissionEnd = getQualityAssuranceEmissionEnd();	

				var mQAFullData = new String();
				mQAFullData = "<QAEmission>";
				mQAFullData += "<OrganizationCode>" + mOrganizationCode + "</OrganizationCode>";
				mQAFullData += "<TaskId>" + mTaskId + "</TaskId>";
				mQAFullData += "<EmissionStart>" + mQAEmissionStart + "</EmissionStart>";
				mQAFullData += "<EmissionEnd>" + mQAEmissionEnd + "</EmissionEnd>";
				mQAFullData += "</QAEmission>";
				
				return mQAFullData;
			};
	    ]]>
    </script>
	<script language="javascript" type="text/javascript" src="../lib/js/build/yuiloader/yuiloader-min.js"></script>
	<script language="javascript" type="text/javascript" src="../lib/js/build/SSUI/General-Loader.js"></script>
	<script language="javascript" type="text/javascript" src="../lib/js/build/SSUI/PrintingTicket-Loader.js"></script>
	<LINK href="../lib/css/CENTROHOSPUCE-MultiLevelLineSelectionBase.css" type="text/css" rel="stylesheet"></LINK>
    <!-- FIN Funciones JScript de la página.-->

    <!-- 
        Dibujo de la página propiamente dicho.
        El código a continuación carece de comentarios puesto que es 
        sumamente sencillo y facilmente adaptable.
    -->
	<script language="javascript">
     
         // Botón de Volver
         //----------------------------

        function Change(pTD)
        {
	        pTD.className = 'BackErrorDown';
        }	

        //----------------------------
     
        var timeOutId;

        function Timeout()
        {	       
	        var mTTL = <xsl:value-of select="TTL"/>;
	        
	        timeOutId = window.setTimeout('window.location.href=("../" + mEmissionPage)',
				        mTTL * 1000);            
        }

        function Cancel()
        {  Glass.show();
	        window.clearTimeout(timeOutId);
	        window.location.href=("../" + mEmissionPage);
        }
		
    </script>
	
	
	<body onload="pageInit(); " 
	      MS_POSITIONING="GridLayout" 
		  class="dvPrinterClass">
        <div align="center">
	        <form id="AltaTurno" 
	              method="post">
                <div id="dvTaskInfo">
	                <table height="98%" width="100%" cellSpacing="0" cellPadding="0" border="0">
	                    <tbody>
	                        <tr height="10%">
	                            <td colSpan="2" align="center">
	                                <!-- <IMG src="../view_configuration/default/encabezado_llamado.gif"></IMG>-->
	                            </td>
	                        </tr>
						    <tr height="10%">
							    <td align="center">
							        <font color="#3BAB82" style="FONT-FAMILY:
							        UNINEUE-BOOK; font-size:200px" size="180">
							            <!-- <b>Su n�mero es el:</b> -->
										<br/>
										<b>  <xsl:value-of select="TaskNum" /> </b>
							        </font>
							    </td>
							    <!--<td align="left">
							        <font color="black" style="font-weight:bolder; FONT-FAMILY: 'Trebuchet MS'" size="6">
							            <xsl:value-of select="TaskNum" />
							        </font>
							    </td>-->
						    </tr>										
	                        <tr>
	                            <td align="center" colSpan="2">&#160;
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" colspan="2">&#160;
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" colSpan="2">
	                                <font color="#4b4b4b" style="FONT-FAMILY: 'Trebuchet MS'" size="5">
	                                    <b></b>
	                                </font>
	                            </td>
	                        </tr>	                        
	                    </tbody>
	                </table>
	            </div>
	            
	            <div id="dvPrinterError" class="dvPrinterErrorClass" style="display:none;">
						  <div class="ErrorHeader"></div>
						  <div class="ErrorText"></div>
				  <div id="buttonBackContainer">							
					<div  class="TextSeparatorClass"></div>
						<div class="ContainerBackUpError">
							<div class="ButtonErrorSeparator">
								<div onclick="Change(this); Cancel();"  class="BackErrorUp">Volver</div>
							</div>
						</div>
				  </div>						  
				</div>
				
				<table height="2%" width="100%" >
			 <!-- Fila del leyenda.-->
                <tr>
                    <!-- Unica columna de leyenda.-->
                    <td align="center">
                    </td>
                    <!-- FIN Unica columna de leyenda.-->
                </tr>
                <!-- FIN Fila de leyenda-->
			</table>
	        </form>
	        
	         <form id="AbortTask" 
	                 action="AbortTask.aspx"
	                 method="post">
                <input type="hidden" name="taskId"></input>
                <input type="hidden" name="errorMessage"></input>
	          </form>
	    </div>
		<!-- pre carga de imagenes-->
	<div class="BackErrorDown" style="display:none;"></div>
	</body>		
    <!-- FIN Dibujo de la página propiamente dicho.-->
	 <script language="javascript" src="../lib/js/jQuery/jquery-1.9.1.js" type="text/javascript"></script>
     <script language="javascript" src="../lib/js/build/SSUI/UtilityGlass.js" type="text/javascript"></script>  
</xsl:template>		
<!-- FIN Template Task. Pantalla de información al usuario e impresión.     -->
<!--========================================================================-->

<!--========================================================================-->
<!-- Template para la página de error.                                      -->
<xsl:template match="Error">	
    <LINK href="../lib/css/CENTROHOSPUCE-MultiLevelLineSelectionBase.css" type="text/css" rel="stylesheet"></LINK>
    <script language="javascript">
     
         // Botón de Volver
         //----------------------------

        function Change(pTD)
        {
	        pTD.className = 'BackErrorDown';
        }	

        function window_onload()
        {
					
			document.onselectstart=function()
				{
					return false;
				}

			Glass.hidden();	
        }
            
        //----------------------------
     
        var timeOutId;

        function Timeout()
        {	       
	        var mTTL = <xsl:value-of select="TTL"/>;
	        
	        timeOutId = window.setTimeout('window.location.href=("../" + mEmissionPage)',
				        mTTL * 1000);            
        }

        function Cancel()
        {   Glass.show();
	        window.clearTimeout(timeOutId);
	       window.location.href=("../" + mEmissionPage);
        }
		
		

    </script>  
    <body onload="Timeout();window_onload();" 
          topmargin="0" 
          bottommargin="0" 
          leftmargin="0" 
          rightmargin="0"
		  style="overflow:hidden"
		  class="dvEmissionErrorClass">
		   <div align="center">
			  <div class="ErrorHeader"></div>
			  <div class="ErrorText"></div>
			  <div id="buttonBackContainer">							
				<div  class="TextSeparatorClass"></div>
				   <div class="ButtonErrorSeparator">
						<div onclick="Change(this); Cancel();"  class="BackErrorUp">Volver</div>
				   </div>
			  </div>
		  </div>	
		<!-- pre carga de imagenes-->
	<div class="BackErrorDown" style="display:none;"></div>		  
    </body>
	 <script language="javascript" src="../lib/js/jQuery/jquery-1.9.1.js" type="text/javascript"></script>
     <script language="javascript" src="../lib/js/build/SSUI/UtilityGlass.js" type="text/javascript"></script>      	
</xsl:template>	
<!-- FIN Template para la página de error.                                      -->
<!--========================================================================-->

</xsl:stylesheet>
