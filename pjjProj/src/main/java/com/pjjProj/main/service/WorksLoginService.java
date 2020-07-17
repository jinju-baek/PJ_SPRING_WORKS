package com.pjjProj.main.service;

import java.util.Map;

public interface WorksLoginService {
	public int loginAccess(Map<String, Object> paramData);

	public Map<String, Object> getUserInfo(Map<String, Object> paramData);

}
