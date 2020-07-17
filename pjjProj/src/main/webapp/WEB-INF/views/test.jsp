<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>
		$(function(){
			$('#test_btn').click(function(){
				var param = {
					RID : 'D00078984C78F',
					STARTDT : '2018-10-08',
					ENDDT : '2020-09-27',
					PAGESIZE : 30,
					PAGENO : 1,
					DEBUG : 'T'
				}
				
				$.ajax({
					method : "POST", 
					url : "select.do",
					data : param,
					dataType : "JSON",
					success : sucSelect,
					error : errSelect
				});
			});
	
			function sucSelect(result){
				var data = result.returnData.resultData;
				var inHtml = '';
				
				for(var i = 0 in data) {
					inHtml += '<tr><td>' + data[i].EVENTTIME + '</td>';
					inHtml += '<td>' + data[i].ROWNUM + '</td>';
					inHtml += '<td>' + data[i].MASTERRSSI + '</td>';
					inHtml += '<td>' + data[i].MESHSTATE + '</td>';
					inHtml += '<td>' + data[i].GAPTOMASTER	+ '</td>';
					inHtml += '<td>' + data[i].REGDT + '</td>';
					inHtml += '<td>' + data[i].GAPTOSLAVE + '</td>';
					inHtml += '<td>' + data[i].SLAVERSSI + '</td></tr>';
				} 

				
				$('#table').html(inHtml);
				
			}
	
			function errSelect(){
				alert("실패");
			}
	
		});
	</script>	
</head>
<body>
	<button id="test_btn">TEST</button>
	<table id="table">
	</table>
</body>

</html>