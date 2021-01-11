// Declaracion de espacios de nombres
// ========================================================================

YAHOO.namespace("uicontrols.emission");

YAHOO.uicontrols.emission = function () {
};

YAHOO.namespace("uicontrols.emission.utils");

YAHOO.uicontrols.emission.utils = function () {
};


// Declaracion de constantes
// ========================================================================
var cGROUP                    = "Group";
var cLINE                     = "Line";
var cBTN_ACCEPT_ID            = "btnAccept";
var cBTN_BACK_ID              = "btnBack";
var cDIV_PREFIX				  = "dv";
// ========================================================================

/**
 * Clase generica Entidad.
 *
 * @namespace YAHOO.uicontrols.emission.utils
 * @class Entity
 * @constructor
 **/
YAHOO.uicontrols.emission.utils.Entity = function(pConf,pParent) {
	//Padre de la entidad
	this.iParent = null;
	
	//Hijos de la entidad 
	this.iChilds = new Array();
	
	//Id
	this.iId;
	
	//Descripcion
	this.iDescription;
	
	// Alias
	this.iAlias
	
	//Orden
	this.iSortOrder;
	
	//Nivel en el arbol
	this.iLevel;
	
	/**
	* Obtiene el nivel del arbol en el que se encuentra nodo
	**/
	this.getLevel = function() {
		return this.iLevel;
	}
	// Incorpora el tramite a mostrar
    // solo si esta vinculado de acuerdo al grupo de cliente
    // y si el grupo de cliente no es nulo
    function PushNewLine(pLine, pThis) {
        mNewLine = new YAHOO.uicontrols.emission.utils.Line(pLine, pThis);

        

        if (YAHOO.uicontrols.emission.Touchscreen.iClientTypeResult == null ||
			pThis.ClientTypeAsoc(YAHOO.uicontrols.emission.Touchscreen.iClientTypeResult, mNewLine)) {
            pThis.iChilds.push(mNewLine);
        }
    }

    // dado un grupo de cliente y la entidad a mostrar , indica si el tramite esta vinculado
    this.ClientTypeAsoc = function (pClientTypeId, pEntity) {
        var mFound = false;

        if (pEntity.toString() == "YAHOO.uicontrols.emission.utils.Line") {
            if (pEntity.iClientTypes != null) {
                if (pEntity.iClientTypes.length) {
                    for (var i = 0; i < pEntity.iClientTypes.length; i++) {
                        if (pEntity.iClientTypes[i].ClientTypeId == pClientTypeId) {
                            mFound = true;
                            break;
                        }
                    }
                } else {
                    mFound = pEntity.iClientTypes.ClientTypeId == pClientTypeId;
                }
            }
        }

        return mFound;
    }
	//Constructor
	{		
		
		this.iParent = pParent;
		
		if (this.iParent == null) {
			this.iLevel = 0;
		} else {			
			this.iLevel = parseInt(this.iParent.getLevel())+1;
		}	
		
		//Si hay grupos hijos se instancian
		if (pConf.Groups != null && pConf.Groups.Group != null) {					
			if(pConf.Groups.Group[0] != undefined) {
				for (var bIndex = 0; bIndex < pConf.Groups.Group.length; bIndex++) {			
					
					this.iChilds.push(new YAHOO.uicontrols.emission.utils.Group(pConf.Groups.Group[bIndex],
																			   this));
				}
			} else {
				this.iChilds.push(new YAHOO.uicontrols.emission.utils.Group(pConf.Groups.Group,
																			   this));
			}
		}

		var mNewLine;
		//Si hay tramites hijos se instancian	
        if (pConf.Lines != null && pConf.Lines.Line != null) {
            if (pConf.Lines.Line[0] != undefined) {
                for (var bIndex = 0; bIndex < pConf.Lines.Line.length; bIndex++) {
                    // Incorpora tramite a mostrar previa validacion
                    // de vinculacion con el grupo resuelto
                    PushNewLine(pConf.Lines.Line[bIndex], this);
                }
            } else {
                if (pConf.Lines.Line.length != undefined) {
                    this.iChilds.push(new YAHOO.uicontrols.emission.utils.Line(pConf.Lines.Line,
																				this));
                }
                else {
                    // Incorpora tramite a mostrar previa validacion
                    // de vinculacion con el grupo resuelto
                    PushNewLine(pConf.Lines.Line, this);
                }
            }
        }
		
	}
	
	/**
	* Obtiene el id
	**/
	this.getId = function() {
		return this.iId;
	}
	
	/**
	* Obtiene la descripcion
	**/
	this.getDescription = function() {
		return this.iDescription;
	}
	
	/**
	* Obtiene el alias
	**/
	this.getAlias = function(){
		return this.iAlias
	}
	
	/**
	* Obtiene el padre
	**/
	this.getParent = function() {
		return this.iParent;
	}
	
	/**
	* Obtiene el orden
	**/
	this.getSortOrder = function() {
		return this.iSortOrder;
	}
	
	/**
	* Devuele verdadero si es la raiz
	**/
	this.isRoot = function() {
		return (this.iParent == null);
	}
	
	/**
	*Devuelve verdadero si es una hoja del arbol
	**/
	this.isLeaf = function() {
		return (this.iChilds.length == 0);
	}
	
	/**
	* Obtiene la lista de hijos
	**/
	this.getChilds = function() {
		return this.iChilds;
	}	
	
}

/**
 * Representa un Grupo.
 *
 * @namespace YAHOO.uicontrols.emission.utils
 * @class Group
 * @constructor
 **/
YAHOO.uicontrols.emission.utils.Group = function(pConf,pParent,pClientTypId) {
	//Categoria
	this.iCategory;
	
	{		
		this.constructor.superclass.constructor.call(this,
												     pConf,
													 pParent);
													  
		//Se valida que exista el padre
		if (pParent!=null) { 
			this.iId 			= pConf.GroupId;
			this.iDescription	= pConf.GroupDescription;
			this.iSortOrder		= parseInt(pConf.SortOrder);
			this.iCategory      = pConf.AbstractGroup;
			this.iAlias			= "";
		} else {
			this.iId 			= -1;
			this.iDescription	= "root";
			this.iSortOrder		= 1;
			this.iCategory		= "root";
			this.iAlias			= "";
		}
	}
	
	this.getCategory = function() {
		return this.iCategory;
	}
	
	this.toString = function() {
		return "YAHOO.uicontrols.emission.utils.Group";
	}
	
	/**
	* Devuelve verdadero si el grupo contiene algun tramite seleccionado
	**/
	this.containSelectedLines = function() {
		var mFound = false;
		var mIndex = 0;
		while (mIndex<this.getChilds().length && !mFound) {
			if (this.getChilds()[mIndex].toString()=="YAHOO.uicontrols.emission.utils.Line" && this.getChilds()[mIndex].isSelected()) {
				mFound = true;
			} else {
				if (this.getChilds()[mIndex].toString()=="YAHOO.uicontrols.emission.utils.Group" && this.getChilds()[mIndex].containSelectedLines()) {
					mFound = true;
				} else {
					mIndex++;
				}
			}
		}
		
		return mFound;
	}
	
	// dado un grupo de cliente y la entidad a mostrar , indica si el tramite esta vinculado
    this.ClientTypeAsoc = function (pClientTypeId, pEntity) {
        var mFound = false;

        if (pEntity.toString() == "YAHOO.uicontrols.emission.utils.Line") {
            if (pEntity.iClientTypes != null) {
                if (pEntity.iClientTypes.length) {
                    for (var i = 0; i < pEntity.iClientTypes.length; i++) {
                        if (pEntity.iClientTypes[i].ClientTypeId == pClientTypeId) {
                            mFound = true;
                            break;
                        }
                    }
                } else {
                    mFound = pEntity.iClientTypes.ClientTypeId == pClientTypeId;
                }
            }
        }

        return mFound;
    }
	/**
	* Obtiene solamente los hijos que se muestran
	**/
	this.getVisibleChilds = function() {
	    var mResult = new Array();
	    var mChilds = this.getChilds();
	    for (var bIndex = 0; bIndex<mChilds.length; bIndex++) {
	        if (mChilds[bIndex].toString() == "YAHOO.uicontrols.emission.utils.Line" || mChilds[bIndex].getVisibleChilds().length>0) {
	            mResult[mResult.length] = mChilds[bIndex];
	        }
	    }
	    return mResult;
	}
	
	this.getKind = function(){
		return cGROUP;
	}
}

// Implementa herencia
YAHOO.lang.extend(YAHOO.uicontrols.emission.utils.Group, 
				 YAHOO.uicontrols.emission.utils.Entity);
				 
/**
 * Representa un Tramite.
 *
 * @namespace YAHOO.uicontrols.emission.utils
 * @class Line
 * @constructor
 **/				 
YAHOO.uicontrols.emission.utils.Line = function(pConf,pParent) {
	
	//Alias
	//this.iAlias;
	
	// Indica si el tramite esta seleccionado
	this.iSelected = false;
	
	{
		this.constructor.superclass.constructor.call(this,
												     pConf,
													 pParent);
										  
		this.iId 			= pConf.LineId;
		this.iDescription	= pConf.LineDes;
		this.iSortOrder		= parseInt(pConf.SortOrder);
		this.iAlias			= pConf.LineAlias;
		this.iConstraintCode = pConf.ConstraintCode;
		if (pConf.ClientTypes != null) {
            this.iClientTypes = pConf.ClientTypes.ClientType;
        }
	}
	
	this.setSelected = function(pState){
		this.iSelected = pState;
	}
	
	this.isSelected = function() {
		return this.iSelected;
	}
	
	this.toString = function() {
		return "YAHOO.uicontrols.emission.utils.Line";
	}
	
	this.getKind = function(){
		return cLINE;
	}
}

// Implementa herencia
YAHOO.lang.extend(YAHOO.uicontrols.emission.utils.Line, 
				 YAHOO.uicontrols.emission.utils.Entity);	



/**
 * Administra las entidades.
 *
 * @namespace YAHOO.uicontrols.emission.utils
 * @class EntityManager
 * @constructor
 **/				 
YAHOO.uicontrols.emission.utils.EntityManager = function(pConf, pPresenter) {	
	//Entidad del arbol en la que se esta parado
	this.iCurrentEntity = null;
	
	//Hash de tramites seleccionados, la clave es el id de tramite
	this.iSelectedLines = new SSUI.uicontrols.uicontrol.Hashtable();
  

  
	/**
	* Devuelve verdadero si el grupo actual es el root
	**/
	this.currentEntityIsRoot = function() {
		return this.iCurrentEntity.isRoot();
	}
	
	this.clearSelection = function() {
	    var mKeys = this.iSelectedLines.getKeys();
	    for (var bIndex = 0; bIndex<mKeys.length; bIndex++ ) {
	        this.iSelectedLines.getValue(mKeys[bIndex])[1].setSelected(false);
	    }
	    this.iSelectedLines = new SSUI.uicontrols.uicontrol.Hashtable();
	}
  
	this.render = function(){
	
		return this.iPresenter.render(this.iCurrentEntity);
		
	}
	
	
	/**
	* Busca en los hijos de una entidad y si encuentra la entidad la establece como actual
	* y si no la encuentra busca en los hijos del padre de la entidad
	**/
	this.searchAndSetAsCurrent = function(pId,pEntity) {
		pEntity.getId();
		var mChildArray = pEntity.getChilds();
		var mIndex = 0;
		var mFound = false;
		while (mIndex < mChildArray.length && !mFound) {
			if (mChildArray[mIndex].getId() == pId) {				
				this.iCurrentEntity = mChildArray[mIndex];
				mFound = true;
			} else {
				mIndex++;
			}
		}
		
		if (!mFound) {
			if (pEntity.getParent() != null) {
				this.searchAndSetAsCurrent(pId,pEntity.getParent());
			} else {
				this.iCurrentEntity = pEntity;
			}
		}
	}
	
	/**
	* Navega hacia el grupo del elemento selccionado
	**/
	this.navigate = function(pElement) {
	
		var mChildArray = this.iCurrentEntity.getChilds();
		var mIndex = 0;
		var mFound = false;
		while (mIndex < mChildArray.length && !mFound) {
			if (mChildArray[mIndex].getKind() == pElement.getKind() && mChildArray[mIndex].getId() == pElement.getId()) {
				this.iCurrentEntity = mChildArray[mIndex];
				mFound = true;
			} else {
				mIndex++;
			}
		}
	
		if (!mFound) {
			this.clearSelection();
			this.searchAndSetAsCurrent(pElement.getId(),this.iCurrentEntity.getParent());
		}
	}
	
	/**
	* Establece un elemento como seleccionado y lo guarda en un hash
	**/
	this.setSelected = function(pElement) {	
		
		if(pElement.isSelected()){
			pElement.setSelected(false);
			
			//Se descuenta 1 de la cantidad de instancias seleccionadas del tr�mite
			var mCount = parseInt(this.iSelectedLines.getValue(pElement.getId())[0]) - 1;
			
			if (mCount==0) {
				this.iSelectedLines.remove(pElement.getId());
			} else {
				this.iSelectedLines.put(pElement.getId(),[mCount,pElement]);
			}
		}
		else{
			pElement.setSelected(true);
			
			if (!this.iSelectedLines.containsKey(pElement.getId())) {
				this.iSelectedLines.put(pElement.getId(),[1,pElement]);
			} else {
				//Sino
				//Se aumenta 1 de la cantidad de instancias seleccionadas del tr�mite
                this.iSelectedLines.put(pElement.getId(), [parseInt(this.iSelectedLines.getValue(pElement.getId())[0]) + 1, pElement]);
			}					
		}
	}
	
	/**
	* Establece un elemento como seleccionado y lo guarda en un hash
	**/
	this.setSingleSelected = function(pElement) {	
		
		//Se verifica que el tramite no este en el hash de tamites seleccionados
		if (!this.iSelectedLines.containsKey(pElement.getId())) {
			if (this.iSelectedLines.size()>0) {
				this.iSelectedLines.getValue(this.iSelectedLines.getKeys()[0])[1].setSelected(false);
				this.iSelectedLines.remove(this.iSelectedLines.getKeys()[0]);
			}
			
			//Busco el hijo que tenga el id del tramite provisto
			//var mChildArray = this.iCurrentEntity.getChilds();
			
			//var mChildArray = pElement.getParent().getChilds();
			
			this.iSelectedLines.put(pElement.getId(),[1,pElement]);
			pElement.setSelected(true);
		} //if
	}
	
	/**
	* Obtiene los Id de tramites seleccionados
	**/
	this.getSelectedLines = function() {
		return this.iSelectedLines.getValues();	
	}
	
	this.goBack = function()	{
		this.iCurrentEntity = this.iCurrentEntity.getParent();
	}
	
	/**
	* Constructor
	**/
	{
		this.iPresenter = pPresenter;
		this.iCurrentEntity = new YAHOO.uicontrols.emission.utils.Group(pConf,null);
		this.iCurrentEntity = new YAHOO.uicontrols.emission.utils.Group(pConf, null, YAHOO.uicontrols.emission.Touchscreen.iClientTypeResult);
	}
}	

/**
 * Administra el touchscreen
 *
 * @namespace YAHOO.uicontrols.emission
 * @class Touchscreen
 * @constructor
 **/		
YAHOO.uicontrols.emission.Touchscreen = new function() {
	
	//Administrador de entidades
	this.iEntityManager = null;
	this.iSelectLineType = "singleline";
	this.iShowPrintButton = false;
	this.iEmissionPage = new String();
	this.iClientTypeResult;
	
	var cTimeOutId;
	
	
	// control de doble submit para monotramite
	this.iHasClicked;
	//Setea el tipo de cliente en la pantalla inicial
	this.setClientType = function(pClientType){
		var mClientTypeIdInput = YAHOO.util.Dom.get('ClientTypeId');
		mClientTypeIdInput.value = pClientType;

		}
	/**
	* Dibuja el contenido de la pantalla
	**/		
	this.render = function() {
		//Se obtiene el div contenedor definido en el xsl
		var mDiv = YAHOO.util.Dom.get('dvBodyTask');
		
		// Se eliminan todos los nodos hijos del DIV.
		if (mDiv.hasChildNodes()) {
			while (mDiv.childNodes.length >= 1) {
				mDiv.removeChild(mDiv.firstChild);       
			} 
		}
		
		//Se crea un div para la cabecera
		var mDivHeader = document.createElement('DIV');
		mDivHeader.className = "TSHead";
		mDiv.appendChild(mDivHeader);
		//Titulo de pantalla
		var mDivDataClient = document.createElement('DIV');
		mDivDataClient.className = "TSDataClient";
		mDivDataClient.id = "TSDataClient";
		var mWelcom = "";
		//if (this.iEntityManager.currentEntityIsRoot()==true){
		//	mWelcom = "<b>Bienvenido,</b> por favor seleccione su opci&oacute;n:";					
		//} else
		//{
		//	mWelcom = "Por favor seleccione su opci&oacute;n:";				
		//}
		mDivDataClient.innerHTML =  mWelcom;
		
		mDiv.appendChild(mDivDataClient);
		//Se obtiene el div del cuerpo
		var mDivBody = this.iEntityManager.render();
        mDiv.appendChild(mDivBody);
		
		//Se crea un div para el pie
		var mDivFoot = document.createElement('DIV');
		mDivFoot.className = "TSFoot";				
		
		
		//Se crea un div para el boton volver
		var mDivBack = document.createElement('DIV');
		mDivBack.id = cBTN_BACK_ID;
		mDivBack.className = "BackUp";	
		mDivBack.innerHTML = "Volver";	
		//Se agrega un estado personalizado al elemento
		mDivBack.setAttribute("ElState","Up");
		//Se agrega un evento clicl al boton
		YAHOO.util.Event.addListener(mDivBack, 
									 "click", 
									 function (pEvent,pParams) {											
										YAHOO.uicontrols.emission.Touchscreen.doAction(pParams.element);
									 },
									 {
										element : mDivBack
									 },
									 true
									 );
		mDivFoot.appendChild(mDivBack);	
		mDiv.appendChild(mDivFoot);		
		
		if (this.iShowPrintButton || this.iSelectLineType =="multiline") {		
			//Se crea un div para el boton aceptar
			var mDivAccept = document.createElement('DIV');
			mDivAccept.id = cBTN_ACCEPT_ID;
			mDivAccept.className = "AcceptUp";
			mDivAccept.innerHTML = "Imprimir ticket";
			//Se agrega un estado personalizado al elemento
			mDivAccept.setAttribute("ElState","Up");
			//Se agrega un evento clicl al boton
			YAHOO.util.Event.addListener(mDivAccept, 
											 "click", 
											 function (pEvent,pParams) {											
												YAHOO.uicontrols.emission.Touchscreen.doAction(pParams.element);
											 },
											 {
												element : mDivAccept
											 },
											 true
											 );
			mDivFoot.appendChild(mDivAccept);	
		}		
	}	
	
	/**
	* Captura el inicio de la emision
	*/
	this.setQualityAssuranceEmissionStart = function()
	{
		var mDate = new Date();
		var mString = new String();
		
		//	Al mes se le suma uno pues inicia en cero
		mString = mDate.getFullYear() + "/" + (mDate.getMonth()+1) + "/" + mDate.getDate() + " " + mDate.getHours() + ":" + mDate.getMinutes() + ":" + mDate.getSeconds() + "." + mDate.getMilliseconds();
		
		YAHOO.util.Dom.get("QualityAssuranceEmissionStart").value = mString;
	};
	
	/**
	* Imprime el ticket en caso de que haya al menos un tr�mite seleccionado
	**/	
	this.printTicket = function(pElement) {
	
		var mSelectedLines = this.iEntityManager.getSelectedLines();
		if (mSelectedLines.length>0) {			
			//Se obtiene el div contenedor definido en el xsl
			var mDivBody = YAHOO.util.Dom.get('dvBodyTask');
			//Se crea un div oculto para contener los checkbox
			var mDiv = document.createElement('DIV');
			mDiv.style.display = "none"; 
			mDivBody.appendChild(mDiv);
			//Para cada tramite seleccionado se crea un checkbox
				for (var bIndex = 0; bIndex<mSelectedLines.length; bIndex++) {				
				var mChk = document.createElement('INPUT');
				mChk.type = "checkbox";
				mChk.id = "Id" + mSelectedLines[bIndex][1].getId();
				mChk.name = "Id" + mSelectedLines[bIndex][1].getId();					
				mDiv.appendChild(mChk);
				YAHOO.util.Dom.get("Id" + mSelectedLines[bIndex][1].getId()).checked = true;
			}	
				
			// captura el inicio de emision
			this.setQualityAssuranceEmissionStart();	
			
			//Se hace el submit
			YAHOO.util.Dom.get('Touchscreen2').submit();			
		} else {
						// si existe se trata de una entidad, si no del boton volver
				if(pElement.getKind){
				var mElementDiv = SSUI.util.Dom.get(cDIV_PREFIX + pElement.getKind() + pElement.getId());

					}
				else{
					var mElementDiv = pElement;
						Glass.hidden();
				}
			//Cambia la apariencia del elemento			
			this.changeAppearance(mElementDiv);
		}
	}

	/**
	* Realiza una acci�n dependiendo del el elemento clockeado
	**/		
	this.doAction = function(pElement) {		
		
		// obtenemos el div de la entidad
		
		// si existe se trata de una entidad, si no del boton volver
		if(pElement.getKind){
			var mElementDiv = SSUI.util.Dom.get(cDIV_PREFIX + pElement.getKind() + pElement.getId());
		}
		else{
			var mElementDiv = pElement;
		}
		
		this.restartTimeOut();	
		
		//Cambia la apariencia del elemento			
		this.changeAppearance(mElementDiv);
		
		//Segun que boton que se haya presionado
		switch (mElementDiv.id) {		
			case cBTN_BACK_ID : if (this.iEntityManager.currentEntityIsRoot()==true){
				window.navigate(this.iEmissionPage);
			}
			else{
				this.iEntityManager.goBack();
				this.render();
			}	
								break;
			case cBTN_ACCEPT_ID : 	// mostramos el vidrio
									Glass.show();
									this.printTicket(pElement);
									break;
			default : 	//Si es un grupo navega hacia los elementos del grupo y los renderiza
						if (mElementDiv.attributes["EntityType"].value==cGROUP) {
							this.iEntityManager.navigate(pElement);
							this.render();		
						} else {
							//Si es tramite lo selecciona							
							if (this.iSelectLineType == "singleline") {
								this.iEntityManager.setSingleSelected(pElement);
								if (this.iShowPrintButton) {
									this.render();
								} else {
									// si no fue presionado un boton
									if(!this.iHasClicked)
									{
										// seteamos el control de doble submit en true
										this.iHasClicked = true;
										// mostramos el vidrio
										Glass.show();
										// imprimimos el ticket
										this.printTicket(pElement);
									}
								}
							} else {
								this.iEntityManager.setSelected(pElement);
							}
						}
						break;						
		}
		
	}  
	
	/**
	* Cambia la apariencia de un boton
	**/	
	this.changeAppearance = function(pElementDiv) {
		var mReplaceStr;
		var mSateStr;
		var mNewClassStr = "";             
	   
		//Se verifica el estado del elemento a trav�s de un atributo personalizado que es "ElState"
		switch (pElementDiv.attributes["ElState"].value) {
			case "Up"   : mReplaceStr = "Down";
						  mSateStr    = "Up";                                  
						  break; 
			case "Down" : mReplaceStr = "Up";
						  mSateStr    = "Down"; 
						  break;
			//TO-DO: Eliminar o sustituir por Exception
			default     : alert("No se pudo determinar el estado del elemento html");                          
		}   
		//Se reemplaza el estado del elemento            
		pElementDiv.attributes["ElState"].value = mReplaceStr;  
		
		var mClasses    = pElementDiv.className;
		var mClassArray = mClasses.split(' ');
		//Para cada clase que posee el elemento
		for (var bIndex = 0; bIndex < mClassArray.length; bIndex++) {
			//Si el final de la clase coincide con el estado del elemento
			if (mClassArray[bIndex].substring(mClassArray[bIndex].length-mSateStr.length,mClassArray[bIndex].length)==mSateStr)
			{
				//Se reemplaza el final por el nuevo estado
				mClassArray[bIndex] = mClassArray[bIndex].substring(0,mClassArray[bIndex].length-mSateStr.length) + mReplaceStr;
			}
			mNewClassStr += mClassArray[bIndex] + " ";                   
		}
		//Se establece la clase
		pElementDiv.className = mNewClassStr;   			 
	}
	
	/**
	* Reinicia el timeout
	**/	
	this.restartTimeOut = function() {
		window.clearTimeout(cTimeOutId);
		cTimeOutId = window.setTimeout("window.location.href=('./" + this.iEmissionPage + "')",
									   mTTL * 1000); 
	}
		
	/**
	* Inicia el touchscreen
	**/	
	this.init = function(pConf, pPresenter, pSelectLineType, pShowPrintButton, pEmissionPage, pClientTypeResult)
	{	
		this.iClientTypeResult = pClientTypeResult;	
		this.iEntityManager = new YAHOO.uicontrols.emission.utils.EntityManager(pConf, pPresenter);	
		this.iHasClicked = false;
		this.iSelectLineType = pSelectLineType;
	    this.iShowPrintButton = pShowPrintButton;
		this.iEmissionPage = pEmissionPage;
	
	}
}		