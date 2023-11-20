public without sharing class ProductCategoriesController {

  @AuraEnabled(cacheable=true)
  public static List<Category__c> getCategories(){
    return [SELECT Id, Name, ParentCategory__c FROM Category__c];
  }

  /* TODO: Create Category Tree for using LWC Tree Grid component to display categories 
   Below part is out of scenario 
  @AuraEnabled(cacheable=true)
  public static List<CategoryTreeNode> getCategoryTree() {
    List<CategoryTreeNode> categoryTree = new List<CategoryTreeNode>();
    Map<Id, CategoryTreeNode> categoryMap = new Map<Id, CategoryTreeNode>();

    // Query all categories
    List<Category__c> allCategories = [
      SELECT Id, name, parentCategory__c
      FROM Category__c
      ORDER BY parentCategory__c NULLS FIRST

    ];
  

    // Create top-level nodes and populate the map
    for (Category__c category : allCategories) {
      CategoryTreeNode node = new CategoryTreeNode(category.id, category.name, category.parentCategory__c);
      categoryMap.put(category.Id, node);
      if (category.ParentCategory__c == null) {
        categoryTree.add(node);
      }
    }

    // Build the hierarchy
    for (Category__c category : allCategories) {
      if (category.ParentCategory__c != null) {
        CategoryTreeNode parentNode = categoryMap.get(
          category.ParentCategory__c
        );
        if (parentNode != null) {
          CategoryTreeNode childNode = categoryMap.get(category.Id);
          if (childNode != null) {
            parentNode.children.add(childNode);
          }
        }
      }
    }

    return categoryTree;
  }



  public class CategoryTreeNode {
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String parentcategoryid;
    @AuraEnabled
    public List<CategoryTreeNode> children;

    public CategoryTreeNode(String id, String name, string parentcategoryid) {
      this.id = id;
      this.name = name;
      this.parentcategoryid = parentcategoryid;
      this.children = new List<CategoryTreeNode>();
    }
  }*/
}