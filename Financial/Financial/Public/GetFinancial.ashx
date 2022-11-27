<%@ WebHandler Language="C#" Class="GetFinancial" %>

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


public class GetFinancial : IHttpHandler {
    public class Parameter
    {
        public string url = string.Empty;
    }
    public class GetDataOut
    {
        public string ErrMsg { get; set; }
        public List<StockRow> gridList { get; set; }
    }
    public class StockRow
    {
        public string CompanyCode { get; set; }
        public string CompanyAbbreviation { get; set; }
    }
    public void ProcessRequest (HttpContext context) {
        GateWay.Response response = new GateWay.Response();
        string InputData = "";
        string OutputData = "";
        GetDataOut outModel = new GetDataOut();
        outModel.gridList = new List<StockRow>();
        try
        {

            InputData = new StreamReader(context.Request.InputStream).ReadToEnd();
            Parameter parameter = JsonConvert.DeserializeObject<Parameter>(InputData);
            HtmlDocument doc = new HtmlDocument();
            WebClient webClient = new WebClient();
            MemoryStream ms = new MemoryStream(webClient.DownloadData(parameter.url));
            doc.Load(ms, Encoding.UTF8);
            HtmlNodeCollection formNode = doc.DocumentNode.SelectNodes("//form[@name='fm']");
            if (formNode != null)
            {
                HtmlNode filenameNode = doc.DocumentNode.SelectSingleNode("//form[@name='fm']/input[@name='filename']");
                string filenameValue = filenameNode.GetAttributeValue("value", "");
                string csvUrl = "https://mops.twse.com.tw/server-java/t105sb02?firstin=true&step=10&filename={0}";
                csvUrl = string.Format(csvUrl, filenameValue);
                string csvData = webClient.DownloadString(csvUrl);
                if (csvData.Trim().Length > 0)
                {
                    DataTable dt = new DataTable();
                    string[] lineStrs = csvData.Split('\n');
                    for (int i = 0; i < lineStrs.Length; i++)
                    {
                        string strline = lineStrs[i];
                        ArrayList csvLine = new ArrayList();
                        this.ParseCSVData(csvLine, strline);
                        if (i == 0)
                        {
                            for (int c = 0; c < csvLine.Count; c++)
                            {
                                dt.Columns.Add(csvLine[c].ToString());
                            }
                        }
                        else
                        {
                            DataRow dr = dt.NewRow();
                            for (int c = 0; c < csvLine.Count; c++)
                            {
                                dr[c] = csvLine[c].ToString();
                            }
                            dt.Rows.Add(dr);
                        }
                    }
                    foreach (DataRow dr in dt.Rows)
                    {
                        StockRow row = new StockRow();
                        row.CompanyCode = dr["公司代號"].ToString();
                        row.CompanyAbbreviation = dr["公司簡稱"].ToString();
                        outModel.gridList.Add(row);
                    }
                }
            }
            response.Code = "000";
            response.Message = "成功";
            response.datas = outModel.gridList;
            OutputData = JsonConvert.SerializeObject(response);
            context.Response.Write(OutputData);
        }
        catch (Exception ex)
        {

        }
    }

    private void ParseCSVData(ArrayList result, string data)
    {
        int position = -1;
        while (position < data.Length)
            result.Add(ParseCSVField(ref data, ref position));
    }

    private string ParseCSVField(ref string data, ref int StartSeperatorPos)
    {
        if (StartSeperatorPos == data.Length - 1)
        {
            StartSeperatorPos++;
            return "";
        }

        int fromPos = StartSeperatorPos + 1;
        if (data[fromPos] == '"')
        {
            int nextSingleQuote = GetSingleQuote(data, fromPos + 1);
            StartSeperatorPos = nextSingleQuote + 1;
            string tempString = data.Substring(fromPos + 1, nextSingleQuote - fromPos - 1);
            tempString = tempString.Replace("'", "''");
            return tempString.Replace("\"\"", "\"");
        }

        int nextComma = data.IndexOf(',', fromPos);
        if (nextComma == -1)
        {
            StartSeperatorPos = data.Length;
            return data.Substring(fromPos);
        }
        else
        {
            StartSeperatorPos = nextComma;
            return data.Substring(fromPos, nextComma - fromPos);
        }
    }

    private int GetSingleQuote(string data, int SFrom)
    {
        int i = SFrom - 1;
        while (++i < data.Length)
            if (data[i] == '"')
            {
                if (i < data.Length - 1 && data[i + 1] == '"')
                {
                    i++;
                    continue;
                }
                else
                    return i;
            }
        return -1;
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}