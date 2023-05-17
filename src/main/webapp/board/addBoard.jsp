<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%
	//세션검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;	
	}

	//디비 연결하기
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//boardNo Max 값 구하기
	PreparedStatement maxStmt = null;
	ResultSet maxRs = null;
	String maxSql = "select max(board_no) max from board";
	maxStmt = conn.prepareStatement(maxSql);
	maxRs = maxStmt.executeQuery();
	int maxCnt = 0;
	if(maxRs.next()){
		maxCnt = maxRs.getInt("max");
	}

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
		margin-left: 50%;
	}
	input, textarea{
		float: left;
		margin-left: 20px;
	}
</style>
</head>
<body>
<div class="container">
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div>
	<h2><img alt="*" src="<%=request.getContextPath()%>/img/icon.png" style="width: 25px; margin-bottom: 10px; margin-right: 5px;">게시글 쓰기</h2>
	<%
		if(request.getParameter("msg") != null){
	%>
		<%=request.getParameter("msg") %>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/board/addBoardAction.jsp" method="post">
		<table class="table table-bordered" style="width: 700px; margin: 0 auto">
			<tr>
				<td style="background-color: #EAEAEA">게시글 번호</td>
				<td>
					
					<input type="text" name="boardNo" value="<%=maxCnt+1%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">지역 이름</td>
				<td>
					
					<input type="text" name="localName">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">타이틀</td>
				<td>
					<input type="text" name="boardTitle" style="width: 70%">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">게시글 내용</td>
				<td>
					<textarea rows="10" cols="60" name="boardContent"></textarea>
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">회원_Id</td>
				<td>
					<input type="text" name="memberId">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-dark">추가</button>
	</form>
</div>
</div>
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>	
</body>
</html>