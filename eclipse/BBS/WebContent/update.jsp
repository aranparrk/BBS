<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<!-- 스크립트 문장을 실행할 수 있도록 만들어주는 코드 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content=Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<% 
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID"); /* 로그인 한 사람이라면 userID라는 변수에 해당 아이디가 담기게 된다. */
		}
		
		if(userID == null){
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('로그인을 하세요.');");
			script.println("location.href='bbs.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>"); 
		}
		int bbsID = 0;
		
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		
		if(bbsID == 0){ /* 특정한 번호가 반드시 존재해야지 특정한 글을 볼 수 있게 된다 */
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('유효하지 않은 글입니다.');");
			script.println("location.href='bbs.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>"); 
		}
		
		Bbs bbs = new BbsDAO().getBbs(bbsID); /* 현재 작성한 글이 작성한 본인인지 확인해야한다. 세션관리가 필요하다. 현재 넘어온  bbsid값을 가지고 해당글을 가져온 다음에 글을 작성한 사람이 맞는지 확인한다 */
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('권한이 없습니다.');");
			script.println("location.href='bbs.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>"); 
		}
	%>
	<!-- 네비바 -->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggler="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트 만들기</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" 
					data-toggle="dropdown" role="button" aria-haspopup="true" 
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<form method="post" action="updateAction.jsp?bbsID=<%= bbsID%>"> <!-- 우리가 업데이트 요청을 할 때 그 요청을 처리하는 action페이지가  존재한다 -->
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type ="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle()%>"></td>
						</tr>
						<tr>
							<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height:350px;"><%= bbs.getBbsContent()%></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글수정">
			</form>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>