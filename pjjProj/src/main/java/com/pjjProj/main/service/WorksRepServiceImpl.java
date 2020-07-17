package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

@Service("reportSerivce")
public class WorksRepServiceImpl implements WorksRepService {
	
	@Resource(name = "sqlSession")
	private SqlSessionTemplate sqlSession;
	
	@Override
	public int getNormCtn(Map<String, Object> paramData) {
		return sqlSession.selectOne("rep.getNormCnt", paramData);
	}
	
	@Override
	public int getLateCtn(Map<String, Object> paramData) {
		return sqlSession.selectOne("rep.getLateCnt", paramData);
	}

	@Override
	public int getAwolCnt(Map<String, Object> paramData) {
		return sqlSession.selectOne("rep.getAwolCnt", paramData);
		
	}

	@Override
	public List<Map<String, Object>> getTimeList(Map<String, Object> paramData) {
		return sqlSession.selectList("rep.getTimeList", paramData);
	}
}
