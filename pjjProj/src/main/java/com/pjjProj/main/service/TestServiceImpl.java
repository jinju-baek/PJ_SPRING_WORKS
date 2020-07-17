package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

@Service("tService")
public class TestServiceImpl implements TestService{
	
	@Resource(name="sqlSession")
	private SqlSessionTemplate sqlSession;
	
	@Override
	public Map<String, Object> getHMH(Map<String, Object> paramData) {
		List<Map<String, Object>> resultData = sqlSession.selectList("main.UP_HOMEAP_MESH_INFO_HIS_SELECT", paramData);
		paramData.put("resultData", resultData);
		
		return paramData; 
	
	}

}
