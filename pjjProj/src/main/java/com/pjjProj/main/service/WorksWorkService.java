package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

public interface WorksWorkService {
	public int setWorkStart(Map<String, Object> paramData);

	public String getStartTime(Map<String, Object> paramData);

	public int setWorkEnd(Map<String, Object> paramData);

	public String getEndTime(Map<String, Object> paramData);

	public Map<String, Object> getWorkInfo(Map<String, Object> paramData);

	public int getStCnt(Map<String, Object> paramData);

	public List<String> getStList(Map<String, Object> paramData);

	public Map<String, Object> getWorkTime(Map<String, Object> paramData);

	public int setWorkType(String id);
}
