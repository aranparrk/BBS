<!-- 실질적으로 사용자의 로그인시도를 처리하는 페이지, 아까 만든 DAO를 이용해서 로그인 작업을 처리할 것이다 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 문장을 사용하기 위해 작성해주는 것이다 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 모든 데이터를 UTF-8으로 받을 수있도록 할 것이다 -->
<jsp:useBean id="user" class="user.User" scope="page"/> <!-- 자바 빈즈를 사용하겟다. user라는 아이디 생성, 클래스에 user.User클래스를 넣어주고 스코프를 페이지를 넣어줌으로서 현재 페이지에서만 빈즈가 사용되게 한다 -->
<jsp:setProperty name="user" property="userID"/> <!-- 로그인 페이지에서 넘겨준 userID라는 것을 그대로 받아서 한명의 사용자에 userID에 넣어준다는 것이다 -->
<jsp:setProperty name="user" property="userPassword"/> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content=Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		UserDAO userDAO = new UserDAO(); // 하나의 인스턴스 생성, 로그인 성공
		int result = userDAO.login(user.getUserID(), user.getUserPassword()); // 로그인을 할 수 있게 해준다, 로그인페이지에서 유저아이디와 유저패스워드가 각각 입력이 된 값으로 넘어와서 로그인 함수에 넣어줘서 로그인을 실행해준다 각각의 값들이 리설트에 담기게 될 것이다
		if(result == 1){ 
			PrintWriter script = response.getWriter(); // 하나의 스크립트 문장을 넣어줄 수 있게 한다 
			script.println("<script>"); // 스크립트문장을 유동적으로 실행할 수있게 해준다 
			script.println("location.href='main.jsp'"); // 링크를 넣어서 main으로 이동할 수 있게 해준다. 로그인 성공시에 이 페이지로 이동하게 된다 
			script.println("</script>"); 
		}
		if(result == 0){ // 로그인 실패
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('비밀번호가 틀립니다.');");
			script.println("history.back();"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>"); 
		}
		if(result == -1){ // 아이디가 존재하지 않을 때
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('아이디가 존재하지 않습니다.');");
			script.println("history.back();"); 
			script.println("</script>"); 
		}
		if(result == -2){ //오류 발생시
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();"); 
			script.println("</script>"); 
		}
	%>
</body>
</html>