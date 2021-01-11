// cSHOW_PREV_SELECTEDGROUPS
// Indica si se debe mostrar la selección previa de grupos 
// valores:
// true  : Muestra las selecciones de grupo previas desde la raiz hasta el nivel actual
// false : No muestra las selecciones de grupo previas
var cSHOW_PREV_SELECTEDGROUPS = false; 
// ========================================================================

// cENTITYCOLUMN_COUNT
// Cantidad de columnas contenedoras de entidades a mostrar
var cENTITYCOLUMN_COUNT = 2; 
// ========================================================================


//Declaracion de constantes
// ========================================================================
var cCLASS_ENTITYCOLUMN 	  = "EntityColumn"; //Clase css de las columnas contenedoras de entidades
var cCLASS_ENTITY_MARGINLEFT  = "EntityMarginLeft"; //Clase css de la columna margen a la izquierda
var cCLASS_ENTITY_MARGINRIGHT = "EntityMarginRight"; //Clase css de la columna margen a la derecha
var cCLASS_ENTITY_SEPARATOR   = "EntitySeparator"; //Clase css de la columna separadora
var cCLASS_BASE_UP_GROUP   	  = "GroupBaseUp"; //Clase base css de los grupos
var cCLASS_BASE_UP_GROUP_LINE_SELECTED = "GroupBaseLineSelectedUp"; //Clase base css de los grupos cuando tienen tramites hijos seleccionados
var cCLASS_BASE_DOWN_GROUP    = "GroupBaseDown"; //Clase base css de los grupos
var cCLASS_BASE_UP_LINE   	  = "LineBaseUp"; //Clase base css de los tramites
var cCLASS_BASE_DOWN_LINE     = "LineBaseDown"; //Clase base css de los tramites
var cCLASS_BODYLINE           = "BodyLineDiv"; //Clase css del contenedor de grupos y tramites

/**
 * Presentador de informacion
 *  
 * @namespace YAHOO.uicontrols.emission.utils
 * @class Presenter
 **/
YAHOO.uicontrols.emission.utils.Presenter = function(pConf) {
  
  /**
	* Ordena el array de hijos por el atributo SortOrder
	**/
	this.OrderChildArray = function(pArray) {	
		for (var bIndex = 0; bIndex < pArray.length; bIndex++) {		  	
			for (var bAnotherIndex = bIndex + 1; bAnotherIndex < pArray.length; bAnotherIndex++) {
			   if (pArray[bIndex].getSortOrder() > pArray[bAnotherIndex].getSortOrder()) {
				    var bAux              = pArray[bIndex];
				    pArray[bIndex]        = pArray[bAnotherIndex];
				    pArray[bAnotherIndex] = bAux;
			   }		   
			}   
		  }
		  return pArray;
	}
  
  /**
	* Dibuja el elemento de un Tramite 
	**/	
	this.renderEnabledLineElement = function(pElement){
		var bDiv = document.createElement('DIV'); 			
		var bCssClass   = "";	
		
		if (pElement.isSelected()) {
			bDiv.setAttribute("ElState","Down");
			bCssClass = cCLASS_BASE_DOWN_LINE + " "+pElement.getParent().getCategory().replace(" ","")+cLINE+"Down";
		} else {
			bDiv.setAttribute("ElState","Up");
			bCssClass = cCLASS_BASE_UP_LINE + " "+pElement.getParent().getCategory().replace(" ","")+cLINE+"Up";
		}
		
		bDiv.className = bCssClass;
		return bDiv;
	}
  
  /**
	* Dibuja el elemento de un Tramite deshabilitado
	**/
	this.renderDisabledLineElement = function(pElement){
		var bDiv = document.createElement('DIV'); 
		
		var bCssClass = cCLASS_BASE_DISABLED_LINE + " "+bEntity.getParent().getCategory().replace(" ","")+cLINE+"Disabled";
				
		bDiv.className = bCssClass;
		return bDiv;
		
	}
  
  /**
	* Dibuja el elemento de un Grupo
	**/
  
	this.renderEnabledGroupElement = function(pElement){	
		var bDiv = document.createElement('DIV');
 		
		bDiv.setAttribute("ElState","Up");	
		
		var bCssClass = cCLASS_BASE_UP_GROUP + " "+pElement.getParent().getCategory().replace(" ","")+cGROUP+"Up";
		
		bDiv.className = bCssClass;
		return bDiv;
	}
  
  /**
	* Dibuja el elemento de un Grupo deshabilitado
	**/
	this.renderDisabledGroupElement = function(pElement){	
		var bDiv = document.createElement('DIV'); 		
		
		var bCssClass = cCLASS_BASE_DISABLED_GROUP + " "+pElement.getParent().getCategory().replace(" ","")+cGROUP+"Disabled";
		
		bDiv.className = bCssClass;
		return bDiv;
	}
	
	/**
	* Dibuja el elemento de un Grupo que contiene en algun nivel tamites seleccionados
	**/
	this.renderGroupWithSelectedLinesElement = function(pElement){	
		var bDiv = document.createElement('DIV'); 
		
		bDiv.setAttribute("ElState","Up");
		
		var bCssClass = cCLASS_BASE_UP_GROUP_LINE_SELECTED + " "+pElement.getParent().getCategory().replace(" ","")+cGROUP+"Up";
		
		bDiv.className = bCssClass;
		return bDiv;
	}
	
	/**
	* Dibuja el elemento de un Grupo seleccionado
	**/
	this.renderSelectedGroupElement = function(pElement) {
		var bDiv = document.createElement('DIV'); 	
		
		bDiv.setAttribute("ElState","Down");
		
		var bCssClass = cCLASS_BASE_DOWN_GROUP + " "+pElement.getParent().getCategory().replace(" ","")+cGROUP+"Up";
		
		bDiv.className = bCssClass;
		return bDiv;
	}	
	
	/**
	* Dibuja un grupo.
	* El parametro pSelectedChildGroup es opcional
	**/
	this.renderGroup = function(pGroup,pSelectedChildGroup) {
    
    
		//Se crea un div que va a conener las columnas
		var mDivCont = document.createElement('DIV'); 
		mDivCont.style.width = "100%";
	    
	    //Se crea un array para contener los divs de las columnas
		var mColDivs = new Array();		
		
		//Se crea un div para la columna margen inzquierdo
		var mDivLeft = document.createElement('DIV'); 
		mDivLeft.id = "dvEntityColLeft";
		mDivLeft.className=cCLASS_ENTITY_MARGINLEFT;
		mColDivs.push(mDivLeft);
    
    
		
		//Se resguarda el valor de la configuración de cantidad de columnas y en caso de que
		//haya un solo elemento que mostrar se crea una sola columna
		var mEntityColCountAunx = cENTITYCOLUMN_COUNT;
		if (pGroup.getVisibleChilds().length==1) {
		    cENTITYCOLUMN_COUNT = 1;
		}		
		
    
		for (var bIndex = 0; bIndex<cENTITYCOLUMN_COUNT; bIndex++) {
			 //Se crea un divseparador a partir de la segunda columna
			 if (bIndex>0) {
			    var bDivSep = document.createElement('DIV'); 
			    bDivSep.id = "dvEntityColSeparator";
			    bDivSep.className=cCLASS_ENTITY_SEPARATOR;
			    mColDivs.push(bDivSep);
			 }
			 //Se crea un div para la columna
			 var bDiv = document.createElement('DIV'); 
			 bDiv.id = "dvEntityCol"+bIndex;
			 bDiv.className=cCLASS_ENTITYCOLUMN;
			 //Si es una sola columna se centra
			 if (cENTITYCOLUMN_COUNT==1) {
				 bDiv.align = "center";
				 bDiv.style.width = "100%";
			 }

			 mColDivs.push(bDiv);
		}
		
    
		//Se crea un div para la columna margen inzquierdo
		var mDivRight = document.createElement('DIV'); 
		mDivRight.id = "dvEntityColRight";
		mDivRight.className=cCLASS_ENTITY_MARGINRIGHT;
		mColDivs.push(mDivRight);
		
		//variable usada para establecer en que columna se debe agregar el div
		var mColIndex = 1;
		
		//Se obtienen los hijos de la entidad en la que estamos parados				
		var mChilds = pGroup.getChilds();
		//Se ordenana los hijos por el atributo sortorder
		var mEntities = this.OrderChildArray(mChilds);
    
		//Para cada hijo se crea un div
		for (var bIndex = 0; bIndex<mEntities.length; bIndex++) {
			var bDiv;
			bEntity = mEntities[bIndex];	
			
			// si es un grupo con hijos o un tramite
			if ((bEntity.toString()=="YAHOO.uicontrols.emission.utils.Group" && bEntity.getVisibleChilds().length>0) ||
				(bEntity.toString()=="YAHOO.uicontrols.emission.utils.Line")) {
					
				//En caso de ser un grupo solo debe mostrarse si tiene algun elemento
				if (bEntity.toString()=="YAHOO.uicontrols.emission.utils.Group" && bEntity.getVisibleChilds().length>0) {
				
					if (pSelectedChildGroup != undefined 
					   && pSelectedChildGroup.getId() == bEntity.getId()) {
						bDiv = this.renderSelectedGroupElement(bEntity);
					} else if (bEntity.containSelectedLines()) {
						bDiv = this.renderGroupWithSelectedLinesElement(bEntity);
					} else {
						bDiv = this.renderEnabledGroupElement(bEntity);	
					}
					bDiv.id = "dv"+cGROUP+bEntity.getId();
					//Se agrega un tipo al elemento
					bDiv.setAttribute("EntityType",cGROUP);
				} else if(bEntity.toString()=="YAHOO.uicontrols.emission.utils.Line"){			
					bDiv = this.renderEnabledLineElement(bEntity);	
					bDiv.id = "dv"+cLINE+bEntity.getId();	
					//Se agrega un tipo al elemento
					bDiv.setAttribute("EntityType",cLINE);				
				}				
			 
				/*
				//Se agrega TAG SPAN para incluir el alias del tramite			
				var mAliasText = document.createElement('SPAN');			
				mAliasText.className = "ButtonAliasText";
				mAliasText.innerHTML = bEntity.getAlias(); 
				//Se establece el texto a mostrar
				bDiv.appendChild(mAliasText);
				*/
			
				//Se agrega TAG SPAN para controlar la longitud del texto			
					var mTruncateText = document.createElement('div');	
                 mTruncateText.innerHTML = bEntity.getDescription(); 
					 
					               
                //Se obtiene el ancho del boton				
				$('body').append('<div class="ButtonText1" style="display:none" id="ButtonTextWidth"></div>');  
				var mMaxWidth = $('#ButtonTextWidth').width();
				$('#ButtonTextWidth').remove();
				
				//se obtiene la cantidad de renglones
				var mCountTextLines = UtilityTextAlign.countTextLines(mMaxWidth, mTruncateText.innerHTML, 'CharClass');
			    //se agrega el stylo 
				mTruncateText.className = "ButtonText" + mCountTextLines;
				

				
				//Se establece el texto a mostrar
				bDiv.appendChild(mTruncateText);
				
				//Para el evento de click se especifica una funcion		
				YAHOO.util.Event.addListener(bDiv, 
											 "click", 
											 function (pEvent,pParams) {											
												YAHOO.uicontrols.emission.Touchscreen.doAction(pParams.element);
											 },
											 {
												element : bEntity
											 },
											 true
											 );

				//Se agrega en la entidad en la columna correspondiente
				//Cuando se llega a la ultima columna se reinicia el indice
				if (mColIndex>(cENTITYCOLUMN_COUNT*2)) {
					mColIndex = 1;
				}
				//Se agrega			
				mColDivs[mColIndex].appendChild(bDiv);
				mColIndex+=2;
				
			}
			
		}
		
		for(var bIndex = 0; bIndex<mColDivs.length;bIndex++) {
			mDivCont.appendChild(mColDivs[bIndex]);
		}
		          
		//Se reestablece el valor de configuracion de cantidad de columnas
		cENTITYCOLUMN_COUNT = mEntityColCountAunx;
		                     
		return mDivCont;		
	}
	
	/**
	* Dibuja el los grupos y trámites
	**/
	this.renderPrevGroups = function(pGroup) {
    
	    var mGroup = pGroup.getParent();
	    
	    var mPrevGroupsDv = null;
	
	    if (mGroup.getParent() != null) {
	        mPrevGroupsDv = this.renderPrevGroups(mGroup);
	    }
	    
	    var mCurrentGroupDiv = this.renderGroup(mGroup,pGroup);
			
		var mDiv =  document.createElement('DIV');
		
		if (mPrevGroupsDv != null) {
		    mDiv.appendChild(mPrevGroupsDv);
		}
		
		mDiv.appendChild(mCurrentGroupDiv);	
		
		return mDiv;
	}
	

		
	/**
	* Dibuja los grupos y trámites
	**/
	this.render = function(pEntity) {
  
    
    var mPrevGroupsDv = null;
	
    if (cSHOW_PREV_SELECTEDGROUPS && pEntity.getParent() != null) {
        mPrevGroupsDv = this.renderPrevGroups(pEntity);
    }
   
    var mCurrentGroupDiv = this.renderGroup(pEntity);
		                 
   	
		mDivBody =  document.createElement('DIV');
		mDivBody.style.align  = "center";
		mDivBody.style.width  = "100%";
		
		mDivBody.className = cCLASS_BODYLINE;
		if (mPrevGroupsDv != null) {
		    mDivBody.appendChild(mPrevGroupsDv);
		}	
		
			var mTable = document.createElement("table");
			mTable.width = "100%";
			mTable.height = "100%";
			var mTBody = document.createElement("tbody");		
			var mTR = document.createElement("tr");
			var mTD = document.createElement("td");
			mTD.valign = "middle";
			mTD.appendChild(mCurrentGroupDiv);
			mTR.appendChild(mTD);
			mTBody.appendChild(mTR);
			mTable.appendChild(mTBody);
			mDivBody.appendChild(mTable);		
	

		return mDivBody;
	}
}