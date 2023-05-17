<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>  
<%@ page import="java.util.*" %> 
<%@ page import="vo.*" %> 
<%
	//세션 요청값 확인
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	//아이디 정보가 없으면 홈으로
	if(request.getParameter("memberId") == null
		|| request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	//비밀번호 정보가 없으면 회원정보로
	String msg = "";
	if(request.getParameter("memberPw") == null
		|| request.getParameter("memberPw").equals("")){
		response.sendRedirect(request.getContextPath() + "/member/profileForm.jsp");
		return;
	}

	// 요청값 변수에 저장
	String memberId = request.getParameter("memberId");
	String oldMemberPw = request.getParameter("memberPw");
	// 디버깅
	System.out.println(memberId + " <-- updatePasswordForm pram memberId");
	System.out.println(oldMemberPw + " <-- updatePasswordForm pram oldMemberPw");
	
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//입력받은 비밀번호와 일치하는 데이터가 있는지 조회
	PreparedStatement updatePwStmt = null;
	ResultSet updatePwRs = null;
	String updateSql = "select member_id memberId, member_pw memberPw, createdate, updatedate from member where member_id = ? and member_pw = password(?)";
	updatePwStmt = conn.prepareStatement(updateSql);
	updatePwStmt.setString(1, memberId);
	updatePwStmt.setString(2, oldMemberPw);
	// 위 sql 디버깅
	System.out.println(updatePwStmt + " <-- profileForm profileStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	updatePwRs = updatePwStmt.executeQuery();
	Member profile = null;
	if(!updatePwRs.next()) {					// 비밀번호가 틀리면 회원정보 페이지로
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	} else {
		profile = new Member();
		profile.setMemberId(updatePwRs.getString("memberId"));
		profile.setMemberPw(updatePwRs.getString("memberPw")); 
		profile.setCreatedate(updatePwRs.getString("createdate"));
		profile.setUpdatedate(updatePwRs.getString("updatedate"));
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
		margin-left: 45%;
	}
</style>
</head>
<body>
<div class="container">
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<div>
	<h2><img alt="*" src="<%=request.getContextPath()%>/img/member.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">비밀번호 수정</h2>
	<form action="<%=request.getContextPath()%>/member/updatePasswordAction.jsp" method="post">
		<table class="table table-bordered" style="width: 600px; margin: 0 auto">
			<tr>
				<td style="background-color: #EAEAEA">아이디</td>
				<td>
					<input type="text" name="memberId" value="<%=memberId%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">변경 할 비밀번호</td>
				<td>
					<input type="hidden" name="memberId" value="<%=profile.getMemberId()%>">
					<input type="hidden" name="oldMemberPw" value="<%=oldMemberPw %>">
					<input type="password" name="memberPw">
				</td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA">비밀번호 확인</td>
				<td>
					<input type="password" name="updateMemberPw">
				</td>
			</tr>
		</table>
		<div class="button">
			<button class="btn btn-outline-dark" type="submit">정보수정</button>
			<button class="btn btn-outline-dark" type="submit" formaction="<%=request.getContextPath()%>/member/deletdMemberAction.jsp">회원탈퇴</button>
		</div>
	</form>
</div>
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>	
</div>	
</body>
</html>