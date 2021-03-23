<!-- 실질적으로 사용자의 로그인시도를 처리하는 페이지, 아까 만든 DAO를 이용해서 로그인 작업을 처리할 것이다 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<!-- 자바스크립트 문장을 사용하기 위해 작성해주는 것이다 -->
<%
	request.setCharacterEncoding("UTF-8");
%>
<!-- 건너오는 모든 데이터를 UTF-8으로 받을 수있도록 할 것이다 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content=Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
	if (session.getAttribute("userID") != null) { //세션이 존재하는 회원들은
		userID = (String) session.getAttribute("userID"); //userID에 해당 세션값을 넣어줄 수 있게 해준다
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.');");
		script.println("location.href='login.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
		script.println("</script>");
	}

	int bbsID = 0;

	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}

	if (bbsID == 0) { /* 특정한 번호가 반드시 존재해야지 특정한 글을 볼 수 있게 된다 */
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.');");
		script.println("location.href='bbs.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
		script.println("</script>");
	}

	Bbs bbs = new BbsDAO().getBbs(bbsID); /* 현재 작성한 글이 작성한 본인인지 확인해야한다. 세션관리가 필요하다. 현재 넘어온  bbsid값을 가지고 해당글을 가져온 다음에 글을 작성한 사람이 맞는지 확인한다 */
	if (!userID.equals(bbs.getUserID())) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.');");
		script.println("location.href='bbs.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
		script.println("</script>");
	}else { // 성공적으로 권한이있는 사람이라면 아래로
		BbsDAO bbsDAO = new BbsDAO(); // 하나의 인스턴스 생성, 로그인 성공
		int result = bbsDAO.delete(bbsID); // 게시글을 작성할 수 있게 해준다, 차례대로 매개변수를 넣어준다
		if (result == -1) { //데이터베이스 오류 발생, 이미 해당아이디가 존재, userid가 pk이기 때문에 중복 된 데이터값이 들어갈 수 없다
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글 삭제에 실패했습니다');");
			script.println("history.back();"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>");
		} else { // 글 수정 성공
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		}
	}
	%>
</body>
</html>