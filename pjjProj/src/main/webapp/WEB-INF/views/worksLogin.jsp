<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.works_wrap {
	display: flex;
	justify-content: center;
	margin-top: 150px;
}

.works_logo {
	font-size: 30px;
	font-weight: bold;
	text-align: center;
	margin-bottom:
}

.login_id_wrap, .login_pw_wrap {
	margin-bottom: 10px;
}

.login_id_not, .login_pw_not {
	font-weight: bold;
	font-size: 15px;
	margin-bottom: 5px
}

.login_id_wrap input, .login_pw_wrap input {
	width: 240px;
	height: 30px;
	padding: 2px 5px;
}

.login_btn {
	margin-top: 5px;
}

.login_btn button {
	width: 254px;
	height: 40px;
	outline: none;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}
</style>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	function login_click() {
		var param = {
			ID : $('#id').val(),
			PW : $('#pw').val()
		}

		$.ajax({
			url : '/loginOn.do',
			data : param,
			type : 'POST',
			datatype : 'json',
			success : loginOnSucess,
			error : loginOnError
		});

		function loginOnSucess(data) {
			if (data.userCnt > 0) {
				$(location).attr('href', '/home/home.do');
			} else {
				swal('아이디 또는 비밀번호가 잘못되었습니다. 다시 입력해주세요.');
				location.reload();
			}
		}
		function loginOnError() {
			swal('에러');
		}

	}
</script>
</head>
<body>
	<div class="works_wrap">
		<div class="works_login_wrap">
			<div class="works_logo">웍스</div>
			<div class="login_id_wrap">
				<div class="login_id_not">아이디</div>
				<input type="text" name="" id="id" class="login_id_input">
			</div>
			<div class="login_pw_wrap">
				<div class="login_pw_not">패스워드</div>
				<input type="password" name="" id="pw" class="login_pw_input">
			</div>
			<div class="login_btn">
				<button type="button" onclick="login_click()">로그인</button>
			</div>
		</div>
	</div>
</body>
</html>