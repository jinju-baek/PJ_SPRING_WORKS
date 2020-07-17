<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.worksReq_body_wrap {
	width: 876px;
	display: flex;
	margin: 30px auto;
}

.works_sidebar_wrap {
	width: 250px;
}

.worksReq_content_wrap {
	margin-left: 15px;
}

.worksReq_content_title {
	font-weight: bold;
	font-size: 28px;
	margin-bottom: 10px;
}

.worksReq_create_wrap {
	border-bottom: 1px solid black;
}

.workReq_content_select {
	height: 30px;
	width: 120px;
	padding: 4px 0 4px 4px;
	margin: 8px;
	outline: none;
}

.workReq_table_wrap {
	text-align: center;
	border-collapse: collapse;
}

.workReq_table_wrap th {
	width: 150px;
	height: 35px;
	border: 1px solid #BDBDBD;
	background-color: #EAEAEA;
}

.workReq_table_wrap td {
	width: 500px;
	border: 1px solid #BDBDBD;
}

.workReq_reqBtn {
	display: flex;
	justify-content: flex-end;
	margin: 8px 8px 20px 0;
}

.workReq_reqBtn button {
	width: 100px;
	height: 30px;
	border-radius: 5px;
	border: none;
	outline: none;
	cursor: pointer;
}

.workReq_his_title {
	margin: 10px;
	font-weight: bold;
}

.workReq_his_table_wrap table {
	border-collapse: collapse;
	text-align: center;
	width: 656px;
}

.workReq_his_table_wrap table th {
	border: 1px solid #BDBDBD;
	padding: 5px;
	background-color: #EAEAEA;
}

.workReq_his_table_wrap table td {
	border: 1px solid #BDBDBD;
	padding: 5px;
	font-size: 13px;
}

.adminReqBtn {
	border-radius: 5px;
	border: none;
	outline: none;
	cursor: pointer;
	padding: 3px 8px;
}

.workReq_table_wrap input {
	width: 150px;
	height: 20px;
	outline: none;
	border: none;
}

.workReq_table_wrap select {
	border: none;
    width: 150px;
    outline: none;
}

.adminReqBtn { 
	margin: 0 3px;
}

.reqEmpNo, .reqWCode, .reqCode {
	display: none;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<div class="worksReq_wrap">
		<div class="worksReq_body_wrap">
			<div class="works_sidebar_wrap">
				<jsp:include page="/WEB-INF/views/include/commonLogin.jsp" />
			</div>
			<div class="worksReq_content_wrap">
				<div class="worksReq_content_title">요청</div>
				<div class="worksReq_create_wrap">
					<select class="workReq_content_select">
						<option value="work_insert" selected>근무일정 생성</option>
						<option value="work_update">근무일정 수정</option>
					</select>
					<table class="workReq_table_wrap">
						<tr>
							<th>날짜</th>
							<td class="reqDate_wrap"><input type="date" class="reqDate"></input></td>
						</tr>
						<tr>
							<th>시작 시간</th>
							<td><input type="time" class="reqStartTime"></input></td>
						</tr>
						<tr>
							<th>종료 시간</th>
							<td><input type="time" class="reqEndTime"></input></td>
						</tr>
					</table>
					<div class="workReq_reqBtn">
						<button type="button" onclick="workReqIns()">생성 요청</button>
					</div>
				</div>
				<div class="workReq_his_wrap">
					<div class="workReq_his_title">근무 요청 현황</div>
					<div class="workReq_his_table_wrap">
						<table class="worReq_table_wrap">
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	var reqDateHtml = '';
	$(document).ready(function() {
		reqHome();
	});

	$('.workReq_content_select').change(function() {
		var reqSel = $(this).val();
		
		if (reqSel == 'work_insert') {
			$('.workReq_reqBtn > button').text('생성 요청')
			reqDateHtml = '<input type="date" class="reqDate"></input>';
			$('.reqDate_wrap').html(reqDateHtml);
		} else if (reqSel = 'work_update') {
			$('.workReq_reqBtn > button').text('수정 요청')
			workReqList();
		}
	});

	function reqHome(){
		var userNum = $('#user_number').val();
		var roleId = $('#roleId').val();
		var paramData = {
			EMPNO : userNum,
			ROLEID : roleId
		}

		if(roleId == 'ADMIN') {
			$('.worksReq_content_title').text('요청 관리');
			$('.worksReq_create_wrap').css('display', 'none');
			$('.workReq_his_title').text('근무 요청');
		}
		
		$.ajax({
			url : '/req/reqHis.do',
			data : paramData,
			datatype : 'json', 
			success : reqHisSuccess,
			error : reqHisError 
		});
	}

	function reqHisSuccess(data){
		var reqTableHtml = '';
		if(data.returnData.roleId == 'USER') {
			reqTableHtml += '<tr><th></th><th>희망근무일</th><th>기존시간</th><th>수정시간</th>'
				+'<th>요청일</th><th>처리현황</th><th>요청취소</th></tr>';
		} else if(data.returnData.roleId == 'ADMIN') {
			reqTableHtml += '<tr><th></th><th>사원명</th><th>희망근무일</th><th>기존시간</th><th>수정시간</th>'
				+'<th>요청일</th><th>처리현황</th><th>처리</th></tr>';
		}
		var reqBtnHtml = '';
		var reqHis = data.returnData;
		if (reqHis.reqCode !== undefined) {
			var reqHisCnt = reqHis.reqCode.length;
			var reqCode;
			var orgDate;
			var orgTime;
			var orgTimeTmp;
			var orgSt;
			var orgEt;
			var reqSt;
			var reqEt;
			var reqTime;
			var procStep;
			var empName;
			var empNo;
			var wCode;
			
			for(var i = 0; i < reqHisCnt; i++){
				reqCode = reqHis.reqCode[i];
				orgDate = reqHis.orgDate[i];
				reqSt = reqHis.reqSt[i];
				reqEt = reqHis.reqEt[i];
				reqTime = reqHis.reqTime[i];
				procStep = reqHis.procStep[i];
				orgTimeTmp = data.returnData.orgTime;	
				orgTime = '-';	
				wCode = reqHis.wCode[i];
				
				
				if (orgTimeTmp != ''){ 
					for(var j = 0; j < orgTimeTmp.length; j += 2){
						ckCode = orgTimeTmp[j];
						if (reqCode == ckCode){
							orgSt = orgTimeTmp[j + 1];
							orgSt = orgSt.slice(23, 28);
							orgEt = orgTimeTmp[j + 1];
							orgEt = orgEt.slice(7, 12);
							orgTime = orgSt + '~' + orgEt;
						}
					}
				}
				
				if(data.returnData.roleId == 'ADMIN'){
					empName = reqHis.empName[i];
					empNo = reqHis.empNo[i];
					reqBtnHtml = '<td><button type="button" class="adminReqBtn apprBtn" onclick="procOn(' + '1' + (i + 1) + ')">승인</button>' 
					+ '<button type="button" class="adminReqBtn refBtn" onclick="procOn(' + '2' + (i + 1) + ')">거절</button></td>';
					if (procStep == '승인' || procStep == '거절' || procStep == '취소') {
						reqBtnHtml = '<td></td>';
					}
					reqTableHtml += '<tr><td class="reqNo' + (i + 1) + '">' + (i + 1)
					+ '<input type="text" class="reqWCode" id="wCode' + (i + 1) + '" value="' + wCode + '"></input>'
					+ '<input type="text" class="reqEmpNo" id="empNo' + (i + 1) + '" value="' + empNo + '"></input>'
					+ '<input type="text" class="reqCode" id="reqCode' + (i + 1) + '" value="' + reqCode + '"></input></td>'
					+ '<td>' + empName + '</td>' + '<td id="procDate' + (i + 1) + '">' + orgDate + '</td><td>' + orgTime
					+ '</td><td id="procTime' + (i + 1) + '">' + reqSt + '~' + reqEt + '</td><td>' + reqTime + '</td><td>' 
					+ procStep + '</td>' + reqBtnHtml + '</tr>';
				} else if(data.returnData.roleId == 'USER'){
					empNo = $('#user_number').val();
					reqBtnHtml = '<td><button type="button" class="adminReqBtn cancelBtn" onclick="procOn(' + '3' + (i + 1) + ')">취소</button></td>';
					if (procStep == '승인' || procStep == '거절' || procStep == '취소') {
						reqBtnHtml = '<td></td>';
					}
					reqTableHtml += '<tr><td class="reqNo' + (i + 1) + '">' + (i + 1)
					+ '<input type="text" class="reqEmpNo" id="empNo' + (i + 1) + '" value="' + empNo + '"></input>'
					+ '<input type="text" class="reqCode" id="reqCode' + (i + 1) + '" value="' + reqCode + '"></input></td>'
					+ '<td>' + orgDate + '</td><td>' + orgTime
					+ '</td><td>' + reqSt + '~' + reqEt + '</td><td>' + reqTime + '</td><td>'
					+ procStep + '</td>' + reqBtnHtml + '</tr>';
				}
			}
		} else {
			if(data.returnData.roleId == 'ADMIN') {
				reqTableHtml += '<tr><td colspan="8">요청건이 없습니다.</td></tr>';
			} else if(data.returnData.roleId == 'USER') {
				reqTableHtml += '<tr><td colspan="7">요청건이 없습니다.</td></tr>';
			}
		}
		$('.worReq_table_wrap').append(reqTableHtml);
	}

	function reqHisError(){
	}
	
	function workReqList() {
		var userNum = $('#user_number').val();
		var paramData = {
			EMPNO : userNum
		}
		$.ajax({
			type : 'POST',
			url : '/req/workList.do',
			data : paramData,
			dataType : 'json',
			success : ReqListSuccess,
			error : ReqListError
		});
	}

	function ReqListSuccess(data) {
		var reqList = data.returnData;
		reqDateHtml = '<select class="reqDate">';
		for (var i = 0; i < reqList.length; i++) {
			reqDateHtml += '<option>' + reqList[i] + '</option>';
		}
		reqDateHtml += '</select>';
		$('.reqDate_wrap').html(reqDateHtml);
	}

	function ReqListError() {
	}

	function workReqIns() {
		var userNum = $('#user_number').val();
		var reqTypeTmp = $('.workReq_content_select').val();
		var reqDateTmp = $('.reqDate').val();
		var reqStTmp = $('.reqStartTime').val();
		var reqEtTmp = $('.reqEndTime').val();
		var paramData = {
			reqType : reqTypeTmp,
			reqDate : reqDateTmp,
			reqSt : reqStTmp,
			reqEt : reqEtTmp,
			EMPNO : userNum
		}

		$.ajax({
			url : '/req/reqIns.do',
			type : 'POST',
			data : paramData,
			dataType : 'text',
			success : reqInsSuccess,
			error : reqInsError
		})

	}

	function reqInsSuccess(data) {
		if (data == '1') {
			swal('값을 전부 입력해주세요.');
		} else if (data == '2') {
			swal('이미 근무일정이 존재하는 날짜입니다. 다른 날짜를 선택해주세요.');
		} else if (data == '3') {
			swal('근무생성 요청에 실패하였습니다. 관리자에게 문의해주세요.')
		} else if(data == '4'){
			swal('오늘 이전의 날짜를 선택해주세요.');
		} else if (data == '0') {
			swal('성공적으로 요청하였습니다.');
			location.reload();
		}
	}

	function reqInsError() {

	}
	
	function procOn(procCode) {
		procCode = '' + procCode;
		var reqProc = procCode.substring(0, 1);
		var reqNum = procCode.substring(1);
		var reqCode = $('#reqCode' + reqNum).val();
		var empNo = $('#empNo' + reqNum).val();
		var wCode = $('#wCode' + reqNum).val();
		var procDate = $('#procDate' + reqNum).text();
		var procTime = $('#procTime' + reqNum).text();
		if(reqProc == '1') { 
			var startTime = procDate + ' ' + procTime.substring(0, 5) + ':00';
			var endTime = procDate + ' ' + procTime.substring(6, 11) + ':00';			
			var paramData = {
				REQCODE : reqCode,
				WCODE : wCode,
				EMPNO : empNo, 
				PROCTYPE : reqProc,
				STARTTIME : startTime,
				ENDTIME : endTime
			}
		} else if(reqProc == '2' || reqProc == '3'){
			var paramData = {
				REQCODE : reqCode,
				EMPNO : empNo,
				PROCSTEP : reqProc
			}
		}
		
		
		$.ajax({
			url: '/req/reqProc.do',
			data: paramData,
			dataType: 'text',
			success: procOnSuccess, 
			error: procOnError 
		});
	}

	function procOnSuccess(data){
		if (data == '0'){
			swal('성공적으로 처리하였습니다.');
			location.reload();
		} else if (data == '1'){
			swal('요청 처리에 실패하였습니다.');
		}
	}

	function procOnError(){
	}

</script>
</html>