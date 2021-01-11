<?xml version="1.0" encoding="utf-8" ?> 
<xsl:stylesheet  	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="1.0">

<xsl:output method="html" />

<xsl:template match="root">

  <xsl:choose>
    
    <xsl:when test="./numbers != ''">
      <xsl:apply-templates select="//numbers"></xsl:apply-templates>
    </xsl:when>	
    
    <xsl:when test="./guidelines != ''">
      <xsl:comment>SideSys.Guideline - NO REMOVER ESTE COMENTARIO</xsl:comment>
      <xsl:apply-templates select="//guidelines"></xsl:apply-templates>
    </xsl:when>	
    
    <xsl:otherwise>

    <!-- INSTITUCIONAL POR DEFECTO -->
    <table width="100%" height="100%">
      <tr>
        <td style="background-image: url(../view_configuration/default/encabezado.jpg);" >
         &#160;
        </td>
       </tr>
    </table>
    <!-- INSTITUCIONAL POR DEFECTO -->
    
    </xsl:otherwise>
  
  </xsl:choose>
  
</xsl:template>

<xsl:template match="//guidelines">	
    
    <!-- DEPRECATED: EXHIBICION DE PAUTAS -->
    
</xsl:template>

<xsl:template match="//numbers">	
	<!-- Reproductor monocanal -->
	<!-- NO REMOVER -->
	<object classid="CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6" id="SSUI_VS_SINGLE_DEVICE_PLAYER" width="1" height="1">
		<param name="width" value="1"/>
		<param name="height" value="1"/>
		<param name="uiMode" value="invisible"/>
	</object>
	<!-- Reproductor monocanal -->
  
    <!-- Inclusion dinamica de hoja de estilos --> 
    <script>
      // Separador para los textos de los banner
      SSUI_VS_BANNER_TEXT_SEPARATOR = " - ";
      
      var mCSS_FILE = "../lib/css/CENTROHOSPUCE-NodeView.css";
      SSUI.util.Get.css(mCSS_FILE, {});

      // establece la sincronizacion de visualizacion y audio de numeros
      //mO.setSyncAudioPlaying(true);

      // establece el player para utilizar el SSVoice.exe
      /*
      SSUI.util.Get.script("../lib/js/build/SSUI/PlayerSSVoiceExe.js", {
      onSuccess: function(oData) {
      mO.soundPlayer  = new SSUI.uicontrols.uicontrol.visualizer.soundPlayerSSVoiceExe(SSUI_VS_MEDIA_PATH);
      }
      });
      */
    </script>  

	
	 <div id="BackgroundNodeId" class="BackgroundNode">
         <!--Encabezado -->
		<div class="headNode"> </div>
         <table height="70%" width="100%" border="0">	
            <tr>
				<td valign="top" align="left" >
					<table border="0" width="100%" cellspacing="1" cellpading="1" id="tblNumber">
						
						<tr>
							<!-- Titulo de turno -->
							<td id="titleNodeTN"  align="center" width="50%" class="titleNode">
                <span id="spTaskTitle">TURNO</span>
							</td>
							<!-- Titulo de DTE -->
							<td  id="titleNodeDD" align="center" width="50%"  class="titleNode">
                <span id="spConsoleTitle">PUESTO</span>
							</td>
							<!-- Flecha -->
							<!--<td align="center" width="30%" bgcolor="red">
								<font style="FONT-WEIGHT: bold; FONT-SIZE: 60; FONT-FAMILY:Trebuchet MS; color:white;">
								Sentido
								</font>
							</td>-->
						</tr>
					</table>
				</td>
				<td valign="middle" align="center"   class="BackgroundAdvertisement" rowspan="2">
					<!-- Obligatorio para mostrado de ads -->
					<div  style="height:100%;" id="dvAds"></div>
				</td>
			</tr>
			<tr>
				<td valign="top" align="left" width="50%"  class="numbering" id="numbers" name="numbers">
					<xsl:apply-templates select="//number"></xsl:apply-templates>
				</td>
			</tr>
			<tr>
				<td valign="middle"  class="BackgroundBanner" colspan="2">
					<!-- Obligatorio para mostrado de banners -->
					<font class="fontBanner" >
						<marquee id="dvBanners" direction="left"></marquee>
					</font>
				</td>
			</tr>
          </table>


	</div>
</xsl:template>

<xsl:template match="//number">
          <table border="0" width="100%">
            <!-- Indica el estilo Numero comun / Numero novedad para la tabla de numeracion -->
            <xsl:attribute name="class">
	                      <xsl:if test="position() != count(//number)">NumberingItem</xsl:if>
	                      <xsl:if test="position()  = count(//number)">NumberingFlashItem</xsl:if>
	          </xsl:attribute>
            
            <tr>
             <!-- Indica el estilo por numeracion ordinal de la fila -->
             <xsl:attribute name="id">TR_<xsl:value-of select="tasknum"/></xsl:attribute>
            
              <td align="center">

                      <!-- Numero de Turno -->
                      <td align="center" width="50%" class="tn">
						<!-- OBLIGATORIO -->
						<span>
							<xsl:attribute name="id">tn_<xsl:value-of select="tasknum"/></xsl:attribute>
						</span>
                       </td>
                        <!-- Descripcion del DTE -->
                      <td width="50%" align="center" class="dd">
						<!-- OBLIGATORIO -->
						<span>
							<xsl:attribute name="id">dd_<xsl:value-of select="dtedes"/></xsl:attribute>
						</span>
                      </td>
                      <!-- Flecha -->
                      <!--<td width="30%" align="center" class="aa">
						
						<span>
							<xsl:attribute name="id">aa_<xsl:value-of select="dtedes"/></xsl:attribute>
						</span>
                      </td>-->

              </td>
            </tr>
          </table>
</xsl:template>

</xsl:stylesheet>