<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
body {
	padding: 0;
	margin: 0;
}

.works_header_wrap {
	border-bottom: 1px solid black;
}

.works_header {
	width: 876px;
	display: flex;
	padding: 15px 0 15px 30px;
	margin: 0 auto;
}

.works_logo {
	margin-right: 50px;
	font-size: 25px;
	font-weight: bold;
}

.header_menu_wrap {
	display: flex;
	align-items: center;
}

.header_menu_wrap button {
	margin: 0 15px;
	border: none;
	background: none;
	font-size: 15px;
	outline: none;
	cursor: pointer;
}
</style>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var roleId = '${returnData.userInfo.ROLEID}';
		var inHtml = '';
		if (roleId == 'USER') {
			inHtml = '<div><button type="button" class="headerBtn_home" onclick="document.location.href=' + "'/home/home.do'" + '">홈</button>'
			+ '</div><div><button type="button" class="headerBtn_Req" onclick="document.location.href=' + "'/req/req.do'" + '">요청</button>'
			+ '</div><div><button type="button" Class="headerBtn_report" onclick="document.location.href=' + "'/rep/rep.do'" + '">리포트</button>'
			+ '</div>';
		} else if(roleId == 'ADMIN') {
			inHtml = '<div><button type="button" class="headerBtn_home" onclick="document.location.href=' + "'/home/home.do'" + '">홈</button>'
			+ '</div><div><button type="button" class="headerBtn_Req" onclick="document.location.href=' + "'/req/req.do'" + '">요청 관리</button>'
			+ '</div>';
		}
		$('.header_menu_wrap').html(inHtml);
	});
</script>
</head>
<body>
	<div class="works_header_wrap">
		<div class="works_header">
			<div class="works_logo">웍스</div>
			<div class="header_menu_wrap"></div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/modal.jsp" />

</body>
</html>