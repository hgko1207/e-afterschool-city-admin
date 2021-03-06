package com.ysc.afterschool.admin.domain.param;

import com.ysc.afterschool.admin.domain.DomainParam;

import lombok.Data;

/**
 * 강사 검색 조건 클래스
 * 
 * @author hgko
 *
 */
@Data
public class TeacherSearchParam implements DomainParam {

	private String name;
}
