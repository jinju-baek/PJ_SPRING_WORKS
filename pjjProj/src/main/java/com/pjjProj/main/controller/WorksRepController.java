package com.pjjProj.main.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
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

import com.pjjProj.main.service.WorksRepService;
import com.pjjProj.main.service.WorksWorkService;

import net.sf.json.JSONObject;

@RequestMapping(value = "/rep", method = { RequestMethod.GET, RequestMethod.POST })
@Controller
public class WorksRepController {

	private static final Logger LOG = LoggerFactory.getLogger(WorksReqController.class);

	@Resource(name = "workService")
	WorksWorkService wwService;

	@Resource(name = "reportSerivce")
	WorksRepService wrService;

	@RequestMapping(value = "/rep.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView worksRepView(HttpServletRequest request, HttpServletResponse response,
			Map<String, Object> returnData) {
		LOG.info(">>>>>WORKS REPPAGE<<<<<");

		ModelAndView mv = new ModelAndView();
		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		HttpSession session = request.getSession();

		// 화면에 전달할 데이터
		returnData.put("ID", session.getAttribute("ID"));
		returnData.put("EMPNO", session.getAttribute("EMPNO"));
		returnData.put("EMPNAME", session.getAttribute("EMPNAME"));
		returnData.put("JOBTITLE", session.getAttribute("JOBTITLE"));
		returnData.put("ROLEID", session.getAttribute("ROLEID"));
		
		// 출근 or 퇴근 버튼을 눌렀을 경우 처리
		String startTime = wwService.getStartTime(returnData);
		returnData.put("STARTTIME", startTime);
		String endTime = wwService.getEndTime(returnData);
		int loginFlag;
		if (startTime != null) {
			loginFlag = 1;
			if (endTime != null) {
				loginFlag = 0;
				returnData.put("ENDTIME", endTime);
			}
		} else {
			loginFlag = 2;
		}
		returnData.put("loginFlag", loginFlag);
		joReturn.put("userInfo", returnData);
		mv.addObject("returnData", joReturn);
		mv.setViewName("worksRep");
		return mv;
	}

	@RequestMapping(value = "/repSel.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView repSel(HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		LOG.info(">>>>>WORKS REPORT CNT SELECT ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;

		try {
			paramData.put("normCnt", wrService.getNormCtn(paramData));
			paramData.put("lateCnt", wrService.getLateCtn(paramData));
			paramData.put("awolCnt", wrService.getAwolCnt(paramData));
			joReturn.put("returnData", paramData);
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

	@RequestMapping(value = "/repList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView repList(HttpServletResponse response, @RequestParam Map<String, Object> paramData) throws IOException {
		LOG.info(">>>>>WORKS REPORT LIST SELECT ACTION<<<<<");
		
		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		
		try {
			List<Map<String, Object>> returnData = new ArrayList<Map<String, Object>>();
			returnData = wrService.getTimeList(paramData);
			joReturn.put("returnData", returnData);
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

}
