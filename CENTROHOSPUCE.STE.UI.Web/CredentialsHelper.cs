using System.Xml.Serialization;
using System.Text;
using System.IO;

namespace CENTROHOSPUCE.STE.UI.Web
{
    public class CredentialsHelper
    {
        private CredentialsHelper()
        {
            //oculto
        }

        /// <summary>
        /// Serializa las credenciales
        /// </summary>
        /// <param name="pCredentials">Credenciales del cliente a serializar</param>
        /// <returns>string serializado</returns>
        public static string Serialize(eFlow.UI.Client.ClientCredentials pCredentials)
        {
            XmlSerializer mSerializer;

            StringBuilder mBuilder = new StringBuilder();

            StringWriter mWriter = new StringWriter(mBuilder);

            mSerializer = new XmlSerializer(pCredentials.GetType());

            XmlSerializerNamespaces mXmlSerNs = new XmlSerializerNamespaces();


            mSerializer.Serialize(mWriter,
                pCredentials,
                mXmlSerNs);

            return mBuilder.ToString();

        }

        /// <summary>
        /// Realiza la deserialización de credenciales
        /// </summary>
        /// <param name="pResponse">String a desserializar.</param>
        /// <returns>Credencial deserializada</returns>
        public static eFlow.UI.Client.ClientCredentials Deserialize(string pResponse)
        {

            // deserializo las credenciales que se encuentran en session y las devuelvo
            //==========================================================================
            // Deserializo el objeto

            eFlow.UI.Client.ClientCredentials mCredentials = null;
            XmlSerializer mSerializer2;
            StringReader mReader;

            mSerializer2 = new XmlSerializer(typeof(eFlow.UI.Client.ClientCredentials));

            mReader = new StringReader(pResponse);

            mCredentials = (eFlow.UI.Client.ClientCredentials)mSerializer2.Deserialize(mReader);

            return mCredentials;
        }
    }
}