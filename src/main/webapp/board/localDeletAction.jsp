<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>    
<%
	//세션검사//세션검사
	if(session.getAttribute("loginMemberId") == null) {	
	response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
	return;	
	}
	//localName 유효성 검사
	if(request.getParameter("localName")==null
		||request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/categoryForm.jsp");
	}
	//변수저장
	String localName = request.getParameter("localName");
	
	System.out.println(localName + "<--localDeletForm pram localName");
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	String msg = "";
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	//delet하는 쿼리문 설정
	PreparedStatement localDeletStmt = null;
	ResultSet localDeletRs = null;
	/* DELETE FROM local WHERE local_name = ? */ 
	String localDeletSql = "DELETE FROM local WHERE local_name = ?";
	localDeletStmt = conn.prepareStatement(localDeletSql);
	localDeletStmt.setString(1,localName);
	
	System.out.println(localDeletStmt + "<--localDeletStmt");
	int row = localDeletStmt.executeUpdate();
	//row 값 확인 
	if(row == 1){
		System.out.println("삭제 실패");
		response.sendRedirect(request.getContextPath()+"/board/localDeletForm.jsp");
		return;
	}else{
		msg = URLEncoder.encode("카테고리가 삭제되었습니다.","utf-8");
		System.out.println("삭제 성공");
		response.sendRedirect(request.getContextPath()+"/board/categortForm.jsp?msg="+msg);
		return;
	}
%>