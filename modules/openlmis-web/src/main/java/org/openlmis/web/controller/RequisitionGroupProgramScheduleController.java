/*
 * This program is part of the OpenLMIS logistics management information system platform software.
 * Copyright © 2013 VillageReach
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License along with this program.  If not, see http://www.gnu.org/licenses.  For additional information contact info@OpenLMIS.org. 
 */

package org.openlmis.web.controller;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.NoArgsConstructor;
import org.openlmis.core.domain.RequisitionGroupProgramSchedule;
import org.openlmis.core.exception.DataException;
import org.openlmis.core.service.*;
import org.openlmis.web.response.OpenLmisResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

import static org.openlmis.web.response.OpenLmisResponse.error;
import static org.openlmis.web.response.OpenLmisResponse.success;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

@Controller
@NoArgsConstructor
public class RequisitionGroupProgramScheduleController extends BaseController {

    public static final String REQUISITION_GROUP_PROGRAM_SCHEDULE = "requisitionGroupProgramSchedule";

    @Autowired
    RequisitionGroupProgramScheduleService requisitionGroupProgramScheduleService;

    @Autowired
    ProgramService programService;

    @Autowired
    RequisitionGroupService requisitionGroupService;

    @RequestMapping(value="/requisitionGroupProgramSchedule/insert",method=POST,headers = ACCEPT_JSON)
    @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_REQ_GRP_PROG_SCHEDULE')")
    public ResponseEntity<OpenLmisResponse> insert(@RequestBody RequisitionGroupProgramSchedule requisitionGroupProgramSchedule, HttpServletRequest request){
        ResponseEntity<OpenLmisResponse> successResponse;
        requisitionGroupProgramSchedule.setModifiedBy(loggedInUserId(request));
        try {
            requisitionGroupProgramScheduleService.save(requisitionGroupProgramSchedule);
        } catch (DataException e) {
            return error(e, HttpStatus.BAD_REQUEST);
        }
        successResponse = success(String.format("Requisition group program schedule has been successfully saved"));
        successResponse.getBody().addData("requisitionGroupMember", requisitionGroupProgramSchedule);
        return successResponse;
    }


    @JsonIgnoreProperties(ignoreUnknown = true)
    @RequestMapping(value="/requisitionGroupProgramSchedule/getDetails/{rgId}/{pgId}",method = GET,headers = ACCEPT_JSON)
    @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_REQ_GRP_PROG_SCHEDULE')")
    public ResponseEntity<OpenLmisResponse> loadScheduleForRequisitionGroupAndProgram(@PathVariable(value="rgId") Long requisitionGroupId, @PathVariable(value="pgId") Long programId, HttpServletRequest request){
        try {
            RequisitionGroupProgramSchedule requisitionGroupProgramSchedule = requisitionGroupProgramScheduleService.getScheduleForRequisitionGroupIdAndProgramId(requisitionGroupId,programId);
            return OpenLmisResponse.response(REQUISITION_GROUP_PROGRAM_SCHEDULE,requisitionGroupProgramSchedule);
        } catch (DataException e) {
            return error(e, HttpStatus.BAD_REQUEST);
        }
    }

  @RequestMapping(value="/requisitionGroupProgramSchedule/remove/{id}",method=GET,headers = ACCEPT_JSON)
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_REQ_GRP_PROG_SCHEDULE')")
  public ResponseEntity<OpenLmisResponse> remove(@PathVariable(value="id") Long requisitionGroupProgramScheduleId, HttpServletRequest request){
    ResponseEntity<OpenLmisResponse> successResponse;
    try {
      requisitionGroupProgramScheduleService.delete(requisitionGroupProgramScheduleId);
    } catch (DataException e) {
      return error(e, HttpStatus.BAD_REQUEST);
    }
    successResponse = success(String.format("Requisition group program association with schedule has been successfully removed"));
    successResponse.getBody().addData("requisitionGroupProgramScheduleId", requisitionGroupProgramScheduleId);
    return successResponse;
  }
}