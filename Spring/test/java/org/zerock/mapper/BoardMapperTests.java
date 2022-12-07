package org.zerock.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {

	@Autowired
	private BoardMapper boardMapper;

	@Test //테이블 조회
	public void testGetList() {

		log.info("-----------------------------");
		boardMapper.getList();

	}

	@Test //<selectkey>를 이용하는 경우와 그렇지 않은 경우의 비교 
	public void testInsert() {
		BoardVO vo = new BoardVO();
		vo.setTitle("Test 테스트");
		vo.setContent("Content 테스트");
		vo.setWriter("tester");

		boardMapper.insert(vo);
		log.info("--------------------------------------------------");
		log.info("after insert " + vo.getBno());
	}

	@Test //<selectkey>를 이용하는 경우와 그렇지 않은 경우의 비교 
	public void testInsertSelectKey() {
		BoardVO vo = new BoardVO();
		vo.setTitle("AAATest 테스트");
		vo.setContent("AAAContent 테스트");
		vo.setWriter("AAAtester");

		boardMapper.insertSelectKey(vo);
		log.info("-------------------------------------------------");
		log.info("after insert " + vo.getBno());
	}

	@Test  //데이터 읽기
	public void testRead() {

		BoardVO vo = boardMapper.read(2L); //2번 데이터 읽기
		log.info(vo);
	}

	@Test // 데이터 삭제
	public void testDelete() {

		int count = boardMapper.delete(1L); //1번 데이터 삭제
		log.info("count : " + count);
	}

	@Test // 데이터 업데이트
	public void testUpdate() {

		BoardVO vo = new BoardVO();
		vo.setBno(2L); //2번 데이터
		vo.setTitle("Updated Title"); // 바꿀 제목
		vo.setContent("Updated Title"); // 바꿀 컨텐츠
		vo.setWriter("user00"); // 바꿀 작성자

		log.info("count : " + boardMapper.update(vo));
	}

	@Test //페이지 처리
	public void testPaging() {

		Criteria cri = new Criteria();

		List<BoardVO> list = boardMapper.getListWithPaging(cri);

		list.forEach(b -> log.info(b));
	}

	@Test
	public void testPageDTO() { // 페이지 넘버 테스트
		Criteria cri = new Criteria();
		cri.setPageNum(25); //페이지가 25번
		PageDTO dto = new PageDTO(cri, 251); // 데이터 251개 
		log.info(dto);
	}

	@Test
	public void testSearch() {
		Map<String, String> map = new HashMap<>();
		// map.put("T", "TTT");
		// map.put("C", "CCC");
		// map.put("W", "WWW");

		Map<String, Map<String, String>> outer = new HashMap<>();
		outer.put("map", map);

		List<BoardVO> list = boardMapper.searchTest(outer);

		log.info(list);
	}

	@Test
	public void testSearchPaging() {

		Criteria cri = new Criteria();
		cri.setType("TCW");
		cri.setKeyword("Test");
		List<BoardVO> list = boardMapper.getListWithPaging(cri);

		list.forEach(b -> log.info(b));
	}

}
