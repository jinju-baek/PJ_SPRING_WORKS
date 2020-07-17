package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

public interface WorksRepService {

	public int getNormCtn(Map<String, Object> paramData);

	public int getLateCtn(Map<String, Object> paramData);

	public int getAwolCnt(Map<String, Object> paramData);
	
	public List<Map<String, Object>> getTimeList(Map<String, Object> paramData);
}
