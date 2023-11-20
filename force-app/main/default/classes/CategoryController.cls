public with sharing class CategoryController {
    @AuraEnabled(cacheable=true)
    public static List<Category__c> getCategories() {
        // Query for categories based on your specific object and field names
        return [SELECT Id, Name FROM Category__c ORDER BY Sequence__c];
    }
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getProductsOrSubcategories(String categoryId) {
        // Your logic to retrieve and return products or subcategories based on the categoryId goes here
        Map<String, Object> result = new Map<String, Object>();
        result.put('products', 'Mountain bike');
    result.put('subcategories', 'Bikes');

    return result;
    }
}