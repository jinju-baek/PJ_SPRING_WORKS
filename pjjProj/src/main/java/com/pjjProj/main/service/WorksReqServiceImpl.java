package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

@Service("requestService")
public class WorksReqServiceImpl implements WorksReqService {

	@Resource(name = "sqlSession")
	private SqlSessionTemplate sqlSession;

	@Override
	public int insertReq(Map<String, Object> paramData) {
		return sqlSession.update("req.insertReq", paramData);
	}

	@Override
	public List<Map<String, Object>> getReqHis(Map<String, Object> paramData) {
		return sqlSession.selectList("req.getRegHis", paramData);
	}

	@Override
	public int updateProcstep(Map<String, Object> paramData) {
		return sqlSession.update("req.updateProcstep", paramData);
	}

}
