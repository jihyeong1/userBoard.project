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
	if(request.getParameter("boardNo")==null
		||request.getParameter("boardNo").equals("")
		||request.getParameter("localName")==null
		||request.getParameter("localName").equals("")
		||request.getParameter("memberId")==null
		||request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	}
	//변수 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String memberId = request.getParameter("memberId");
	String createdate = request.getParameter("createdate");
	String updatedate = request.getParameter("updatedate");
	System.out.println(boardNo);
	//디버깅
	System.out.println(boardNo + "<--modifyBoard pram boardNo");
	System.out.println(localName + "<--modifyBoard pram localName");
	System.out.println(boardTitle + "<--modifyBoard pram boardTitle");
	System.out.println(boardContent + "<--modifyBoard pram boardContent");
	System.out.println(memberId + "<--modifyBoard pram memberId");
	System.out.println(createdate + "<--modifyBoard pram createdate");
	System.out.println(updatedate + "<--modifyBoard pram updatedate");
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
		margin-left: 650px;
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
	<h2><img alt="*" src="<%=request.getContextPath()%>/img/modify.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">게시글 수정</h2>
	<%
		if(request.getParameter("msg") != null){
	%>
		<p class="text-center"><%=request.getParameter("msg") %></p>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/board/modifyBoardAction.jsp" method="post">
		<table class="table table-bordered" style="width: 70%; height:500px; margin: 0 auto">
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold;">board_No</td>
				<td>
					<input type="text" name="boardNo" value="<%=boardNo %>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold;">local_Name</td>
				<td>
					<input type="text" name="localName" value="<%=localName %>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold;">board_Title</td>
				<td>
					<input type="text" name="boardTitle">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold;">board_Content</td>
				<td>
					<textarea rows="5" cols="80" name="boardContent">내용을 입력해주세요.</textarea>
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold;">member_Id</td>
				<td>
					<input type="text" name="memberId" value="<%=memberId %>" readonly="readonly">
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