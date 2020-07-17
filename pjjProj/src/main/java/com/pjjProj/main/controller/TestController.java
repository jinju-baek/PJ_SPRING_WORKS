package com.pjjProj.main.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.pjjProj.main.service.TestService;

import net.sf.json.JSONObject;

@Controller
public class TestController {

	@Resource(name="tService")
	private TestService tService;
	
	private static final Logger log = LoggerFactory.getLogger("com.pjjProj");
	
	@RequestMapping(value = "/test.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String test() {
		log.info(">>>>>>>>>>>>>>>>>>>> TEST PAGE");
		return "test";
	}
	
	@RequestMapping(value = "/select.do", method = RequestMethod.POST)
	public ModelAndView select(HttpServletResponse response, @RequestParam Map<String, Object> paramData) throws IOException {
		log.info(">>>>>>>>>>>>>>>>>>>> SELECT ");
		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		
		try {
			Map<String, Object> resultData = tService.getHMH(paramData);
			joReturn.put("returnData", resultData);
			out = response.getWriter();
			out.write(joReturn.toString());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			out.flush();
			out.close();
		}
		/* view 단으로 값 보내기 */
		return null;
	}
	
}
