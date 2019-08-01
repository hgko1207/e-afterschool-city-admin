package com.ysc.afterschool.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ysc.afterschool.admin.domain.db.Teacher;
import com.ysc.afterschool.admin.domain.db.Teacher.Sex;
import com.ysc.afterschool.admin.domain.param.TeacherSearchParam;
import com.ysc.afterschool.admin.service.CRUDService;
import com.ysc.afterschool.admin.service.TeacherService;

/**
 * 강사 관리 컨트롤러 클래스
 * 
 * @author hgko
 *
 */
@Controller
@RequestMapping("teacher")
public class TeacherController extends AbstractController<Teacher, TeacherSearchParam, Integer> {
	
	@Autowired
	private TeacherService teacherService;

	public TeacherController(CRUDService<Teacher, TeacherSearchParam, Integer> crudService) {
		super(crudService);
	}

	/**
	 * 강사 목록 화면
	 * @param model
	 */
	@GetMapping("list")
	public void list(Model model) {
		model.addAttribute("sexList", Sex.values());
	}
	
	/**
	 * 강사 추가 기능
	 * @param teacher
	 * @return
	 */
	@PostMapping("regist")
	public ResponseEntity<?> regist(Teacher teacher) {
		if (teacherService.regist(teacher)) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	/**
	 * 강사 정보 수정
	 * @param subject
	 * @return
	 */
	@Override
	public ResponseEntity<?> update(Teacher teacher) {
		Teacher result = teacherService.get(teacher.getId());
		result.setTel(teacher.getTel());
		result.setEmail(teacher.getEmail());
		
		if (teacherService.update(result)) {
			return new ResponseEntity<>(HttpStatus.OK);
		}
		
		return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
}