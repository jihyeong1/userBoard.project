<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%
	//요청값 검사
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	
	}
	System.out.println(request.getParameter("boardNo") + "<--불러온 boardNo");
	
	//불러온 값 저장하기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
 		currentPage = Integer.parseInt(request.getParameter("currentPage"));
 	}
 	System.out.println(currentPage + "<--currentPage값");
 	
	int rowPerPage = 10;  
	int startRow = (currentPage - 1)*rowPerPage;
	
	int totalRow = 0;
	
	//모델링 설정 시작점
	//디비 연결하기
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//상세리스트 모델링 하기
	// boardOne 결과셋
	PreparedStatement boardDetailStmt = null;
	ResultSet boardDetailRs = null;
	String boardDetailsql="";
	/* select board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate 
	from board where board_no = ? */
	boardDetailsql= "select board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate from board where board_no = ? ";
	boardDetailStmt = conn.prepareStatement(boardDetailsql);
	boardDetailStmt.setInt(1,boardNo);
	boardDetailRs = boardDetailStmt.executeQuery(); //row ->1
	
	//디버깅
	System.out.println(boardDetailStmt + "<--boardDetailStmt");
	
	SubList subList = null;
	if(boardDetailRs.next()){
		subList = new SubList();
		subList.setBoardNo(boardDetailRs.getInt("boardNo")); 
		subList.setLocalName(boardDetailRs.getString("localName")); 
		subList.setBoardTitle(boardDetailRs.getString("boardTitle")); 
		subList.setBoardContent(boardDetailRs.getString("boardContent")); 
		subList.setMemberId(boardDetailRs.getString("memberId")); 
		subList.setCreatedate(boardDetailRs.getString("createdate")); 
		subList.setUpdatedate(boardDetailRs.getString("updatedate")); 
	}
	
	//comment list 결과셋
	/* SELECT comment_no, board_no, comment_content
	FROM comment
	WHERE board_no = 1000;
	LIMIT 0, 10; */ 
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	//수정해야함
	String commentListSql="SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? ORDER BY createdate DESC LIMIT ?,?";
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1, boardNo);
	commentListStmt.setInt(2, startRow);
	commentListStmt.setInt(3, rowPerPage);
	commentListRs = commentListStmt.executeQuery(); //row -> 최대10
	
	//디버깅
	System.out.println(commentListStmt + "<--commentListStmt");
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentListRs.next()){
		Comment c = new Comment(); 
		c.setCommentNo(commentListRs.getInt("commentNo"));
		c.setBoardNo(commentListRs.getInt("boardNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
	}
	
	//pageCnt 쿼리문
	PreparedStatement pageCntstmt = null;
	ResultSet pageCntRs = null;
	String pageCntsql = "SELECT count(*) from comment WHERE board_no = ?";
	pageCntstmt = conn.prepareStatement(pageCntsql);
	pageCntstmt.setInt(1,boardNo);
	pageCntRs = pageCntstmt.executeQuery();
	if(pageCntRs.next()){
		totalRow = pageCntRs.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	
	
%>     
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	h2{
		text-align: center;
		margin-top: 20px;
		margin-left: 30px;
		margin-bottom: 30px;
	}
	table {
		text-align: center;	
	}
	a{
		text-decoration: none;
		color: #000000;
	}
	.button{
		margin-left: 49%;
		margin-top: 20px;
		margin-bottom: 20px;
	}
	.comment{
		margin-top: 50px;
	}
	p{
		color: red;
	}	
</style>
</head>
<body>
<div class="container">
<div>
	<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
<h2><img alt="*" src="<%=request.getContextPath()%>/img/modify.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">게시글 상세설명</h2>
<form action="<%=request.getContextPath()%>/board/modifyBoard.jsp" method="post">
	<table class="table table-bordered" style="width: 700px; height: 400px; margin: 0 auto">
			<tr>			
				<td style="background-color: #EAEAEA; font-weight: bold">게시글 번호
					<input type="hidden" name="boardNo" value="<%=subList.getBoardNo()%>">
				</td>
				<td><%=subList.getBoardNo() %></td>
			</tr>
			
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold">지역 이름
					<input type="hidden" name="localName" value="<%=subList.getLocalName()%>">
				</td>
				<td><%=subList.getLocalName()%></td>
			</tr>
			
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold">타이틀
					<input type="hidden" name="boardTitle" value="<%=subList.getBoardTitle()%>">
				</td>
				<td><%=subList.getBoardTitle() %></td>
			</tr>
			
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold">게시글 내용
					<input type="hidden" name="boardContent" value="<%=subList.getBoardContent()%>">
				</td>
				<td><%=subList.getBoardContent() %></td>
			</tr>
			
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold">회원_Id
					<input type="hidden" name="memberId" value="<%=subList.getMemberId()%>">
				</td>
				<td><%=subList.getMemberId()%></td>
			</tr>
			
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold">생성일
					<input type="hidden" name="createdate" value="<%=subList.getCreatedate()%>">
				</td>
				<td><%=subList.getCreatedate() %></td>
			</tr>
			<tr>
				<td style="background-color: #EAEAEA; font-weight: bold">수정일
					<input type="hidden" name="updatedate" value="<%=subList.getUpdatedate()%>">
				</td>
				<td><%=subList.getUpdatedate() %></td>
			</tr>
	</table>
	<%
		//내가 쓴 게시글 만 수정 삭제할 수 있도록 설정
		String loginId = (String) session.getAttribute("loginMemberId");
		if(loginId != null && loginId.equals(subList.getMemberId())){
	%>
			<div class="button">
				<button class="btn btn-outline-dark" type="submit">수정</button>
				<button class="btn btn-outline-dark" type="submit" formaction="<%=request.getContextPath()%>/board/deletBoard.jsp">삭제</button>
			</div>
	<%		
		}
	%>
	</form>
	<!-- comment 입력 : 세션유무에 따른 분기 -->
	<hr>
	<%
		//로그인 사용자만 댓글 입력 허용
		if(session.getAttribute("loginMemberId") != null){
			//현재 로그인 사용자의 아이디
			String loginMemberId = (String)session.getAttribute("loginMemberId");
	%>		
		<div>
			<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
				<input type="hidden" name="boardNo" value="<%=subList.getBoardNo()%>">
				<input type="hidden" name="memberId" value="<%=loginMemberId%>">
				<table class="table table-bordered">
					<tr>
						<th style="background-color: #EAEAEA">댓글 입력</th>
						<td>
							<textarea rows="2" cols="80" name="commentContent"></textarea>
						</td>
					</tr>	
					<div>
						<button type="submit"  class="btn btn-outline-dark" style=" margin-bottom:10px; margin-right:10px; float: right; ">댓글입력</button>
					</div>	
				</table>
			</form>
		</div>
	<%		
		}
	%>
	<hr style="margin-top: 50px;">
	
	<!-- comment list 결과셋 -->
	<form action="<%=request.getContextPath()%>/board/modifyComment.jsp" method="post">
	<%
		if(request.getParameter("msg") != null){
	%>
			<p class="text-center"><%=request.getParameter("msg") %></p>
	<%		
		}
	%>
		<table class="table table-bordered">
			<h2 class="comment"><img alt="*" src="<%=request.getContextPath()%>/img/commentIcon.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">댓글창</h2>
			<tr class="table-dark">
				<th style="width: 60%">댓글 내용</th>
				<th>회원_ID</th>
				<th>생성일</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			<%
			  for(Comment c : commentList){
			%>
				<tr>
					<td><%=c.getCommentContent()%></td>
					<td><%=c.getMemberId()%></td>
					<td><%=c.getUpdatedate()%></td>			
			<%
			//내가 쓴 게시글 만 수정 삭제할 수 있도록 설정
			if(loginId != null && loginId.equals((String)session.getAttribute("loginMemberId"))){
			%>		
					<td>
						<a href="<%=request.getContextPath()%>/board/modifyComment.jsp?commentContent=<%=c.getCommentContent()%>&memberId=<%=c.getMemberId() %>&updatedate=<%=c.getUpdatedate()%>&boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>">수정</a>
					</td>
					<td>
						<a href="<%=request.getContextPath()%>/board/removeCommentAction.jsp?commentContent=<%=c.getCommentContent()%>&memberId=<%=c.getMemberId() %>&updatedate=<%=c.getUpdatedate()%>&boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>">삭제</a>
					</td>
				</tr>
			<%	  
			  }}
			%>
		</table>
	</form>
	
	<div>
		<%
			if(currentPage > 1){
		%>
				<a class="btn btn-outline-dark" style="margin-bottom: 10px; float: left;" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage - 1%>&boardNo=<%=boardNo%>">이전</a>
		<%		
			}
		%>
		<%
			if(currentPage < lastPage){
		%>
				<a class="btn btn-outline-dark" style="margin-bottom: 10px; float: right;" href="<%=request.getContextPath()%>/board/boardOne.jsp?currentPage=<%=currentPage + 1%>&boardNo=<%=boardNo%>">다음</a>
		<%		
			}
		%>
	</div>
	<div style="margin-top: 80px; margin-bottom: 20px;">
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>	
</div>	
</body>
</html>