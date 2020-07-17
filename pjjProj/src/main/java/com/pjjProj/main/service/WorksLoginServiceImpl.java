package com.pjjProj.main.service;

import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

@Service("loginService")
public class WorksLoginServiceImpl implements WorksLoginService {

	@Resource(name = "sqlSession")
	private SqlSessionTemplate sqlSession;

	@Override
	public int loginAccess(Map<String, Object> paramData) {
		return sqlSession.selectOne("user.login", paramData);
	}

	@Override
	public Map<String, Object> getUserInfo(Map<String, Object> paramData) {
		return sqlSession.selectOne("user.getUserInfo", paramData);
	}

}
