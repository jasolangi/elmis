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

import lombok.NoArgsConstructor;
import org.openlmis.core.domain.*;
import org.openlmis.core.exception.DataException;
import org.openlmis.core.service.FacilityApprovedProductService;
import org.openlmis.core.service.ProgramProductService;
import org.openlmis.web.response.OpenLmisResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

import static org.openlmis.web.response.OpenLmisResponse.error;
import static org.openlmis.web.response.OpenLmisResponse.response;
import static org.openlmis.web.response.OpenLmisResponse.success;

/**
 * This controller handles endpoint related to get non full supply products for a given facility, program combination.
 */

@Controller
@NoArgsConstructor
public class FacilityApprovedProductController extends BaseController {

  public static final String NON_FULL_SUPPLY_PRODUCTS = "nonFullSupplyProducts";
  public static final String PRODUCTS = "products";

  @Autowired
  private ProgramProductService programProductService;

  @Autowired
  private FacilityApprovedProductService facilityApprovedProductService;

  @RequestMapping(value = "/facilityApprovedProducts/facility/{facilityId}/program/{programId}/nonFullSupply", method = RequestMethod.GET, headers = "Accept=application/json")
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'CREATE_REQUISITION, AUTHORIZE_REQUISITION')")
  public ResponseEntity<OpenLmisResponse> getAllNonFullSupplyProductsByFacilityAndProgram(@PathVariable("facilityId") Long facilityId,
                                                                                          @PathVariable("programId") Long programId) {
    return response(NON_FULL_SUPPLY_PRODUCTS, facilityApprovedProductService.getNonFullSupplyFacilityApprovedProductByFacilityAndProgram(facilityId, programId));
  }

  @RequestMapping(value = "/facilityApprovedProducts/facility/{facilityId}/program/{programId}/all", method = RequestMethod.GET, headers = "Accept=application/json")
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_PRODUCT_ALLOWED_FOR_FACILITY')")
  public ResponseEntity<OpenLmisResponse> getProductsCompleteListByFacilityAndProgram(@PathVariable("facilityId") Long facilityId,
                                                                                          @PathVariable("programId") Long programId) {
      return response(PRODUCTS, facilityApprovedProductService.getProductsCompleteListByFacilityAndProgram(facilityId, programId));
  }

  @RequestMapping(value = "/facilityApprovedProducts/facilityType/{facilityTypeId}/program/{programId}/all", method = RequestMethod.GET, headers = "Accept=application/json")
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_PRODUCT_ALLOWED_FOR_FACILITY')")
  public ResponseEntity<OpenLmisResponse> getProductsCompleteListByFacilityTypeAndProgram(@PathVariable("facilityTypeId") Long facilityTypeId,
                                                                                      @PathVariable("programId") Long programId) {
      return response(PRODUCTS, facilityApprovedProductService.getProductsCompleteListByFacilityTypeAndProgram(facilityTypeId, programId));
  }


  @RequestMapping(value = "/facilityApprovedProducts/{facilityTypeId}/program/{programId}/programProductList", method = RequestMethod.GET, headers = ACCEPT_JSON)
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_PRODUCT_ALLOWED_FOR_FACILITY')")
  public ResponseEntity<OpenLmisResponse> getProductsAlreadyApprovedListByFacilityTypeAndProgram(@PathVariable Long programId, @PathVariable Long facilityTypeId) {
      return response(PRODUCTS, facilityApprovedProductService.getProductsAlreadyApprovedListByFacilityTypeAndProgram(facilityTypeId, programId));
  }

  @RequestMapping(value="/facilityApprovedProducts/facilityType/{facilityTypeId}/program/{programId}/product/{productId}",method = RequestMethod.GET,headers = ACCEPT_JSON)
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_PRODUCT_ALLOWED_FOR_FACILITY')")
  public ResponseEntity<OpenLmisResponse> getDetailsForFacilityTypeApprovedProduct(@PathVariable("facilityTypeId") Long facilityTypeId,
                                                                              @PathVariable("programId") Long programId,
                                                                              @PathVariable("productId") Long productId){
      return response("facilityTypeApprovedProduct", facilityApprovedProductService.getFacilityApprovedProductByProgramProductAndFacilityTypeId(facilityTypeId,programId,productId));

  }

  @RequestMapping(value="/facilityApprovedProducts/remove/facilityType/{facilityTypeId}/program/{programId}/product/{productId}",method = RequestMethod.GET,headers = ACCEPT_JSON)
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_PRODUCT_ALLOWED_FOR_FACILITY')")
  public ResponseEntity<OpenLmisResponse> removeFacilityTypeApprovedProduct(@PathVariable("facilityTypeId") Long facilityTypeId,
                                                                                   @PathVariable("programId") Long programId,
                                                                                   @PathVariable("productId") Long productId){
      ResponseEntity<OpenLmisResponse> successResponse;
      try {
          facilityApprovedProductService.removeFacilityApprovedProductByProgramProductAndFacilityTypeId(facilityTypeId, programId, productId);
      } catch (DataException e) {
          return error(e, HttpStatus.BAD_REQUEST);
      }
      successResponse = success(String.format("Save successful"));
      return successResponse;
  }

  @RequestMapping(value="/facilityApprovedProducts/insert.json",method = RequestMethod.POST,headers = ACCEPT_JSON)
  @PreAuthorize("@permissionEvaluator.hasPermission(principal,'MANAGE_PRODUCT_ALLOWED_FOR_FACILITY')")
  public ResponseEntity<OpenLmisResponse> saveANewFacilityTypeApprovedProduct(@RequestBody FacilityTypeApprovedProduct facilityTypeApprovedProduct, HttpServletRequest request){
      ResponseEntity<OpenLmisResponse> successResponse;
      try{
          facilityApprovedProductService.save_ext(facilityTypeApprovedProduct,loggedInUserId(request));
      }
      catch (DataException e) {
        return error(e, HttpStatus.BAD_REQUEST);
      }

    successResponse = success(String.format("Save successful"));
    return successResponse;
  }

}
