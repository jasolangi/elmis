Feature: Smoke Tests

  @smokeRequisition
  Scenario: User should be able to initiate and submit emergency RnR
    Given I have the following data for regimen:
      | HIV | storeInCharge | ADULTS | RegimenCode1 | RegimenName1 | RegimenCode2 | RegimenName2 |
    Given I have "storeInCharge" user with "CREATE_REQUISITION,VIEW_REQUISITION" rights and data to initiate requisition
    And I am logged in as "storeInCharge"
    And I access initiate emergency requisition page
    Then I got error message "No current period defined. Please contact the Admin."
    When I have period "currentPeriod" associated with schedule "M"
    And I access home page
    And I access initiate emergency requisition page
    Then I should verify "currentPeriod" with status "Not yet started" in row "1"
    When I access proceed
    And I access initiate emergency requisition page
    Then I should verify "currentPeriod" with status "INITIATED" in row "2"
    And I should verify "currentPeriod" with status "Not yet started" in row "1"
    When I access proceed
    And I enter beginning balance "100"
    And I enter quantity dispensed "100"
    And I enter quantity received "100"
    And I click submit
    And I click ok
    Then I validate beginning balance "100"
    And I validate quantity dispensed "100"
    And I validate quantity received "100"
    And I access home page
    And I access initiate requisition page
    And I access initiate emergency requisition page
    Then I should verify "currentPeriod" with status "INITIATED" in row "3"
    Then I should verify "currentPeriod" with status "SUBMITTED" in row "2"
    And I should verify "currentPeriod" with status "Not yet started" in row "1"

  @smokeRequisition
  Scenario: User should be able to save and submit regimen data
    Given I have the following data for regimen:
      | HIV | storeInCharge | ADULTS | RegimenCode1 | RegimenName1 | RegimenCode2 | RegimenName2 |
    And I have "storeInCharge" user with "CREATE_REQUISITION,VIEW_REQUISITION" rights and data to initiate requisition
    And I have regimen template configured
    And I am logged in as "storeInCharge"
    And I access initiate requisition page
    When I click proceed
    And I populate RnR data
    And I click proceed
    And I access regimen tab
    Then I should see regimen fields
    When I type patients on treatment "100"
    And I type patients initiated treatment "100"
    And I type patients stopped treatment "100"
    And I type remarks "Regimens data filled"
    And I click save
    Then I should see saved successfully
    When I click submit
    And I click ok
    Then I should see submit successfully

  @smokeRequisition
  Scenario: User should view requisition and regimen after authorization
    Given I have the following data for regimen:
      | HIV | storeInCharge | ADULTS | RegimenCode1 | RegimenName1 | RegimenCode2 | RegimenName2 |
    And I have "storeInCharge" user with "CREATE_REQUISITION,VIEW_REQUISITION" rights and data to initiate requisition
    And I have regimen template configured
    And I am logged in as "storeInCharge"
    And I access initiate requisition page
    When I click proceed
    And I populate RnR data
    And I populate Regimen data as patientsOnTreatment "100" patientsToInitiateTreatment "200" patientsStoppedTreatment "300" remarks "Regimens data filled"
    And I access home page
    And I access view RnR screen
    Then I should see elements on view requisition page
    When I update requisition status to "SUBMITTED"
    And I type view search criteria
    And I click search
    Then I should see no requisition found message
    When I update approved quantity "10"
    And I update requisition status to "AUTHORIZED"
    And I click search
    Then I should see requisition status as "AUTHORIZED"
    When I click RnR List
    Then I verify total field
    When I access regimen tab for view requisition
    Then I verify values on regimen page as patientsOnTreatment "100" patientsToInitiateTreatment "200" patientsStoppedTreatment "300" remarks "Regimens data filled"

  @smokeRequisition
  Scenario: Verifying Forgot Password functionality
    Given I am on forgot password screen
    When I type email "John_Doe@openlmis.com"
    And I type and username "Admin123"
    When I click submit button
    Then I should see email send successfully
    And I am logged in as "Admin123"

  @smokeRequisition
  Scenario: Verify New Regimen Created
    Given I have data available for programs configured
    And I am logged in as "Admin123"
    When I access regimen configuration page
    Then I should see configured program list
    When I configure program "ESSENTIAL MEDICINES" for regimen template
    And I add new regimen:
      | Category | Code  | Name  | Active |
      | Adults   | Code1 | Name1 | true   |
    And I save regimen
    Then I should see regimen created message

  @smokeRequisition
  Scenario: Verify New Regimen Reporting Field Configuration
    Given I have data available for programs configured
    And I am logged in as "Admin123"
    When I access regimen configuration page
    Then I should see configured program list
    When I configure program "ESSENTIAL MEDICINES" for regimen template
    And I add new regimen:
      | Category | Code  | Name  | Active |
      | Adults   | Code1 | Name1 | true   |
    And I access regimen reporting fields tab
    Then I should see regimen reporting fields
    When I add new regimen reporting field:
      | NoOfPatientsOnTreatment | Remarks        |
      | false                   | Testing column |
    And I save regimen
    Then I should see regimen created message
    When I edit program "ESSENTIAL MEDICINES" for regimen template
    Then I should see created regimen and reporting fields:
      | Code  | Name  | Remarks        |
      | Code1 | Name1 | Testing column |
    When I activate Number Of Patients On Treatment
    And I save regimen
    Then I should see regimen created message

  @smokeRequisition
  Scenario: Admin user should not access requisition page
    Given I am logged in as "Admin123"
    When I access initiate requisition page through URL
    Then I should see unauthorized access message

  @smokeRequisition
  Scenario: Requisition user should not access admin Page
    Given I have "storeInCharge" user with "CREATE_REQUISITION,VIEW_REQUISITION" rights
    And I am logged in as "storeInCharge"
    When I access create facility page through URL
    Then I should see unauthorized access message

  @smokeRequisition
  Scenario: Admin can create, disable & restore user
    Given I am logged in as "Admin123"
    When I create a user:
      | Email                   | FirstName | LastName | UserName |
      | Dummy_User@openlmis.com | Dummy     | User     | Dummy    |
    Then I should see user not verified
    When I disable user "Dummy User"
    Then I should see disable user "Dummy User" message
    When I enable user "Dummy User"
    Then I should see enable user "Dummy User" message
    When I verify user email "Dummy_User@openlmis.com"
    Then I should see user "Dummy User" verified

  @smokeRequisition
  Scenario: User should be able to configure order file format
    Given I configure order file:
      | File Prefix | Header In File |
      | O           | FALSE          |
    And I am logged in as "Admin123"
    And I access configure order page
    Then I should see order file prefix "O"
    And I should see include column header as "false"
    And I should see all column headers disabled
    And I should see include checkbox "checked" for all column headers
    When I save order file format
    Then I should see "Order file configuration saved successfully!"

  @smokeRequisition
  Scenario: User should be able to configure shipment file format using default format
    When I am logged in as "Admin123"
    And I access configure shipment page
    And I should see include column headers unchecked
    And I should see include checkbox for all data fields
    And I should see default value of positions
    When I save shipment file format
    Then I should see successful message "Shipment file configuration saved successfully!"

  @smokeRequisition
  Scenario: User should be able to configure budget file format using default format
    When I am logged in as "Admin123"
    And I access configure budget page
    And I should see include column headers option unchecked
    And I verify default checkbox for all data fields
    And I verify default value of positions
    When I save budget file format
    Then I should see budget successful saved message as "Budget file configuration saved successfully!"

  @smokeRequisition
  Scenario: User should download order file and verify
    Given I have the following data for regimen:
      | HIV | storeInCharge | ADULTS | RegimenCode1 | RegimenName1 | RegimenCode2 | RegimenName2 |
    And I configure order file:
      | File Prefix | Header In File |
      | O           | TRUE           |

    And I configure openlmis order file columns:
      | Data Field Label         | Include In Order File | Column Label | Position | Format     |
      | header.order.number      | TRUE                  | ONUm         | 7        |            |
      | header.order.date        | TRUE                  | Order Date   | 6        | yyyy/MM/dd |
      | label.period             | TRUE                  | Period       | 5        | dd/MM/yyyy |
      | header.quantity.approved | TRUE                  | AQTY         | 4        |            |
      | header.product.code      | TRUE                  |              | 3        |            |
      | header.product.name      | TRUE                  |              | 2        |            |
      | create.facility.code     | TRUE                  | FCCode       | 1        |            |

    And I configure non openlmis order file columns:
      | Data Field Label | Include In Order File | Column Label | Position |
      | NOT APPLICABLE   | TRUE                  |              | 7        |
      | NOT APPLICABLE   | TRUE                  | Dummy        | 8        |

    And I have "storeInCharge" user with "CREATE_REQUISITION,VIEW_REQUISITION,APPROVE_REQUISITION" rights and data to initiate requisition
    And I have "lmu" role having "ADMIN" based "CONVERT_TO_ORDER,VIEW_ORDER" rights
    And I have users:
      | UserId | Email                 | FirstName | LastName | UserName | Role | FacilityCode |
      | 111    | Jake_Doe@openlmis.com | Jake      | Doe      | lmu      | lmu  | F10          |
    And I have fulfillment data for user "lmu" role "lmu" and facility "F10"
    And I have regimen template configured
    And I am logged in as "storeInCharge"
    And I access initiate requisition page
    When I click proceed
    And I populate RnR data
    And I populate Regimen data as patientsOnTreatment "100" patientsToInitiateTreatment "200" patientsStoppedTreatment "300" remarks "Regimens data filled"
    And I update requisition status to "SUBMITTED"
    And I update requisition status to "AUTHORIZED"
    And I have approved quantity "10"
    And I update requisition status to "APPROVED"
    And I logout
    And I am logged in as "lmu"
    And I access convert to order page
    And I convert to order
    And I access view orders page
    And I download order file
    And I get order data in file prefix "O"
    Then I verify order file line "1" having "FCCode,,,AQTY,Period,Order Date,ONUm,,Dummy"
    And I verify order file line "2" having "F10"
    And I verify order file line "2" having "antibiotic Capsule 300/200/600 mg"
    And I verify order file line "2" having "P10"
    And I verify order file line "2" having "10"
    And I verify order file line "2" having "16/01/2012"
    And I verify order date format "yyyy/mm/dd" in line "2"
    And I verify order id in line "2"

  @smokeRequisition
  Scenario: Blank
    Given I have "storeInCharge" user with "MANAGE_POD" rights
    And I am logged in as "storeInCharge"

  @smokeRequisition
  Scenario: Selected requisitions across pages should not convert to order
    Given I have "51" requisitions for convert to order
    And I am logged in as "storeInCharge"
    When I access convert to order page
    And I select "1" requisition on page "1"
    And I select "1" requisition on page "2"
    And I convert selected requisitions to order
    Then "1" requisition converted to order

  @smokeRequisition
  Scenario: User should able to see list of orders to update POD for "Ready to pack" order
    Given I have "storeInCharge" user with "MANAGE_POD" rights
    And I have a/an "Regular" order in "READY_TO_PACK" status
    And I am logged in as "storeInCharge"
    When I access Manage POD page
    Then I should see list of orders to manage POD for Rnr
    When I click on update Pod link for Row "1"
    Then I should see all products to update pod

  @smokeRequisition
  Scenario: User should able to see list of orders to update POD for packed orders
    Given I have "storeInCharge" user with "MANAGE_POD" rights
    And I have a/an "Regular" order in "RELEASED" status
    When I receive shipment for the order
    And I am logged in as "storeInCharge"
    And I access Manage POD page
    And I click on update Pod link for Row "1"
    Then I should see all products listed in shipment file to update pod

  @smokeRequisition
  Scenario: User should able to submit POD for emergency RnR
    Given I have "storeInCharge" user with "MANAGE_POD" rights
    And I have a/an "Emergency" order in "RELEASED" status
    And I am logged in as "storeInCharge"
    And I receive shipment for the order
    And I access Manage POD page
    And I click on update Pod link for Row "1"
    And I enter "10" as quantity received, "78" as quantity returned and "notes" as notes in row "1"
    And I enter "openLMIS" as deliveredBy,"Facility Incharge" as receivedBy and "27/02/2014" as receivedDate
    And I submit POD
    Then I verify quantity received, quantity returned,notes,deliveredBy,receivedBy,receivedDate disabled
    And I verify in database quantity received as "10", quantity returned as "78" and notes as "notes"
    And I verify in database deliveredBy as "openLMIS",receivedBy as "Facility Incharge" and receivedDate as "2014-02-27 00:00:00"
    Then I access view orders page
    And I verify order status as "Received" in row "1"
    Then I access Manage POD page
    And I verify order not present on manage pod page

# DISTRIBUTION SMOKE TESTS

  @smokeDistribution
  Scenario: User should able to configure program product ISA
    Given I have data available for program product ISA
    And I am logged in as "Admin123"
    When I access program product ISA page for "VACCINES"
    And I type ratio "3.9" dosesPerYear "3" wastage "10" bufferPercentage "25" adjustmentValue "0" minimumValue "10" maximumValue "1000"
    Then I verify calculated ISA value having population "1000" as "122"
    And I click cancel

  @smokeDistribution
  Scenario: User should able to initiate & delete distribution
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Single" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    And I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I change language as Portuguese on Distribution Page
    And I change language as English on Distribution Page
    Then I see no distribution in cache
    When I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    Then I should see data download successfully
    And I should see delivery zone "Delivery Zone First" program "VACCINES" period "Period14" in table
    And I remove cached distribution
    Then I observe confirm delete distribution dialog
    When I cancel delete distribution
    And I should see delivery zone "Delivery Zone First" program "VACCINES" period "Period14" in table
    And I remove cached distribution
    And I confirm delete distribution
    Then I see no distribution in cache

  @smokeDistribution
  Scenario: User should able to fetch program period on manage distribution screen
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Multiple" facilities attached to delivery zones
    And I am logged in as "storeInCharge"
    And I access plan my distribution page
    Then I verify fields
    And I should see deliveryZone "--None Assigned--"
    When I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    Then I should see program "VACCINES,TB"
    And I select program "VACCINES"
    Then I should see period "Period14"
    And I click view load amount

  @smokeDistribution
  Scenario: User should able to override ISA
    Given I have the following data for override ISA:
      | user     | program  | product | productName | category | whoRatio | dosesPerYear | wastageFactor | bufferPercentage | minimumValue | maximumValue | adjustmentValue |
      | Admin123 | VACCINES | P1      | antibiotic1 | C1       | 1        | 2            | 3             | 4                | null         | null         | 5               |
    And I am logged in as "Admin123"
    And I access create facility page
    When I create facility
    And I override ISA "24"
    Then I should see calculated ISA "7"
    When I click ISA done
    And I save facility
    Then I should see save successfully
    When I search facility
    Then I should see overridden ISA "24"

  @smokeDistribution
  Scenario: Distribution user should view ISA, Override ISA and NoRecords for different delivery zone, program & period combination
    Given I have data available for distribution load amount
    And I have data available for "Multiple" facilities attached to delivery zones
    And I have following ISA values:
      | Program  | Product | whoRatio | dosesPerYear | wastageFactor | bufferPercentage | minimumValue | maximumValue | adjustmentValue |
      | VACCINES | P10     | 10       | 10           | 10            | 10               | null         | null         | 0               |
    And I have following override ISA values:
      | Facility Code | Program  | Product | ISA  |
      | F11           | VACCINES | P11     | 1005 |
    And I update population of facility "F10" as "342"
    And I have role assigned to delivery zones
    When I am logged in as "fieldCoordinator"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I click view load amount
    Then I should see ISA values as per delivery zone facilities
    And  I verify ISA values for Product1 as:
      | Facility1 | Facility2 |
      | 31        | 31        |
    And  I verify ISA values for Product2 as:
      | Facility1 | Facility2 |
      | 101       | --        |
    And I should not see inactive products on view load amount
    When I access plan my distribution page
    And I select delivery zone "Delivery Zone Second"
    And I select program "TB"
    And I select period "Period14"
    And I click view load amount
    Then I should see message "No records found"

  @smokeDistribution
  Scenario: Distribution user should view aggregate ISA for delivery zone
    Given I have data available for distribution load amount
    And I have data available for "Single" facility attached to delivery zones
    And I have following override ISA values:
      | Facility Code | Program  | Product | ISA  |
      | F10           | VACCINES | P10     | 1000 |
      | F10           | VACCINES | P11     | 2000 |
      | F11           | VACCINES | P10     | 3000 |
      | F11           | VACCINES | P11     | 4000 |
    And I have role assigned to delivery zone first
    When I am logged in as "fieldCoordinator"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I click view load amount
    Then I should see aggregate ISA values as per multiple facilities in one delivery zone

  @smokeDistribution
  Scenario: User should see facility list/ selection page
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    And I am logged in as "storeInCharge"
    And I access plan my distribution page
    When I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I verify Distributions data is not synchronised
    Then I should see Delivery Zone "Delivery Zone First", Program "VACCINES" and Period "Period14" in the header
    And I should see No facility selected
    And I should see "active" facilities that support the program "VACCINES" and delivery zone "Delivery Zone First"

  @smokeDistribution
  Scenario: User should be able to add/edit/delete refrigerator
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    And I am logged in as "storeInCharge"
    And I access plan my distribution page
    When I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I navigate to "refrigerator" tab
    And I add new refrigerator
    Then I should see New Refrigerator screen
    When I enter Brand "LG"
    And I enter Modal "800 LITRES"
    And I enter Serial Number "GR-J287PGHV"
    And I access done
    And I verify Distributions data is not synchronised
    And I verify Refrigerator data is not synchronised
    Then I should see refrigerator "GR-J287PGHV;LG;800 LITRES" added successfully
    And I see "overall" refrigerator icon as "RED"
    When I edit refrigerator
    Then I see "individual" refrigerator icon as "RED"
    And I enter refrigerator temperature "3"
    And I see "overall" refrigerator icon as "AMBER"
    Then I see "individual" refrigerator icon as "AMBER"
    And I verify "Yes" it was working correctly when I left
    And I enter low alarm events "1"
    And I enter high alarm events "0"
    And I verify "No" that there is a problem with refrigerator since last visit
    Then I see "individual" refrigerator icon as "GREEN"
    And I see "overall" refrigerator icon as "GREEN"
    And I enter Notes "miscellaneous"
    And I add refrigerator
    And I verify Refrigerator data is not synchronised
    Then I should not see Refrigerator details section
    And I should see Edit button
    When I edit refrigerator
    Then I should see refrigerator details as refrigerator temperature "3" low alarm events "1" high alarm events "0" notes "miscellaneous"
    And I add refrigerator
    When I delete refrigerator
    Then I should see confirmation for delete
    When I confirm delete
    Then I should see refrigerator "GR-J287PGHV;LG;800 LITRES" deleted successfully

  @smokeDistribution
  Scenario: User should fill Visit Information when facility was visited
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I verify that I am on visit information page
    Then Verify "visit information" indicator should be "RED"
    When I select "yes" facility visited
    And I select visit date as current date
    And I Enter "visit information" values:
      | observations     | confirmedByName | confirmedByTitle | verifiedByName | verifiedByTitle |
      | some observation | samuel          | fc               |                |                 |
    Then Verify "visit information" indicator should be "AMBER"
    When I Enter "visit information" values:
      | vehicleId | observations     | confirmedByName | confirmedByTitle | verifiedByName | verifiedByTitle |
      |           | some observation | samuel          | fc               | Verifier       | X YZ            |
    Then Verify "visit information" indicator should be "GREEN"
    And I enter vehicle id as "023!YU-09"
    And I reload the page
    Then I verify radio button "yes" is selected
    And I verify visit date
    And I verify saved "visit information" values:
      | vehicleId | observations     | confirmedByName | confirmedByTitle | verifiedByName | verifiedByTitle |
      | 023!YU-09 | some observation | samuel          | fc               | Verifier       | X YZ            |
    When I navigate to "epi inventory" tab
    Then Verify "epi inventory" indicator should be "RED"

  @smokeDistribution
  Scenario: User should fill Visit Information when facility was not visited
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I update product "P10" to have product group "penta"
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I verify that I am on visit information page
    Then I see Overall facility icon as "AMBER"
    And I see "F10" facility indicator icon as "AMBER"
    And I navigate to "refrigerator" tab
    When I add new refrigerator
    When I enter Brand "LG"
    And I enter Modal "800 LITRES"
    And I enter Serial Number "GR-J287PGHV"
    And I access done
    And I navigate to "visit information" tab
    Then Verify "visit information" indicator should be "RED"
    When I select "no" facility visited
    Then Verify "visit information" indicator should be "AMBER"
    And I select Others reason
    Then Verify "visit information" indicator should be "AMBER"
    And I enter Other reason as "reason for not visiting"
    Then Verify "visit information" indicator should be "GREEN"
    And Verify "refrigerator" indicator should be "GREEN"
    And Verify "epi inventory" indicator should be "GREEN"
    When I navigate to "epi inventory" tab
    Then I see "epi inventory" fields disabled
    When I navigate to "refrigerator" tab
    And I access show
    Then I see "refrigerator" fields disabled
    When I navigate to "visit information" tab
    Then I verify radio button "No" is selected
    And I verify Others reason selected
    And I verify Other reason entered as "reason for not visiting"

  @smokeDistribution
  Scenario: User should fill EPI use data
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I update product "P10" to have product group "penta"
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I navigate to "epi use" tab
    Then Verify "epi use" indicator should be "RED"
    Then I should see product group "penta-Name"
    When I Enter "epi use" values:
      | distributed | expirationDate | loss | received | firstOfMonth | endOfMonth |
      | 16          | 11/2012        | 1    | 10       | 12           |            |
    Then Verify "epi use" indicator should be "AMBER"
    When I enter EPI end of month as "5"
    Then Verify "epi use" indicator should be "GREEN"
    And I verify total is "22"
    And I verify saved "epi use" values:
      | distributed | expirationDate | loss | received | firstOfMonth | endOfMonth | total |
      | 16          | 11/2012        | 1    | 10       | 12           | 5          | 22    |
    When I access plan my distribution page
    When I record data for distribution "1"
    And I choose facility "F10"
    Then Verify "epi use" indicator should be "GREEN"

  @smokeDistribution
  Scenario: User should fill EPI Inventory data
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I update product "P10" to have product group "penta"
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I navigate to "epi inventory" tab
    Then Verify "epi inventory" indicator should be "RED"
    And I Enter "epi inventory" values:
      | existingQuantity | deliveredQuantity | spoiledQuantity |
      | 100              | 50                | 100             |
      | 10               |                   | 10              |
    Then Verify "epi inventory" indicator should be "AMBER"
    When I enter EPI Inventory deliveredQuantity of Row "2" as "5"
    Then Verify "epi inventory" indicator should be "GREEN"
    And I verify saved "epi inventory" values:
      | existingQuantity | deliveredQuantity | spoiledQuantity |
      | 100              | 50                | 100             |
      | 10               | 5                 | 10              |

  @smokeDistribution
  Scenario: User should fill Full Coverage data
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I navigate to "full coverage" tab
    Then Verify "full coverage" indicator should be "RED"
    And I Enter "full coverage" values:
      | femaleHealthCenter | femaleMobileBrigade | maleHealthCenter | maleMobileBrigade |
      | 123                | 22                  | 23               |                   |
    Then Verify "full coverage" indicator should be "AMBER"
    When I enter coverage maleMobileBrigade as "500"
    Then Verify "full coverage" indicator should be "GREEN"
    And I verify saved "full coverage" values:
      | femaleHealthCenter | femaleMobileBrigade | maleHealthCenter | maleMobileBrigade |
      | 123                | 22                  | 23               | 500               |

  @smokeDistribution
  Scenario: User should fill Child Coverage data
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    And I have following ISA values:
      | Program  | Product | whoRatio | dosesPerYear | wastageFactor | bufferPercentage | minimumValue | maximumValue | adjustmentValue |
      | VACCINES | P10     | 10       | 10           | 10            | 10               | null         | null         | 0               |
    And I have following override ISA values:
      | Facility Code | Program  | Product | ISA  |
      | F11           | VACCINES | P11     | 1005 |
    And I update population of facility "F10" as "342"
    And I setup mapping for child coverage
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I navigate to "child coverage" tab
    Then Verify "child coverage" indicator should be "RED"
    And I Enter "child coverage" values:
      | healthCenter11 | outreach11 | healthCenter23 | outreach23 | openedVial |
      | 123            | 22         | 23             | 34         | 4          |
    Then Verify "child coverage" indicator should be "GREEN"
    When I apply NR to healthCenter11Months for rowNumber "12"
    Then Verify "child coverage" indicator should be "GREEN"
    And I apply NR to healthCenter11Months for rowNumber "12"
    Then Verify "child coverage" indicator should be "AMBER"
    When I enter healthCenter11Months for rowNumber "12" as "34"
    Then Verify "child coverage" indicator should be "GREEN"
    And I verify saved "child coverage" values:
      | targetGroup | healthCenter11 | outreach11 | total1 | coverageRate | healthCenter23 | outreach23 | total2 | total3 | openedVial | wastageRate |
      | 34          | 123            | 22         | 145    | 426          | 23             | 34         | 57     | 202    | 4          | -1415       |

  @smokeDistribution
  Scenario: User should fill Adult Coverage data
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    And I update population of facility "F10" as "342"
    And I setup mapping for adult coverage
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I navigate to "adult coverage" tab
    Then Verify "adult coverage" indicator should be "RED"
    And I Enter "adult coverage" values:
      | healthCenter1 | outreach1 | healthCenter25 | outreach25 | openedVial |
      | 123           | 22        | 23             | 34         | 4          |
    Then Verify "adult coverage" indicator should be "GREEN"
    When I apply NR to outreach2To5 for rowNumber "1"
    Then Verify "adult coverage" indicator should be "GREEN"
    And I apply NR to outreach2To5 for rowNumber "1"
    Then Verify "adult coverage" indicator should be "AMBER"
    When I enter outreach2To5 for rowNumber "1" as "31"
    Then Verify "adult coverage" indicator should be "GREEN"
    And I verify saved "adult coverage" values:
      | targetGroup | healthCenter1 | outreach1 | total1 | healthCenter25 | outreach25 | total2 | total3 | coverageRate | openedVial | wastageRate |
      | 1385        | 123           | 22        | 145    | 23             | 31         | 54     | 199    | 14           | 4          | -1967       |

  @smokeDistribution
  Scenario: User should verify facility and sync status when facility was visited
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I update product "P10" to have product group "penta"
    And I have data available for "Multiple" facilities attached to delivery zones
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    And I disassociate "F11" from delivery zone
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    When I record data for distribution "1"
    And I choose facility "F10"
    Then I see Overall facility icon as "AMBER"
    And I see "F10" facility indicator icon as "AMBER"
    And I navigate to "refrigerator" tab
    When I add new refrigerator
    When I enter Brand "LG"
    And I enter Modal "800 LITRES"
    And I enter Serial Number "GR-J287PGHV"
    And I access done
    Then I see Overall facility icon as "RED"
    When I access plan my distribution page
    When I try to sync recorded data
    Then I verify sync message as "No facility for the chosen zone, program and period is ready to be sync"
    When I record data for distribution "1"
    And I choose facility "F10"
    And I navigate to "refrigerator" tab
    When I edit refrigerator
    And I enter refrigerator temperature "3"
    And I verify "Yes" it was working correctly when I left
    And I enter low alarm events "1"
    And I enter high alarm events "0"
    And I verify "No" that there is a problem with refrigerator since last visit
    And I navigate to "visit information" tab
    When I select "yes" facility visited
    And I select visit date as current date
    And I Enter "visit information" values:
     | observations | confirmedByName | confirmedByTitle | verifiedByName | verifiedByTitle |
     |              | samuel          | fc               | Verifier       | XYZ             |
    And I navigate to "epi use" tab
    And I Enter "epi use" values:
      | distributed | expirationDate | loss | received | firstOfMonth | endOfMonth |
      | 16          | 11/2012        | 1    | 10       | 12           |            |
    And I enter EPI end of month as "5"
    And I navigate to "child coverage" tab
    Then Verify "child coverage" indicator should be "RED"
    And I Enter "child coverage" values:
      | healthCenter11 | outreach11 | healthCenter23 | outreach23 | openedVial |
      | 123            | 22         | 23             | 34         | 4          |
    Then Verify "child coverage" indicator should be "GREEN"
    Then I navigate to "full coverage" tab
    And I Enter "full coverage" values:
      | femaleHealthCenter | femaleMobileBrigade | maleHealthCenter | maleMobileBrigade |
      | 123                | 22                  | 23               | 242               |
    Then I navigate to "epi inventory" tab
    And I Enter "epi inventory" values:
      | existingQuantity | deliveredQuantity | spoiledQuantity |
      | 20               | 100               | 5               |
      | 10               | 50                | 3               |
    Then I navigate to "adult coverage" tab
    And I Enter "adult coverage" values:
      | healthCenter1 | outreach1 | healthCenter25 | outreach25 | openedVial |
      | 123           | 22        | 23             | 34         | 4          |
    Then I see Overall facility icon as "GREEN"
    When I access plan my distribution page
    And I sync recorded data
    Then I check confirm sync message as "F10-Village Dispensary"
    When I done sync message
    And I view visit information in DB for facility "F10":
      | observations | confirmedByName | confirmedByTitle | verifiedByName | verifiedByTitle | vehicleId | synced | visited | reasonForNotVisiting | otherReasonDescription |
      | null         | samuel          | fc               | Verifier       | XYZ             | null      | t      | t       | null                 | null                   |
    And I view epi use data in DB for facility "F10" and product group "penta":
      | distributed | expirationDate | loss | received | firstOfMonth | endOfMonth |
      | 16          | 11/2012        | 1    | 10       | 12           | 5          |
    And I view refrigerator readings in DB for refrigerator serial number "GR-J287PGHV" and facility "F10":
      | temperature | functioningCorrectly | lowAlarmEvents | highAlarmEvents | problemSinceLastTime | notes |
      | 3.0         | Y                    | 1              | 0               | N                    | null  |
    And I view full coverage readings in DB for facility "F10":
      | femaleHealthCenter | femaleOutreach | maleHealthCenter | maleOutreach |
      | 123                | 22             | 23               | 242          |
    And I view epi inventory readings in DB for facility "F10" for product "P10":
      | existingQuantity | deliveredQuantity | spoiledQuantity |
      | 20               | 100               | 5               |
    And I view epi inventory readings in DB for facility "F10" for product "P11":
      | existingQuantity | deliveredQuantity | spoiledQuantity |
      | 10               | 50                | 3               |
    And I view child coverage values in DB for facility "F10":
      | healthCenter11 | outreach11 | total1 | coverageRate | healthCenter23 | outreach23 | total2 | total3 | openedVial |
      | 123            | 22         | 145    | 426          | 23             | 34         | 57     | 202    | 4          |
    And I view adult coverage values in DB for facility "F10":
      | healthCenter1 | outreach1 | total1 | healthCenter25 | outreach25 | total2 | total3 | openedVial |
      | 123           | 22        | 145    | 23             | 34         | 57     | 202    | 4          |
    And I verify no record present in refrigerator problem table for refrigerator serial number "GR-J287PGHV" and facility "F10"
    And I see distribution status as synced
    When I view data for distribution "1"
    And I choose facility "F10"
    Then I see Overall facility icon as "BLUE"
    Then I see "visit information" fields disabled
    When I navigate to "epi use" tab
    Then I see "epi use" fields disabled
    When I navigate to "full coverage" tab
    Then I see "full coverage" fields disabled
    When I navigate to "refrigerator" tab
    And I access show
    Then I see "refrigerator" fields disabled
    When I navigate to "child coverage" tab
    Then I see "child coverage" fields disabled
    And I access plan my distribution page
    And I delete already cached data for distribution
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    Then I verify period "Period14" not present
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period13"
    And I initiate distribution
    When I record data for distribution "1"
    And I choose facility "F10"
    Then I see Overall facility icon as "RED"
    And I navigate to "refrigerator" tab
    And I see "Overall" refrigerator icon as "RED"
    And I verify the refrigerator "GR-J287PGHV;LG;800 LITRES" present


  @smokeDistribution
  Scenario: User should verify facility and sync status when facility was not visited
    Given I have the following data for distribution:
      | userSIC       | deliveryZoneCodeFirst | deliveryZoneCodeSecond | deliveryZoneNameFirst | deliveryZoneNameSecond | facilityCodeFirst | facilityCodeSecond | programFirst | programSecond | schedule |
      | storeInCharge | DZ1                   | DZ2                    | Delivery Zone First   | Delivery Zone Second   | F10               | F11                | VACCINES     | TB            | M        |
    And I update product "P10" to have product group "penta"
    And I have data available for "Multiple" facilities attached to delivery zones
    And I disassociate "F11" from delivery zone
    And I assign delivery zone "DZ1" to user "storeInCharge" having role "store in-charge"
    When I am logged in as "storeInCharge"
    And I access plan my distribution page
    And I select delivery zone "Delivery Zone First"
    And I select program "VACCINES"
    And I select period "Period14"
    And I initiate distribution
    And I record data for distribution "1"
    And I choose facility "F10"
    And I verify that I am on visit information page
    Then I see Overall facility icon as "AMBER"
    And I see "F10" facility indicator icon as "AMBER"
    And I navigate to "child coverage" tab
    Then Verify "child coverage" indicator should be "RED"
    And I Enter "child coverage" values:
      | healthCenter11 | outreach11 | healthCenter23 | outreach23 | openedVial |
      | 123            | 22         | 23             | 34         | 4          |
    Then Verify "child coverage" indicator should be "GREEN"
    Then I navigate to "full coverage" tab
    And I Enter "full coverage" values:
      | femaleHealthCenter | femaleMobileBrigade | maleHealthCenter | maleMobileBrigade |
      | 123                | 22                  | 23               | 242               |
    And I navigate to "adult coverage" tab
    And I Enter "adult coverage" values:
      | healthCenter1 | outreach1 | healthCenter25 | outreach25 | openedVial |
      | 123           | 22        | 23             | 34         | 4          |
    And I navigate to "refrigerator" tab
    When I add new refrigerator
    When I enter Brand "LG"
    And I enter Modal "800 LITRES"
    And I enter Serial Number "GR-J287PGHV"
    And I access done
    And I navigate to "visit information" tab
    Then Verify "visit information" indicator should be "RED"
    When I select "no" facility visited
    And I select No Transport reason
    Then Verify "visit information" indicator should be "GREEN"
    Then I see Overall facility icon as "GREEN"
    And Verify "refrigerator" indicator should be "GREEN"
    And Verify "epi inventory" indicator should be "GREEN"
    And Verify "epi use" indicator should be "GREEN"
    When I navigate to "epi inventory" tab
    Then I see "epi inventory" fields disabled
    When I navigate to "epi use" tab
    Then I see "epi use" fields disabled
    When I navigate to "refrigerator" tab
    And I access show
    Then I see "refrigerator" fields disabled
    And I see Overall facility icon as "GREEN"
    When I access plan my distribution page
    And I sync recorded data
    And I check confirm sync message as "F10-Village Dispensary"
    And I done sync message
    And I view visit information in DB for facility "F10":
      | observations | confirmedByName | confirmedByTitle | verifiedByName | verifiedByTitle | vehicleId | synced | visited | reasonForNotVisiting  | otherReasonDescription |
      | null         | null            | null             | null           | null            | null      | t      | f       | TRANSPORT_UNAVAILABLE | null                   |
    And I view epi use data in DB for facility "F10" and product group "penta":
      | distributed | expirationDate | loss | received | firstOfMonth | endOfMonth |
      | null        | null           | null | null     | null         | null       |
    And I view full coverage readings in DB for facility "F10":
      | femaleHealthCenter | femaleOutreach | maleHealthCenter | maleOutreach |
      | 123                | 22             | 23               | 242          |
    And I view epi inventory readings in DB for facility "F10" for product "P10":
      | existingQuantity | deliveredQuantity | spoiledQuantity |
      | null             | null              | null            |
    And I view epi inventory readings in DB for facility "F10" for product "P11":
      | existingQuantity | deliveredQuantity | spoiledQuantity |
      | null             | null              | null            |
    And I view child coverage values in DB for facility "F10":
      | healthCenter11 | outreach11 | total1 | coverageRate | healthCenter23 | outreach23 | total2 | total3 | openedVial |
      | 123            | 22         | 145    | 426          | 23             | 34         | 57     | 202    | 4          |
    And I view adult coverage values in DB for facility "F10":
      | healthCenter1 | outreach1 | total1 | healthCenter25 | outreach25 | total2 | total3 | openedVial |
      | 123           | 22        | 145    | 23             | 34         | 57     | 202    | 4          |
    And I see distribution status as synced
    When I view data for distribution "1"
    And I choose facility "F10"
    Then I see Overall facility icon as "BLUE"
    Then I see "visit information" fields disabled
    When I navigate to "epi use" tab
    Then I see "epi use" fields disabled
    When I navigate to "full coverage" tab
    Then I see "full coverage" fields disabled
    When I navigate to "refrigerator" tab
    And I access show
    Then I see "refrigerator" fields disabled
    When I navigate to "child coverage" tab
    Then I see "child coverage" fields disabled