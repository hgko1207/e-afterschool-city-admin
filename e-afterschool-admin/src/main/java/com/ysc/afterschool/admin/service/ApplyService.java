package com.ysc.afterschool.admin.service;

import java.util.List;

import com.ysc.afterschool.admin.domain.db.Apply;
import com.ysc.afterschool.admin.domain.param.ApplySearchParam;

public interface ApplyService extends CRUDService<Apply, ApplySearchParam, Integer> {

	List<Apply> getList(int studentId);

	boolean delete(List<Apply> applies);
}
