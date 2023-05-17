<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>  
<%@ page import="java.util.*" %> 
<%@ page import="vo.*" %>
<%
	//세션검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;	
	}
	//모델링
	//디비
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//로컬리스트쿼리문
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	/* SELECT local_name localName, createdate, updatedate form local; */
	String localSql="SELECT local_name localName, createdate, updatedate from local order by local_name";
	localStmt = conn.prepareStatement(localSql);
	
	//디버깅
	System.out.println(localStmt + "<--categoryForm pram localStmt");
	localRs = localStmt.executeQuery();
	
	//localList 모델데이터
	ArrayList<LocalList> localList = new ArrayList<LocalList>();
	while(localRs.next()){
		LocalList l = new LocalList();
		l.setLocalName(localRs.getString("localName"));
		l.setCreatedate(localRs.getString("createdate"));
		l.setUpdatedate(localRs.getString("updatedate"));
		localList.add(l);
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
	}
	table {
		text-align: center;
		line-height: 2;
	}
	a{
		text-decoration: none;
		color: #000000;
	}
	p{
		color: red;
	}	
</style>
</head>
<body>
<div class="container">
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div>
	<h2><img alt="*" src="<%=request.getContextPath()%>/img/icon.png" style="width: 25px; margin-bottom: 10px; margin-right: 5px;">카테고리 목록</h2>
</div>
	<%
		if(request.getParameter("msg") != null){
	%>
		<p class="text-center"><%=request.getParameter("msg") %></p>
	<%		
		}
	%> <br>
<a  class="btn btn-outline-dark" style="float: right; margin-bottom: 20px;" href="<%=request.getContextPath()%>/board/localInsertForm.jsp">카테고리 추가</a>
<table class="table table-hover">
	<tr>
		<th style="background-color: #EAEAEA;">지역명</th>
		<th style="background-color: #EAEAEA;">수정</th>
		<th style="background-color: #EAEAEA;">삭제</th>
	</tr>
		<%
			for(LocalList l : localList){
		%>
		<tr>
				<td><%=l.getLocalName()%></td>
				<td>
					<a href="<%=request.getContextPath()%>/board/localUpdateForm.jsp?localName=<%=l.getLocalName()%>">수정</a>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/board/localDeletForm.jsp?localName=<%=l.getLocalName()%>">삭제</a>
				</td>
		</tr>
		<%		
			}
		%>
</table>
</div>
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
</div>	
</body>
</html>