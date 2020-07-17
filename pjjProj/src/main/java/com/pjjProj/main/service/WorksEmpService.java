package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

public interface WorksEmpService {

	public int getEmpCnt(String empno);

	public int getChkinCnt();

	public int getChklaterCnt();

	public int getChkawolCnt();

	public List<Map<String, Object>> getMissHis(Map<String, Object> paramData);

	public List<Map<String, Object>> getEmpInfo();

	public int empIns(Map<String, Object> paramData);

	public int setEmpUp(Map<String, Object> paramData);

	public int setEmpDel(Map<String, Object> paramData);

}
