<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>商品列表</title>
    <link rel="stylesheet" type="text/css" href="/static/css/bootstrap.css">
    <link href="/static/layui/css/layui.css" rel="stylesheet">
    <link href="static/css/productList.css" rel="stylesheet">

</head>
<body>
<div class="panel panel-info">
    <div class="panel-heading">全部商品</div>
    <div class="panel-body">
        <div class="form-group">
            <label class="col-md-1 control-label" for="product_name">商品名：</label>
            <div class="col-md-2">
                <input type="text" class="form-control" id="product_name" name="product" value="">
            </div>
            <label class="col-md-1 control-label" for="seller_name">卖家名：</label>
            <div class="col-md-2">
                <input type="text" class="form-control" id="seller_name" name="seller" value="">
            </div>
            <div class="col-md-1">
                <input type="button" class="btn btn-default" value="查询" onclick="initLayPage()"/>
            </div>
        </div>
        <br/>
        <br>
        <div id="queryResult">
            <table class="table table-bordered">
                <thead>
                <tr>
                    <td>id</td>
                    <td>商品名称</td>
                    <td>单价</td>
                    <td>上传时间</td>
                    <td>更新时间</td>
                    <td>操作</td>
                </tr>
                </thead>

                <tbody id="data_body">

                </tbody>
            </table>
        </div>
        <br>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-sm" onclick="add()">
                <i class="layui-icon" >&#xe654;</i>
            </button>
            <button class="layui-btn layui-btn-sm">
                <i class="layui-icon">&#xe642;</i>
            </button>
            <button class="layui-btn layui-btn-sm">
                <i class="layui-icon">&#xe640;</i>
            </button>
            <button class="layui-btn layui-btn-sm">
                <i class="layui-icon">&#xe602;</i>
            </button>
        </div>
        <div id="layui"></div>

    </div>
    <div class="panel-footer"></div>
</div>

<div class="modal fade" id="mymodal-data">
    <div class="modal-dialog">
        <div class="modal-content">
            <form class="form-horizontal" action="" method="post">
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
                        <label class="col-md-4 control-label">单价：</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="show_price" name="price" value=""
                                   onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}
                                       else{this.value=this.value.replace(/\D/g,'')}"
                                   onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}
                                       else{this.value=this.value.replace(/\D/g,'')}" maxlength="8">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" onclick="update()">确定</button>
                    <button class="btn btn-default" data-dismiss="modal">取消</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="mymodal-data2">
    <div class="modal-dialog">
        <div class="modal-content">
            <form class="form-horizontal" action="" method="post">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times</button>
                    <h4>新增商品信息</h4>
                </div>
                <div class="modal-body">
                    <%--<div class="form-group">--%>
                        <%--<label class="col-md-4 control-label">商品id：</label>--%>
                        <%--<div class="col-md-5">--%>
                            <%--<input type="text" readonly="readonly" class="form-control" id="add_id" name="id" value=""--%>
                                   <%--onkeyup="this.value=this.value.replace(/\s+/g,'')">--%>
                        <%--</div>--%>
                    <%--</div>--%>

                    <div class="form-group">
                        <label class="col-md-4 control-label">商品名：</label>
                        <div class="col-md-5">
                            <input type="text" required="required" class="form-control" id="add_name" name="name"
                                   value="">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-4 control-label">单价：</label>
                        <div class="col-md-5">
                            <input type="text" class="form-control" id="add_price" name="price" value=""
                                   onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}
                                       else{this.value=this.value.replace(/\D/g,'')}"
                                   onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}
                                       else{this.value=this.value.replace(/\D/g,'')}" maxlength="8">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" onclick="create()">确定</button>
                    <button class="btn btn-default" data-dismiss="modal">取消</button>
                </div>
            </form>
        </div>
    </div>
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
            pageConf.pageSize = 5;
            pageConf.currentPage = 1;

            pageConf.productName = productName;
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
                    limits:[5,10,15,30,50],
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
            let date1 = new Date(obj.createTime);
            let Y1 = date1.getFullYear() + '-';
            let M1 = (date1.getMonth() + 1 < 10 ? '0' + (date1.getMonth() + 1) : date1.getMonth() + 1) + '-';
            let D1 = date1.getDate() + ' ';
            let h1 = date1.getHours() + ':';
            let m1 = date1.getMinutes() + ':';
            let s1 = date1.getSeconds();
            let time1 = Y1 + M1 + D1 + h1 + m1 + s1;

            let date2 = new Date(obj.updateTime);
            let Y2 = date2.getFullYear() + '-';
            let M2 = (date2.getMonth() + 1 < 10 ? '0' + (date2.getMonth() + 1) : date2.getMonth() + 1) + '-';
            let D2 = date2.getDate() + ' ';
            let h2 = date2.getHours() + ':';
            let m2 = date2.getMinutes() + ':';
            let s2 = date2.getSeconds();
            let time2 = Y2 + M2 + D2 + h2 + m2 + s2;
            // id 很多时候并不是连续的，如果为了显示比较连续的记录数，可以这样根据当前页和每页条数动态的计算记录序号
            // index = index +num+1;
            info += '<tr><td>' + obj.id + '</td><td>' + obj.name + '</td><td>' + obj.price + '</td><td>' + time1 +
                '</td><td>' + time2 + '</td>' +
                '<td style="text-align: center;"><button name="btnModify" ' +
                'type="button" class="btn btn-success btn-sm" ' +
                ' onclick="show(' + obj.id + ',\'' + obj.name + '\' ,' + obj.price + ')" >修改</button>'
                + '&nbsp;&nbsp;&nbsp;' +
                '<button name="btnDelete" type="button" class="btn btn-danger btn-sm"' +
                ' onclick="remove(' + obj.id + ')">删除</button></td></tr>';
        });
        $("#data_body").html(info);
    }

    function remove(id) {
        if (confirm("确定要删除编号为" + id + "的商品")) {
            $.ajax({
                type: 'get',
                url: "product/delete/" + id,
                success: function (data) {
                    alert(data);
                    console.log(data);
                    initLayPage();
                }
            });
        }
    }

    function show(id, name, price) {
        $("#show_id").val(id);
        $("#show_name").val(name);
        $("#show_price").val(price);
        $("#mymodal-data").modal({
            keyboard: false,
            backdrop: 'static'
        });
    }

    function add(){
        $("#mymodal-data2").modal({
            keyboard: false,
            backdrop: 'static'
        });
    }

    function update() {

        let productId = $("#show_id").val();
        let name = $("#show_name").val();
        let price = $("#show_price").val();
        $.post('product/update',{id:productId,name:name,price:price},function(data){
            alert(data);
        });
    }

    function create() {
        let productId = $("#add_id").val();
        let name = $("#add_name").val();
        let price = $("#add_price").val();
        $.post('product/add',{id:productId,name:name,price:price},function(data){
            alert(data);
        });
    }

</script>
</body>

</html>