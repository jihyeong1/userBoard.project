<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>  
<%@ page import = "java.util.*" %>  
<%
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	/* SELECT local_name localName, '대한민국' conuntry,  '정지형' worker
	FROM local 
	LIMIT 0,1; */
	
	String sql = "SELECT local_name localName, '대한민국' conuntry,  '정지형' worker FROM local LIMIT 0,1;";
	stmt= conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	// vo대신 hashMap타입을 사용
	
	HashMap<String, Object> map = null;
	//object를 사용하면 모든 참조타입이 다 들어올 수 있다.
	if(rs.next()){
		/* System.out.println(rs.getString("localName"));
		System.out.println(rs.getString("conuntry"));
		System.out.println(rs.getString("worker")); */
		map = new HashMap<String,Object>();
		map.put("localName", rs.getString("localName")); // map.put(키이름, 값)
		map.put("conuntry", rs.getString("conuntry"));
		map.put("worker", rs.getString("worker"));
	}
	System.out.println((String)map.get("localName"));
	System.out.println((String)map.get("conuntry"));
	System.out.println((String)map.get("worker"));
	
	//여러개를 출력할 때에는 ArrayList안에 Hashmap을 넣어서 만들어라
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT local_name localName, '대한민국' conuntry,  '정지형' worker FROM local";
	stmt2= conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()){
		HashMap<String, Object> m = new HashMap<String,Object>();
		m.put("localName", rs2.getString("localName")); // map.put(키이름, 값)
		m.put("conuntry", rs2.getString("conuntry"));
		m.put("worker", rs2.getString("worker"));
		list2.add(m);
	}
	
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	String sql3 = "SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
	stmt3= conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	while(rs3.next()){
		HashMap<String, Object> m = new HashMap<String,Object>();
		m.put("localName", rs3.getString("localName")); // map.put(키이름, 값)
		m.put("cnt", rs3.getInt("cnt"));
		list3.add(m);
	}
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
			<tr>
				<th>localName</th>
				<th>conuntry</th>
				<th>worker</th>
			</tr>

			<tr>
				<td><%=map.get("localName")%></td>
				<td><%=map.get("conuntry")%></td>
				<td><%=map.get("worker")%></td>
			</tr>
		</table>
		
		<hr>
	
	<table>
		<tr>
			<th>localName</th>
			<th>conuntry</th>
			<th>worker</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list2){
		%>
				<tr>
					<td><%=m.get("localName")%></td>
					<td><%=m.get("conuntry")%></td>
					<td><%=m.get("worker")%></td>
				</tr>
		<%		
			}
		%>
	</table>
	
	<hr>
	
	<ul>
		<li>
			<a href="">전체</a>
		</li>
		<%
			for(HashMap<String, Object> m : list3){
		%>
				<li>
					<a href=""><%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)</a>
				</li>	
		<%
			}
		%>
	</ul>
</body>
</html>