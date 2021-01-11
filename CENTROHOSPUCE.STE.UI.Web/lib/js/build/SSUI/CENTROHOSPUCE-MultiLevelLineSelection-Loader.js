
    /* Loader particular para el multi level line selection
       ==================================*/
	multiLevelLineSelectionLoader = new function()	
	{      
		 // Registra los modulos
    this.register = function(pL)
    {	
			var mL = pL.getInstance();    
      
			mL.addModule({
				name     : "multiLevelLineSelection",
				type     : "js",
				path     : "SSUI/CENTROHOSPUCE-MultiLevelLineSelection.js",
				requires : ["dom"]
			});
      
      mL.addModule({
				name     : "multiLevelLineSelection_presenter",
				type     : "js",
				path     : "SSUI/CENTROHOSPUCE-MultiLevelLineSelection_Presenter.js"
			});		   
      		            
			mL.require("multiLevelLineSelection");
      mL.require("multiLevelLineSelection_presenter");
      		                
    };
 
	};
	
	
	// Registra el modulo para su carga
    multiLevelLineSelectionLoader.register(SSUI_GENERAL_LOADER);