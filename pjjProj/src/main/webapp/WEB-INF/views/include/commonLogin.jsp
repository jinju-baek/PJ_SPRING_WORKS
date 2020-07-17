<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.user_info_wrap {
	display: flex;
	align-items: flex-end;
	justify-content: center;
}

.user_info_wrap div {
	margin: 0 3px;
}

.user_number, .roleId {
	display: none;
}

.user_name {
	font-weight: bold;
	font-size: 18px;
}

.user_jobtitle {
	font-size: 12px;
}

.schedule_wrap {
	/* height: 70px; */
}

.nowTime {
	height: 17px;
	text-align: center;
	font-size: 13px;
}

.schedule_notice {
	font-size: 12px;
	margin: 10px 8px;
	text-align: center;
}

.workOn_time, .workOff_time {
	font-size: 12px;
	width: 100px;
	margin: 6px auto;
	display: none;
}

.schedule_btn {
	display: flex;
	justify-content: center;
	flex-direction: column;
}

.schedule_btn button {
	margin: 2px 0;
	border: none;
	outline: none;
	cursor: pointer;
	height: 28px;
	border-radius: 5px;
}

.workOff_btn {
	display: none;
}
</style>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	var time;
	var startTime;
	$(document).ready(function() {
		var roleId = '${returnData.userInfo.ROLEID}';
		var infoHtml = '';
		var scheduleHtml = '';
		var btnHtml = '';
		if (roleId == 'USER') {
			infoHtml = '<input type="text" class="user_number" id="user_number" value="${returnData.userInfo.EMPNO}">'
				+ '<input type="text" class="roleId" id="roleId" value="${returnData.userInfo.ROLEID}">'
				+ '<div class="user_name" id="user_name">${returnData.userInfo.EMPNAME}</div>'
				+ '<div class="user_jobtitle">${returnData.userInfo.JOBTITLE}</div>';
			scheduleHtml = '<div class="nowTime" id="nowTime"></div>'
				+ '<div class="schedule_notice">일정이 없습니다.</div>'
				+ '<div class="workOn_time">출근 :</div>'
				+ '<div class="workOff_time">퇴근 :</div>';
			btnHtml = '<button type="button" class="workOn_btn" onclick="workOn()">출근하기</button>'
				+ '<button type="button" class="workOff_btn" onclick="workOff()">퇴근하기</button>'
				+ '<button type="button" onclick="logout()">로그아웃</button>';
			$('.user_info_wrap').html(infoHtml);
			$('.schedule_wrap').html(scheduleHtml);
			$('.schedule_btn').html(btnHtml);
			
			var loginFlag = '${returnData.userInfo.loginFlag}';
			if (loginFlag == 1) {
				workOnSuccess('${returnData.userInfo.STARTTIME}');
			}
			if (loginFlag == 0) {
				workOnSuccess('${returnData.userInfo.STARTTIME}');
				workOffSuccess('${returnData.userInfo.ENDTIME}');
			}
		} else if (roleId == 'ADMIN') {
			infoHtml = '<input type="text" class="user_number" id="user_number" value="${returnData.userInfo.EMPNO}">'
				+ '<input type="text" class="roleId" id="roleId" value="${returnData.userInfo.ROLEID}">'
				+ '<div class="user_name" id="user_name">${returnData.userInfo.EMPNAME}</div>';
			scheduleHtml = '<div class="nowTime" id="nowTime"></div>';
			btnHtml = '<button type="button" onclick="logout()">로그아웃</button>';
			$('.user_info_wrap').html(infoHtml);
			$('.schedule_wrap').html(scheduleHtml);
			$('.schedule_btn').html(btnHtml);
		}
		
	});

	setInterval(function() {
		var clock = document.getElementById("nowTime");
		var date = new Date();
		time = leadingZeros(date.getFullYear(), 4) + '-'
				+ leadingZeros(date.getMonth() + 1, 2) + '-'
				+ leadingZeros(date.getDate(), 2) + ' '
				+ leadingZeros(date.getHours(), 2) + ':'
				+ leadingZeros(date.getMinutes(), 2) + ':'
				+ leadingZeros(date.getSeconds(), 2);
		clock.innerHTML = time;
	}, 1000);

	function leadingZeros(n, digits) {
		var zero = '';
		n = n.toString();
		if (n.length < digits) {
			for (i = 0; i < digits - n.length; i++)
				zero += '0';
		}
		return zero + n;
	}

	function workOn() {
		var userNum = $('#user_number').val();
		var paramData = {
			EMPNO : userNum
		}
		$.ajax({
			url : '/home/workOn.do',
			data : paramData,
			dataType : 'text',
			success : workOnSuccess,
			error : workOnError
		});

	}

	function workOnSuccess(data) {
		startTime = data;
		var subStartTime = data.substring(10, 19);

		$('.schedule_notice').css('display', 'none');
		$('.workOn_time').append(subStartTime).css('display', 'block');
		$('.workOff_time').css('display', 'block');
		$('.workOn_btn').css('display', 'none');
		$('.workOff_btn').css('display', 'block');
	}

	function workOnError() {
	}

	function workOff() {
		var userNum = $('#user_number').val();
		var paramData = {
			EMPNO : userNum,
			STARTTIME : startTime
		}
		$.ajax({
			url : '/home/workOff.do',
			data : paramData,
			dataType : 'text',
			success : workOffSuccess,
			error : workOffError
		});
	}

	function workOffSuccess(data) {
		var subEndTime = data.substring(10, 19);
		$('.workOff_time').append(subEndTime);
		$('.workOff_btn').attr('onclick', '').text('오늘도 수고하셨습니다.').css('cursor', 'no-drop');
	}

	function workOffError() {
	}

	function logout() {
		swal('로그아웃되었습니다.');
		$(location).attr('href', '/logout.do');
	}
</script>
</head>
<body>
	<div class="user_info_wrap"></div>
	<div class="schedule_wrap"></div>
	<div class="schedule_btn"></div>
</body>
</html>