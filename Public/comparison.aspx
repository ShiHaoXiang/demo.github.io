<%@ Page Language="C#" AutoEventWireup="true" CodeFile="comparison.aspx.cs" Inherits="Public_comparison" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="comparison">

        </div>
    </form>
</body>
</html>

<script src="../Js/vue.js"></script>
<script src="../Js/vue-resource.js"></script>
<script src="../Js/jquery.js"></script>
<script>
    var comparison = new Vue({
        el: '#comparison',
        data: {
            Stocknumber: '<%=Stocknumber%>',
            Year: '',
        },
        mounted: function () {
            this.init();
        },
        methods: {
            init: function () {
                this.GetYear();
                this.GetFinancial();
            },
            GetYear: function () {
                var date = new Date();
                this.Year = date.getFullYear() - 1912;
            },
            GetFinancial: function () {
                var stocknumber = this.Stocknumber.split("-");
                for (var i = 0; i < stocknumber.length; i++) {
                    var obj = {
                        url: 'https://mops.twse.com.tw/mops/web/ajax_t05st22?encodeURIComponent=1&run=Y&step=1&TYPEK=sii&year= &isnew=false&co_id=' + stocknumber[i] + '&firstin=1&off=1&ifrs=Y',
                        year: this.Year,
                    };
                    this.$http.post("GetFinancialRatios.ashx", JSON.stringify(obj)).then(
                        function (response) {
                            var res2 = response.body;

                        }
                    );
                }
            },
        },
    })
</script>