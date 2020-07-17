<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<button id="test_btn">TEST</button>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
	$(function(){
		$('#test_btn').click(function(){
			$.ajax({
				method : "POST", 
				url : "select.do", 
				dataType : "JSON",
				success : sucSelect,
				error : errSelect
			});
		});

		function sucSelect(result){
			alert("result");	
		}

		function errSelect(){
			alert("실패");
		}

	});
</script>
</html>