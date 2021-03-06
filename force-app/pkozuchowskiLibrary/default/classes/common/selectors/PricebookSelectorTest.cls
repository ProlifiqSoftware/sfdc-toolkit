/**
* MIT License
*
* Copyright (c) 2018 Piotr Kożuchowski
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/
@IsTest
private class PricebookSelectorTest {

    @TestSetup
    static void testSetup() {
        insert new List<Pricebook2>{
                new Pricebook2(Name = 'Test Pricebook 0', IsActive = true),
                new Pricebook2(Name = 'Test Pricebook 1', IsActive = true),
                new Pricebook2(Name = 'Test Pricebook 2', IsActive = true),
                new Pricebook2(Name = 'Test Pricebook 3', IsActive = false)
        };
    }


    /**
     * Standard pricebook Id value in unit test context should be the same as Test.getStandardPricebookId() call result.
     */
    @IsTest
    static void testSelectStandardPricebookId() {
        System.assertEquals(
                Test.getStandardPricebookId(),
                new PricebookSelector().selectStandardPricebookId()
        );
    }

    @IsTest
    static void testSelectById() {
        Pricebook2 actual = [SELECT Id FROM Pricebook2 WHERE Name = 'Test Pricebook 0'];
        Pricebook2 expected = new PricebookSelector().selectById(actual.Id);

        System.assertEquals(actual.Id, expected.Id);
    }

    @IsTest
    static void testSelectByIds() {
        Map<Id, Pricebook2> actual = new Map<Id, Pricebook2>([
                SELECT Id
                FROM Pricebook2
                WHERE Name IN ('Test Pricebook 0', 'Test Pricebook 1')
        ]);
        Map<Id, Pricebook2> expected = new Map<Id, Pricebook2>(
                new PricebookSelector().selectByIds(actual.keySet())
        );

        System.assertEquals(actual.keySet(), expected.keySet());
    }

    @IsTest
    static void testSelectByName() {
        Pricebook2 actual = [SELECT Id FROM Pricebook2 WHERE Name = 'Test Pricebook 0'];
        Pricebook2 expected = new PricebookSelector().selectByName('Test Pricebook 0');

        System.assertEquals(actual.Id, expected.Id);
    }

    @IsTest
    static void testSelectByNames() {
        Map<Id, Pricebook2> actual = new Map<Id, Pricebook2>([
                SELECT Id
                FROM Pricebook2
                WHERE Name IN ('Test Pricebook 0', 'Test Pricebook 1')
        ]);
        Map<Id, Pricebook2> expected = new Map<Id, Pricebook2>(
                new PricebookSelector().selectByNames(new Set<String>{
                        'Test Pricebook 0', 'Test Pricebook 1'
                })
        );

        System.assertEquals(actual.keySet(), expected.keySet());
    }

    @IsTest
    static void testSelectorReturnsNullWhenPricebookIsNotFound() {
        System.assertEquals(null, new PricebookSelector().selectByName('Other'));
    }

    @IsTest
    static void testSelectorQueriesOnlyActivePricebooks() {
        Pricebook2 inactivePricebook = [SELECT Id,Name FROM Pricebook2 WHERE IsActive = FALSE LIMIT 1];

        System.assertEquals(null, new PricebookSelector().selectById(inactivePricebook.Id));
        System.assertEquals(null, new PricebookSelector().selectByName(inactivePricebook.Name));
    }
}