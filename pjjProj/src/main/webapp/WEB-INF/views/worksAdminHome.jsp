<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<style type="text/css">
.worksAdmHome_body_wrap {
	width: 876px;
	display: flex;
	margin: 30px auto;
}

.works_sidebar_wrap {
	width: 200px;
}

.worksAdmHome_wrap {
	margin: 0 15px;
}

.part_wrap {
	width: 100%;
	margin: 15px 0;
}

.title_bold {
	font-size: 20px;
	font-weight: bold;
}

.title_wrap {
	display: flex;
	justify-content: space-between;
}

table {
	width: 100%;
	text-align: center;
	border-collapse: collapse;
	border-top: 1px solid black;
	border-bottom: 1px solid black;
}

tr {
	height: 30px;
}

th {
	background-color: #EAEAEA;
	text-align: center;
}

td {
	padding: 7px;
	border-top: 1px solid #BDBDBD;
	font-size: 13px;
}

.empCnt {
	font-size: 15px;
	line-height: 27px;
}

.empCnt_View_wrap {
	display: flex;
	justify-content: space-between;
	margin: 10px 0;
}

.empCnt_subtitle, .empCnt_content {
	font-size: 15px;
	text-align: center;
	width: 180px;
	height: 30px;
	margin: 0px 8px;
	line-height: 30px;
}

.empCnt_subtitle {
	border-top: 1px solid black;
	border-left: 1px solid black;
	border-right: 1px solid black;
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
	background-color: #EFEFEF;
}

.empCnt_content {
	border-bottom: 1px solid black;
	border-left: 1px solid black;
	border-right: 1px solid black;
	border-bottom-left-radius: 3px;
	border-bottom-right-radius: 3px;
}

.daterange {
	outline: none;
	height: 23px;
	margin-bottom: 10px;
}

.empManage_table {
	margin: 5px 0;
}

.empInfoTr:hover {
	background-color: lightgrey;
	cursor: pointer;
}

.add_btn {
	width: 100px;
	height: 30px;
	outline: none;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<div class="worksAdmHome_body_wrap">
		<div class="works_sidebar_wrap">
			<jsp:include page="/WEB-INF/views/include/commonLogin.jsp" />
		</div>
		<div class="worksAdmHome_wrap">
			<div class="works_empCnt_wrap part_wrap">
				<div class="title_wrap">
					<div class="empCnt_title title_bold">2020년 6월 29일</div>
					<div class="empCnt title_bold">총 직원수 : 3</div>
				</div>
				<div class="empCnt_View_wrap">
					<div class="empCnt_norm_wrap">
						<div class="empCnt_subtitle title_bold">출근</div>
						<div class="empCnt_content chkinCnt"></div>
					</div>
					<div class="empCnt_awol_wrap">
						<div class="empCnt_subtitle title_bold">지각</div>
						<div class="empCnt_content chklaterCnt"></div>
					</div>
					<div class="empCnt_late_wrap">
						<div class="empCnt_subtitle title_bold">결근</div>
						<div class="empCnt_content chkawolCnt"></div>
					</div>
				</div>
			</div>
			<div class="commuteMiss_wrap part_wrap">
				<div class="title_wrap">
					<div class="commuteMist_title title_bold">출근/퇴근 누락 기록</div>
					<div>
						<input type="text" class="daterange" value="01/01/2018 - 01/15/2018" />
					</div>
				</div>
				<div class="commuteMiss_content_wrap">
					<table class="commuteMiss_table"></table>
				</div>
			</div>
			<div class="empManage_wrap part_wrap">
				<div class="empManage_title_wrap">
					<div class="title_bold">직원 관리</div>
					<div class="title_wrap">
						<div class="empCnt">총 직원수 : 3</div>
						<button type="button" class="add_btn" onclick="empInsClick()">직원 추가</button>
					</div>
				</div>
				<div class="empManage_contnet_wrap">
					<table class="empManage_table"></table>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script type="text/javascript">
	var startDate;
	var endDate;
	$(document).ready(function() {
		var userNum = $('#user_number').val();
		var today = new Date();
		var year = today.getFullYear();
		var month = today.getMonth() + 1;
		var date = today.getDate();
		$('.empCnt_title').text(year + '년 ' + month + '월 ' + date + '일');

		var paramData= {
			empno: userNum
		}
		
		$.ajax({
			url: '/emp/empCnt.do',
			data: paramData, 
			dataType: 'json', 
			success: successEmpCnt,
			error: errorEmpCnt
		});

		getThisWeek();
		$('.daterange').val(startDate + ' - ' + endDate);
		var paramData = {
			startDate : startDate,
			endDate : endDate
		}
		
		$.ajax({
			url: '/emp/missHis.do',
			data: paramData, 
			dataType: 'json', 
			success: missHisSuccess,
			error: missHisError
		});

		$('.daterange').daterangepicker({
			opens : 'left'
		}, function(start, end) {
			startDate = start.format('YYYY/MM/DD');
			endDate = end.format('YYYY/MM/DD');
			var paramData = {
				startDate : startDate,
				endDate : endDate
			}
			
			$.ajax({
				url: '/emp/missHis.do',
				data: paramData, 
				dataType: 'json', 
				success: missHisSuccess,
				error: missHisError
			});
		});

		$.ajax({
			url: '/emp/empSel.do',
			dataType: 'json',
			success: empSelSuccess,
			error: empSelSuccess
		});
	});

	function empSelSuccess(data){
		var inHtml = '<tr><th>사원 번호</th><th>아이디</th><th>이름</th><th>지점</th><th>직무</th><th>이메일</th>'
			+ '<th>전화번호</th><th>입사일</th></tr>'; 
		if (data.infoFlag == '0'){
			for(var one in data.returnData){
				inHtml += '<tr class="empInfoTr emp' + data.returnData[one].EMPNO + '" onclick="empUpClick(' + data.returnData[one].EMPNO + ')"><td>' + data.returnData[one].EMPNO + '</td><td>' + data.returnData[one].ID + '</td><td>' + data.returnData[one].EMPNAME + '</td><td>'
				+ data.returnData[one].BRANCH + '</td><td>' + data.returnData[one].JOBTITLE + '</td><td>'
				+ data.returnData[one].EMAIL + '</td><td>' + data.returnData[one].PHONE + '</td><td> ' 
					 + data.returnData[one].JOINDATE + '</td></tr>'
			}
		} else if (data.infoFlag == '1'){
			inHtml += '<tr><td colspan = "8">조회된 사원이 없습니다.</td></tr>'; 
		}
		$('.empManage_table').html(inHtml);
	}
	
	function empSelError(){
	}
	
	function missHisSuccess(data){
		var inHtml = '<tr><th>직원</th><th>날짜</th><th>근무시간</th><th>조직</th><th>직위</th></tr>';
		if (data.hisFlag == '1'){
			inHtml += '<td colspan="5">해당 날짜의 출근/퇴근 누락 기록이 없습니다.</td>';
			$('.commuteMiss_table').html(inHtml);			
		} else if (data.hisFlag == '0'){
			for(var one in data.returnData){
				var starttime = data.returnData[one].STARTTIME;
				var endtime = data.returnData[one].ENDTIME;
				if(starttime === undefined){
					starttime = ' ';
				} else if (endtime === undefined){
					endtime = ' ';
				}
				inHtml += '<tr><td>' + data.returnData[one].EMPNAME + '</td><td>' + data.returnData[one].DATE + '</td><td>' 
				+ starttime + ' ~ ' + endtime + '</td><td>' + data.returnData[one].BRANCH 
				+ '</td><td>' + data.returnData[one].JOBTITLE + '</td></tr>';
			}
			
			$('.commuteMiss_table').html(inHtml);
		}
	}

	function missHisError(){
	}

	function successEmpCnt(data){
		$('.empCnt').text('총 직원수 : ' + data.returnData.empCnt);
		$('.chkinCnt').text(data.returnData.chkinCnt);
		$('.chklaterCnt').text(data.returnData.chklaterCnt);
		$('.chkawolCnt').text(data.returnData.chkawolCnt);
	}

	function errorEmpCnt(){
	}

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

	function empInsClick(){
		$('.modal_body_wrap').css('display', 'block');
		$('.modal_insBtn').css('display', 'block');
		$('.modal_upBtn').css('display', 'none');
		$('.modal_delBtn').css('display', 'none');
		$('.empno').css('display', 'none');
	}

	function empIns(){
		var roleId = $('input:radio[name=roleId]:checked').val();
		var empId = $('#id').val();
		var empPw = $('#pw').val();
		var empName = $('#name').val();
		var empBranch = $('#branch').val();
		var empJobtitle = $('#jobtitle').val();
		var empEmail = $('#email').val();
		var empPhone = $('#phone').val();
		var empDate = $('#date').val();
		var paramData = {
			ROLEID : roleId,
			ID : empId,
			PW : empPw,
			EMPNAME : empName,
			BRANCH : empBranch,
			JOBTITLE : empJobtitle,
			EMAIL : empEmail,
			PHONE : empPhone,
			JOINDATE : empDate
		}

		$.ajax({
			url: '/emp/empIns.do',
			data: paramData,
			dataType: 'json',
			success: empInsSuccess,
			error: empInsError
		});
	}

	function empInsSuccess(data){
		if (data.insFlag == '0'){
			swal('성공적으로 추가되었습니다.');
			location.reload();
		} else if (data.insFlag == '1'){
			swal('직원정보 등록에 실패하였습니다.');
		}
	}

	function empInsError(){
	}

	function empUpClick(empno){
		$('.modal_insBtn').css('display', 'none');
		$('.modal_upBtn').css('display', 'block');
		$('.modal_delBtn').css('display', 'block');
		$('.empno_wrap').css('display', 'flex');
		$('.modal_body_wrap').css('display', 'block');
		$('.empno_input').text($('.emp' + empno + ' td:eq('+ 0 +')').text());
		$('#id').val($('.emp' + empno + ' td:eq('+ 1 +')').text());
		$('#name').val($('.emp' + empno + ' td:eq('+ 2 +')').text()); //
		$('#branch').val($('.emp' + empno + ' td:eq('+ 3 +')').text()); //
		$('#jobtitle').val($('.emp' + empno + ' td:eq('+ 4 +')').text()); //
		$('#email').val($('.emp' + empno + ' td:eq('+ 5 +')').text());
		$('#phone').val($('.emp' + empno + ' td:eq('+ 6 +')').text());
		var date = $('.emp' + empno + ' td:eq('+ 7 +')').text();
		var year = date.substring(1, 5);
		var month = date.substring(6, 8);
		var day = date.substring(9, 11);
		$('#date').val(year + '-' + month + '-' + day);
	}
	function empUp(){
		var empno = $('.empno_input').text();
		var roleId = $('input:radio[name=roleId]:checked').val();
		var empId = $('#id').val();
		var empPw = $('#pw').val();
		var empName = $('#name').val();
		var empBranch = $('#branch').val();
		var empJobtitle = $('#jobtitle').val();
		var empEmail = $('#email').val();
		var empPhone = $('#phone').val();
		var empDate = $('#date').val();
		var paramData = {
			EMPNO : empno,
			ROLEID : roleId,
			ID : empId,
			PW : empPw,
			EMPNAME : empName,
			BRANCH : empBranch,
			JOBTITLE : empJobtitle,
			EMAIL : empEmail,
			PHONE : empPhone,
			JOINDATE : empDate
		}
		$.ajax({
			url: '/emp/empUp.do',
			data: paramData,
			dataType: 'json',
			success: empUpSuccess,
			error: empUpError
		});
	}

	function empUpSuccess(data){
		if (data.upFlag == '0'){
			swal('성공적으로 수정되었습니다.');
			location.reload();
		} else if (data.upFlag == '1'){
			swal('직원정보 수정에 실패하였습니다.');
		}
	}

	function empUpError(){
	}
	
	function empDel(){
		var empno = $('.empno_input').text();
		var paramData = {
			EMPNO : empno
		}
		$.ajax({
			url: '/emp/empDel.do',
			data: paramData,
			dataType: 'json',
			success: empDelSuccess,
			error: empDelError
		});
	}

	function empDelSuccess(data){
		if (data.delFlag == '0'){
			swal('성공적으로 삭제되었습니다.');
			location.reload();
		} else if (data.delFlag == '1'){
			swal('직원정보 삭제에 실패하였습니다.');
		}
	}

	function empDelError(){
	}
</script>
</html>