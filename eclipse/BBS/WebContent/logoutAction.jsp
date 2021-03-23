<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content=Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		session.invalidate(); //현재 이 페이지에 접속한 회원이 세션을 빼앗기도록 만든다
	%>
		<script>
			location.href='main.jsp';
		</script>
</body>
</html>