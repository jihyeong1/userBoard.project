<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<% 
	//인코딩 하기
	request.setCharacterEncoding("utf-8");
	//넘어온 값 확인
	System.out.println(session.getAttribute("loginMemberId")+"<--넘어온 loginMemberId"); 
	System.out.println(request.getParameter("boardNo")+"<--넘어온 boardNo"); 

	//loginMemberId 세션 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//요청값 검사 boardNo 
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")
			){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//넘어온 comment가 없을 때
	if(request.getParameter("commentContent").equals("")){
		// boardOne으로 보낼때 boardNo값 같이 보내기
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + request.getParameter("boardNo"));
		return;
	}
	
	//변수 설정
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String commentContent = request.getParameter("commentContent");
	String memberId = request.getParameter("memberId");

	
	//디버깅
	System.out.println(boardNo + "<==boardNo");
	System.out.println(commentContent + "<==commentContent");
	System.out.println(memberId + "<==memberId");
	
	//모델링 설정 시작점
	//디비 연결하기
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//insert구문 모델링
	PreparedStatement insertCommentStmt = null;
	ResultSet insertCommentRs = null;
	String insertCommentSql = "insert into comment(board_no, comment_content, member_id, createdate, updatedate) values(?,?,?,now(),now())";
	insertCommentStmt = conn.prepareStatement(insertCommentSql);
	insertCommentStmt.setInt(1, boardNo);
	insertCommentStmt.setString(2, commentContent);
	insertCommentStmt.setString(3, memberId);
	int row = insertCommentStmt.executeUpdate();
	
    System.out.println(row + " <--row");
    System.out.println(insertCommentStmt +"<--insertCommentStmt");
    
    //쿼리문 실행할 때 영향받은 행의 수가 잘 추가되었는지 확인해주기
    if(row ==  1){
    	System.out.println("입력성공");
    	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);

    }else{
    	System.out.println("입력실패");
    }
%>