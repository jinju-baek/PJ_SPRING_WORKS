package com.pjjProj.main.controller;

import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Date;
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

import com.pjjProj.main.service.WorksLoginServiceImpl;
import com.pjjProj.main.service.WorksWorkServiceImpl;

import net.sf.json.JSONObject;

@Controller
@RequestMapping(value = "/home", method = { RequestMethod.GET, RequestMethod.POST })
public class WorksHomeController {
	private static final Logger LOG = LoggerFactory.getLogger(WorksHomeController.class);

	@Resource(name = "loginService")
	WorksLoginServiceImpl wlService;

	@Resource(name = "workService")
	WorksWorkServiceImpl wwService;

	@RequestMapping(value = "/home.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView worksHome(HttpServletRequest request, Map<String, Object> paramData) {
		LOG.info(">>>>>WORKS MAINPAGE<<<<<");

		ModelAndView mv = new ModelAndView();
		HttpSession session = request.getSession();
		JSONObject joReturn = new JSONObject();

		String id = session.getAttribute("ID").toString();
		paramData.put("ID", id);
		
		// 화면 로딩시 오늘 이전의 날짜들 WORKTYPE 갱신
		wwService.setWorkType(id);
		
		// 화면에 전달할 데이터
		paramData = wlService.getUserInfo(paramData);
		session.setAttribute("EMPNO", paramData.get("EMPNO").toString());
		session.setAttribute("EMPNAME", paramData.get("EMPNAME").toString());
		session.setAttribute("JOBTITLE", paramData.get("JOBTITLE").toString());
		String roleId = paramData.get("ROLEID").toString();
		session.setAttribute("ROLEID", roleId);
		
		// 출근 or 퇴근을 한경우
		String startTime = wwService.getStartTime(paramData);
		paramData.put("STARTTIME", startTime);
		String endTime = wwService.getEndTime(paramData);
		int loginFlag;
		if (startTime != null) {
			loginFlag = 1;
			if (endTime != null) {
				loginFlag = 0;
				paramData.put("ENDTIME", endTime);
			}
		} else {
			loginFlag = 2;
		}
		paramData.put("loginFlag", loginFlag);
		joReturn.put("userInfo", paramData);
		if(roleId.equals("USER")) {
			mv.setViewName("worksHome");
		} else if (roleId.equals("ADMIN")) {
			mv.setViewName("worksAdminHome");
		}
		mv.addObject("returnData", joReturn);

		return mv;
	}

	@RequestMapping(value = "/workOn.do", method = RequestMethod.GET)
	public ModelAndView workOn(HttpServletResponse response, @RequestParam Map<String, Object> paramData) throws IOException{
		LOG.info(">>>>>WORKON ACTION<<<<<");

		Writer out = null;
		Date time = new Date();

		// DB에 저장할 date 형식
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		// 출근버튼 누른 시간과 정해진 출근 시간을 비교할 date 형식
		SimpleDateFormat format2 = new SimpleDateFormat("HH:mm:ss");

		try {
			// 출근하기 버튼 누른 시간
			String curTmpTime = format2.format(time);
			Date curTime = format2.parse(curTmpTime);
			// 정해진 출근 시간
			String commonTmpTime = "09:00:00";
			Date commonTime = format2.parse(commonTmpTime);
			// DB에 저장할 STARTTIME값
			String curTmpDate = format1.format(time);
			Date curDate = format1.parse(curTmpDate);
			paramData.put("STARTTIME", curDate);

			int result = curTime.compareTo(commonTime);
			if (result > 0) { // 출근버튼 누른 시간이 더 클 경우 근무코드 입력
				// 지각 = CHKLATER
				paramData.put("WORKTYPE", "CHKLATER");

			} else { // 출근 버튼 누른 시간이 더 작을 경우 근무코드 입력
				// 출근 = CHKIN
				paramData.put("WORKTYPE", "CHKIN");
			}

			// 근무 데이터 insert
			int exeCnt = wwService.setWorkStart(paramData);
			if (exeCnt > 0) { // 근무 데이터 insert 성공시
				String startTime = wwService.getStartTime(paramData);
				out = response.getWriter();
				out.write(startTime);
			}

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

	@RequestMapping(value = "/workOff.do", method = RequestMethod.GET)
	public ModelAndView WorkOff(HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		LOG.info(">>>>>WORKOFF ACTION<<<<<");

		Writer out = null;
		Date time = new Date();

		// DB에 저장할 date 형식
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

		try {
			// DB에 저장할 ENDTIME값
			String curTmpDate = format1.format(time);
			Date curDate = format1.parse(curTmpDate);
			paramData.put("ENDTIME", curDate);
			paramData.put("WORKTYPE", "CHKOUT");

			int exeCnt = wwService.setWorkEnd(paramData);

			if (exeCnt > 0) { // 근무 데이터 update 성공시
				String endTime = wwService.getEndTime(paramData);
				out = response.getWriter();
				out.write(endTime);
			}

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

	@RequestMapping(value = "/srchCalendar.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView getWorkList(HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		try {
			Map<String, Object> returnData = wwService.getWorkInfo(paramData);
			joReturn.put("returnData", returnData);
			out = response.getWriter();
			out.write(joReturn.toString());
		} catch (Exception ex) {
			LOG.error("getDetailDeviceCnt Error :: {}", ex.getMessage());
		} finally {
			if (out != null) {
				out.flush();
				out.close();
			}
		}
		return null;
	}

}
