<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>    
<!DOCTYPE html>
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
	
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	String msg = "";
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	//delet 쿼리 작성
	PreparedStatement deletStmt = null;
	ResultSet deletRs = null;
	String deletSql = "DELETE FROM comment WHERE comment_no=?";
	deletStmt = conn.prepareStatement(deletSql);
	deletStmt.setInt(1,commentNo);
	
	System.out.println(deletStmt + "<--deletStmt");
	int row = deletStmt.executeUpdate();
	
	//row값 검사
	if(row == 1){
		msg = URLEncoder.encode("댓글이 삭제되었습니다.","utf-8");
		System.out.println("삭제 성공");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}else{
		System.out.println("삭제 실패");
	}
%>
