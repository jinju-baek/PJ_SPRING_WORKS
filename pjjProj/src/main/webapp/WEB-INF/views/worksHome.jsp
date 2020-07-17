<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.works_body_wrap {
	width: 876px;
	display: flex;
	margin: 30px auto;
}

.works_sidebar_wrap {
	width: 250px;
}

.works_content_wrap {
	margin-left: 15px;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<div class="works_wrap">
		<div class="works_body_wrap">
			<div class="works_sidebar_wrap">
				<jsp:include page="/WEB-INF/views/include/commonLogin.jsp" />
			</div>
			<div class="works_content_wrap">
				<div class="calendar_wrap">
					<jsp:include page="/WEB-INF/views/include/calendar.jsp" />
				</div>
			</div>
		</div>
	</div>
</body>
</html>