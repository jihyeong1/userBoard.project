<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%
	//세션검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//유효성 검사
	if(request.getParameter("commentNo")==null
		||request.getParameter("commentNo").equals("")
		||request.getParameter("boardNo")==null
		||request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	}
	//변수 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));

	
	//디버깅
	System.out.println(boardNo + "<--modifyComment pram boardNo");
	System.out.println(commentNo + "<--modifyComment pram commentNo");
	
	
%>     
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h2{
		text-align: center;
		margin-top: 20px;
		margin-bottom: 30px;
	}
	table {
		text-align: center;	
	}
	button {
		margin-top: 20px;
		margin-left: 53%;
	}
	input, textarea {
		float: left;
		margin-left: 10px;
	}
	p{
		color: red;
	}
</style>
</head>
<body>
<div  class="container">
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>

<div>
	<h2><img alt="*" src="<%=request.getContextPath()%>/img/commentIcon.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">댓글 수정</h2>
	<%
		if(request.getParameter("msg") != null){
	%>
		<p class="text-center"><%=request.getParameter("msg") %></p>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/board/modifyCommentAction.jsp" method="post">
		<table class="table table-bordered" style="width: 70%; margin: 0 auto">
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold;">댓글 내용</td>
				<td>
					<input type="hidden" name="boardNo" value="<%=boardNo %>">
					<input type="hidden" name="commentNo" value="<%=commentNo %>">
					<input type="text" name="commentContent" style="width: 90%;">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-dark">수정</button>
	</form>
</div>

<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>	
</div>
</body>
</html>