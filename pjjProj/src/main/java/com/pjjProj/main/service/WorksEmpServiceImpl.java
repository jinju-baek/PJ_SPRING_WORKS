package com.pjjProj.main.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Service;

@Service("employee")
public class WorksEmpServiceImpl implements WorksEmpService {

	@Resource(name = "sqlSession")
	private SqlSessionTemplate sqlSession;

	@Override
	public int getEmpCnt(String empno) {
		return sqlSession.selectOne("emp.getEmpCnt", empno);
	}

	@Override
	public int getChkinCnt() {
		return sqlSession.selectOne("emp.getChkinCnt");
	}

	@Override
	public int getChklaterCnt() {
		return sqlSession.selectOne("emp.getChklaterCnt");
	}

	@Override
	public int getChkawolCnt() {
		return sqlSession.selectOne("emp.getChkawolCnt");
	}

	@Override
	public List<Map<String, Object>> getMissHis(Map<String, Object> paramData) {
		return sqlSession.selectList("emp.getMissHis", paramData);
	}

	@Override
	public List<Map<String, Object>> getEmpInfo() {
		return sqlSession.selectList("emp.getEmpInfo");
	}

	@Override
	public int empIns(Map<String, Object> paramData) {
		return sqlSession.update("emp.empIns", paramData);
	}

	@Override
	public int setEmpUp(Map<String, Object> paramData) {
		return sqlSession.update("emp.empUp", paramData);
	}

	@Override
	public int setEmpDel(Map<String, Object> paramData) {
		return sqlSession.delete("emp.empDel", paramData);
	}

}
