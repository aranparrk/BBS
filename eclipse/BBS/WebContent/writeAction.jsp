<!-- 실질적으로 사용자의 로그인시도를 처리하는 페이지, 아까 만든 DAO를 이용해서 로그인 작업을 처리할 것이다 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 문장을 사용하기 위해 작성해주는 것이다 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 모든 데이터를 UTF-8으로 받을 수있도록 할 것이다 -->
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/> <!-- 자바 빈즈를 사용하겟다. user라는 아이디 생성, 클래스에 user.User클래스를 넣어주고 스코프를 페이지를 넣어줌으로서 현재 페이지에서만 빈즈가 사용되게 한다 -->
<jsp:setProperty name="bbs" property="bbsTitle"/> <!-- 로그인 페이지에서 넘겨준 userID라는 것을 그대로 받아서 한명의 사용자에 userID에 넣어준다는 것이다 -->
<jsp:setProperty name="bbs" property="bbsContent"/> 

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content=Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){ //세션이 존재하는 회원들은
			 userID = (String)session.getAttribute("userID"); //userID에 해당 세션값을 넣어줄 수 있게 해준다
		}
		if(userID == null){
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('로그인을 하세요.');");
			script.println("location.href='login.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>"); 
		} else{
			if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null){ // 입력을 안 했을 때
				PrintWriter script = response.getWriter(); 
				script.println("<script>"); 
				script.println("alert('입력이 누락되었습니다.');");
				script.println("history.back();"); // 이전 페이지로 사용자를 돌려보낸다
				script.println("</script>"); 
			} else{ // 데이터베이스를 등록해줄 것
				BbsDAO bbsDAO = new BbsDAO(); // 하나의 인스턴스 생성, 로그인 성공
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent()); // 게시글을 작성할 수 있게 해준다, 차례대로 매개변수를 넣어준다
				if(result == -1){ //데이터베이스 오류 발생, 이미 해당아이디가 존재, userid가 pk이기 때문에 중복 된 데이터값이 들어갈 수 없다
					PrintWriter script = response.getWriter(); 
					script.println("<script>"); 
					script.println("alert('글쓰기에 실패했습니다');");
					script.println("history.back();"); // 이전 페이지로 사용자를 돌려보낸다
					script.println("</script>"); 
				}else{ // 회원가입 성공
					PrintWriter script = response.getWriter(); 
					script.println("<script>"); 
					script.println("location.href='bbs.jsp'");
					script.println("</script>"); 
				}
			}
		}
	%>
</body>
</html>