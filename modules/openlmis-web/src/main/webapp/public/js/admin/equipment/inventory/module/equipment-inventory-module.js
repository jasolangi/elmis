/*
 * This program was produced for the U.S. Agency for International Development. It was prepared by the USAID | DELIVER PROJECT, Task Order 4. It is part of a project which utilizes code originally licensed under the terms of the Mozilla Public License (MPL) v2 and therefore is licensed under MPL v2 or later.
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the Mozilla Public License as published by the Mozilla Foundation, either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Mozilla Public License for more details.
 *
 * You should have received a copy of the Mozilla Public License along with this program. If not, see http://www.mozilla.org/MPL/
 */

angular.module('equipment-inventory', ['openlmis','ui.bootstrap.modal', 'ui.bootstrap.dialog', 'ui.bootstrap.dropdownToggle']).config(['$routeProvider', function ($routeProvider) {
  $routeProvider.
      when('/', {controller: EquipmentInventoryController, templateUrl: 'partials/list.html'}).
      when('/:from/:facilityId/:programId', {controller: EquipmentInventoryController, templateUrl: 'partials/list.html'}).
      when('/create/:from/:facilityId/:programId', {controller: CreateEquipmentInventoryController, templateUrl: 'partials/create.html'}).
      when('/edit/:id', {controller: CreateEquipmentInventoryController, templateUrl: 'partials/create.html'}).
      when('/log/:id', {controller: LogController, templateUrl: 'partials/log.html'}).
      when('/request/:id', {controller: CreateServiceRequestController, templateUrl: 'partials/request.html'}).
      otherwise({redirectTo: '/'});
}]).run(function ($rootScope, AuthorizationService) {
  AuthorizationService.preAuthorize('MANAGE_EQUIPMENT_INVENTORY');
});