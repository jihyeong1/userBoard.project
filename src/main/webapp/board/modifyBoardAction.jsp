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
	String msg="";
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String localName = request.getParameter("localName");
	String memberId = request.getParameter("memberId");
	if(request.getParameter("boardTitle")==null
		||request.getParameter("boardTitle").equals("")){
		msg = URLEncoder.encode("타이틀이 입력되지 않았습니다.","utf-8");
		localName = URLEncoder.encode(localName,"utf-8");
		response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp?msg="+msg+"&boardNo="+boardNo+"&localName="+localName+"&memberId="+memberId);
		return;
	}
	if(request.getParameter("boardContent")==null
		||request.getParameter("boardContent").equals("")){
		msg = URLEncoder.encode("코멘트가 입력되지 않았습니다.","utf-8");
		localName = URLEncoder.encode(localName,"utf-8");
		response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp?msg="+msg+"&boardNo="+boardNo+"&localName="+localName+"&memberId="+memberId);
		return;
	}	
	
	//변수 저장
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String createdate = request.getParameter("createdate");
	String updatedate = request.getParameter("updatedate");
	
	//디버깅
	System.out.println(boardNo + "<--변경 할 pram boardNo");
	System.out.println(localName + "<--변경 할 pram localName");
	System.out.println(boardTitle + "<--변경 할 pram boardTitle");
	System.out.println(boardContent + "<--변경 할 pram boardContent");
	System.out.println(memberId + "<--변경 할 pram memberId");
	
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
	String updateSql="UPDATE board SET board_title=?, board_content=?, updatedate=NOW() WHERE board_no=?";
	updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1,boardTitle);
	updateStmt.setString(2,boardContent);
	updateStmt.setInt(3,boardNo);
	
	System.out.println(updateStmt + "<--updateStmt");
	
	int row = updateStmt.executeUpdate();
	
	//row값 검사
	if(row == 1){
		System.out.println("수정성공");
		msg = URLEncoder.encode("수정에 성공했습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		return;
	}else{
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath()+"/board/modifyBoard.jsp");
		return;
	}
%>