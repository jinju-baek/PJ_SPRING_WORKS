package com.pjjProj.main.controller;

import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.bouncycastle.asn1.ocsp.Request;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.pjjProj.main.service.WorksReqService;
import com.pjjProj.main.service.WorksWorkService;

import net.sf.json.JSONObject;

@Controller
@RequestMapping(value = "/req", method = { RequestMethod.GET, RequestMethod.POST })
public class WorksReqController {
	private static final Logger LOG = LoggerFactory.getLogger(WorksReqController.class);

	@Resource(name = "workService")
	WorksWorkService wwService;

	@Resource(name = "requestService")
	WorksReqService wrService;

	@RequestMapping(value = "/req.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView worksReqView(HttpServletRequest request, HttpServletResponse response,
			Map<String, Object> returnData) {
		LOG.info(">>>>>WORKS REQPAGE<<<<<");

		ModelAndView mv = new ModelAndView();
		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		HttpSession session = request.getSession();

		// 화면에 전달할 데이터
		returnData.put("ID", session.getAttribute("ID"));
		returnData.put("EMPNO", session.getAttribute("EMPNO"));
		returnData.put("EMPNAME", session.getAttribute("EMPNAME"));
		returnData.put("JOBTITLE", session.getAttribute("JOBTITLE"));
		String roleId = (String) session.getAttribute("ROLEID");
		returnData.put("ROLEID", roleId);
		
		if(roleId.equals("USER")) {
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
		}
		joReturn.put("userInfo", returnData);
		mv.setViewName("worksReq");
		mv.addObject("returnData", joReturn);
		return mv;
	}

	@RequestMapping(value = "/reqIns.do", method = { RequestMethod.POST })
	public ModelAndView worksReqIns(HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		LOG.info(">>>>>WORKS REQ INSERT ACTION<<<<<");

		Writer out = null;
		Date time = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		SimpleDateFormat formatReqDate = new SimpleDateFormat("yyyy-MM-dd");

		try {
			String reqTypeTmp = (String) paramData.get("reqType");
			String reqDate = (String) paramData.get("reqDate");
			String reqSt = (String) paramData.get("reqSt");
			String reqEt = (String) paramData.get("reqEt");
			String startTimeTmp = "";
			String endTimeTmp = "";
			Date startTime = null; 
			Date endTime = null;

			out = response.getWriter();
			String reqFlag = "0";
			// 하나라도 입력된 값이 없을 경우
			if (reqDate == "" || reqSt == "" || reqEt == "") {
				reqFlag = "1";
				out.write(reqFlag);
				return null;
			}

			startTimeTmp = reqDate + " " + reqSt + ":00.000";
			endTimeTmp = reqDate + " " + reqEt + ":00.000";
			startTime = format.parse(startTimeTmp);
			endTime = format.parse(endTimeTmp);
			String nowTmpTime = format.format(time);
			Date nowTime = format.parse(nowTmpTime);

			paramData.put("REQST", startTime);
			paramData.put("REQET", endTime);
			paramData.put("PROCSTEP", "PROC");
			paramData.put("REQTIME", nowTime);

			String reqType = "MOD";
			if (reqTypeTmp.equals("work_insert")) {
				reqType = "ADD";
				paramData.put("STARTTIME", startTime);
				// 이미 근무일정이 존재하는 경우
				int stCnt = wwService.getStCnt(paramData);
				if (stCnt > 0) {
					reqFlag = "2";
					out.write(reqFlag);
					return null;
				}
				// 신청한 근무일정이 오늘 이후일 경우
				String todayTmp = format.format(time);
				Date today = formatReqDate.parse(todayTmp);
				int compare = startTime.compareTo(today);
				if (compare > 0) {
					reqFlag = "4";
					out.write(reqFlag);
					return null;
				}
			}

			paramData.put("REQTYPE", reqType);
			int result = wrService.insertReq(paramData);

			// insert에 실패했을 경우
			if (result < 1) {
				reqFlag = "3";
				out.write(reqFlag);
				return null;
			}
			out.write(reqFlag);
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

	@RequestMapping(value = "/workList.do", method = RequestMethod.POST)
	public ModelAndView workReqList(HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		LOG.info(">>>>>WORKS GET WORK LIST ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;

		List<String> stList = wwService.getStList(paramData);
		List<String> dtList = new ArrayList<String>();
		String tmp = "";
		try {
			for (int i = 0; i < stList.size(); i++) {
				tmp = stList.get(i);
				dtList.add(i, tmp.substring(0, 10));
			}
			joReturn.put("returnData", dtList);
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

	@RequestMapping(value = "/reqHis.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView getReqHis(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramData,
			Map<String, Object> returnData) throws IOException {
		LOG.info(">>>>>WORKS GET REQ LIST ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		HttpSession session = request.getSession();

		List<Map<String, Object>> reqHisTmp = wrService.getReqHis(paramData);
		List<Object> procStep = new ArrayList<Object>();
		List<Object> orgTime = new ArrayList<Object>();
		List<Object> reqCode = new ArrayList<Object>();
		List<Object> orgDate = new ArrayList<Object>();
		List<Object> reqEt = new ArrayList<Object>();
		List<Object> reqSt = new ArrayList<Object>();
		List<Object> reqTime = new ArrayList<Object>();
		List<Object> empNo = new ArrayList<Object>();
		List<Object> empName = new ArrayList<Object>();
		List<Object> wCode = new ArrayList<Object>();

		String reqCodeTmp = "";
		String reqStTmp = "";
		String reqEtTmp = "";
		String reqTimeTmp = "";

		try {
			String roleId = (String) session.getAttribute("ROLEID");
			returnData.put("roleId", roleId);
			
			for (int i = 0; i < reqHisTmp.size(); i++) {
				// 요청코드
				reqCodeTmp = (String) reqHisTmp.get(i).get("REQCODE");
				reqCodeTmp = reqCodeTmp.substring(1);
				reqCode.add(reqCodeTmp);

				// 처리현황
				if (reqHisTmp.get(i).get("PROCSTEP").equals("PROC")) {
					procStep.add("처리중");
				} else if (reqHisTmp.get(i).get("PROCSTEP").equals("APPROV")) {
					procStep.add("승인");
				} else if (reqHisTmp.get(i).get("PROCSTEP").equals("REF")) {
					procStep.add("거절");
				} else if (reqHisTmp.get(i).get("PROCSTEP").equals("CANC")) {
					procStep.add("취소");
				}

				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

				// 희망근무일자
				reqStTmp = format.format(reqHisTmp.get(i).get("REQST"));
				orgDate.add(reqStTmp.substring(0, 10));

				paramData.put("STARTDATE", reqStTmp);
				// REQTYPE 값이 MOD일 경우 PJJ_WORK테이블에서 기존 근무일정 조회
				if (reqHisTmp.get(i).get("REQTYPE").equals("MOD")) {
					orgTime.add(reqCodeTmp);
					orgTime.add(wwService.getWorkTime(paramData) + "");
				}

				// 요청출근시간
				reqSt.add(reqStTmp.substring(11, 16));

				// 요청퇴근시간
				reqEtTmp = format.format(reqHisTmp.get(i).get("REQET"));
				reqEt.add(reqEtTmp.substring(11, 16));

				// 요청일자
				reqTimeTmp = format.format(reqHisTmp.get(i).get("REQTIME"));
				reqTime.add(reqTimeTmp.substring(0, 19));
				
				if(paramData.get("ROLEID").equals("ADMIN")) {
					// 사원번호
					empNo.add(reqHisTmp.get(i).get("EMPNO"));
					// 사원명
					empName.add(reqHisTmp.get(i).get("EMPNAME"));
				}
				
				// 근무코드
				wCode.add(reqHisTmp.get(i).get("WCODE"));
				
				returnData.put("reqCode", reqCode);
				returnData.put("orgDate", orgDate);
				returnData.put("orgTime", orgTime);
				returnData.put("reqEt", reqEt);
				returnData.put("reqSt", reqSt);
				returnData.put("reqTime", reqTime);
				returnData.put("procStep", procStep);
				returnData.put("empName", empName);
				returnData.put("empNo", empNo);
				returnData.put("wCode", wCode);
			}
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
	
	@RequestMapping(value = "/reqProc.do", method = RequestMethod.POST)
	public ModelAndView reqProc(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramData) throws IOException {
		LOG.info(">>>>>WORKS UPDATE REQTYPE ACTION<<<<<");
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
				
		try {
			String reqCode = (String) paramData.get("EMPNO") + (String) paramData.get("REQCODE");
			String procStep = (String) paramData.get("PROCSTEP");
			paramData.put("REQCODE", reqCode);
			if(procStep.equals("1")) {
				paramData.put("PROCSTEP", "APPROV");
			} else if(procStep.equals("2")) {
				paramData.put("PROCSTEP", "REF");
			} else if(procStep.equals("3")) {
				paramData.put("PROCSTEP", "CANC");
			}
			
			Date today = new Date();
			String now = format.format(today);
			today = format.parse(now);
			paramData.put("PROCTIME", today);
			
			int result = wrService.updateProcstep(paramData);
			
			String reqFlag = "1"; 
			if(result > 0) {
				reqFlag = "0";
			}
			out = response.getWriter();
			out.write(reqFlag);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(out != null) {
				out.flush();
				out.close();
			}
		}
		return null;
	}

}
