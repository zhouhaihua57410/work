<%--
  Created by IntelliJ IDEA.
  User: zhouhaihua
  Date: 2019/1/29
  Time: 6:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Title</title>
    <link href="static/css/bootstrap.css" rel="stylesheet">
    <link href="/static/layui/css/layui.css" rel="stylesheet">
    <link href="static/css/login.css" rel="stylesheet">
    <link href="static/css/shopping_cart.css" rel="stylesheet">

</head>
<body>


<div id="header">
    <div class="col-lg-2"></div>
    <div class="col-lg-2">
        <c:choose>
            <c:when test="${sessionScope.identity=='seller'}">卖家你好，</c:when>
            <c:when test="${sessionScope.identity=='buyer'}">买家你好，</c:when>
        </c:choose>
        <c:choose>
            <c:when test="${sessionScope.username == null}">请[<a href="login.jsp">登录</a>]</c:when>
            <c:when test="${sessionScope.username != null}">
                ${sessionScope.username} ! [<a href="/user/logout">退出</a>]
            </c:when>
        </c:choose>

    </div>
    <div class="col-lg-3"></div>
    <div class="col-lg-1"></div>
    <div class="col-lg-1">
        <a href="/index.jsp">首页</a>
    </div>
    <div class="col-lg-1">
        <c:choose>
            <c:when test="${sessionScope.identity=='buyer'}"><a href="bill.jsp">账务</a></c:when>
        </c:choose>
    </div>
    <div class="col-lg-1">
        <c:choose>
            <c:when test="${sessionScope.identity=='seller'}"><a href="publish.jsp">发布</a></c:when>
            <c:when test="${sessionScope.identity=='buyer'}"><a href="shopping_cart.jsp">购物车</a></c:when>
        </c:choose>
    </div>
</div>

<input type="hidden" id="product_name">
<input type="hidden" id="userId" value="${sessionScope.userId}">
<input type="hidden" id="identity" value="${sessionScope.identity}">


<div class="content">

    <div id="title">
        已添加到购物车的内容
    </div>


    <div id="queryResult">
        <table class="table table-bordered table-hover">
            <thead id="t_head">
                <tr>
                    <td>内容图片</td>
                    <td>内容名称</td>
                    <td>购买时间</td>
                    <td>购买数量</td>
                    <td>购买价格</td>
                    <td>操作</td>
                </tr>
            </thead>

            <tbody id="data_body">

            </tbody>
        </table>
        <div id="summary_div">
            <span>总计： </span>
            <span id="summary"></span>
        </div>

    </div>
    <input type="hidden" id="idList">
    <button class="btn btn-primary" onclick="buy();">购买</button>



</div>
<div id="index_footer">
    版权所有：©网易2019届小猪仔SANSUX
</div>
<script type="text/javascript" src="/static/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="/static/js/bootstrap.js"></script>
<script type="text/javascript" src="/static/layui/layui.all.js"></script>
<script>
    $(function () {
        initLayPage();
    });


    /**
     * 初始化layui分页
     */
    function initLayPage(pageConf) {
        if (!pageConf) {
            pageConf = {};
            let productName = $("#product_name").val();
            pageConf.pageSize = 8;
            pageConf.currentPage = 1;
            pageConf.productName = productName;
            pageConf.userId = $("#userId").val();
        }

        $.post("product/shoppingCart", pageConf, function (data) {
            layui.use(['laypage', 'layer'], function () {
                let page = layui.laypage;
                page.render({
                    elem: 'layui',
                    theme: '#FF5722',
                    count: data.total,
                    curr: pageConf.currentPage,
                    limit: pageConf.pageSize,
                    first: "首页",
                    last: "尾页",
                    layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
                    limits: [8, 12, 20, 28, 48],
                    jump: function (obj, first) {
                        if (!first) {
                            pageConf.currentPage = obj.curr;
                            pageConf.pageSize = obj.limit;
                            initLayPage(pageConf);
                        }
                    }
                });
                fillTable(data.list, (pageConf.currentPage - 1) * pageConf.pageSize); //页面填充
            })
        });
    }

    //填充表格数据
    function fillTable(data, num) {
        let info = '';
        let summary='';
        let idList = new Array();
        $.each(data, function (index, obj) {
            idList.push(obj.id);
            let date1 = new Date(obj.createTime);
            let Y1 = date1.getFullYear() + '-';
            let M1 = (date1.getMonth() + 1 < 10 ? '0' + (date1.getMonth() + 1) : date1.getMonth() + 1) + '-';
            let D1 = date1.getDate() + ' ';
            let h1 = date1.getHours() + ':';
            let m1 = date1.getMinutes() + ':';
            let s1 = date1.getSeconds();
            let time1 = Y1 + M1 + D1 + h1 + m1 + s1;
            summary =Number(summary) + Number(obj.price) * Number(obj.sellNum);
            info += '<tr><td><img class="show_img" src="/static/images/' + obj.img + '">' +'</td><td>' + obj.name + '</td><td>'+ time1 +'</td><td>'+ obj.sellNum +
                '</td><td><span class="money_unit">¥ </span>' + obj.price+'</td><td><button class="btn btn-danger btn_move" onclick="move('+obj.id+');">移出</button>'+ '</td></tr>';
        });

        $("#data_body").html(info);
        $("#idList").val(idList);
        $("#summary").html(summary);
    }

    function move(id) {
        if(confirm("确定将该内容移出购物车？")){
            $.get("product/moveFromShoppingCart/"+id, function (data) {
                alert(data);
            });
            initLayPage();
        }
    }

    function buy() {
        let idList="";
        idList = $("#idList").val();
        $.ajax({
            url:"product/buyProduct",
            type:'POST',
            data:{"idList":idList},
            success:function (data) {
                alert(data);
            initLayPage();
            },
            error:function (msg) {
                debugger;
                alert("error");
            }
        });
    }


</script>

