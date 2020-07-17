package com.pjjProj.main.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.pjjProj.main.service.WorksLoginService;

import net.sf.json.JSONObject;

@Controller
public class WorksLoginController {

	@Resource(name = "loginService")
	WorksLoginService wlService;

	private static final Logger LOG = LoggerFactory.getLogger(WorksLoginController.class);

	@RequestMapping(value = "/login.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String loginhome() {
		LOG.info(">>>>>LOGIN PAGE<<<<<");
		return "worksLogin";
	}

	@RequestMapping(value = "/loginOn.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView loginOn(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramData, Map<String, Object> returnData) throws IOException {
		LOG.info(">>>>>LOGIN ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		HttpSession session = request.getSession();
		
		try {
			// 회원이 있는 경우 id를 session에 저장
			int userCnt = wlService.loginAccess(paramData);
			if (userCnt > 0) {
				session.setAttribute("ID", paramData.get("ID"));
			}
			joReturn.put("userCnt", userCnt);
			out = response.getWriter();
			out.write(joReturn.toString());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				out.flush();
				out.close();
			}
		}
		return null;
	}

	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request) {
		LOG.info(">>>>>LOGOUT ACTION<<<<<");
		ModelAndView view = new ModelAndView();

		HttpSession session = request.getSession();
		session.invalidate();

		view.setViewName("redirect:/login.do");
		return view;
	}

}
