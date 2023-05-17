<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>    
<%
	
	//세션 검사
	if(session.getAttribute("loginMemberId")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;	
	}
	//localName, updateLocalName 유효성 검사
	if(request.getParameter("localName")==null
		||request.getParameter("localName").equals("")
		||request.getParameter("updateLocalName")==null
		||request.getParameter("updateLocalName").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/localUpdateForm.jsp");
		return;
	}	
	//변수 저장
	String localName = request.getParameter("localName");
	String updateLocalName = request.getParameter("updateLocalName");
	//디버깅
	System.out.println(localName + "<--localUpdatdAction parm localName");
	System.out.println(updateLocalName + "<--localUpdatdAction parm updateLocalName");
	//모델링
	//디비연동
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	String msg = "";
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	//updatdalocalName 중복될 경우의 쿼리문
	PreparedStatement updateLocalStmt = null;
	ResultSet updateLocalRs = null;
	String updateLocalSql = "SELECT local_name localName from local where local_name=?";
	updateLocalStmt = conn.prepareStatement(updateLocalSql);
	updateLocalStmt.setString(1,updateLocalName);
	
	System.out.println(updateLocalStmt + "updateLocalStmt");
	updateLocalRs = updateLocalStmt.executeQuery();
	if(updateLocalRs.next()){
		msg = URLEncoder.encode("중복된 카테고리명 입니다. 수정해주세요.","utf-8");
		String urlLocalName = URLEncoder.encode(localName,"utf-8"); 
		response.sendRedirect(request.getContextPath()+"/board/localUpdateForm.jsp?msg="+msg+"&localName="+urlLocalName);
		return;
	}
	//localName을 변경 할 updatd 쿼리문
	PreparedStatement updateLocalStmt2 = null;
	/* UPDATE local SET local_name= ? WHERE local_name= ? */ 
	String updateLocalSql2 = "UPDATE local SET local_name= ? WHERE local_name= ?";
	updateLocalStmt2 = conn.prepareStatement(updateLocalSql2);
	updateLocalStmt2.setString(1,updateLocalName);
	updateLocalStmt2.setString(2,localName);
	
	System.out.println(updateLocalStmt2 + "<--updateLocalStmt2");
	int row = updateLocalStmt2.executeUpdate();
	
	//row 확인
	if(row==1){
		System.out.println("수정 성공");
		msg = URLEncoder.encode("지역명 수정에 성공했습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/categoryForm.jsp?msg="+msg);
		return;
	}
%> 