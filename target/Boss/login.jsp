<%--
  Created by IntelliJ IDEA.
  User: zhouhaihua
  Date: 2018/12/29
  Time: 2:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<html>
<head>
    <title>Title</title>
    <link href="static/css/bootstrap.css" rel="stylesheet">
    <link href="static/css/login.css" rel="stylesheet">
</head>
<body>
<div id="header">
    <div class="col-lg-2"></div>
    <div class="col-lg-2">
        <c:choose>
            <c:when test="${sessionScope.username == null}">请[<a href="login.jsp">登录</a>]</c:when>
            <c:when test="${sessionScope.username != null}">${sessionScope.username}</c:when>
        </c:choose>
    </div>
    <div class="col-lg-2"></div>
    <div class="col-lg-3"></div>
    <div class="col-lg-2">
        <a href="index.jsp">首页</a>
    </div>
    <div class="col-lg-2"></div>
</div>


<div id="div1">
    <form id="form1" class="col-md-12" action="user/login" autocomplete="off" method="post">
        <div class="form-group">
            <label for="username">用户名：</label>
            <input class="form-control" required="required" autocomplete="off" type="text" name="username" id="username">
        </div>

        <div class="form-group">
            <label for="password">密码：</label>
            <input class="form-control" required="required" autocomplete="off" type="password" name="password"
                   id="password">
        </div>
        <div class="form-group">
            <label for="btn"></label>
            <button id="btn" class="btn btn-primary">登录</button>
        </div>


    </form>
</div>
<div id="index_footer">
    版权所有：©网易2019届小猪仔SANSUX
</div>
</body>
</html>
