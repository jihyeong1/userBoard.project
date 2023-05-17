<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>    
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;	
	}
 	
	//요청값 유효성 검사
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
	
	//요청값 변수저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println(memberId + "<-- deletdMemberAction pram memberId");
	System.out.println(memberPw + "<-- deletdMemberAction pram memberPw");
	
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//아이디와 비밀번호 입력받아서 탈퇴하는 쿼리 작성
	PreparedStatement deletMemberStmt = null;
	String deletMemberSql = "delete from member where member_id = ? and member_pw = password(?)";
	deletMemberStmt = conn.prepareStatement(deletMemberSql);
	deletMemberStmt.setString(1, memberId);
	deletMemberStmt.setString(2, memberPw);
	
	System.out.println(deletMemberStmt + "<-- deletdMemberAction pram deletMemberStmt");
	
	int row = deletMemberStmt.executeUpdate();
	
	if(row == 1){
		System.out.println("회원삭제성공");
	}else{ //회원 삭제 실패 시
		System.out.println("회원 삭제 실패"); 
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	}
	
	session.invalidate();
	response.sendRedirect(request.getContextPath() + "/home.jsp");
%>