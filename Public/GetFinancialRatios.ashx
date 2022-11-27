<%@ WebHandler Language="C#" Class="GetFinancialRatios" %>

using System;
using System.Web;
using System.IO;
using Newtonsoft.Json;
using System.Net;
using HtmlAgilityPack;
using System.Text;
using System.Data;
using System.Collections;
using System.Collections.Generic;

public class GetFinancialRatios : IHttpHandler {

    public class Parameter
    {
        public string url = string.Empty;
        public string year = string.Empty;
    }

    public void ProcessRequest (HttpContext context) {
        GateWay.Response response = new GateWay.Response();
        string InputData = "";
        string OutputData = "";
        try
        {
            InputData = new StreamReader(context.Request.InputStream).ReadToEnd();
            Parameter parameter = JsonConvert.DeserializeObject<Parameter>(InputData);
            for(var i = 1; i <=2; i++)
            {
                if(i == 2)
                {
                    parameter.year = (Convert.ToInt32(parameter.year) - 4).ToString();
                }
                parameter.url = parameter.url.Replace(" ", parameter.year);

                HtmlDocument doc = new HtmlDocument();
                WebClient webClient = new WebClient();
                MemoryStream ms = new MemoryStream(webClient.DownloadData(parameter.url));
                doc.Load(ms, Encoding.UTF8);
                var docNode = doc.DocumentNode;
                var table = docNode.SelectSingleNode("//table[@style]");
                var td = table.SelectNodes(".//td");
                //td[0].InnerHtml.ToString().Replace("&nbsp;                   ", "")
            }
        }
        catch (Exception ex)
        {

        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}