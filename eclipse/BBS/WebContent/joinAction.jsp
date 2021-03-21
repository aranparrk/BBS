<!-- 실질적으로 사용자의 로그인시도를 처리하는 페이지, 아까 만든 DAO를 이용해서 로그인 작업을 처리할 것이다 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 문장을 사용하기 위해 작성해주는 것이다 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 모든 데이터를 UTF-8으로 받을 수있도록 할 것이다 -->
<jsp:useBean id="user" class="user.User" scope="page"/> <!-- 자바 빈즈를 사용하겟다. user라는 아이디 생성, 클래스에 user.User클래스를 넣어주고 스코프를 페이지를 넣어줌으로서 현재 페이지에서만 빈즈가 사용되게 한다 -->
<jsp:setProperty name="user" property="userID"/> <!-- 로그인 페이지에서 넘겨준 userID라는 것을 그대로 받아서 한명의 사용자에 userID에 넣어준다는 것이다 -->
<jsp:setProperty name="user" property="userPassword"/> 
<jsp:setProperty name="user" property="userName"/> 
<jsp:setProperty name="user" property="userGender"/> 
<jsp:setProperty name="user" property="userEmail"/> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content=Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		if(user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null || user.getUserGender() == null || user.getUserEmail() ==null){
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('입력이 누락되었습니다.');");
			script.println("history.back();"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>"); 
		} else{
			UserDAO userDAO = new UserDAO(); // 하나의 인스턴스 생성, 로그인 성공
			int result = userDAO.join(user); // user을 넣어주면 각각의 변수들을 입력 받아서 하나의 유저라는 인스턴스가 조인함수를 수행하도록 매개변수로 들어간다
			if(result == -1){ //데이터베이스 오류 발생, 이미 해당아이디가 존재, userid가 pk이기 때문에 중복 된 데이터값이 들어갈 수 없다
				PrintWriter script = response.getWriter(); 
				script.println("<script>"); 
				script.println("alert('이미 존재하는 아이디입니다.');");
				script.println("history.back();"); // 이전 페이지로 사용자를 돌려보낸다
				script.println("</script>"); 
			}else{ // 회원가입 성공
				PrintWriter script = response.getWriter(); 
				script.println("<script>"); 
				script.println("location.href='main.jsp'"); // 회원가입이 되었을 땐 로그인할 수 있게 해준다
				script.println("</script>"); 
			}
		}
	%>
</body>
</html>