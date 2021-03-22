package bbs;

import java.sql.*;
import java.util.*;

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
		String SQL = "SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') FROM DUAL"; //현재 날짜를 가져오는 쿼리문이다
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
	
	public ArrayList<Bbs> getList(int pageNumber) { // 특정한 리스트를 담아서 반환할 수 있게 만들어준다. 외부 라이브러리를 가져올 수 있게 임폴트 해준다 특정한 페이지에 따른 총 10개의 게시글을 만들 수 있게 해준다
		String SQL = "SELECT * FROM (SELECT * FROM BBS WHERE bbsID < ? AND BBSAVAILABLE = 1 ORDER BY bbsID DESC) WHERE ROWNUM <= 10"; //게시글 번호는 1번부터 늘어나야하기 때문에 마지막에 쓰인 글을 가져와서 그 번호에 1을 더한 값이 그 다음 글이 된다 내림차순을해서 마지막으르 가져올 것
		ArrayList<Bbs> list = new ArrayList<Bbs>(); //BBS를 담을 수 있는 리스트를 만들어 준다 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // 현재 연결되어 있는 객체를 이용해서 SQL문장을 실행준비 상태로 만들어준다
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // ?에 담길 내용, getNext는 그 다음에 작성될 글번호를 의미한다. 현재 게시글이 5개면 6이 나오기때문에 6보다 작은 값이 나오기 때문에 1~5까지 모두 나온다 특정한 페이지에서 10개만큼 게시글을 뽑아서 출력하기 위해서
			rs = pstmt.executeQuery(); // 실제 실행했을 때 나오는 결과를 가져온다
			while(rs.next()) { // 결과가 나올 때마다
				Bbs bbs = new Bbs(); // 이 객체가 나오게 한다
				bbs.setBbsID(rs.getInt(1)); //bbs에 담긴 모든 속성을 다 띄우기 때문에 각각 다 넣어주면 간단하게 작동한다
				bbs.setBbsTitle(rs.getString(2)); 
				bbs.setUserID(rs.getString(3)); 
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs); //리스트에 해당 인스턴스를 담아서 반환할 수 있도록 해주면 된다
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	//페이징처리를 위한 함수
	public boolean nextPage(int pageNumber) { // 게시글이 10개 20개 10단위로 끝난다면 다음 페이지라는 버튼이 없어야 한다. 왜냐하면 다음페이지에는 다음글이 없기 때문이다
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND	bbsAvailable = 1"; //게시글 번호는 1번부터 늘어나야하기 때문에 마지막에 쓰인 글을 가져와서 그 번호에 1을 더한 값이 그 다음 글이 된다 내림차순을해서 마지막ㅇ르 가져올 것	
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // 현재 연결되어 있는 객체를 이용해서 SQL문장을 실행준비 상태로 만들어준다
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10); // ?에 담길 내용, getNext는 그 다음에 작성될 글번호를 의미한다. 현재 게시글이 5개면 6이 나오기때문에 6보다 작은 값이 나오기 때문에 1~5까지 모두 나온다 특정한 페이지에서 10개만큼 게시글을 뽑아서 출력하기 위해서
			rs = pstmt.executeQuery(); // 실제 실행했을 때 나오는 결과를 가져온다
			if(rs.next()) { // 결과가 하나라도 존재 한다면
				return true; // 다음페이지로 넘어갈 수 있다
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
