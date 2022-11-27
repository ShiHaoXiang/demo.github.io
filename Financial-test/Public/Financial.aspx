<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Financial.aspx.cs" Inherits="Public_Financial" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>財務報表</title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Financial">
            <div>
                <span>模式</span>
                <select v-model="model" v-on:change="ChangeModel()">
                    <option value="">請選擇模式</option>
                    <option value="1">製作財務報表</option>
                    <option value="2">財務比率比較</option>
                </select>
            </div>
            <div>
                <template v-if="model=='1'">
                    <div>

                    </div>
                </template>
                <template v-else-if="model=='2'">
                    <div>
                        <datalist id="area"></datalist>
                        <table class="box">
                            <tr>
                                <td>
                                    <input list="area" type="text" id="tt1"/>
                                </td>
                                <td>
                                    <input list="area" type="text" id="tt2"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input list="area" type="text" id="tt3"/>
                                </td>
                                <td>
                                    <input list="area" type="text" id="tt4"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input list="area" type="text" id="tt5"/>
                                </td>
                                <td>
                                    <input list="area" type="text" id="tt6"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input list="area" type="text" id="tt7"/>
                                </td>
                                <td>
                                    <input list="area" type="text" id="tt8"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input list="area" type="text" id="tt9"/>
                                </td>
                                <td>
                                    <input list="area" type="text" id="tt10"/>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type="button" value="開始比較" v-on:click="Getnumber()"/>
                                </td>
                            </tr>
                        </table>
                    </div>
                </template>
            </div>
        </div>
    </form>
</body>
</html>

<link href="../Css/StyleSheet-Financial.css" rel="stylesheet" />
<script src="../Js/vue.js"></script>
<script src="../Js/vue-resource.js"></script>
<script src="../Js/jquery.js"></script>

<script>
    var Financial = new Vue({
        el: '#Financial',
        data: {
            model: '',
            stock: [],
        },
        mounted: function () {

        },
        methods: {
            ChangeModel: function () {
                if (this.model == "1") {

                }
                else if (this.model == "2") {
                    var obj = {
                        url: 'https://mops.twse.com.tw/mops/web/ajax_t51sb01?encodeURIComponent=1&step=1&firstin=1&TYPEK=sii&code=',
                    };
                    this.$http.post("GetFinancial.ashx", JSON.stringify(obj)).then(
                        function (response) {
                            var res2 = response.body;
                            for (var i = 0; i < res2.datas.length; i++) {
                                $("#area").append('<option label="' + res2.datas[i]["CompanyCode"] + '" value="' + res2.datas[i]["CompanyCode"] + " " + res2.datas[i]["CompanyAbbreviation"] + '"></option>');
                            }
                        }
                    );
                }
            },
            Getnumber: function () {
                this.stock = [];
                for (var i = 1; i <= 10; i++) {
                    var ans = $("#tt" + i.toString()).val();
                    if (ans != "") {
                        if (this.stock.indexOf(ans.split(" ")[0]) == -1) {
                            this.stock.push(ans.split(" ")[0]);
                        }
                        else {
                            return;
                        }
                    }
                }
                if (this.stock.length >= 2) {
                    window.location.href = "comparison.aspx?stocknumber=" + this.stock.join("-");
                }
                else {
                    alert("未選擇兩筆以上的資料")
                }
            },
        }
    })
</script>