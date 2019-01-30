<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018-07-23
  Time: 15:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>预警日志</title>
    <link rel="stylesheet" type="text/css" href="css-styles/query.css"/>
    <link rel="stylesheet" type="text/css" href="css-styles/jquery-ui-1.8.2.custom.css"/>
    <link rel="stylesheet" type="text/css" href="css-styles/ui.jqgrid.css"/>
    <script src="js/jquery.js" type="text/javascript"></script>
    <script src="js/grid.locale-cn.js" type="text/javascript"></script>
    <script src="js/jquery.jqGrid.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/WdatePicker.js"></script>
    <script type="text/javascript">

        <!--查询事件,判断条件的合法性-->
        $(function () {// 初始化内容
            $("#to").val(GetDateStr(0));//现在的时间
            $("#from").val(GetDateStr(-7));//一星期前
            $("#list").jqGrid({
                caption: '预警日志',
                url: '/journal',
                postData: {starttime:  $("#from").val(), endtime: $("#to").val()+1000*60*60*24},
                ajaxGridOptions: {type: "POST"},
                datatype: "json",
                colNames: ['编号', '时间点', '覆冰厚度(mm)','等级','操作','处理人','备注'],
                colModel: [
                    {name: 'no', index: 'no', width: 15, align: 'center'},
                    {name: 'time', index: 'time', width: 20},
                    {name: 'thickness', index: 'thickness', width: 25, align: 'center'},
                    {name: 'grade', index: 'grade', width: 20, align: 'center'},
                    {name: 'operation', index: 'operation', width: 25, align: 'center'},
                    {name: 'operator', index: 'operator', width: 25, align: 'center'},
                    {name: 'remarks', index: 'remarks', width: 50, align: 'center'}
                ],
                rowNum: 10,
                rowList: [10, 20, 30],
                rownumbers: true,
                rownumWidth: 20,
                pager: '#pager2',
                sortname: 'id',
                loadonce: true,
                autowidth: true,
                height: 270,
                viewrecords: true,
                sortable: true,
                sortorder: "asc"
            }).navGrid("#pager2", {edit: false, add: false, del: false});
            return check();
        });

        function GetDateStr(AddDayCount) {
            var dd = new Date();
            dd.setDate(dd.getDate() + AddDayCount);//获取AddDayCount天后的日期
            var y = dd.getFullYear();
            var m = dd.getMonth() + 1;//获取当前月份的日期
            var d = dd.getDate();
            return y + "-" + m + "-" + d;
        }

        function check() {
            var starttime = $("#from").val();//传送的起始时间数据
            var endtime = $("#to").val()+1000*24*60*60;//传送的终止时间数据
            if(checkdate()){
                $("#list").jqGrid('setGridParam',{
                    datatype:'json',
                    postData:{starttime: starttime, endtime: endtime}
                }).trigger('reloadGrid');
            }

        }
        <!--日期验证-->
        function checkdate() {
            var start = document.getElementById("from").value;
            var end = document.getElementById("to").value;
            var flag = true;
            if (start.length == 0 || end.length == 0) {
                alert("请选择一个时间段!");
                flag = false;
            }
            start = start.split("-");
            end = end.split("-");
            var dstart = new Date(start[0], start[1] - 1, start[2]);
            var dend = new Date(end[0], end[1] - 1, end[2]);
            if (dend < dstart) {
                alert("时间段选择有误，开始时间不能比结束时间晚!");
                flag = false;
            }
            else if (Math.round((dend - dstart) / 86400000) > 365) {
                alert("时间段跨度请勿超过一年!");
                flag = false;
            }
            return flag;
        }

    </script>
</head>

<body>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0" bgcolor="#F9FCF3">
    <tr>
        <col width="40"/>
        <col width="60"/>
        <col width="120"/>
        <col/>
    <tr>
        <td colspan="4" align="left" bgcolor="#F5F8F2">
            <table cellpadding="0" cellspacing="0" width="100%" border="0" class="nobord">
                <img src="/images/tb.gif" width="22" height="21" align="absmiddle"/> <span class="bt1">预警日志查询</span>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="4" align="left" bgcolor="#F5F8F2" style="line-height: 220%;">
            监控类型：<label>所有类别</label>
            <br/>数据时间：<input type="text" size="9" onclick="WdatePicker()" readonly="readonly" name="from" id="from"/>
            &nbsp;-&nbsp;<input type="text" size="9" onclick="WdatePicker()" readonly="readonly" name="to" id="to"/>
            &nbsp;&nbsp;<input type="button" value="查 询" class="iptbtn" onclick="check()"/>
        </td>
    </tr>
    <tr>
        <table id="list"></table>
        <div id="pager2"></div>
    </tr>
    </tr>
</table>
</body>
</html>

