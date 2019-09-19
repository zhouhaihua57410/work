<%--
  Created by IntelliJ IDEA.
  User: zhouhaihua
  Date: 2018/12/29
  Time: 2:50 PM
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
    <link href="static/css/index.css" rel="stylesheet">

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
        <a href="index.jsp">首页</a>
    </div>
    <div class="col-lg-1">
        <c:choose>
            <c:when test="${sessionScope.identity=='buyer'}"><a href="publish.jsp">账务</a></c:when>
        </c:choose>
    </div>
    <div class="col-lg-1">
        <c:choose>
            <c:when test="${sessionScope.identity=='seller'}"><a href="publish.jsp">发布</a></c:when>
            <c:when test="${sessionScope.identity=='buyer'}"><a href="publish.jsp">购物车</a></c:when>
        </c:choose>
    </div>
</div>

<input type="hidden" id="product_name">
<input type="hidden" id="userId" value="${sessionScope.userId}">

<div class="content">

    <ul class="nav nav-tabs">
        <li class="active"><a href="#notice1" data-toggle="tab"> 所有内容</a></li>
        <c:choose>
            <c:when test="${sessionScope.identity=='buyer'}">
                <li><a href="#notice2" data-toggle="tab">未购买</a></li>
            </c:when>
        </c:choose>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade in active" id="notice1">

            <ul id="productList">

            </ul>
            <div class="split"></div>

            <div id="layui"></div>


        </div>
        <div class="tab-pane fade in" id="notice2">
            123123
        </div>
    </div>
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

        $.post("product/list", pageConf, function (data) {
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
        $.each(data, function (index, obj) {
            info += '<li class="product">'
                + '<a href="/product/show/' + obj.id + '">'
                + '<div class="img"><img src="/static/images/' + obj.img + '"></div>'
                + '</a>'
                + '<div class="product_name">' + obj.name + '</div>'
                + '<div class="price"><span class="unit">¥   </span>' + obj.price + '</div>';
            if (obj.flag.length != 0) {
                info += '<div class="triangle"></div>'
                    + '<div class="flag">' + obj.flag + '</div>'
            }
            info += '</li>';
        });
        $("#productList").html(info);
    }
</script>
</body>
</html>
