<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>  
<%@ page import="java.util.*" %> 
<%@ page import="vo.*" %>   
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//로그인 중인 아이디 변수에 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	//디버깅
	System.out.println(loginMemberId + "<--loginMemberId");
	
	//디비접속
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//memberId 와 일치하는 행 조회하기
	PreparedStatement profileStmt = null;
	ResultSet profileRs = null;
	String profileSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ?";
	profileStmt = conn.prepareStatement(profileSql);
	profileStmt.setString(1, loginMemberId);
	// 위 sql문 디버깅
	System.out.println(profileStmt+"<--profileForm pram profileStmt");
	//전송한 sql문 반환
	profileRs = profileStmt.executeQuery();
	Member profile = null;
	if(profileRs.next()){
		profile = new Member();
		profile.setMemberId(profileRs.getString("memberId"));
		profile.setMemberPw(profileRs.getString("memberPw"));
		profile.setCreatedate(profileRs.getString("createdate"));
		profile.setUpdatedate(profileRs.getString("updatedate"));
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
	.button {
		margin-top: 20px;
		margin-left: 44%;
	}
</style>
</head>
<body>
<div class="container">
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div>
	<h2><img alt="*" src="<%=request.getContextPath()%>/img/member.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">회원 정보</h2>
	<form action="<%=request.getContextPath()%>/member/updatePasswordForm.jsp" method="post">
		<table class="table table-bordered" style="width: 600px; margin: 0 auto">
			<tr>
				<td style="background-color: #EAEAEA">아이디</td>
				<td>
					<input type="text" name="memberId" value="<%=profile.getMemberId()%>" readonly="readonly" >
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">비밀번호</td>
				<td>
					<input type="password" name="memberPw">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">생성날짜</td>
				<td><%=profile.getCreatedate().substring(0,10) %></td>
			</tr>
		</table>
	<div class="button">	
		<button type="submit" class="btn btn-outline-dark">비밀번호 수정</button>
		<button type="submit" class="btn btn-outline-dark" formaction="<%=request.getContextPath()%>/member/deletdMemberAction.jsp">회원 탈퇴</button>
	</div>	
	</form>
</div>
</div>
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>	
</div>	
</body>
</html>