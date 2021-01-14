using System;
using eFlow.UI.Client;

namespace CENTROHOSPUCE.STE.Shared.Extensions
{
    // <summary>
    /// Extensiones para las credenciales del cliente.
    /// </summary>
    public static class ClientCredentialsExtensions
    {
        private static readonly String GROUP_CLIENT = "typeclient";


        // El parametro unidad Negocio devuelto por el WS, se guarda en las credenciales CorporateName.
        public static String GetBusinessUnit(this IClientCredentials pClientCredentials)
        {
            return pClientCredentials.ClientData[GROUP_CLIENT].ToString();
        }

        public static void SetBusinessUnit(this IClientCredentials pClientCredentials, String pDescriptionClientType)
        {

            if (!String.IsNullOrWhiteSpace(pDescriptionClientType))
            {
                pClientCredentials.ClientData[GROUP_CLIENT] = pDescriptionClientType.Trim();
            }

        }

    }
}



