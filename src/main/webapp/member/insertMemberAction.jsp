<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>    
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//유효성 검사
	if(request.getParameter("insertMemberId").equals("")
		|| request.getParameter("insertMemberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
		return;
	}

	//요청값 변수 선언
	String insertMemberId = request.getParameter("insertMemberId");
	String insertMemberPw = request.getParameter("insertMemberPw");	
	
	//디버깅
	System.out.println(insertMemberId + "<-- insertMemberId");
	System.out.println(insertMemberPw + "<-- insertMemberPw");
	
	//요청값 묶어서 저장하기
	Member paramMember = new Member();
	paramMember.setMemberId(insertMemberId);
	paramMember.setMemberPw(insertMemberPw);
	
	System.out.println(insertMemberId + "<-- insertMemberId");

	//디비 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	PreparedStatement stmt2 = null;
	String msg = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//쿼리 작성
	/* INSERT INTO member(member_id, member_pw, createdate, updatedate)
	VALUES(insertMemberId = ? , insertMemberPw = PASSWORD(?), NOW(), NOW()); */

	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	System.out.println(stmt + "<--stmt");

	// id(기본키)가 중복되는 경우 에러 발생 -> select로 id먼저 비교한 후 중복값은 리다이렉션 시키기
	String sql2 = "SELECT member_id memberId from member where member_id = ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, paramMember.getMemberId());
	System.out.println( stmt2 + " <--insertMemberAction stmt2");
	rs = stmt2.executeQuery();	
	//중복된 아이디가 있는경우
	if(rs.next()){ 
		msg = URLEncoder.encode("중복된 ID입니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
	int row = stmt.executeUpdate();
	//디버깅
	System.out.println(row + "row값");
	
	if(row==1){
		System.out.println("회원가입 성공");
		response.sendRedirect(request.getContextPath() + "/home.jsp"); //정상작동하면 홈으로
	}else{
		System.out.println("회원가입 실패");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp"); //실패시 가는 곳
	}
%>