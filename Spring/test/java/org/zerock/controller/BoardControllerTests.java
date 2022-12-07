package org.zerock.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })//파일 2개 읽어오기
@Log4j

public class BoardControllerTests {

	@Setter(onMethod_ = {@Autowired})
	private WebApplicationContext ctx;
	
	private MockMvc mockMvc; 
	//가짜 객체를 만들어서 애플리케이션 서버에 배포하지 않고도 스프링 MVC 동작을 재현할 수 있는 클래스
	
	  @Before //테스트 메소드를 실행하기 전에 먼저 자동으로 실행시켜주는 기능
	  public void setup() {
	    this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	  }
	  
	  @Test //데이터 목록을 불러오기 여부 테스트 코드
	  public void testList() throws Exception {
	    log.info(
	        mockMvc.perform(
	         MockMvcRequestBuilders.get("/board/list"))
	        .andReturn()
	        .getModelAndView()
	        .getModelMap());
	  }
	  
	  @Test //새롭게 등록되는 게시물의 번호를 전달하기 위해 사용
	  public void testRegister() throws Exception {
	    log.info(
	        mockMvc.perform(
	         MockMvcRequestBuilders.post("/board/register")
	         .param("title", "Test 테스트")
	         .param("content", "Test 테스트")
	         .param("writer", "Test 테스트"))
	        .andReturn());
	  }
	  
	  
	
}
