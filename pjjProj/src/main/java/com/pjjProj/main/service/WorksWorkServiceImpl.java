package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

@Service("workService")
public class WorksWorkServiceImpl implements WorksWorkService {

	@Resource(name = "sqlSession")
	private SqlSessionTemplate sqlSession;

	@Override
	public int setWorkStart(Map<String, Object> paramData) {
		return sqlSession.update("work.UP_PJJ_WORKTYPE_INSERT", paramData);
	}

	@Override
	public String getStartTime(Map<String, Object> paramData) {
		return sqlSession.selectOne("work.getStartTime", paramData);
	}

	@Override
	public int setWorkEnd(Map<String, Object> paramData) {
		return sqlSession.update("work.UP_PJJ_WORKTYPE_UPDATE", paramData);
	}

	@Override
	public String getEndTime(Map<String, Object> paramData) {
		return sqlSession.selectOne("work.getEndTime", paramData);
	}

	@Override
	public Map<String, Object> getWorkInfo(Map<String, Object> paramData) {
		List<Map<String, Object>> resultData = sqlSession.selectList("work.UP_JJP_CALENDAR_INFO_HIS_SELECT", paramData);
		paramData.put("resultData", resultData);
		return paramData;
	}

	@Override
	public int getStCnt(Map<String, Object> paramData) {
		return sqlSession.selectOne("work.getStCnt", paramData);
	}

	@Override
	public List<String> getStList(Map<String, Object> paramData) {
		return sqlSession.selectList("work.getStList", paramData);
	}

	@Override
	public Map<String, Object> getWorkTime(Map<String, Object> paramData) {
		return sqlSession.selectOne("work.getWorkTime", paramData);
	}

	@Override
	public int setWorkType(String id) {
		return sqlSession.update("work.setWorkType", id);
	}


}
