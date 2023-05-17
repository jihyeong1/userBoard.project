<%@page import="java.net.URLEncoder"%>
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
	//localName 요청값 검사
	if(request.getParameter("localName")==null
		||request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/categoryForm.jsp");
	}
	//변수 저장
	String localName = request.getParameter("localName");
	//디버깅
	System.out.println(localName + "<--localUpdateForm parm localName");
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	String msg = "";
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	//모델링시작
	//출력할 sql문 가져오기
	//게시글이 있을 때 수정할 수 없도록 설정
	PreparedStatement localUpdateStmt = null;
	ResultSet localUpdateRs = null;
	String localUpdateSql = "select count(local_name) cnt from board where local_name=?";
	localUpdateStmt = conn.prepareStatement(localUpdateSql);
	localUpdateStmt.setString(1,localName);
	
	//디버깅
	System.out.println(localUpdateStmt + "<--localUpdateStmt");
	localUpdateRs = localUpdateStmt.executeQuery();
	
	int cnt=0;
	if(localUpdateRs.next()){
		cnt = localUpdateRs.getInt("cnt");
	}
	
	//게시물이 있을 경우 반환
	if(cnt != 0 ){
		msg = URLEncoder.encode("게시물이 있어 지역명을 수정할 수 없습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/categoryForm.jsp?msg="+msg);
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
</style>
</head>
<body>
<div  class="container">
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div>
	<h2><img alt="*" src="<%=request.getContextPath()%>/img/icon.png" style="width: 25px; margin-bottom: 10px; margin-right: 5px;">카테고리 수정</h2>
	<%
		if(request.getParameter("msg") != null){
	%>
		<%=request.getParameter("msg") %>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/board/localUpdatdAction.jsp" method="post">
		<table class="table table-bordered" style="width: 600px; margin: 0 auto">
			<tr>
				<td style="background-color: #EAEAEA">지역명</td>
				<td>
					<input type="text" name="localName" value="<%=localName %>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">수정 할 지역명</td>
				<td>
					<input type="text" name="updateLocalName">
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