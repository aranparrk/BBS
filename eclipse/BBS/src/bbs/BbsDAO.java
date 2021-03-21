package bbs;

import java.sql.*;

public class BbsDAO {
	private Connection conn; // 데이터베이스에 접근해줄 수 있는 하나의 객체
	//private PreparedStatement pstmt; 여러개의 함수가 사용되기 때문에 각각 함수끼리 데이터베이스의 접근에 있어서 마찰이 있지 않기 위해 지워진다
	private ResultSet rs; // 어떠한 정보를 담을 수 있는 하나의 객체
	
	public BbsDAO() { // 생성자를 만들어 준다, 하나의 객체가 생성되고 자동으로 데이터베이스 커넥션이 이루어질 수 있도록 해준다
		try { // 예외처리 해줄 수 있게 한다
			String dbURL = "jdbc:oracle:thin:@localhost:1521:xe";
			String dbID = "aranparrk"; 
			String dbPassword = "1245";
			Class.forName("oracle.jdbc.driver.OracleDriver"); //mysql 드라이버를 찾을 수 있도록 한다, mysql에 접속할 수 있도록 매개체역할을 해주는 하나의 라이브러리다
			conn=DriverManager.getConnection(dbURL, dbID, dbPassword); //dbURL에 아이디와 비밀번호를 이용해 접속이 가능하다. 접속이 완료가 되면 conn 객체안에 접속한 정보가 담기게 된다
		} catch (Exception e) {
			e.printStackTrace(); // 오류가 발생했을 때 오류가 무엇인지 출력해줄 수 있게 해준다
		}
	}
	
	public String getDate() { // 현재의 시간을 가져오는 함수, 게시판의 글을 작성할 때 현재 서버의 시간을 넣어준다
		String SQL = "select to_char(sysdate, 'yyyy/mm/dd') from dual"; //현재 날짜를 가져오는 쿼리문이다
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // 현재 연결되어 있는 객체를 이용해서 SQL문장을 실행준비 상태로 만들어준다
			rs = pstmt.executeQuery(); // 실제 실행했을 때 나오는 결과를 가져온다
			if(rs.next()) { //결과가 있는 경우엔 다음과 같이
				return rs.getString(1); // 현재의 날짜를 그대로 반환될 수 있게 한다
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	public int getNext() { // 현재의 시간을 가져오는 함수, 게시판의 글을 작성할 때 현재 서버의 시간을 넣어준다
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //게시글 번호는 1번부터 늘어나야하기 때문에 마지막에 쓰인 글을 가져와서 그 번호에 1을 더한 값이 그 다음 글이 된다 내림차순을해서 마지막ㅇ르 가져올 것
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // 현재 연결되어 있는 객체를 이용해서 SQL문장을 실행준비 상태로 만들어준다
			rs = pstmt.executeQuery(); // 실제 실행했을 때 나오는 결과를 가져온다
			if(rs.next()) { //결과가 있는 경우엔 다음과 같이
				return rs.getInt(1) + 1; // 나온 결과에 1을 더해서 그 다음 게시글의 번호가 들어갈 수 있게 만들어 준다
			}
			return 1; // 첫 번째 게시물인 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)"; 
		try {	
			PreparedStatement pstmt = conn.prepareStatement(SQL); // 현재 연결되어 있는 객체를 이용해서 SQL문장을 실행준비 상태로 만들어준다
			pstmt.setInt(1, getNext()); // 하나씩 값을 넣어주도록 한다, 즉 다음번에 쓰여야할 게시글 번호가 되야 한다
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1); //글이 보여지는 형태, 삭제가 안 된 형태
			return pstmt.executeUpdate(); // 성공했을 때면 0이상의 결과를 반환, 그렇지 않은 경우엔 오류가 발생했을 땐 -1 66행이 리턴된다
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
}
