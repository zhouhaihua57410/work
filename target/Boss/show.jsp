<%--
  Created by IntelliJ IDEA.
  User: zhouhaihua
  Date: 2019/1/5
  Time: 9:24 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Title</title>
    <link href="/static/css/bootstrap.css" rel="stylesheet">
    <link href="/static/layui/css/layui.css" rel="stylesheet">
    <link href="/static/css/login.css" rel="stylesheet">
    <link href="/static/css/show.css" rel="stylesheet">

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
            <c:when test="${sessionScope.username == null}">请[<a href="/login.jsp">登录</a>]</c:when>
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
            <c:when test="${sessionScope.identity=='buyer'}"><a href="/bill.jsp">账务</a></c:when>
        </c:choose>
    </div>
    <div class="col-lg-1">
        <c:choose>
            <c:when test="${sessionScope.identity=='seller'}"><a href="/publish.jsp">发布</a></c:when>
            <c:when test="${sessionScope.identity=='buyer'}"><a href="/shopping_cart.jsp">购物车</a></c:when>
        </c:choose>
    </div>
</div>
<div class="content">

    <div class="product row">
        <div class="col-md-3" id="img_box">
            <img src="/static/images/${product.img}">
        </div>

        <div class="col-md-6">
            <input type="hidden" id="product_id" value="${product.id}">
            <div id="name">${product.name}</div>
            <div id="abstracts">${product.abstracts}</div>
            <div id="price_outer">¥<span id="price_inner">${product.price}</span></div>
            <c:choose>
                <c:when test="${sessionScope.identity=='buyer'}">
                    <div id="buy_count">
                        <span>购买数量：</span>
                        <a href="#" id="sub" onclick="sub();">-</a>
                        <span id="count">1</span>
                        <a href="#" id="add" onclick="add()">+</a>
                    </div>
                </c:when>
            </c:choose>
            <div id="choose">

                <c:choose>
                    <c:when test="${flag==1}">
                        <button id="have_buy" disabled="disabled" class="btn btn-danger">已购买</button>
                        <span id="buy_price">当时购买价格 ¥${buy_price}</span>
                    </c:when>
                    <c:when test="${sessionScope.identity=='seller'}">
                        <button id="edit" onclick="edit(${product.id},'${product.name}','${product.price}','${product.abstracts}','${product.description}','${product.img}');" class="btn btn-primary">编辑</button>
                        &nbsp;
                        <button onclick="deleteProduct();" class="btn btn-danger">删除</button>
                        &nbsp;
                        <span>已售出</span>&nbsp;<span>${product.sellNum}</span>&nbsp;<span>件</span>
                    </c:when>
                    <c:when test="${flag==0 and sessionScope.identity=='buyer'}">
                        <button id="join" onclick="join();" class="btn btn-primary">加入购物车</button>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>
    <div id="description_head">详细信息</div>
    <div id="description">${product.description}</div>
    <a id="reload" href="/product/show/${product.id}">重新加载</a>

</div>
<div id="index_footer">
    版权所有：©网易2019届小猪仔SANSUX
</div>

<div class="modal fade" id="mymodal-data">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="form-horizontal">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times</button>
                    <h4>修改商品信息</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-md-4 control-label">商品id：</label>
                        <div class="col-md-5">
                            <input type="text" readonly="readonly" class="form-control" id="show_id" name="id" value=""
                                   onkeyup="this.value=this.value.replace(/\s+/g,'')">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-4 control-label">商品名：</label>
                        <div class="col-md-5">
                            <input type="text" required="required" class="form-control" id="show_name" name="name"
                                   value="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-4 control-label">摘要：</label>
                        <div class="col-md-5">
                            <input type="text" required="required" class="form-control" id="show_abstracts" name="abstracts"
                                   value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-4 control-label">单价：</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="show_price" name="price" value=""
                                   onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}
                                       else{this.value=this.value.replace(/\D/g,'')}"
                                   onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}
                                       else{this.value=this.value.replace(/\D/g,'')}" maxlength="8">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-4 control-label">图片：</label>
                        <div class="col-md-7">
                            <%--<input type="file" required="required" multiple="multiple" class="form-control" id="show_img" name="img" value="">--%>
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
                        <div class="col-md-2">

                            <%--<button onclick="uploadImg();" class="btn btn-primary">上传</button>--%>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-4 control-label">正文：</label>
                        <div class="col-md-5">
                            <textarea required="required" cols="43" rows="8"  id="show_description" name="description"
                                      value=""></textarea>
                        </div>

                    </div>

                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" onclick="updateProduct();">确定</button>
                    <button class="btn btn-default" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="/static/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="/static/js/bootstrap.js"></script>
<script>
    const div = $("#count");
    function add() {
        let count = div.html();
        count++;
        div.html(count);
    }

    function edit(id,name,price,abstracts,description,img) {
        $("#show_id").val(id);
        $("#show_name").val(name);
        $("#show_price").val(price);
        $("#show_abstracts").val(abstracts);
        $("#show_description").val(description);
        $("#photoCover").val(img);
        $("#mymodal-data").modal({
            keyboard: false,
            backdrop: 'static'
        });
    }

    function updateProduct() {
        let productId = $("#show_id").val();
        let name = $("#show_name").val();
        let price = $("#show_price").val();
        let abstracts = $("#show_abstracts").val();
        let description = $("#show_description").val();
        let img = $("#photoCover").val();
        $.ajax({
            type:'post',
            url: '/product/editProduct',
            data:{id:productId,name:name,price:price,abstracts:abstracts,description:description,img:img},
            success:function(data){
                alert(data);
            },
            error: function(msg){
                debugger;
                alert("error");
            }
        });
        $("#mymodal-data").modal('hide');
        $("#reload").click();


    }


    function sub() {
        let count = div.html();
        if (count > 1) {
            count--;
        }else{
            alert("商品数量至少为1！")
        }
        div.html(count);
    }
    function join(){
        let count = div.html();
        let product_id = $("#product_id").val();
        let price = $("#price_inner").html();
        $.post('/product/joinShoppingCart',
            {
                productId: product_id,
                count: count,
                price:price
            },
            function (data) {
                alert(data);
            });
    }

    function deleteProduct() {
        if(confirm("确定要删除该商品？")){
            let product_id = $("#product_id").val();

            $.get('/product/deleteProduct/'+ product_id,
                function (data) {
                    alert(data);
                });
        }

    }

    $('input[id=lefile]').change(function () {
        $('#photoCover').val($(this).val());
    });

    function uploadImg() {

        let file = $("#lefile").get(0).files[0];
        if (file == null) {
            alert("请选择文件！");
            return;
        }
        let fd = new FormData();
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
                alert("数据访问异常！");
            }
        });
        return ;
    }
</script>
</body>
</html>
