package com.ysc.afterschool.admin.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ysc.afterschool.admin.domain.db.Invitation;
import com.ysc.afterschool.admin.domain.param.InvitationSearchParam;
import com.ysc.afterschool.admin.repository.InvitationRepository;
import com.ysc.afterschool.admin.service.InvitationService;

@Transactional
@Service
public class InvitationServiceImpl implements InvitationService {
	
	@Autowired
	private InvitationRepository invitationRepository;

	@Override
	public Invitation get(Integer id) {
		return invitationRepository.findById(id).get();
	}

	@Transactional(readOnly = true)
	@Cacheable("school.list")
	@Override
	public List<Invitation> getList() {
		return invitationRepository.findAll();
	}

	@Override
	public boolean regist(Invitation domain) {
		if (isNew(domain)) {
			return invitationRepository.save(domain) != null;
		} else {
			return false;
		}	
	}

	@Override
	public boolean update(Invitation domain) {
		if (!isNew(domain)) {
			return invitationRepository.save(domain) != null;
		} else {
			return false;
		}	
	}

	@Override
	public boolean delete(Integer id) {
		invitationRepository.deleteById(id);
		return true;
	}

	@Override
	public List<Invitation> getList(InvitationSearchParam param) {
		if (param.getCityId() != 0) {
			return invitationRepository.findByCityId(param.getCityId());
		}
		return getList();
	}

	private boolean isNew(Invitation domain) {
		return !invitationRepository.existsById(domain.getId());
	}
}