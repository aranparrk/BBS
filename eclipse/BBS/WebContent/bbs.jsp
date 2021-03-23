<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%> <!-- 스크립트 문장을 실행할 수 있도록 만들어주는 코드 -->
<%@ page import="bbs.BbsDAO"%> 
<%@ page import="bbs.Bbs"%> 
<%@ page import="java.util.*"%> <!-- 게시판의 목록이 필요할 때 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content=Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	a, a:hover{
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<% 
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID"); /* 로그인 한 사람이라면 userID라는 변수에 해당 아이디가 담기게 된다. */
		}
		int pageNumber = 1; /* 몇 번째 페이지인지 알려주기 위해서 1로 넣어준다. 1이라는 것은 기본페이지를 의미한다 */
		if(request.getParameter("pageNumber") != null){ /* 페이지넘버가 넘어오면 페이지넘버에는 파라미터 값을 넣어줄 수 있도록 한다 */
			pageNumber = Integer.parseInt(request.getParameter("pageNumber")); /* 파라미터는 정수형으로 바꿔주는 parseInt로 바꿔줘야한다 */
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
			<%
				if(userID == null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" 
					data-toggle="dropdown" role="button" aria-haspopup="true" 
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%	
				} else{
			%>
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
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th style="background-color: #eeeeee; text-align: center;">번호</th>
					<th style="background-color: #eeeeee; text-align: center;">제목</th>
					<th style="background-color: #eeeeee; text-align: center;">작성자</th>
					<th style="background-color: #eeeeee; text-align: center;">작성일</th>
				</tr>
			</thead>
			<tbody>
				<%
					BbsDAO bbsDAO = new BbsDAO(); /* 게시글을 뽑아올 수 있도록 하나의 인스턴스를 만들어준다 */
					ArrayList<Bbs> list = bbsDAO.getList(pageNumber); /* 리스트를 만들고 그 값을 현재의 페이지에서 가져온 목록ㅇ르 출력해볼 것 */
					for(int i = 0; i < list.size(); i++){
				%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td> <!-- 현재 게시글의 정보를 가져오면 된다 -->
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n", "<br>") %></a></td> <!-- 제목을 눌렀을 때는 해당 게시글의 내용을 보여주는 페이지로 넘어가야 하므로 해당 jsp로 해당 게시글 번호를 매개변수로 보냄으로서 처리하게 해준다 즉 해당 게시글 번호에 맞는 게시물을 나중에 뷰페이지에서 보여주기 위함이다-->
						<td><%= list.get(i).getUserID() %></td> <!-- 현재 게시글의 정보를 가져오면 된다 -->
						<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td> <!-- 현재 게시글의 정보를 가져오면 된다 -->
					</tr>
				<%	 
					}
				%>
			</tbody>
			</table>
				<%
					if(pageNumber != 1){ /* 페이지 넘버가 1이 아니라면 */
				%>
					<a href="bbs.jsp?pageNumber=<%= pageNumber - 1%>" class="btn btn-success btn-araw-left">이전</a>
				<%		
					} if(bbsDAO.nextPage(pageNumber + 1)){ /* 다음페이지가 존재한다면 */
				%>
					<a href="bbs.jsp?pageNumber=<%= pageNumber + 1%>" class="btn btn-success btn-araw-left">다음</a>
				<%		
					}
				%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>