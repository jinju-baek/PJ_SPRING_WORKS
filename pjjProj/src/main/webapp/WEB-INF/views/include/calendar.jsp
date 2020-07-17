<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.cal_top {
	text-align: center;
	font-size: 30px;
}

.cal {
	text-align: center;
}

table.calendar {
	display: inline-table;
	text-align: left;
	border-top: 1px solid black;
    border-bottom: 1px solid black;
    border-collapse: collapse;
    margin-top: 10px;
}

table.calendar td {
	vertical-align: top;
	width: 100px;
	padding: 7px;
	border-top: 1px solid #BDBDBD;
}
table.calendar th {
	background-color: #EAEAEA;
	text-align: center;
}
#movePrevMonth, #moveNextMonth {
	text-decoration: none;
}
#movePrevMonth:visited, #moveNextMonth:visited{
	color: black;
}
.cal-schedule {
	font-size: 13px;
}
</style>
<script type="text/javascript">
	var today = null;
	var year = null;
	var month = null;
	var firstDay = null;
	var lastDay = null;
	var $tdDay = null;
	var $tdSche = null;
	var jsonData = null;

	var splitStartYear = [];
	var splitStartMon = [];
	var splitStartDay = [];
	var splitEndDay = [];
	var startRealTime = [];

	$(document).ready(function() {
		drawCalendar();
		initDate();
		doSrch();
		drawDays();
		$("#movePrevMonth").on("click", function() {
			movePrevMonth();
		});
		$("#moveNextMonth").on("click", function() {
			moveNextMonth();
		});
	});

	function doSrch() {
		var userNum = $('#user_number').val();
		var param = {
			EMPNO : userNum
		};
		$.ajax({
			method : "post",
			url : "/home/srchCalendar.do",
			data : param,
			dataType : "JSON",
			async : false,
			beforeSend : beforeAjax,
			success : sucDoSrch,
			error : errDoSrch

		});
	}

	function beforeAjax(xmlHttpRequest) {
		xmlHttpRequest.setRequestHeader("AJAX", "true");
	}

	function sucDoSrch(result) {
		var workList = result.returnData.resultData;
		var splitStartDate = [];
		var splitEndDate = [];
		var splitStartDate = [];
		var startTime = [];
		var endTime = [];
		var splitStartYYMMDDDate = [];
		var splitEndYYMMDDDate = [];

		for (var i = 0; i < workList.length; i++) {
			splitStartDate[i] = workList[i].STARTTIME;
			splitEndDate[i] = workList[i].ENDTIME;
		}

		for (var j = 0; j < splitStartDate.length; j++) {
			splitStartDate[j] = splitStartDate[j].split(" ");

			//퇴근을 안한 경우 데이터가 없기때문에 null값 체크해준다
			if (splitEndDate[j] != null) {
				splitEndDate[j] = splitEndDate[j].split(" ");
			}
		}

		for (var k = 0; k < splitStartDate.length; k++) {
			splitStartYYMMDDDate[k] = splitStartDate[k][0].split("-");

			if (splitEndDate[k] != null) {
				splitEndYYMMDDDate[k] = splitEndDate[k][0].split("-");
			}

			startTime[k] = splitStartDate[k][1];
			if (splitEndDate[k] != null) {
				endTime[k] = splitEndDate[k][1];
			}

			splitStartYear[k] = splitStartYYMMDDDate[k][0];
			splitStartMon[k] = splitStartYYMMDDDate[k][1].replace('/(^0+)/', "");
			splitStartDay[k] = splitStartYYMMDDDate[k][2].replace('/(^0+)/', "");

			if (splitEndYYMMDDDate[k] != null) {
				splitEndDay[k] = splitEndYYMMDDDate[k][2].replace('/(^0+)/', "");
			}
		}

		var dateMatch = null;
		for (var i = 1; i < firstDay.getDay() + lastDay.getDate(); i++) {

			dateMatch = firstDay.getDay() + i - 1;
			for (var j = 0; j < splitStartDay.length; j++) {
				if (splitStartDay[j] == i && splitStartYear[j] == year
						&& splitStartMon[j] == month.replace('/(^0+)/', "")) {
					if (startTime[j] == "00:00:00") {
						$tdSche.eq(dateMatch).text("결근");
					} else {
						$tdSche.eq(dateMatch).text(
								startTime[j].substring(0, 5) + " ~ ");
					}
				}
			}
			for (var j = 0; j < splitStartDay.length; j++) {
				if (splitEndDay[j] == i && splitStartYear[j] == year
						&& splitStartMon[j] == month.replace('/(^0+)/', "")
						&& splitEndDay[j] != null) {
					if (startTime[j] == "00:00:00") {
						$tdSche.eq(dateMatch).append("");
					} else {
						$tdSche.eq(dateMatch).append(endTime[j].substring(0, 5));
					}
				}
			}

		}
	}

	function errDoSrch(xhr, status, error) {
		if (xhr.status == 999) {
			swal({
				title : "세션이 만료되었습니다. 다시 로그인하시기 바랍니다.",
				closeOnClickOutside : false
			}).then($(location).attr('href', 'login.do'));
		} else {
			swal({
				title : "메뉴 리스트 조회 중 오류가 발생하였습니다.",
				closeOnClickOutside : false
			});
		}
	}

	//Calendar 그리기
	function drawCalendar() {
		var setTableHTML = "";
		setTableHTML += '<table class="calendar">';
		setTableHTML += '<tr><th>SUN</th><th>MON</th><th>TUE</th><th>WED</th><th>THU</th><th>FRI</th><th>SAT</th></tr>';
		for (var i = 0; i < 6; i++) {
			setTableHTML += '<tr height="70">';
			for (var j = 0; j < 7; j++) {
				setTableHTML += '<td style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap">';
				setTableHTML += '    <div class="cal-day"></div>';
				setTableHTML += '    <div class="cal-schedule"></div>';
				setTableHTML += '    <div class="cal-schedule2"></div>';
				setTableHTML += '</td>';
			}
			setTableHTML += '</tr>';
		}
		setTableHTML += '</table>';
		$("#cal_tab").html(setTableHTML);
	}

	//날짜 초기화
	function initDate() {
		$tdDay = $("td div.cal-day")
		$tdSche = $("td div.cal-schedule")
		$tdSche2 = $("td div.cal-schedule2")
		dayCount = 0;
		today = new Date();
		year = today.getFullYear();
		month = today.getMonth() + 1;
		if (month < 10) {
			month = "0" + month;
		}
		firstDay = new Date(year, month - 1, 1);
		lastDay = new Date(year, month, 0);
	}

	//calendar 날짜표시
	function drawDays() {
		$("#cal_top_year").text(year);
		$("#cal_top_month").text(month);
		for (var i = firstDay.getDay(); i < firstDay.getDay()
				+ lastDay.getDate(); i++) {
			$tdDay.eq(i).text(++dayCount);
		}
		for (var i = 0; i < 42; i += 7) {
			$tdDay.eq(i).css("color", "red");
		}
		for (var i = 6; i < 42; i += 7) {
			$tdDay.eq(i).css("color", "blue");
		}
	}

	//calendar 월 이동
	function movePrevMonth() {
		month--;
		if (month <= 0) {
			month = 12;
			year--;
		}
		if (month < 10) {
			month = String("0" + month);
		}
		getNewInfo();
	}

	function moveNextMonth() {
		month++;
		if (month > 12) {
			month = 1;
			year++;
		}
		if (month < 10) {
			month = String("0" + month);
		}
		getNewInfo();
	}

	//정보갱신
	function getNewInfo() {
		for (var i = 0; i < 42; i++) {
			$tdDay.eq(i).text("");
			$tdSche.eq(i).text("");
			$tdSche2.eq(i).text("");
		}
		dayCount = 0;
		firstDay = new Date(year, month - 1, 1);
		lastDay = new Date(year, month, 0);

		doSrch();
		drawDays();
	}
</script>
</head>
<body>
	<div class="cal_top">
		<a href="#" id="movePrevMonth"><span id="prevMonth">&lt;</span></a> 
		<span id="cal_top_year"></span> 
		<span id="cal_top_month"></span>
		<a href="#" id="moveNextMonth"><span id="nextMonth">&gt;</span></a>
	</div>
	<div id="cal_tab" class="cal"></div>
</body>
</html>