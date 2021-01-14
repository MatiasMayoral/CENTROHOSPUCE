<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CENTROHOSPUCEIDPage.aspx.cs" Inherits="CENTROHOSPUCE.STE.UI.Web.CENTROHOSPUCEIDPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    
<LINK href="lib/css/CENTROHOSPUCE-MultiLevelLineSelectionBase.css" type="text/css" rel="stylesheet"></LINK>                        

<!--========================================================================-->
<script language="javascript" src="lib/js/build/yuiloader/yuiloader-min.js" type="text/javascript"></script>
<script language="javascript" src="lib/js/jQuery/jquery-1.9.1.js" type="text/javascript"></script>
<script language="javascript" src="lib/js/build/SSUI/UtilityText.js" type="text/javascript"></script>
<script language="javascript" src="lib/js/build/SSUI/General-Loader.js" type="text/javascript"></script>
<script language="javascript" src="lib/js/build/SSUI/TouchScreen-Loader.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript" src="lib/js/build/SSUI/Json2.js"></script>
<script language="javascript" src="lib/js/build/SSUI/CENTROHOSPUCE-MultiLevelLineSelection-Loader.js" type="text/javascript"></script> 
<script language="javascript">
    
    var mClientTypes = '<asp:Literal Runat="server" ID="litClientTypes"></asp:Literal>';
    var mClientTypesObject = JSON.parse(mClientTypes);
    
    function renderGroupsClients(){
        
        var mDVClientIdentification = $('#tableClientTypes');

        for (var i = 0; i < mClientTypesObject.length; i++) {
            //id del grupo de cliente
            var mClientTypeId = mClientTypesObject[i].id;

            //creo un div para agregar la entidad y le coloco la clase y el id
            var trClientType = document.createElement('TR');
            trClientType.id = "dv" + mClientTypesObject[i].description.replace(/\s/g, '');;
            trClientType.className = "LineBaseUp rootLineUp ClientType";
            if (trClientType.id == "dvAseguradoPreferencial" || trClientType.id == "dvNoAseguradoPreferencial")
            {
                trClientType.className = "PreferencialLineBaseUp rootLineUp ClientType";                
            }
            trClientType.value = mClientTypeId;
            trClientType.style.verticalAlign = "middle";
            trClientType.style.marginTop = "50px";
            trClientType.style.cursor = "pointer";
            trClientType.style.width = "500px";
            trClientType.style.lineHeight = "70px";

            //evento click: dispara el TS
            trClientType.addEventListener("click", navigateToTouchscreen, "false"); 
            trClientType.addEventListener("mousedown", changeAppareance, "false"); 
            trClientType.addEventListener("mouseup", changeAppareance, "false"); 
            //Texto dentro del div
            trClientType.innerHTML = mClientTypesObject[i].description;
            if (trClientType.id == "dvAseguradoPreferencial" || trClientType.id == "dvNoAseguradoPreferencial")
            {
                trClientType.innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + mClientTypesObject[i].description;                
            }
            //Cosa Loca
            if (trClientType.id != "dvNoIdentificado" && trClientType.id != "dvGC5" && trClientType.id != "dvGC6")
            {
                mDVClientIdentification.append(trClientType);
            }
        }
    }

    function navigateToTouchscreen(){
        window.navigate("CENTROHOSPUCETouchscreen.aspx?ClientTypeId=" + this.value);
    }

    function changeAppareance(){
        if (arguments[0].type == "mousedown"){
            this.className = "LineBaseUp rootLineDown ClientType";
            if(this.id == "dvAseguradoPreferencial" || this.id == "dvNoAseguradoPreferencial")
            {
                this.className = "PreferencialLineBaseUp rootLineDown ClientType";
            }
            
        }
        else{
            this.className = "LineBaseUp rootLineUp ClientType";
            if(this.id == "dvAseguradoPreferencial" || this.id == "dvNoAseguradoPreferencial")
            {
                this.className = "PreferencialLineBaseUp rootLineUp ClientType";
            }
        }
    }

    $( document ).ready(function() {
        //renderizo las entidades
        renderGroupsClients();

        //Cantidad de tipos de clientes
        var mQuantityOfClientTypes = mClientTypesObject.length;

        //Dependiendo de la cantidad, se realizan diversas configuraciones estéticas (máximo 7 entidades)
        if (mQuantityOfClientTypes == 1){
            var mDvEntitySeparatorTop = document.getElementById('EntitySeparatorTop');
            mDvEntitySeparatorTop.style.height = "356px";
        }
        if (mQuantityOfClientTypes == 2){
            var mTable = document.getElementById('tableClientTypes');
            mTable.cellSpacing = "70";
            var mDvTable = document.getElementById('dvTable');
            mDvTable.style.width = "550px";
            var mDvEntitySeparatorLeft = document.getElementById('EntitySeparatorLeft');
            mDvEntitySeparatorLeft.style.width = "238px";
            var mDvEntitySeparatorTop = document.getElementById('EntitySeparatorTop');
            mDvEntitySeparatorTop.style.height = "260px";
        }
        if (mQuantityOfClientTypes == 3){
            var mTable = document.getElementById('tableClientTypes');
            mTable.cellSpacing = "70";
            var mDvTable = document.getElementById('dvTable');
            mDvTable.style.width = "550px";
            var mDvEntitySeparatorLeft = document.getElementById('EntitySeparatorLeft');
            mDvEntitySeparatorLeft.style.width = "238px";
            var mDvEntitySeparatorTop = document.getElementById('EntitySeparatorTop');
            mDvEntitySeparatorTop.style.height = "187px";
        }
        if (mQuantityOfClientTypes == 4){
            var mDvEntitySeparatorTop = document.getElementById('EntitySeparatorTop');
            mDvEntitySeparatorTop.style.height = "195px";
        }

        if (mQuantityOfClientTypes == 5){
            var mTable = document.getElementById('tableClientTypes');
            mTable.cellSpacing = "15";
            var mDvEntitySeparatorTop = document.getElementById('EntitySeparatorTop');
            mDvEntitySeparatorTop.style.height = "250px";
        }
        if (mQuantityOfClientTypes == 6){
            var mTable = document.getElementById('tableClientTypes');
            mTable.cellSpacing = "25";
            var mDvEntitySeparatorTop = document.getElementById('EntitySeparatorTop');
            mDvEntitySeparatorTop.style.height = "137px";
        }
        if (mQuantityOfClientTypes == 7){
            var mTable = document.getElementById('tableClientTypes');
            mTable.cellSpacing = "15";
            var mDvEntitySeparatorTop = document.getElementById('EntitySeparatorTop');
            mDvEntitySeparatorTop.style.height = "250px";

        }


    });

</script>

<head runat="server">
    <title>CENTROHOSPUCE - IDPage</title>
</head>
<body>
    <div class="dvTouchScreenClass" style="WIDTH:1024px;HEIGHT:768px">    
        <div id="EntitySeparatorTop"></div>  
        <div id="EntitySeparatorLeft"></div>
        <div id="dvTable" style="width: 500px; float:left">
            <table id ="tableClientTypes" height="100%" width="100%" cellSpacing="40" cellPadding="0" border="0" width="500px"></table>
        </div>      
        <div id="EntitySeparatorRight"></div>
        <!--<div id="dvClientIdentification" align="center"></div>-->
        
        
    </div>
</body>
</html>