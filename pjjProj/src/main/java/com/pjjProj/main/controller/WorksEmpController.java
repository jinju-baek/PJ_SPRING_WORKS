package com.pjjProj.main.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
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

import com.pjjProj.main.service.WorksEmpService;

import net.sf.json.JSONObject;

@RequestMapping(value = "/emp", method = { RequestMethod.GET, RequestMethod.POST })
@Controller
public class WorksEmpController {
	private static final Logger LOG = LoggerFactory.getLogger(WorksEmpController.class);

	@Resource(name = "employee")
	WorksEmpService weService;

	@RequestMapping(value = "/empCnt.do", method = { RequestMethod.POST })
	public ModelAndView empCnt(HttpServletResponse response, @RequestParam Map<String, Object> paramData,
			Map<String, Object> returnData) throws IOException {
		LOG.info(">>>>>EMPLOYEE INFOCNT SELECT ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;

		try {
			String empno = (String) paramData.get("empno");
			returnData.put("empCnt", weService.getEmpCnt(empno));
			returnData.put("chkinCnt", weService.getChkinCnt());
			returnData.put("chklaterCnt", weService.getChklaterCnt());
			returnData.put("chkawolCnt", weService.getChkawolCnt());

			joReturn.put("returnData", returnData);
			out = response.getWriter();
			out.write(joReturn.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@RequestMapping(value = "/missHis.do", method = RequestMethod.POST)
	public ModelAndView missHis(HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		LOG.info(">>>>>EMPLOYEE MISSHIS SELECT ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;

		try {
			List<Map<String, Object>> returnData = new ArrayList<Map<String, Object>>();
			int hisFlag;
			if (weService.getMissHis(paramData).isEmpty()) {
				hisFlag = 1;
			} else {
				hisFlag = 0;
				for (Map<String, Object> list : weService.getMissHis(paramData)) {
					returnData.add(list);
				}
				joReturn.put("returnData", returnData);
			}
			joReturn.put("hisFlag", hisFlag);
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

	@RequestMapping(value = "/empSel.do", method = RequestMethod.POST)
	public ModelAndView empSel(HttpServletResponse response) throws IOException {
		LOG.info(">>>>>EMPLOYEE MISSHIS SELECT ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		List<Map<String, Object>> returnData = new ArrayList<Map<String, Object>>();
		try {
			int infoFlag;
			if (weService.getEmpInfo().isEmpty()) {
				infoFlag = 1;
			} else {
				infoFlag = 0;
				for (Map<String, Object> list : weService.getEmpInfo()) {
					returnData.add(list);
				}
			}
			joReturn.put("infoFlag", infoFlag);
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

	@RequestMapping(value = "/empIns.do", method = RequestMethod.POST)
	public ModelAndView empIns(HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		LOG.info(">>>>>EMPLOYEE EMPINFO INSERT ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		try {
			int result = weService.empIns(paramData);
			int insFlag;
			if (result > 0) {
				insFlag = 0;
			} else {
				insFlag = 1;
			}
			joReturn.put("insFlag", insFlag);
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
	
	@RequestMapping(value = "/empUp.do", method = RequestMethod.POST)
	public ModelAndView empUp(HttpServletResponse response, @RequestParam Map<String, Object> paramData) throws IOException {
		LOG.info(">>>>>EMPLOYEE EMPINFO UPDATE ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		try {
			int result = weService.setEmpUp(paramData);
			int upFlag;
			if (result > 0) {
				upFlag = 0;
			} else {
				upFlag = 1;
			}
			joReturn.put("upFlag", upFlag);
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
	
	@RequestMapping(value = "/empDel.do", method = RequestMethod.POST)
	public ModelAndView empDel(HttpServletResponse response, @RequestParam Map<String, Object> paramData) throws IOException {
		LOG.info(">>>>>EMPLOYEE EMPINFO DELETE ACTION<<<<<");

		JSONObject joReturn = new JSONObject();
		response.setContentType("application/x-json; charset=UTF-8");
		Writer out = null;
		try {
			int result = weService.setEmpDel(paramData);
			int delFlag;
			if (result > 0) {
				delFlag = 0;
			} else {
				delFlag = 1;
			}
			joReturn.put("delFlag", delFlag);
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
