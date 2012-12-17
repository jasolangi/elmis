INSERT INTO master_rnr_columns
( id ,  name                           ,  position  ,                         label                                  , source         , sourceConfigurable         ,                        formula                           , indicator          , used       ,  visible      , mandatory    ,  description)
VALUES
(  1 , 'productCode'                   ,          1 , 'Product Code'                                                 ,'R'             , false                      , ''                                                       , 'O'                , true       , true          , true         , 'Unique identifier for each commodity'                                                                            ),
(  2 , 'product'                       ,          2 , 'Product'                                                      ,'R'             , false                      , ''                                                       , 'R'                , true       , true          , true         , 'Primary name of the product'                                                                                     ),
(  3 , 'unitOfIssue'                   ,          3 , 'Unit/Unit of Issue'                                           ,'R'             , false                      , ''                                                       , 'U'                , true       , true          , true         , 'Dispensing unit for this product'                                                                                ),
(  4 , 'beginningBalance'              ,          4 , 'Beginning Balance'                                            ,'U'             , false                      , ''                                                       , 'A'                , true       , true          , false        , 'Stock in hand of previous period.This is quantified in dispensing units'                                         ),
(  5 , 'quantityReceived'              ,          5 , 'Total Received Quantity'                                      ,'U'             , false                      , ''                                                       , 'B'                , true       , true          , false        , 'Total quantity received in last period.This is quantified in dispensing units'                                   ),
(  6 , 'quantityDispensed'             ,          6 , 'Total Consumed Quantity'                                      ,'U'             , true                       , 'A + B (+/-) D - E'                                      , 'C'                , true       , true          , false        , 'Quantity dispensed/consumed in last reporting  period. This is quantified in dispensing units'                   ),
(  7 , 'lossesAndAdjustments'          ,          7 , 'Total Losses / Adjustments'                                   ,'U'             , false                      , 'D1 + D2+D3...DN'                                        , 'D'                , true       , true          , false        , 'All kind of looses/adjustments made at the facility'                                                             ),
(  8 , 'reasonForLossesAndAdjustments' ,          8 , 'Reason for Losses and Adjustments'                            ,'U'             , false                      , ''                                                       , 'S'                , true       , true          , false        , 'Type of Losses/adjustments'                                                                                      ),
(  9 , 'stockInHand'                   ,          9 , 'Stock on Hand'                                                ,'C'             , true                       , 'A+B(+/-)D-C'                                            , 'E'                , true       , true          , false        , 'Current physical count of stock on hand. This is quantified in dispensing units'                                 ),
( 10 , 'newPatientCount'               ,         10 , 'Total number of new patients added to service on the program' ,'U'             , false                      , ''                                                       , 'F'                , true       , true          , false        , 'Total of new patients introduced'                                                                                ),
( 11 , 'stockOutDays'                  ,         11 , 'Total Stockout days'                                          ,'U'             , false                      , ''                                                       , 'X'                , true       , true          , false        , 'Total number of days facility was out of stock'                                                                  ),
( 12 , 'normalizedConsumption'         ,         12 , 'Adjusted Total Consumption'                                   ,'C'             , false                      , 'C * (M*30)/((M*30)-X) + ( F* No of tabs per month * 1)' , 'N'                , true       , true          , false        , 'Total quantity consumed after adjusting for stockout days. This is quantified in dispensing units'               ),
( 13 , 'amc'                           ,         13 , 'Average Monthly Consumption(AMC)'                             ,'C'             , false                      , '(N/M + Ng-1/M + ...Ng-(g-1)/M)/G'                       , 'P'                , true       , true          , false        , 'Average Monthly consumption, for last three months. This is quantified in dispensing units'                      ),
( 14 , 'maxStockQuantity'              ,         14 , 'Maximum Stock Quantity'                                       ,'C'             , false                      , 'P * MaxMonthsStock'                                     , 'H'                , true       , true          , false        , 'Maximum Stock calculated based on consumption and max months of stock.This is quantified in dispensing units'    ),
( 15 , 'calculatedOrderQuantity'       ,         15 , 'Calculated Order Quantity'                                    ,'C'             , false                      , 'H - E'                                                  , 'I'                , true       , true          , false        , 'Actual Quantity needed after deducting stock in hand. This is quantified in dispensing units'                    ),
( 16 , 'quantityRequested'             ,         16 , 'Requested Quantity'                                           ,'U'             , false                      ,  ''                                                      , 'J'                , true       , true          , false        , 'Requested override of calculated quantity.This is quantified in dispensing units'                                ),
( 17 , 'reasonForRequestedQuantity'    ,         17 , 'Requested Quantity Explanation'                               ,'U'             , false                      ,  ''                                                      , 'W'                , true       , true          , false        , 'Explanation of request for a quantity other than calculated order quantity'                                      ),
( 18 , 'quantityApproved'              ,         18 , 'Approved Quantity'                                            ,'U'             , false                      ,  ''                                                      , 'K'                , true       , true          , false        , 'Final approved quantity. This is quantified in dispensing units'                                                 ),
( 19 , 'packsToShip'                   ,         19 , 'Packs to Ship'                                                ,'C'             , false                      , 'K / U + Rounding rules'                                 , 'V'                , true       , true          , false        , 'Total packs to be shipped based on pack size and applying rounding rules'                                        ),
( 20 , 'price'                         ,         20 , 'Price per pack'                                               ,'R'             , false                      ,  ''                                                      , 'T'                , true       , true          , false        , 'Price per Pack. It defaults to zero if not specified.'                                                           ),
( 21 , 'cost'                          ,         21 , 'Total cost'                                                   ,'C'             , false                      , 'V * T'                                                  , 'Q'                , true       , true          , false        , 'Total cost of the product. This will be zero if price is not defined'                                            ),
( 22 , 'remarks'                       ,         22 , 'Remarks'                                                      ,'U'             , false                      , ''                                                       , 'L'                , true       , true          , false        , 'Any additional remarks'                                                                                          );

