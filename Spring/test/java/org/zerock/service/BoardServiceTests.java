package org.zerock.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)// 스프링 컨테이너 생성
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml") // 생성된  스프링 컨테이너에 스프링 빈을 추가 하기 위한 설정 파일 읽는 용도
@Log4j // 로그 객체를 생성 해준다
public class BoardServiceTests {
	
	@Autowired  // 자신에게 해당 타입의 빈을 주입
	private BoardService service;

	@Test //서비스 출력
	public void testPrint() {

		log.info(service);
	}

	@Test //데이터 값 다 가져오기
	public void testGetList() {

		service.getList().forEach(board -> log.info(board));
	}

	@Test // 등록 처리 
	public void testRegister() {
		BoardVO vo = new BoardVO();
		vo.setTitle("Test 테스트");
		vo.setContent("Content 테스트");
		vo.setWriter("tester");

	}
}
