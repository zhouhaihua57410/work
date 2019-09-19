<%--
  Created by IntelliJ IDEA.
  User: zhouhaihua
  Date: 2019/1/5
  Time: 3:58 PM
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
    <link href="static/css/publish.css" rel="stylesheet">

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
    <div class="col-lg-1"></div>
    <div class="col-lg-1">
        <c:choose>
            <c:when test="${sessionScope.identity=='seller'}"><a href="publish.jsp">发布</a></c:when>
        </c:choose>

    </div>
</div>
<div class="content">
    <input type="hidden" id="userId" value="${sessionScope.userId}">
    <div id="create">
        <div class="row">
            <div class="col-md-8">
                <div class="form-group row">
                    <label class="col-md-2 control-label">标题：</label>
                    <div class="col-md-8">
                        <input type="text" required="required" class="form-control" placeholder="2-80个字符" id="name"
                               name="name" value="">
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-md-2 control-label">摘要：</label>
                    <div class="col-md-8">
                        <input type="text" required="required" class="form-control" placeholder="2-100个字符"
                               id="abstracts" name="abstract"
                               value="">
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-md-2 control-label">图片：</label>
                    <div class="col-md-8">
                        <input id="lefile" type="file" name="image" multiple="multiple">
                        <div class="input-group">
                            <input type="text" id="photoCover" class="form-control" placeholder="未选择文件...">
                            <span class="input-group-btn">
                                <button class="btn btn-default" onclick="$('input[id=lefile]').click();" type="button">
                                    <i class="fa fa-folder-open"></i>浏览文件</button>
                                    <button class="btn btn-default" onclick="uploadImg()">上传</button>
                                </span>

                        </div>
                    </div>
                    <div class="col-md-6"></div>
                </div>

            </div>
            <div class="col-md-4">
                <div id="img_box">
                    <img class="img_content" src="">
                </div>
            </div>
        </div>


        <div class="form-group row">
            <label class="col-md-1 control-label">正文：</label>
            <div class="col-md-9">
                <textarea name="description" id="description" cols="97" rows="13" placeholder="2-1000个字符"></textarea>
            </div>
        </div>


        <div class="form-group row">
            <label class="col-md-1 control-label">价格：</label>
            <div class="col-md-2">
                <input type="text" required="required" class="form-control" id="price" name="price"
                       value="">
            </div>
            <div class="col-md-5">元</div>
        </div>

        <div class="form-group row">
            <label class="col-md-1 control-label"></label>
            <div class="col-md-5">
                <input type="submit" id="submit" value="提交">
                <button class="btn btn-danger col-md-2" id="fabu" onclick="upload();">发布</button>
            </div>
            <div class="col-md-5">

            </div>
        </div>
    </div>

</div>
<div id="index_footer">
    版权所有：©网易2019届小猪仔SANSUX
</div>
<script type="text/javascript" src="/static/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="/static/js/bootstrap.js"></script>
<script>
    $('input[id=lefile]').change(function () {
        $('#photoCover').val($(this).val());
    });

    $(".a-upload").on("change", "input[type='file']", function () {
        var filePath = $(this).val();
        if (filePath.indexOf("jpg") != -1 || filePath.indexOf("png") != -1 || filePath.index("jpeg")) {
            $(".fileerrorTip").html("").hide();
            var arr = filePath.split('\\');
            var fileName = arr[arr.length - 1];
            $(".showFileName").html(fileName);
        } else {
            $(".showFileName").html("");
            $(".fileerrorTip").html("您未上传文件，或者您上传文件类型有误！").show();
            return false
        }
    });

    $("input[type='file']").on('change', function () {
        var oFReader = new FileReader();
        var file = document.getElementById('lefile').files[0];
        oFReader.readAsDataURL(file);
        oFReader.onloadend = function (oFRevent) {
            var src = oFRevent.target.result;
            $('.img_content').attr('src', src);
        }
    });


    function upload() {
        let name = $("#name").val();
        let abstracts = $("#abstracts").val();
        let img = $("#lefile").val();
        let description = $("#description").val();
        let price = $("#price").val();
        let userId = $("#userId").val();
        $.post('product/add',
            {
                name: name,
                price: price,
                abstracts: abstracts,
                img: img,
                description: description,
                sellerId: userId,
                flag: ""
            },
            function (data) {
                alert(data);
            });
    }

    function uploadImg() {

        var file = $("#lefile").get(0).files[0];
        if (file == null) {
            alert("请选择文件！");
            return;
        }
        var fd = new FormData();
        fd.append("file", file);
        $.ajax({
            url: "/product/uploadImg/",
            type: 'POST',
            data: fd,
            processData: false,// 不处理数据
            contentType: false, // 不设置内容类型
            dataType:'json',
            success: function (data) {
                alert(data.DATA);
            },
            error: function (msg) {
                debugger;
                alert("error");
            }
        });
    }
</script>
</body>
</html>
