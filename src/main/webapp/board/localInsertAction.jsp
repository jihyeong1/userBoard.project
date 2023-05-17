<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>     
<%
	//세션검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;	
	}
	
	// 요청값 검사
	// 넘어온 localName이 없을 때
	if(request.getParameter("localName") == null
		|| request.getParameter("localName").equals("")){
		 String msg = URLEncoder.encode("지역명을 입력해주세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/localInsertForm.jsp?msg="+msg);
	}
	// 변수 설정
	String localName = request.getParameter("localName");
	//디버깅
	System.out.println(localName + "<==localinsertAction pram localName");
	// 디비연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	
	// localName 추가(insert)하는 쿼리문 설정
	PreparedStatement localInsertStmt = null;
	ResultSet localInsertRs = null;
	/* INSERT INTO local(local_name,createdate,updatedate) 
	VALUES('예산',NOW(),NOW()); */
	String localInsertSql ="INSERT INTO local(local_name,createdate,updatedate) VALUES(?,NOW(),NOW())";
	localInsertStmt = conn.prepareStatement(localInsertSql);
	localInsertStmt.setString(1,localName);
	
	//디버깅
	System.out.println(localInsertStmt + "<==localinsertAction pram localInsertStmt");
	
	//localName 이 중복될 경우
	String msg="";
	PreparedStatement stmt2 = null;
	ResultSet rs = null;
	String sql2 = "SELECT local_name localName from local where local_name = ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,localName);
	System.out.println( stmt2 + " <--insertMemberAction stmt2");
	rs = stmt2.executeQuery();	
	if(rs.next()){ 
		msg = URLEncoder.encode("중복된 카테고리 입니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/localInsertForm.jsp?msg="+msg);
		return;
	}
	//디버깅
	System.out.println(stmt2 + "<==localinsertAction pram stmt2");
	
	int row = localInsertStmt.executeUpdate();
	// insert가 잘 되었는지 추가 확인(row)
	if(row == 1){
		System.out.println("입력성공");
		msg = URLEncoder.encode("카테고리가 생성 되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/categoryForm.jsp?msg="+msg);
	}
%>