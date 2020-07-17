<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.13.1/css/all.css" integrity="sha384-xxzQGERXS00kBmZW/6qxqJPyxW3UR0BPsL4c8ILaIWXva5kFi7TxkIIaMiKtqV1Q" crossorigin="anonymous">
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.worksRep_body_wrap {
	width: 876px;
	display: flex;
	margin: 30px auto;
}

.works_sidebar_wrap {
	width: 250px;
}

.worksRep_wrap {
	margin-left: 15px;
	width: 100%;
}

.worksRep_title_wrap {
	font-size: 27px;
	font-weight: bold;
	margin-bottom: 10px;
}

.datepicker_wrap {
	margin: 4px;
}

.datepicker_wrap input {
	outline: none;
	height: 23px;
	margin-bottom: 10px;
}

.report_wrap {
	border-top: 1px solid black;
}

.report_title {
	font-size: 22px;
	font-weight: bold;
	margin: 10px;
}

.report_content {
	display: flex;
	justify-content: space-between;
	margin: 5px 3px;
}

.workDate_wrap {
	display: flex;
}

.workDate_wrap div {
	padding-left: 5px;
}

.chev_wrap {
	border: none;
	outline: none;
	background: none;
	cursor: pointer;
}

.reportData_wrap_NORM, .reportData_wrap_CHKLATER, .reportData_wrap_AWOL {
	margin-left: 10px;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<div class="worksRep_body_wrap">
		<div class="works_sidebar_wrap">
			<jsp:include page="/WEB-INF/views/include/commonLogin.jsp" />
		</div>
		<div class="worksRep_wrap">
			<div class="worksRep_title_wrap">리포트</div>
			<div class="datepicker_wrap">
				<input type="text" class="daterange"/>
			</div>
			<div class="report_wrap">
				<div class="report_title">근로리포트</div>
				<div class="report_content_wrap">
					<div class="report_content">
						<div>근로 일수</div>
						<div class="workDate_wrap">
							<div class="normCnt"></div>
							<button class="chev_wrap">
								<i class="fas fa-chevron-right NORMcnt_view" onclick="cntList('NORM')"></i>
							</button>
						</div>
					</div>
					<div class="reportData_wrap_NORM"></div>
					<div class="report_content">
						<div>지각 횟수</div>
						<div class="workDate_wrap">
							<div class="lateCnt"></div>
							<button class="chev_wrap">
								<i class="fas fa-chevron-right CHKLATERcnt_view" onclick="cntList('CHKLATER')"></i>
							</button>
						</div>
					</div>
					<div class="reportData_wrap_CHKLATER"></div>
					<div class="report_content">
						<div>결근 횟수</div>
						<div class="workDate_wrap">
							<div class="awolCnt"></div>
							<button class="chev_wrap">
								<i class="fas fa-chevron-right AWOLcnt_view" onclick="cntList('AWOL')"></i>
							</button>
						</div>
					</div>
					<div class="reportData_wrap_AWOL"></div>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script>
	var startDate;
	var endDate;
	$(document).ready(function() {
		getThisWeek();
		$('.daterange').val(startDate + ' - ' + endDate);
		var userNum = $('#user_number').val();
		var paramData = {
			startDate : startDate,
			endDate : endDate,
			EMPNO : userNum
		}
		
		$.ajax({
			url: '/rep/repSel.do',
			data: paramData, 
			dataType: 'json',
			success: repSelSuccess,
			error: repSelError
		});
	}); 

	function getThisWeek(){
		var today = new Date();  
		var theYear = today.getFullYear();
		var theMonth = today.getMonth();
		var theDate  = today.getDate();
		var theDayOfWeek = today.getDay();
		
		for(var i=0; i<7; i++) {
			 var resultDay = new Date(theYear, theMonth, theDate + (i - theDayOfWeek));
			 var yyyy = resultDay.getFullYear();
			 var mm = Number(resultDay.getMonth()) + 1;
			 var dd = resultDay.getDate();
			
			 mm = String(mm).length === 1 ? '0' + mm : mm;
			 dd = String(dd).length === 1 ? '0' + dd : dd;
			if(i == 0 ){
				startDate = mm + '/' + dd + '/' + yyyy;
			} else if(i == 6){
				endDate = mm + '/' + dd + '/' + yyyy;
			}
		}
	}

	$('.daterange').daterangepicker({
		opens : 'right'
	}, function(start, end, label) {
		startDate = start.format('YYYY/MM/DD');
		endDate = end.format('YYYY/MM/DD');
		var userNum = $('#user_number').val();
		var paramData = {
			startDate : startDate,
			endDate : endDate, 
			EMPNO : userNum
		}
		
		$.ajax({
			url: '/rep/repSel.do',
			data: paramData, 
			dataType: 'json',
			success: repSelSuccess,
			error: repSelError
		});
	});

	function repSelSuccess(data){
		$('.normCnt').text(data.returnData.normCnt + '일');
		$('.lateCnt').text(data.returnData.lateCnt + '일');
		$('.awolCnt').text(data.returnData.awolCnt + '일');
	}

	function repSelError(){
	}

	function cntList(type){
		var userNum = $('#user_number').val();
		var rangeDate = $('.daterange').val();
		var paramData = {
			EMPNO : userNum,
			WORKTYPE : type,
			startDate : startDate,
			endDate : endDate 
		}

		$.ajax({
			url : '/rep/repList.do',
			data : paramData,
			dataType : 'json',
			success : repListSuccess,
			error : repListError
		});

		function repListSuccess(data){
			$('.' + type + 'cnt_view').attr('onclick', "exitCntList('" + type + "')");
			var reportData = data.returnData;
			var inHtml = '';
			for(var i = 0; i < reportData.length; i++){
				var startTime = reportData[i].STARTTIME;
				var endTime = reportData[i].ENDTIME;
				if(endTime === undefined) {
					endTime = '';
				} else {
					endTime = endTime.substring(11, 19);
				}
				inHtml += '<div class="reportData">' + startTime + ' ~ ' + endTime + '</div>';
			}
			$('.reportData_wrap_' + type).html(inHtml);
		}
	}

	function repListError(){
	}

	function exitCntList(type){
		var inHtml = '';
		$('.reportData_wrap_' + type).text(inHtml);
		$('.' + type + 'cnt_view').attr('onclick', "cntList('" + type + "')");
	}

</script>
</html>