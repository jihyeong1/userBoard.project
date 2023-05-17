<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>  
<%
	//세션검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//유효성 검사
	if(request.getParameter("commentNo") == null
		|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	//보내줄 boardNo값 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg="";
	if(request.getParameter("commentContent") == null
		||request.getParameter("commentContent").equals("")){
		System.out.println("댓글없음");
		msg = URLEncoder.encode("댓글을 입력해주세요.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/modifyComment.jsp?msg="+msg+"&commentNo="+commentNo+"&boardNo="+boardNo);
		return;
	}
	//변수저장
	String commentContent = request.getParameter("commentContent");	
	
	//디버깅
	System.out.println(commentContent + "<--변경 할 pram boardNo");
	
	//디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//modifyboard 쿼리문 작성(update)
	/* UPDATE board SET board_title=?, board_content=?, updatedate=NOW() WHERE board_no=? */
	PreparedStatement updateStmt=null;
	String updateSql="UPDATE comment SET comment_content=?, updatedate=NOW() WHERE comment_no=?";
	updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1,commentContent);
	updateStmt.setInt(2,commentNo);
	
	System.out.println(updateStmt + "<--updateStmt");
	
	int row = updateStmt.executeUpdate();
	
	//row값 검사
	if(row == 1){
		System.out.println("수정성공");
		msg = URLEncoder.encode("수정에 성공했습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}else{
		System.out.println("수정실패");
	}
%>