<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.13.1/css/all.css" integrity="sha384-xxzQGERXS00kBmZW/6qxqJPyxW3UR0BPsL4c8ILaIWXva5kFi7TxkIIaMiKtqV1Q" crossorigin="anonymous">
<style type="text/css">
.modal_body_wrap {
    display: none;
	position: fixed;
	left: 45%;
    top: 25%;
    background-color: rgba(0,0,0,0.4);
    overflow: auto;
	z-index: 1000;
}

.modal_wrap {
	width: 300px;
	border: 1px solid black;
	background-color: white;
}

.role_wrap {
	margin-left: 15px;
}

.modal_title_wrap {
	display: flex;
	justify-content: space-between;
	margin: 5px 8px;
}

.modal_title {
	font-size: 20px;
	font-weight: bold;
}

.fa-times-circle {
	cursor: pointer;
	line-height: 27px;
	font-size: 21px;
}

.modal_content {
	display: flex;
	margin: 8px 20px;
}

.modal_content_title {
	width: 65px;
}

.modal_content_input input, .empno_input  {
	margin-left: 8px;
}

.modal_content_input_date input {
	width: 172px;
}
.modal_content_input select {
	width: 172px;
	margin-left: 10px;
}

.modal_btn_wrap {
	display: flex;
	justify-content: flex-end;
	margin: 10px;
}

.modal_btn_wrap button {
	border: none;
	background: #EAEAEA;
	cursor: pointer;
	width: 50px;
	height: 25px;
	margin: 0 5px;
	outline: none;
}
</style>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	function modalExit(){
		$('.modal_body_wrap').css('display', 'none');
		$('input:radio[name=roleId]')[0].checked = true;
		$('.empno_input').text('');
		$('.modal_content_input').children('input').val('');
		$('#branch option:eq(0)').attr('selected', 'selected');
		$('#jobtitle option:eq(0)').attr('selected', 'selected');
	}
</script>
<body>	
	<div class="modal_body_wrap">
		<div class="modal_wrap">
			<div class="modal_title_wrap">
				<div class="modal_title">직원 추가</div>
				<i class="far fa-times-circle" onclick="modalExit()"></i>
			</div>
			<div class="role_wrap">
				<label><input type="radio" name="roleId" value="USER" checked>일반</label>
				<label><input type="radio" name="roleId" value="ADMIN">관리자</label>
			</div>
			<div class="modal_content_wrap">
				<div class="modal_content empno_wrap">
					<div class="modal_content_title">사원번호</div>
					<span class="empno_input"></span>
					
				</div>
				<div class="modal_content">
					<div class="modal_content_title">아이디</div>
					<div class="modal_content_input">
						<input type="text" id="id" name="">
					</div>
				</div>
				<div class="modal_content">
					<div class="modal_content_title">비밀번호</div>
					<div class="modal_content_input">
						<input type="password" id="pw" name="">
					</div>
				</div>
				<div class="modal_content">
					<div class="modal_content_title">사원명</div>
					<div class="modal_content_input">
						<input type="text" id="name" name="">
					</div>
				</div>
				<div class="modal_content">
					<div class="modal_content_title">지점</div>
					<div class="modal_content_input modal_content_sel">
						<select id="branch">
							<option value="본사">본사</option>
							<option value="통신사업본부">통신사업본부</option>
						</select>
					</div>
				</div>
				<div class="modal_content">
					<div class="modal_content_title">직무</div>
					<div class="modal_content_input modal_content_sel">
						<select id="jobtitle">
							<option value="대표이사">대표이사</option>
							<option value="전무">전무</option>
							<option value="상무">상무</option>
							<option value="이사">이사</option>
							<option value="부장">부장</option>
							<option value="팀장">팀장</option>
							<option value="차장">차장</option>
							<option value="과장">과장</option>
							<option value="대리">대리</option>
							<option value="사원">사원</option>
						</select>
					</div>
				</div>
				<div class="modal_content">
					<div class="modal_content_title">이메일</div>
					<div class="modal_content_input">
						<input type="email" id="email" name="">
					</div>
				</div>
				<div class="modal_content">
					<div class="modal_content_title">전화번호</div>
					<div class="modal_content_input">
						<input type="tel" id="phone" name="">
					</div>
				</div>
				<div class="modal_content">
					<div class="modal_content_title">입사일</div>
					<div class="modal_content_input modal_content_input_date">
						<input type="date" id="date" name="">
					</div>
				</div>
			</div>
			<div class="modal_btn_wrap">
				<button type="button" class="modal_insBtn" onclick="empIns()">추가</button>
				<button type="button" class="modal_upBtn" onclick="empUp()">수정</button>
				<button type="button" class="modal_delBtn" onclick="empDel()">삭제</button>
			</div>
		</div>
	</div>
</body>
</html>