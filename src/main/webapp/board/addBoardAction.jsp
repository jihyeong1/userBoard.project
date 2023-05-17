<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %> 
<%
	//넘어온 값 확인 
	System.out.println(request.getParameter("boardNo")+"<--넘어온 boardNo"); 
	System.out.println(request.getParameter("localName")+"<--넘어온 localName"); 
	System.out.println(request.getParameter("boardTitle")+"<--넘어온 boardTitle");
	System.out.println(request.getParameter("boardContent")+"<--넘어온 boardContent");
	System.out.println(request.getParameter("memberId")+"<--넘어온 memberId");

	//loginMemberId 세션 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//유효성 검사
	String msg = "";
	if(request.getParameter("localName") == null
		||request.getParameter("localName").equals("")){
		msg = URLEncoder.encode("localName이 입력되지않았습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp?msg="+msg);
		return;
	}
	if(request.getParameter("boardTitle") == null
		||request.getParameter("boardTitle").equals("")){
		msg = URLEncoder.encode("boardTitle이 입력되지않았습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp?msg="+msg);
		return;
		}
	if(request.getParameter("boardContent") == null
		||request.getParameter("boardContent").equals("")){
		msg = URLEncoder.encode("boardContent이 입력되지않았습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp?msg="+msg);
		return;
		}
	if(request.getParameter("memberId") == null
		||request.getParameter("memberId").equals("")){
		msg = URLEncoder.encode("memberId 입력되지않았습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp?msg="+msg);
		return;
		}
	
	//변수 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String memberId = request.getParameter("memberId");
	
	//디버깅
	System.out.println(localName + "<==localName");
	System.out.println(boardTitle + "<==boardTitle");
	System.out.println(boardContent + "<==boardContent");
	System.out.println(memberId + "<==memberId");
	
	//디비 연결하기
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// local테이블에 local_name이 없을 경우 추가해주는 쿼리작성
	// local_name 이 있는지 조회
	String categoryCheckSql = "SELECT * FROM local WHERE local_name=?";
    PreparedStatement categoryCheckStmt = conn.prepareStatement(categoryCheckSql);
    categoryCheckStmt.setString(1,localName);
    ResultSet categoryCheckRs = categoryCheckStmt.executeQuery();
    if(!categoryCheckRs.next()){
    	// local_name 이 없으면 추가
        String insertCategorySql="INSERT INTO local (local_name, createdate, updatedate) VALUES(?,now(),now())";
    	PreparedStatement insertCategoryStmt = conn.prepareStatement(insertCategorySql);
    	insertCategoryStmt.setString(1,localName);
    	int insertCategoryRow = insertCategoryStmt.executeUpdate();
    }
	
	//로컬네임이 있으면 insert구문 모델링
	PreparedStatement addInsertStmt = null;
	String addInsertSql = "INSERT INTO board values(?,?,?,?,?,now(),now())";
	addInsertStmt = conn.prepareStatement(addInsertSql);
	addInsertStmt.setInt(1,boardNo);
	addInsertStmt.setString(2,localName);
	addInsertStmt.setString(3,boardTitle);
	addInsertStmt.setString(4,boardContent);
	addInsertStmt.setString(5,memberId);
	
	int row = addInsertStmt.executeUpdate();
	
	if(row==1){
	      msg = URLEncoder.encode("데이터가 성공적으로 추가 되었습니다","utf-8");
	      response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
	      System.out.println("변경성공 row값-->"+row);
	      return;
	   }else{

	      response.sendRedirect(request.getContextPath()+"/board/addBoard.jsp?msg="+msg);
	      System.out.println("변경실패 row값-->"+row);
	      return;
	   }
%>