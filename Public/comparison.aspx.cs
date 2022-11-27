using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Public_comparison : System.Web.UI.Page
{
    public string Stocknumber = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Stocknumber = Request.QueryString["stocknumber"];
    }
}