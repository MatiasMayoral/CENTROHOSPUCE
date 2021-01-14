using log4net;
using STE2 = STE;
using CENTROHOSPUCE.STE.Shared.Extensions;
using eFlow.UI.Client;

namespace CENTROHOSPUCE.STE.UI.Web
{
    public partial class CENTROHOSPUCETouchScreen : STE2.TouchScreen
    {
        private static log4net.ILog cLogger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected override void UpdateVisualizationModel(System.Xml.XmlNode pVisualizationModelNode)
        {
            //Obtiene dato del grupo desde la url
            var groupClient = "asegurado";

            //creacion de la credencial
            cLogger.Debug("Creando credencial.");
            ClientCredentials mClientCredentials = new ClientCredentials();
            //se setea el grupo en las extendidas
            mClientCredentials.SetBusinessUnit(groupClient);

            // Serializo las credenciales para guardarlas en la session.				                
            cLogger.Debug("Guardando en sesión la credencial.");
            Session[Turnos.CENTROHOSPUCENewTask.CREDENTIALS_KEY] = CredentialsHelper.Serialize(mClientCredentials);
        }
    }
}