using Newtonsoft.Json;
using STE;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using STE2 = STE;

namespace CENTROHOSPUCE.STE.UI.Web
{
    public partial class CENTROHOSPUCEIDPage : System.Web.UI.Page
    {
        class ClientType
        {
            public int id { get; set; }
            public string description { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {            
            Hashtable mHash;
            DataTable mClientTypeDT;

            //Se obtienen los grupos de cliente
            mHash = STE2.eFlow.GetClientTypes(STE2.LoginData.GetUserName(this),
                                             STE2.LoginData.GetPassword(this),
                                             STE2.LoginData.GetOrganizationCode(this),
                                             STE2.LoginData.GetUserHostName(this),
                                             STE2.LoginData.GetDTECode((Hashtable)this.Session["LoginData"]),
                                             Convert.ToInt32(STE2.eFlow.Function.Atencion));

            mClientTypeDT = STE2.WebFnc.GetTableFromHash(mHash,
                                                    "ClientsTypesDS",
                                                    0);
            //Creo una lista de un tipo que contiene solo el id y la descripcion
            List<ClientType> mClientTypes = new List<ClientType>();

            //Si hay al menos un grupo de cliente
            if (mClientTypeDT.Rows.Count > 0)
            {
                for (int i = 0; i < mClientTypeDT.Rows.Count; i++)
                {
                    ClientType mClientType = new ClientType();
                    mClientType.id = Convert.ToInt32(mClientTypeDT.Rows[i].ItemArray[0]);
                    mClientType.description = mClientTypeDT.Rows[i].ItemArray[2].ToString();
                    mClientTypes.Add(mClientType);
                }
            }
            else
            {
                throw new Exception("No se recuperaron grupos de clientes. Se debe configurar al menos uno.");
            }
            
            //Los ordeno de manera ascendente por código de cliente
            mClientTypes = mClientTypes.OrderBy(x => x.id).ToList();

            //Lo mando como un JSON en un literal para poder manejarlo en la vista
            this.litClientTypes.Text = JsonConvert.SerializeObject(mClientTypes, Formatting.None);
        }
    }
}