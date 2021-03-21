package user;

import java.sql.*; // 외부라이브러리를 추가해줄 수 있다

public class UserDAO {
	private Connection conn; // 데이터베이스에 접근해줄 수 있는 하나의 객체
	private PreparedStatement pstmt;
	private ResultSet rs; // 어떠한 정보를 담을 수 있는 하나의 객체
	
	public UserDAO() { // 생성자를 만들어 준다, 하나의 객체가 생성되고 자동으로 데이터베이스 커넥션이 이루어질 수 있도록 해준다
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
	
	public int login(String userID, String userPassword) { // 실제로 로그인을 시도하는 함수를 만들어준다
		String SQL = "SELECT userPassword FROM user1 WHERE userID = ?";// 실제로 데이터베이스에 입력할 명령어를 sql문장으로 만들어준다, USER테이블에서 해당 비밀번호를 가져오게 해준다
		try {
			pstmt = conn.prepareStatement(SQL); // 어떠한 정해진 sql문장을 데이터베이스에 삽입하는 형식으로 인스턴스를 가져온다
			pstmt.setString(1, userID); //setString으로 1하고 유저아이디를 넣어준다. 기본적으로 sql인잭션같은 해킹기법을 방어하기 위한 수단으로서 pstmt을 이용한다.
			// 하나의 문장을 준비해놓고 물음표를 넣어놨다가 나중에 그 물음표에 해당하는 내용으로 userID를 넣어준 것이다. 매개변수로 넘어온 userID를 물음표에 들어갈 수 있게 해줘서 실제로 데이터베이스에는 현재 접속을 시도하고자 하는 그 사용자의 아이디를 입력받아서 그 아이디가 실제로 존재하는지 실제로 존재한다면 그 비밀번호는 뭔지 데이터베이스에서 가져오도록 하는 것
			rs = pstmt.executeQuery(); // 결과를 담을 수 있는 객체에다가 실행한 결과를 넣어준다
			if(rs.next()) {
				// 결과가 존재한다면 이쪽이 실행
				if(rs.getString(1).equals(userPassword)) //결과로 넣은 userpassword를 받아서 접속을 시도한 usepassword와 같다면 다음과 같이 return 1을 해준다
					return 1; //로그인 성공
				else
					return 0; //비밀번호 불일치
			}
			return -1; //결과가 존재하지 않는다면 이쪽이 실행, 아이디가 없다고 알려준다
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류를 의미한다
	} // 이런 함수를 실제로 사용해서 사용자에게 로그인 결과를 알려주는 페이지 loginAction.jsp이다
}
