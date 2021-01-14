using System;
using StandardSTE = STE;
using log4net;
using eFlow.UI.Client;

namespace CENTROHOSPUCE.STE.UI.Web.Turnos
{   
    public partial class CENTROHOSPUCENewTask : StandardSTE.Turnos.NewTask
    {
        private static log4net.ILog cLogger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public static readonly string CREDENTIALS_KEY = "ClientCredencials";

        protected override eFlow.UI.Client.ClientCredentials CreateCredentials()
        {

            eFlow.UI.Client.ClientCredentials mClientCredentials = new ClientCredentials();

            try
            {
                // deserializo las credenciales que se encuentran en session y las devuelvo
                //==========================================================================    	                	            

                //Obtiene las credenciales de sesión
                cLogger.Debug("Obteniendo de sesión la credencial del cliente.");
                if (Session[CREDENTIALS_KEY] != null)
                {
                    string mResponse = Session[CREDENTIALS_KEY].ToString();

                    // vacía las credenciales de sesión
                    cLogger.Debug("Eliminando las credenciales de sesión.");
                    Session[CREDENTIALS_KEY] = null;

                    Session.Remove(CREDENTIALS_KEY);

                    //Deserializa la credencials
                    CENTROHOSPUCENewTask.cLogger.Debug("Deserializando la credencial.");
                    mClientCredentials = CredentialsHelper.Deserialize(mResponse);

                    cLogger.Debug("Retornando credencial deserializada .");
                }

                return mClientCredentials;
            }
            catch (Exception bErr)
            {
                cLogger.ErrorFormat("Error al deserializar las credenciales",
                    bErr);

                throw new Exception("Error al deserializar credenciales.",
                    bErr);
            }
        }
    }
}