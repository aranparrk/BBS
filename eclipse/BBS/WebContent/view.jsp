<!-- 특정한 게시글을 보여주는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!-- 스크립트 문장을 실행할 수 있도록 만들어주는 코드 -->
<%@ page import="bbs.Bbs"%>
<!-- 실제 데이터 베이스를 사용할 수 있도록 해준다 -->
<%@ page import="bbs.BbsDAO"%>
<!-- 데이터베이스 접근객체 또한 가져올 수 있게 해준다 -->
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
		int bbsID = 0;
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID")); /* 게시판 웹사이트에서 어떠한 글을 눌러서 들어갔을 때 bbsID가 정상적으로 넘어왔다면 view페이지 안에서 그걸 이용해서 bbsid에 담은다음에 그걸 처리할 수 있게 해준다 */
		}
		if(bbsID == 0){ /* 특정한 번호가 반드시 존재해야지 특정한 글을 볼 수 있게 된다 */
			PrintWriter script = response.getWriter(); 
			script.println("<script>"); 
			script.println("alert('유효하지 않은 글입니다.');");
			script.println("location.href='bbs.jsp';"); // 이전 페이지로 사용자를 돌려보낸다
			script.println("</script>"); 
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID); /* 해당 글의 구체적인 글의 내용을 가져올 수 있게 해준다. 유효한 글이라면 구체적인 정보를 bbs라는 인스턴스 안에 담을 수 있게 해준다 실제로 해당 글을 보여줄 수 있도록 실제로 보여주는 부분을 작업해보자 */
	%>
	<!-- 네비바 -->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggler="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트 만들기</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				if(userID == null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>
			<%	
				} else{
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<table class="table table" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"	style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colsapn="2"><%=bbs.getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colsapn="2"><%=bbs.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colsapn="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2" style="min-height: 200px; text-align: left;"><%=bbs.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></td>
					</tr>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<%
				if(userID != null && userID.equals(bbs.getUserID())){ /* 현재 들어온 글의 작성자가 본인이라면 해당글을 수정할 수있게 만들어줘야한다 */
			%>
					<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a> <!-- 해당bbsID를 가져갈 수 있게 해서 매개변수로서 가져갈 수 있도록 만들어준다 -->
					<a onclick= "return confirm('정말 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a> <!-- 바로 삭제를 진행버리는 action페이지로 이동하기 때문에 -->
			<%
				}
			%>
			<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>