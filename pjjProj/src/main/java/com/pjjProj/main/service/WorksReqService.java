package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

public interface WorksReqService {

	public int insertReq(Map<String, Object> paramData);

	public List<Map<String, Object>> getReqHis(Map<String, Object> paramData);

	public int updateProcstep(Map<String, Object> paramData);

}
