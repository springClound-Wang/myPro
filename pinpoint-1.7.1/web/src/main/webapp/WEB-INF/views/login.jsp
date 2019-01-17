<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登陆</title>
    <link rel="shortcut icon" href="favicon.png" type="image/png">
    <link rel="icon" href="favicon.png" type="image/png">
    <link rel="stylesheet" href="../../components/bootstrap/dist/css/bootstrap.min.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script src="../../components/jquery/dist/jquery.min.js"></script>
    <script src="../../components/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../../components/jquery/dist/md5.min.js"></script>

    <style type="text/css">
        body{
            background-image: url("../../lib/img/timg.jpg"); background-size:100% 100%;
            background-attachment:fixed; background-size: cover;
            background-color: #CCCCCC;  background-position: center center;background-repeat: no-repeat;

        }

        .form{background:#ffffff;width:400px;margin:120px auto;border-radius: 5px}
        /*阴影*/
        .fa{display: inline-block;top: 27px;left: 6px;position: relative;color: #ccc;}
        input[type="text"],input[type="password"]{padding-left:26px;}
        .checkbox{padding-left:21px;}
    </style>



</head>
<body>
<div class="container">
    <div class="form row">
        <div class="form-horizontal col-md-offset-3" id="login_form">
            <h3 class="form-title">LOGIN</h3>
            <div class="col-md-9">
                <div class="form-group">
                    <i class="fa fa-user fa-lg"></i>
                    <input class="form-control required" type="text" placeholder="Mobile" id="loginPhone" name="username" autofocus="autofocus" maxlength="20"/>
                </div>
                <div class="form-group">
                    <i class="fa fa-lock fa-lg"></i>
                    <input class="form-control required" type="password" placeholder="Password" id="loginPassword" name="password" maxlength="8"/>
                </div>
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" name="remember" />记住我
                    </label>
                </div>
                <div class="form-group col-md-offset-9">
                    <button type="submit" class="btn btn-success pull-right" name="submit" id="jsLoginBtn">登录</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script>
    $(function () {
        $("#jsLoginBtn").click(function () {
            var loginPhone=$("#loginPhone").val();
            var re = /^[1][3-9][0-9]{9}$/;
            if (!re.test(loginPhone)) {
                $("#loginPhone").css({"border-color":"red"}).focus();
                alert("手机号格式不正确");
                return;
            }
            else{
                $("#loginPhone").css({"border-color":""});
            }
            var loginPassword=$("#loginPassword").val();
            if(!loginPassword){
                $("#loginPassword").css({"border-color":"red"}).focus();
                alert("请输入密码");
                return;
            }else{
                $("#loginPassword").css({"border-color":""});
            }

            if(loginPassword){
                loginPassword=inputPassToFormPass(loginPassword);
            }

            var obj={"userPhone":loginPhone,"userPassword":loginPassword};
            var promise = $.post("/login/doLogin.pinpoint",obj);
            promise.then(function (json) {
                if(json=="success"){
                    location.href="/#/main";
                }else{
                    alert(json.errorMessage?json.errorMessage:json);
                }


            }, function (error) {
                console.log(error);
                alert("网络异常,请稍后重试");
            });
        });
    });

    function inputPassToFormPass(inputPass) {
        //盐
        var salt = "https://www.5pao.com-17601430479";
        //混淆视听 slat
        var str = ""+salt.charAt(0)+salt.charAt(2) + inputPass +salt.charAt(5) + salt.charAt(4);
        //加密一次
        return md5(str);
    }

</script>
</html>



