/*
 * This program was produced for the U.S. Agency for International Development. It was prepared by the USAID | DELIVER PROJECT, Task Order 4. It is part of a project which utilizes code originally licensed under the terms of the Mozilla Public License (MPL) v2 and therefore is licensed under MPL v2 or later.
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the Mozilla Public License as published by the Mozilla Foundation, either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Mozilla Public License for more details.
 *
 * You should have received a copy of the Mozilla Public License along with this program. If not, see http://www.mozilla.org/MPL/
 */

package org.openlmis.extension.pageobjects;

import com.thoughtworks.selenium.SeleneseTestNgHelper;
import org.openlmis.UiUtils.TestWebDriver;
import org.openlmis.pageobjects.Page;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.How;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.pagefactory.AjaxElementLocatorFactory;

import java.io.IOException;


public class ManageSupervisoryNodesPage extends Page {

    @FindBy(how=How.XPATH,using="//input[@value='Save']")
    private static WebElement saveButton;

    @FindBy(how=How.ID, using="code")
    private static WebElement supervisoryNodeCodeField;

    @FindBy(how=How.ID, using="name")
    private static WebElement supervisoryNodeNameField;

    @FindBy(how=How.XPATH, using="//select[@ng-model='supervisoryNode.parent.id']")
    private static WebElement supervisoryNodeParentField;

    @FindBy(how=How.ID, using="description")
    private static WebElement supervisoryNodeDescriptionField;


    @FindBy(how= How.ID, using="supervisory-node-add-new")
    private static WebElement addSupervisoryNodeButton;

    @FindBy(how=How.XPATH, using = "//div[@id='saveSuccessMessageDiv']/span")
    private static WebElement saveSuccessMessage;

    @FindBy(how=How.XPATH, using = "//div[@id='saveErrorMsgDiv']")
    private static WebElement saveErrorMessage;


    @FindBy(how=How.ID, using = "supervisory-node-facility-add-new")
    private static WebElement chooseFacilityButton;

    @FindBy(how=How.ID, using = "facilityValue")
    private static WebElement associatedFacilityField;

    @FindBy(how = How.ID, using = "//input[@value='Close']")
    private static WebElement closeFacilityDialogButton;


    public ManageSupervisoryNodesPage(TestWebDriver driver) throws IOException {
        super(driver);
        PageFactory.initElements(new AjaxElementLocatorFactory(TestWebDriver.getDriver(),10),this);
        testWebDriver.setImplicitWait(10);
    }

    public void EnterAndVerifyNewSupervisoryNode(String code, String name, String supervisoryNodeParentID, String description,String facilityId){
        testWebDriver.waitForElementToAppear(addSupervisoryNodeButton);
        addSupervisoryNodeButton.click();
        testWebDriver.waitForElementToAppear(supervisoryNodeCodeField);

        supervisoryNodeCodeField.clear();
        supervisoryNodeCodeField.sendKeys(code);
        supervisoryNodeNameField.clear();
        supervisoryNodeNameField.sendKeys(name);
        testWebDriver.selectByValue(supervisoryNodeParentField, supervisoryNodeParentID);
        supervisoryNodeDescriptionField.clear();
        supervisoryNodeDescriptionField.sendKeys(description);

        testWebDriver.waitForElementToAppear(chooseFacilityButton);
        chooseFacilityButton.click();
        testWebDriver.waitForElementToAppear(associatedFacilityField);
        testWebDriver.selectByValue(associatedFacilityField, facilityId);

        testWebDriver.waitForElementToAppear(closeFacilityDialogButton);
        closeFacilityDialogButton.click();

        testWebDriver.waitForElementToAppear(saveButton);
        saveButton.click();

        testWebDriver.sleep(1500);

        SeleneseTestNgHelper.assertTrue("Supervisory node '" + name + "' has been successfully created message is not showing up.",saveSuccessMessage.isDisplayed());
    }

    public void EnterAndVerifyNewSupervisoryNodeWOFacility(String code, String name, String supervisoryNodeParentID, String description){
        testWebDriver.waitForElementToAppear(addSupervisoryNodeButton);
        addSupervisoryNodeButton.click();
        testWebDriver.waitForElementToAppear(supervisoryNodeCodeField);

        supervisoryNodeCodeField.clear();
        supervisoryNodeCodeField.sendKeys(code);
        supervisoryNodeNameField.clear();
        supervisoryNodeNameField.sendKeys(name);
        testWebDriver.selectByValue(supervisoryNodeParentField, supervisoryNodeParentID);
        supervisoryNodeDescriptionField.clear();
        supervisoryNodeDescriptionField.sendKeys(description);

        testWebDriver.waitForElementToAppear(saveButton);
        saveButton.click();

        testWebDriver.sleep(1500);

        SeleneseTestNgHelper.assertTrue("Error message is not showing up for empty facility.",saveErrorMessage.isDisplayed());
    }

    public void EnterAndVerifyNewSupervisoryNodeWONameAndCode(String supervisoryNodeParentID, String description,String facilityId){
        testWebDriver.waitForElementToAppear(addSupervisoryNodeButton);
        addSupervisoryNodeButton.click();
        testWebDriver.waitForElementToAppear(supervisoryNodeCodeField);

        testWebDriver.selectByValue(supervisoryNodeParentField, supervisoryNodeParentID);
        supervisoryNodeDescriptionField.clear();
        supervisoryNodeDescriptionField.sendKeys(description);

        testWebDriver.waitForElementToAppear(chooseFacilityButton);
        chooseFacilityButton.click();
        testWebDriver.waitForElementToAppear(associatedFacilityField);
        testWebDriver.selectByValue(associatedFacilityField, facilityId);

        testWebDriver.waitForElementToAppear(closeFacilityDialogButton);
        closeFacilityDialogButton.click();

        testWebDriver.waitForElementToAppear(saveButton);
        saveButton.click();

        testWebDriver.sleep(1500);

        SeleneseTestNgHelper.assertTrue("Error message is not showing up for empty code and name.",saveErrorMessage.isDisplayed());
    }
}