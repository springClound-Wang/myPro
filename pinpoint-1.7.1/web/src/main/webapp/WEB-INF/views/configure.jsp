<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户组配置</title>
    <link rel="stylesheet" href="../../components/bootstrap/dist/css/bootstrap.min.css">
    <script src="../../components/jquery/dist/jquery.min.js"></script>
    <script src="../../components/bootstrap/dist/js/bootstrap.min.js"></script>
    <style type="text/css">
        .table span i{
            cursor: pointer;
        }
        .group-table span i:first-child{display:none;}
        .member-table span i:first-child{display:none;}
        .user-table span .glyphicon-share-alt{
            display:none;
        }

        form{
            margin: 0px;
            padding: 0px;
        }
        #home{
            margin-top: 20px;
        }
        #home .panel-default-a{
            width: 32%;
            float: left;
            margin-right: 2%;
        }
        #home .panel-default-a:last-child{
            margin-right: 0;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">精确配置</h3>
        </div>
        <div class="panel-body">

            <div>

                <!-- Nav tabs -->
                <ul class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab" data-toggle="tab">用户组设置</a></li>

                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane active" id="home">
                        <div class="panel panel-default panel-default-a">
                            <div class="panel-heading"><font id="group-table-title">用户组(0)</font><span onclick="addrow()" style="cursor: pointer;float: right"><i class="glyphicon glyphicon-plus"></i>添加</span></div>
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="userGroupName" placeholder="请输入名称">
                                            <span class="input-group-btn">
                                            <button class="btn btn-default" onclick="searchUserGroup()" type="button"><i class="glyphicon glyphicon-search"></i>搜索</button>
                                            </span>
                                        </div><!-- /input-group -->
                                    </div><!-- /.col-lg-6 -->
                                </div><!-- /.row -->
                                <table class="table table-hover table-bordered group-table">

                                </table>
                            </div>
                        </div>
                        <div class="panel panel-default panel-default-a" >
                            <div class="panel-heading" id="member-table-title">用户组成员(0)</div>
                            <div class="panel-body">
                                <table class="table table-hover table-bordered member-table">
                                    <tr><td align="center">选择"用户组"在这里启用</td></tr>
                                </table>
                            </div>
                        </div>

                        <div class="panel panel-default panel-default-a">
                            <div class="panel-heading"><font id="user-table-title">用户(0)</font><span onclick="addUserRow()" style="cursor: pointer;float: right"><i class="glyphicon glyphicon-plus"></i>添加</span></div>
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="userName" placeholder="请输入名称或部门">
                                            <span class="input-group-btn">
                                            <button class="btn btn-default" onclick="searchUser()" type="button"><i class="glyphicon glyphicon-search"></i>搜索</button>
                                            </span>
                                        </div><!-- /input-group -->
                                    </div><!-- /.col-lg-6 -->
                                </div><!-- /.row -->
                                <table class="table table-hover table-bordered user-table">
                                </table>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
    </div>
</div>
</body>
<script>

        function addrow(){

            var tables = $('.group-table');
            var addtr = $("<tr>"+
                "<td><form onsubmit='return false'><font><input type='text' name='groupName' placeholder='新建用户组'> <span style=\"float: right\"><i class=\"glyphicon glyphicon-ok insert\" style='display:inline-block'></i>&nbsp;&nbsp;&nbsp;<i class=\"glyphicon glyphicon-remove\" onclick='deleteTrRow(this)'></i></span></font></form></td>"+
                "</tr>");
            tables.prepend(addtr);

        }

        function deleteTrRow(obj){
            //多一个parent就代表向前一个标签,
            //本删除范围为<td><tr>两个标签,即向前两个parent
            //如果多一个parent就会删除整个table
            $(obj).parent().parent().parent().parent().parent().remove();
        }
        //删除用户组
        $('.group-table').on("click","tr td span i.del",function(e) {
            if(e && e.stopPropagation) { //非IE
                e.stopPropagation();
            } else { //IE
                window.event.cancelBubble = true;
            }
            var result=$(this).parent().parent().parent().hasClass('danger');
            var id=$(this).data("data");

            if(result){
                //删除
                $.ajax({
                    type: 'DELETE',
                    url: '/userGroup.pinpoint',
                    data: '{"id":"'+id+'"}',
                    success: function(data){
                        if(data&&data.errorCode){
                            alert(data.errorMessage);
                        }else{
                            searchUserGroup();
                        }
                    },contentType:"application/json;charset=UTF-8",
                        dataType: "json",
                    error: function(data){
                        console.log(data);
                        alert("网络错误,请稍后重试");
                    }
                });
            }else {
                $(this).parent().parent().parent().addClass("danger");
                $(this).attr("style","color:red");
                $(this).prev("i").show();
            }

        });
        //删除用户组用户
        $('.member-table').on("click","tr td span i.del",function(e) {
            if(e && e.stopPropagation) { //非IE
                e.stopPropagation();
            } else { //IE
                window.event.cancelBubble = true;
            }
            var result=$(this).parent().parent().parent().hasClass('danger');

            if(result){
                var userGroup=$(this).data("usergroup");
                var member=$(this).data("member");
                var obj=$(this);
                //删除
                $.ajax({
                    type: 'DELETE',
                    url: '/userGroup/member.pinpoint',
                    data: '{"memberId":"'+member+'","userGroupId":"'+userGroup+'"}',
                    success: function(data){
                        if(data&&data.errorCode){
                            alert(data.errorMessage);
                        }else{
                           //将用户的复选框取消
                            $("#user_"+member).find("input").attr("checked",false);
                            obj.parent().parent().parent().remove();
                        }
                        var  num=$('.member-table tr').length;
                        $("#member-table-title").html("用户组成员("+num+")");
                    },contentType:"application/json;charset=UTF-8",
                    dataType: "json",
                    error: function(data){
                        console.log(data);
                        alert("网络错误,请稍后重试");
                    }
                });
            }else {
                $(this).parent().parent().parent().addClass("danger");
                $(this).attr("style","color:red");
                $(this).prev("i").show();
            }

        });
        //撤销用户组操作
        $('.group-table').on("click","tr td span i.ret",function(e)  {
            if(e && e.stopPropagation) { //非IE
                e.stopPropagation();
            } else { //IE
                window.event.cancelBubble = true;
            }
            $(this).parent().parent().parent().removeClass("danger");
            $(this).hide();
            $(this).next("i").removeAttr("style");
        });
        //撤销用户组用户操作
        $('.member-table').on("click","tr td span i.ret",function(e)  {
            if(e && e.stopPropagation) { //非IE
                e.stopPropagation();
            } else { //IE
                window.event.cancelBubble = true;
            }
            $(this).parent().parent().parent().removeClass("danger");
            $(this).hide();
            $(this).next("i").removeAttr("style");
        });
        //新增用户组操作
        $('.group-table').on("click","tr td span i.insert",function(e)  {
            if(e && e.stopPropagation) { //非IE
                e.stopPropagation();
            } else { //IE
                window.event.cancelBubble = true;
            }
           var name= $(this).parent().prev("input").val();
            if(!name){
                alert("请输入用户组名称");
                $(this).parent().prev("input").focus();
                return;
            }
            var arr='{"id":"'+name+'"}';
            $.ajax({
                "type": "POST",
                "url": "/userGroup.pinpoint",
                "data": arr,
                "success": function (data) {
                    if(data&&data.errorCode){
                        alert(data.errorMessage);
                    }else{
                        searchUserGroup();
                    }
                },"contentType":"application/json;charset=UTF-8",
                "dataType": "json",
                "error": function (data) {
                    console.log(data);
                    alert("网络错误,请稍后重试");
                }
            });
        });
        //新增用户
         function addUserRow(){
             //获取表单
             var len=$(".user-table").find('form').length;
             if(len>=1){
                 findAllUser();
             }
             var tables = $('.user-table');
             var addtr = $("<tr>"+
                 "<td>" +"<div class=\"panel panel-default\">" +
                 "<div class=\"panel-body\"><form  onsubmit='return false'>" +
                 "<input type=\"number\" name='userId' class=\"form-control\" placeholder=\"用户编号\">" +
                 "<input type=\"text\" name='name'  class=\"form-control\" placeholder=\"名称\">" +
                 "<input type=\"text\" name='department'  class=\"form-control\" placeholder=\"部门\">" +
                 "<input type=\"text\" name='phoneNumber'  class=\"form-control\" maxlength='11' placeholder=\"手机号\">" +
                 "<input type=\"text\" name='email'  class=\"form-control\" placeholder=\"邮箱\"><span style=\"float: right\"><i class=\"glyphicon glyphicon-ok\" onclick='conAddUser(this)'></i>&nbsp;&nbsp;&nbsp;<i class=\"glyphicon glyphicon-remove\" onclick='deleteTrRow(this)'></i></span>" +
                 "</form></div></div>"+
                 "</tr>");

             tables.prepend(addtr);
         }

         //确认新增用户
        function conAddUser() {
            var dataBool=true;
            //获取所有表单数据
            var form=$('.user-table').find("form").serializeObject();

            for(var key in form){
                if(!form[key]){
                    alert('请填写完整的表单数据');
                    dataBool=false;
                    break;
                }

                if(key=="phoneNumber"){
                    var re = /^[1][3-9][0-9]{9}$/;
                    if (!re.test(form[key])) {
                        alert('请填写正确的手机号');
                        dataBool=false;
                        break;
                    }
                }
                if(key=="email"){
                    var re = /^[A-Za-z\d]+([-_.][A-Za-z\d]+)*@([A-Za-z\d]+[-.])+[A-Za-z\d]{2,4}$/;
                    if (!re.test(form[key])) {
                        alert('请填写正确的邮箱');
                        dataBool=false;
                        break;
                    }
                }
            }
            if(dataBool){
                $.ajax({
                    "type": "POST",
                    "url": "/user.pinpoint",
                    "data": JSON.stringify(form) ,
                    "success": function (data) {
                        if(data&&data.errorCode){
                            alert(data.errorMessage);
                        }else{
                            findAllUser();
                        }
                    },"contentType":"application/json;charset=UTF-8",
                    "dataType": "json",
                    "error": function (data) {
                        console.log(data);
                        alert("网络错误,请稍后重试");
                    }
                });
            }

        }
        function eaditUser(obj){
            //获取表单
            var len=$(".user-table").find('form').length;
            //console.log(len)
            if(len>=1){
                findAllUser();
            }
            var userid=$(obj).data("userid");
            var department=$(obj).data("department");
            var name=$(obj).data("name");
            var phone=$(obj).data("phone");
            var email=$(obj).data("email");

            var str=$("#user_"+userid).html();
            $("#user_"+userid).empty();
            $("#user_"+userid).append("<div class=\"panel panel-default\">" +
                "                 <div class=\"panel-body\"><form onsubmit='return false'>" +
                "<input type=\"text\" class=\"form-control\" name='userId'  readonly='readonly' value='"+userid+"' placeholder=\"用户编号\">" +
                "<input type=\"text\" class=\"form-control\" name='name' value='"+name+"' placeholder=\"名称\">" +
                "<input type=\"text\" class=\"form-control\" name='department'  value='"+department+"' placeholder=\"部门\">" +
                "<input type=\"text\" class=\"form-control\" name='phoneNumber' maxlength='11' value='"+phone+"' placeholder=\"手机号\">" +
                "<input type=\"text\" class=\"form-control\" name='email' value='"+email+"' placeholder=\"邮箱\"><span style=\"float: right\"><i class=\"glyphicon glyphicon-ok\" onclick='conEditUser()'></i>&nbsp;&nbsp;&nbsp;<i class=\"glyphicon glyphicon-remove\" data-data='"+str+"' onclick=\"showUserEdit(this,"+userid+")\"></i></span>" +
                "</form></div>" +
                "             </div>");
        }
        function showUserEdit(obj,num) {
            $("#user_"+num).empty();
            $("#user_"+num).append($(obj).data("data"));
        }
        function searchUserGroup(){
            var name=$("#userGroupName").val();
           // console.log(name);
            //查询所有用户组
            $.get("/userGroup.pinpoint?userGroupId="+name,function(data){
                if(data&&data.length>0){
                    $(".group-table").empty();
                    for(var userGroup in data) {
                        $(".group-table").append("<tr><td data-data="+data[userGroup].id+"><span>"+data[userGroup].id+"</span><span style=\"float: right\">" +
                            "<i class=\"glyphicon glyphicon-share-alt ret\"></i>&nbsp;&nbsp;&nbsp;" +
                            "<i class=\"glyphicon glyphicon-remove del\" data-data='"+data[userGroup].id+"' ></i></span></td></tr>");
                    }
                }
                var  num= $('.group-table tr').length;
                $("#group-table-title").html("用户组("+num+")");
            });
        }
        function userGroupCall(callback){
            //查询所有用户组
            $.get("/userGroup.pinpoint",function(data){
                callback&&callback(data);
            });
        }
        //搜索用户
        function searchUser(){
            var name=$("#userName").val();
            if(!name){
                alert("请输入查询名称");
              return;
            }
            //查询所有用户
            $.get("/user.pinpoint?searchKey="+name,function(data){
                $(".user-table").empty();
                if(data&&data.length>0){
                    for(var user in data) {
                        $(".user-table").append("<tr><td id=\"user_"+data[user].userId+"\"><span>("+data[user].department+")"+data[user].name+"</span><span style=\"float: right\">" +
                            "<i onclick='returnUser(this)' class=\"glyphicon glyphicon-share-alt\"></i>&nbsp;&nbsp;&nbsp;" +
                            "<i data-userid='"+data[user].userId+"' data-name='"+data[user].name+"' data-department='"+data[user].department+"' data-phone='"+data[user].phoneNumber+"' data-email='"+data[user].email+"' onclick=\"eaditUser(this)\" class=\"glyphicon glyphicon-pencil\"></i>&nbsp;&nbsp;&nbsp;" +
                            "<i data-data='"+data[user].userId+"' class=\"glyphicon glyphicon-remove\" onclick=\"deleteUser(this)\"></i></span></td></tr>");
                    }
                    $(".user-table td").prepend("<input type='checkbox' class='box'/>");
                    //获取当前member下所有的用户
                    var member=$(".member-table i.del");
                    for(var i=0;i<member.length;i++){
                        for(var j=0;i<data.length;j++){
                            if(member[i]==data[j].userId){
                                //给用户选中效果
                                $("#user_"+member[i]).find("input").attr("checked","checked");
                            }
                        }
                    }
                }
                var  num=$('.user-table tr').length;
                $("#user-table-title").html("用户("+num+")");
            });
        }
        //删除用户
        function deleteUser(obj){
            var result=$(obj).parent().parent().parent().hasClass('danger');
            if(result){
                var id=$(obj).data("data");
                $.ajax({
                    "type": "DELETE",
                    "url": "/user.pinpoint",
                    "data": '{"userId":"'+id+'"}' ,
                    "success": function (data) {
                        if(data&&data.errorCode){
                            alert(data.errorMessage);
                        }else{
                            findAllUser();
                        }
                    },"contentType":"application/json;charset=UTF-8",
                    "dataType": "json",
                    "error": function (data) {
                        console.log(data);
                        alert("网络错误,请稍后重试");
                    }
                });
            }else {
                $(obj).parent().parent().parent().addClass("danger");
                $(obj).attr("style","color:red");
                $(obj).prev("i").hide();
                $(obj).prev().prev("i").show();
            }

        }
        //撤销用户操作
        function returnUser(obj){
            $(obj).parent().parent().parent().removeClass("danger");
            $(obj).hide();
            $(obj).next().next("i").removeAttr("style");
            $(obj).next("i").show();
        }
        //编辑用户
        function conEditUser(){
            var dataBool=true;
            //获取所有表单数据
            var form=$('.user-table').find("form").serializeObject();

            for(var key in form){
                if(!form[key]){
                    alert('请填写完整的表单数据');
                    dataBool=false;
                    break;
                }

                if(key=="phoneNumber"){
                    var re = /^[1][3-9][0-9]{9}$/;
                    if (!re.test(form[key])) {
                        alert('请填写正确的手机号');
                        dataBool=false;
                        break;
                    }
                }
                if(key=="email"){
                    var re = /^[A-Za-z\d]+([-_.][A-Za-z\d]+)*@([A-Za-z\d]+[-.])+[A-Za-z\d]{2,4}$/;
                    if (!re.test(form[key])) {
                        alert('请填写正确的邮箱');
                        dataBool=false;
                        break;
                    }
                }
            }
            if(dataBool){
                $.ajax({
                    "type": "PUT",
                    "url": "/user.pinpoint",
                    "data": JSON.stringify(form) ,
                    "success": function (data) {
                        if(data&&data.errorCode){
                            alert(data.errorMessage);
                        }else{
                            findAllUser();
                        }
                    },"contentType":"application/json;charset=UTF-8",
                    "dataType": "json",
                    "error": function (data) {
                        console.log(data);
                        alert("网络错误,请稍后重试");
                    }
                });
            }

        }
        function findAllUser(){
            //查询所有用户
            $.get("/user.pinpoint",function(data){
                if(data&&data.length>0){
                    $(".user-table").empty();
                    for(var user in data) {
                        $(".user-table").append("<tr><td id=\"user_"+data[user].userId+"\"><span>("+data[user].department+")"+data[user].name+"</span><span style=\"float: right\">" +
                            "<i onclick='returnUser(this)' class=\"glyphicon glyphicon-share-alt\"></i>&nbsp;&nbsp;&nbsp;" +
                            "<i data-userid='"+data[user].userId+"' data-name='"+data[user].name+"' data-department='"+data[user].department+"' data-phone='"+data[user].phoneNumber+"' data-email='"+data[user].email+"' onclick=\"eaditUser(this)\" class=\"glyphicon glyphicon-pencil\"></i>&nbsp;&nbsp;&nbsp;" +
                            "<i data-data='"+data[user].userId+"' class=\"glyphicon glyphicon-remove\" onclick=\"deleteUser(this)\"></i></span></td></tr>");
                    }
                }
                var  num=$('.user-table tr').length;
                $("#user-table-title").html("用户("+num+")");
            });
        }
        $(function () {
            //查询所有用户组
            userGroupCall(function (data) {
                if(data&&data.length>0){
                    for(var userGroup in data) {
                        $(".group-table").append("<tr><td data-data="+data[userGroup].id+"><span>"+data[userGroup].id+"</span><span style=\"float: right\">" +
                            "<i class=\"glyphicon glyphicon-share-alt ret\"></i>&nbsp;&nbsp;&nbsp;" +
                            "<i class=\"glyphicon glyphicon-remove del\"  data-data='"+data[userGroup].id+"'></i></span></td></tr>");
                    }
                }
                var  num= $('.group-table tr').length;
                $("#group-table-title").html("用户组("+num+")");
            })
            //查询所有用户
            findAllUser();
            //查询用户组用户
            $('.group-table').on("click","tr td",function(){
                if(!$(this).data("data")){
                    return;
                }
                var  successBool=$(this).parent().hasClass("success");
                var  dangerBool=$(this).parent().hasClass("danger");
                //将其他的颜色恢复
                $(this).parent().siblings().removeClass("success");
                var span_i=$(this).parent().siblings().find("td span i.del");
                for(var i=0;i<span_i.length;i++){
                    $(span_i[i]).show();
                }

                if(successBool||dangerBool){
                    return;
                }
                var  inputBox=$(".user-table td input");
                for(var i=0;i<inputBox.length;i++){
                    $(inputBox[i]).attr("checked",false);
                }
                $(this).parent().addClass("success");
                $(this).find("i").hide();
                var groupid=$(this).data("data");
                //console.log(groupid);
                $.ajax({
                    type: 'GET',
                    url: '/userGroup/member.pinpoint',
                    data: {'userGroupId': groupid},
                    success: function (data) {
                        $('.member-table').empty();
                       if(data&&data.length>0){
                           $(".user-table td input").remove();
                           $(".user-table td").prepend("<input type='checkbox' class='box'/>");
                           for(var user in data) {
                               $(".member-table").append("<tr><td><span>("+data[user].department+")"+data[user].name+"</span><span style=\"float: right\">" +
                                   "<i class=\"glyphicon glyphicon-share-alt ret\"></i>&nbsp;&nbsp;&nbsp;" +
                                   "<i data-userGroup='"+data[user].userGroupId+"' data-member='"+data[user].memberId+"' class=\"glyphicon glyphicon-remove del\"></i></span></td></tr>");
                               //给用户选中效果
                             $("#user_"+data[user].memberId).find("input").attr("checked","checked");

                           }
                       }
                        var  num=$('.member-table tr').length;
                        $("#member-table-title").html("用户组成员("+num+")");
                    },
                    error: function (data) {
                        console.log(data);
                        alert("网络错误,请稍后重试");
                    }
                });

            });
            $.fn.serializeObject = function()
            {
                var o = {};
                var a = this.serializeArray();
                $.each(a, function() {
                    if (o[this.name]) {
                        if (!o[this.name].push) {
                            o[this.name] = [o[this.name]];
                        }
                        o[this.name].push(this.value || '');
                    } else {
                        o[this.name] = this.value || '';
                    }
                });
                return o;
            };
            $(".user-table").on("click","input[type='checkbox']",function(e){
                if(e && e.stopPropagation) { //非IE
                    e.stopPropagation();
                } else { //IE
                    window.event.cancelBubble = true;
                }
                    var bool=$(this).is(":checked");
                    var member=$(this).next().next().find("i:nth-child(2)").data("userid");
                    var department=$(this).next().next().find("i:nth-child(2)").data("department");
                    var name=$(this).next().next().find("i:nth-child(2)").data("name");
                    var userGroup=$(".group-table tr.success").find("span")[0].innerHTML;
                    if(bool){
                        //给当前用户组加上
                        $.ajax({
                            type: 'POST',
                            url: '/userGroup/member.pinpoint',
                            data: '{"memberId":"'+member+'","userGroupId":"'+userGroup+'"}',
                            success: function(data){
                                if(data&&data.errorCode){
                                    alert(data.errorMessage);
                                }else{
                                    //将用户组成员添加一个
                                    $(".member-table").append("<tr><td><span>("+department+")"+name+"</span><span style=\"float: right\">" +
                                        "<i class=\"glyphicon glyphicon-share-alt ret\"></i>&nbsp;&nbsp;&nbsp;" +
                                        "<i data-userGroup='"+userGroup+"' data-member='"+member+"' class=\"glyphicon glyphicon-remove del\"></i></span></td></tr>");
                                }
                                var  num=$('.member-table tr').length;
                                $("#member-table-title").html("用户组成员("+num+")");
                            },contentType:"application/json;charset=UTF-8",
                            dataType: "json",
                            error: function(data){
                                console.log(data);
                                alert("网络错误,请稍后重试");
                            }
                        });
                    }else{
                       // 给当前用户组取消
                        $.ajax({
                            type: 'DELETE',
                            url: '/userGroup/member.pinpoint',
                            data: '{"memberId":"'+member+'","userGroupId":"'+userGroup+'"}',
                            success: function(data){
                                if(data&&data.errorCode){
                                    alert(data.errorMessage);
                                }else{
                                    //将用户组成员删除一个
                                    $(".member-table").find("i.del").each(function(){
                                        console.log($(this).attr("data-member"));
                                       if($(this).data("member")==member){
                                           $(this).parent().parent().parent().remove();
                                       }
                                    });
                                }
                                var  num=$('.member-table tr').length;
                                $("#member-table-title").html("用户组成员("+num+")");
                            },contentType:"application/json;charset=UTF-8",
                            dataType: "json",
                            error: function(data){
                                console.log(data);
                                alert("网络错误,请稍后重试");
                            }
                        });
                    }
                }
            );
        });
</script>
</html>
