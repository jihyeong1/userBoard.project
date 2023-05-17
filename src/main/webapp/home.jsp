<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>  
 <%
	// 요청분석(컨트롤러 계층)
	// 1.세션 session JSP내장(기본)객체
	// 2. request / response
	int currentPage = 1;
 	if(request.getParameter("currentPage") != null){
 		currentPage = Integer.parseInt(request.getParameter("currentPage"));
 	}
 	System.out.println(currentPage + "<--currentPage값"); 
 	
 	//출력 행 설정
 	int rowPerPage = 10;
 	int startRow = (currentPage - 1) * rowPerPage; 
 	
 	int totalRow = 0;
 	
 	//localName의 초기화설정
	String localName = "전체"; //기본값을 "전체"로 설정
	if(request.getParameter("localName") != null){ //전체값이 들어오지않았을 때
		localName = request.getParameter("localName"); //localName에 값 저장
	}
	System.out.println(localName + "<--localName");
	
	// 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement subMenuStmt = null;
	ResultSet subMenuRs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	//subMenuList 쿼리문 만들기
	/* SELECT '전체' localName,COUNT(local_name) cnt FROM board
	UNION all
	SELECT local_name, COUNT(local_name) FROM board group BY local_name; */
	String subMenuSql = "SELECT '전체' localName,COUNT(local_name) cnt FROM board UNION all SELECT local_name, COUNT(local_name) FROM board group BY local_name";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	subMenuRs = subMenuStmt.executeQuery();
	
	//subMenuList <-- 모델데이터
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);					
	}
	
	//subMenuBoard 쿼리문 만들기
	/* SELECT local_name, board_title, SUBSTRING(board_content, 1, 11) FROM board; */
	PreparedStatement subMenuBoardStmt = null;
	ResultSet subMenuBoardRs = null;
	String subMenuBoard = "SELECT board_no boardNo, local_name localName, board_title boardTitle, SUBSTRING(board_content, 1, 11) boardContent, member_id memberId, createdate FROM board";
	String subMenuAddSql = " WHERE local_name = ?";
	if(!localName.equals("전체")){
		subMenuBoard += subMenuAddSql + " ORDER BY createdate DESC LIMIT ?, ?"; //전체 값이 설정되지않았을 때 sql문 합치기
		subMenuBoardStmt = conn.prepareStatement(subMenuBoard);
		subMenuBoardStmt.setString(1, localName);
		subMenuBoardStmt.setInt(2, startRow);
		subMenuBoardStmt.setInt(3, rowPerPage);
	} else {
		subMenuBoard += " ORDER BY createdate DESC LIMIT ?, ?";
		subMenuBoardStmt = conn.prepareStatement(subMenuBoard);
		subMenuBoardStmt.setInt(1, startRow);
		subMenuBoardStmt.setInt(2, rowPerPage);
	}		
	
	subMenuBoardRs = subMenuBoardStmt.executeQuery(); //DB쿼리 결과셋 모델
	
	//디버깅
	System.out.println(subMenuBoardStmt + "<-- subMenuBoardStmt");
	
	//subMenuBoard <-- 모델데이터
	ArrayList<SubList> subList = new ArrayList<SubList>();
	while(subMenuBoardRs.next()){
		SubList s = new SubList();
		s.setBoardNo(subMenuBoardRs.getInt("boardNo"));
		s.setLocalName(subMenuBoardRs.getString("localName"));
		s.setBoardTitle(subMenuBoardRs.getString("boardTitle"));
		s.setMemberId(subMenuBoardRs.getString("memberId"));
		s.setBoardContent(subMenuBoardRs.getString("boardContent"));
		s.setCreatedate(subMenuBoardRs.getString("createdate"));
		subList.add(s);
	}
	
	//pageCnt 쿼리문
	PreparedStatement pageCntstmt = null;
	ResultSet pageCntRs = null;
	String pageCntsql = "";
	String pageCntAddsql = "";
	pageCntsql = "SELECT local_name, count(*) from board";
	pageCntAddsql = " WHERE local_name = ?";
	//if문으로 분기
	if(localName.equals("전체")
		|| localName == null || localName.equals("")){
		pageCntstmt = conn.prepareStatement(pageCntsql);
	}else{
		pageCntsql += pageCntAddsql;
		pageCntstmt = conn.prepareStatement(pageCntsql);
		pageCntstmt.setString(1, localName);
	}
	pageCntRs = pageCntstmt.executeQuery();
	
	System.out.println(pageCntstmt + "<--pageCntstmt");
	
	if(pageCntRs.next()){
		totalRow = pageCntRs.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	
	//숫자표시 페이징 하기
	int pagePerPage = 10;
	int minPage = ((currentPage-1)/pagePerPage * pagePerPage)+1;
	int maxPage = minPage +(pagePerPage-1);
	if(maxPage>lastPage){
		maxPage = lastPage;
	}
%> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
@import url('https://fonts.googleapis.com/css2?family=Dongle&display=swap');
	a{
		text-decoration: none;
		color: #000000;
	}
	.col-sm-3 h3{
		text-align: center;
		margin-top: 10px;
	}
	p{
		margin-top: 20px;
		color: red;
	}
	.cateh3{
		margin-top: 20px;
		padding-top: 30px;
		padding-left: 30px;
	}
	.table-hover th{
	 	background-color: #9E9E9E;
	} 
	.carousel-caption{
		margin-bottom: 25%;
		font-family: 'Dongle', sans-serif;
		color: #4A148C;
	}
	.row{
		margin-top: 20px;
	}
	.list{
		display: flex;
	}
	.list img{
		width: 100%;
	}
	.list img,p{
		text-align: center;
		color: #000000;
	}
	.title{
		color: #1565C0;
		font-weight: bold;
	}
</style>
	
</head>
<body>
<div class="container">
	<!-- 메인 메뉴(가로) -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<!-- Carousel -->
<div id="demo" class="carousel slide" data-bs-ride="carousel">

  <!-- Indicators/dots -->
  <div class="carousel-indicators">
    <button type="button" data-bs-target="#demo" data-bs-slide-to="0" class="active"></button>
    <button type="button" data-bs-target="#demo" data-bs-slide-to="1"></button>
    <button type="button" data-bs-target="#demo" data-bs-slide-to="2"></button>
  </div>
  
  <!-- The slideshow/carousel -->
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="./img/mainbg.png" alt="./img/mainbg.png" class="d-block" style="width:100%; opacity: 0.7;">
      <div class="carousel-caption">
        <h3 style="font-size: 95px;">우리들의 여행 스토리</h3>
        <p style="color: #4A148C; font-size: 40px;">다양한 여행 스토리를 공유해보세요</p>
      </div>
    </div>
    <div class="carousel-item">
      <img src="./img/mainbg1.png" alt="Chicago" class="d-block" style="width:100%; opacity: 0.7;">
      <div class="carousel-caption">
        <h3  style="font-size: 95px;">우리들의 여행 스토리</h3>
        <p style="color: #4A148C; font-size: 40px;">다양한 여행 스토리를 공유해보세요</p>
      </div>
    </div>
    <div class="carousel-item">
      <img src="./img/mainbg2.png" alt="New York" class="d-block" style="width:100%; opacity: 0.7;">
      <div class="carousel-caption">
        <h3 style="font-size: 95px;">우리들의 여행 스토리</h3>
        <p style="color: #4A148C; font-size: 40px;">다양한 여행 스토리를 공유해보세요</p>
      </div>
    </div>
  </div>
  
  <!-- Left and right controls/icons -->
  <button class="carousel-control-prev" type="button" data-bs-target="#demo" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#demo" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>
	
	<!-- 서브메뉴(세로) subMenuList모델 출력 -->
	<div class="row">
		<div class="col-sm-3">
			<h3><img alt="*" src="./img/icon.png" style="width: 25px; margin-bottom: 10px; margin-right: 5px;">카테고리</h3>
			<ul class="list-group">
				<%
					for(HashMap<String, Object> m : subMenuList){
				%>
						<li class="list-group-item d-flex justify-content-between align-items-center">
							<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
								<%=(String)m.get("localName")%>
							</a>
							<span class="badge bg-primary rounded-pill"><%=(Integer)m.get("cnt")%></span>
						</li>	
				<%
					}
				%>
			</ul>
			<a href="<%=request.getContextPath()%>/board/categoryForm.jsp" class="btn btn-outline-secondary  btn-sm" style="margin-top: 10px; float: right;">카테고리 관리</a>
		</div>
		<div class="col-sm-6" style="margin-top: 10px;">
			<div class="list">
				<div>			
					<a href="" data-bs-toggle="tooltip" title="여행정보"><img alt="*" src="./img/sublist1.png"></a>
					<p class="title">여행 정보</p>
					<p>다양한 여행정보를 확인하세요.</p>
				</div>
				<div>
					<a href="" data-bs-toggle="tooltip" title="여행일정"><img alt="*" src="./img/sublist2.png"></a>
					<p class="title">여행 일정</p>
					<p>다양한 여행일정을 확인하세요.</p>
				</div>
			</div>
			
			<div class="list">
				<div>			
					<a href="" data-bs-toggle="tooltip" title="커뮤니티"><img alt="*" src="./img/sublist3.png"></a>
					<p class="title">커뮤니티</p>
					<p>여행자들과 정보를 공유해보세요.</p>
				</div>
				<div>
					<a href="" data-bs-toggle="tooltip" title="인기도시TOP10"><img alt="*" src="./img/sublist4.png" style="width: 260px; height: 140px; margin-top: 10px;"></a>
					<p class="title">인기도시 TOP10</p>
					<p>이 달의 인기도시를 확인하세요.</p>
				</div>
			</div>
		</div>
		<div class="col-sm-3" style="margin-top: 10px;">
			<!-- home 내용 : 로그인폼/ 카테고리별 게시글 5개씩  -->
			<!-- 로그인 폼 -->
			<%
				if(session.getAttribute("loginMemberId")==null){
					//로그인전이면 로그인폼출력
			%>
				<div>
					<img alt="*" src="<%=request.getContextPath()%>/img/bg1.png" style="width: 100%; margin-bottom: 20px;">
				</div>
				<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
					<table class="input-group" style="margin-left: 10px;">
						<tr>
							<td>아이디</td>
							<td>
								<input type="text" name="memberId" class="form-control">
							</td>
						</tr>
						<tr>
							<td>비밀번호</td>
							<td>
								<input type="password" name="memberPw" class="form-control" style="margin-top: 10px;">	
							</td>
						</tr>
					</table>
					<button type="submit" class="btn btn-dark btn-sm" style="margin-top: 10px; margin-right:10px; float: right; ">로그인</button>
				</form>
			<%		
				}else{
			%>
				<div>
					<img alt="*" src="<%=request.getContextPath()%>/img/bg.png" style="width: 100%; margin-bottom: 10px;">
				</div>
				<table class="table table-dark" style="text-align: center;">
					<tr>
						<td>
							<%=(String)session.getAttribute("loginMemberId")%>님이 접속중입니다.
						</td>
					</tr>
				</table>
			<%
				}
			%>
		</div>
	</div>
	</div>
	
	<!-- 카테고리 별 내용 출력 -->
<div class="container">
	<div>
		<%
			if(request.getParameter("msg") !=null){
		%>
				<p class="text-center"><%=request.getParameter("msg") %></p>
		<%		
			}
		%>
		<a class="btn btn-outline-dark" style="float: right; margin-top: 30px; margin-bottom: 20px;" href="<%=request.getContextPath()%>/board/addBoard.jsp">게시글 쓰기</a>
		<h3 class="cateh3"><img alt="*" src="./img/modify.png" style="width: 40px; margin-bottom: 10px; margin-right: 5px;">게시글</h3>
		<table class="table table-hover" style="margin-top: 20px; text-align: center;">
			<tr>
				<th>지역 이름</th>
				<th>타이틀</th>
				<th>게시글 내용</th>
				<th>회원_Id</th>
				<th>생성일</th>
			</tr>
			<%
				for(SubList s : subList){
			%>
					<tr>
						<td><%=s.getLocalName() %></td>
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=s.getBoardNo()%>">
								<%=s.getBoardTitle() %>
							</a>
						</td>
						<td><%=s.getBoardContent() %></td>
						<td><%=s.getMemberId() %></td>
						<td><%=s.getCreatedate() %></td>
					</tr>
			<%		
				}
			%>
		</table>	
	</div>
	<!-- 페이징 설정 -->
	<div>
		<!-- 페이징 -->
	<ul class="pagination justify-content-center">
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=1&localName=<%=localName%>">맨처음</a></li>
	<%	
     if(minPage > 1){  
	%>
			<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=minPage-pagePerPage%>&localName=<%=localName%>">이전</a></li>
	<%		
		}
	%>
	<%	
		for(int i=minPage; i<=maxPage; i=i+1){
			if(i == currentPage){
	%>
				<li class="page-item" style="padding: 6px; margin-right: 8px; margin-left: 8px; font-weight: bold; color: red; "><%=i %></li>
	<%				
			}else{
	%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&localName=<%=localName%>"><%=i%></a></li>
	<%			
			}		
		}
	%>
	<%
		if(maxPage != lastPage){
	%>
			<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=minPage+pagePerPage%>&localName=<%=localName%>">다음</a></li>
	<%	
		}
	%>
	<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=lastPage %>&localName=<%=localName%>">맨끝</a></li>
	</ul>
	</div>
</div>			
<div class="container" style="margin-top: 80px; margin-bottom: 20px;">
	<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<jsp:include page="/inc/copyright.jsp"></jsp:include>	
</div>	
</body>
</html>