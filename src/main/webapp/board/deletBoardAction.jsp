<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	//세션검사
	if(session.getAttribute("loginMemberId") == null) {	
	response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
	return;	
	}

	//유효성 검사
	if(request.getParameter("boardNo")==null
		||request.getParameter("boardNo").equals("")){
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
	System.out.println(boardNo + "<--deletBoardAction pram boardNo");
	System.out.println(localName + "<--deletBoardAction pram localName");
	System.out.println(boardTitle + "<--deletBoardAction pram boardTitle");
	System.out.println(boardContent + "<--deletBoardAction pram boardContent");
	System.out.println(memberId + "<--deletBoardAction pram memberId");
	System.out.println(createdate + "<--deletBoardAction pram createdate");
	System.out.println(updatedate + "<--deletBoardAction pram updatedate");
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
	String deletSql = "DELETE FROM board WHERE board_no=?";
	deletStmt = conn.prepareStatement(deletSql);
	deletStmt.setInt(1,boardNo);
	
	System.out.println(deletStmt + "<--deletStmt");
	int row = deletStmt.executeUpdate();
	
	//row값 검사
	if(row == 1){
		msg = URLEncoder.encode("카테고리가 삭제되었습니다.","utf-8");
		System.out.println("삭제 성공");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	}else{
		System.out.println("삭제 실패");
		return;
	}
%>