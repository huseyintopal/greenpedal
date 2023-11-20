public class ProductController {
 /*   public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
        @AuraEnabled
        public String[] categories { get; set; }
    }*/

    public class ProductTile {
        @AuraEnabled
        public Product_Category__c product { get; set; }
        @AuraEnabled
        public Product2 product2 { get; set; }
        @AuraEnabled
        public String imageUrlHero { get; set; }
        @AuraEnabled
        public Double price { get; set; }
        @AuraEnabled
        public Boolean outOfStock{ get; set; }
        @AuraEnabled
        public String productLink { get; set; }
        @AuraEnabled
        public String quantity { get; set; }
        @AuraEnabled
        public Set<String> imageUrls { get; set; }
        @AuraEnabled
        public String shortDescription { get; set; }
    }

    @AuraEnabled(Cacheable=true scope='global')
    public static List<ProductTile> getProducts(String[] categoriesToFilter) {
       // System.debug('searchKey: ' + searchKey);
        System.debug('categoriesToFilter: ' + categoriesToFilter);
        List<ProductTile> result = new List<ProductTile>();
        List<Product_Category__c> products = getProductInfo(categoriesToFilter);
        Set<Id> productIds = getProductIDs (products);
        Map<Id, Double> listPriceMapByProductId = getPricesByProductId(productIds);
       // Map<Id, Double> discountMapByOfferId = getdiscountMapByOfferId (offersWithRelatedObj, listPriceMapByProductId);
        Map<Id, String> imageUrlMapByProductId = getImageUrlMapByProductId(productIds);
        String myDomain = Url.getOrgDomainUrl().toExternalForm();

        for (Product_Category__c product:products){
            String productLink = myDomain + '/lightning/r/Product2/' + product.Product__c + '/view';

            ProductTile productInfo = new ProductTile();
            productInfo.product = product;            
            productInfo.imageUrlHero = imageUrlMapByProductId.get(product.Product__c);
            productInfo.price = listPriceMapByProductId.get(product.Product__c);
            productInfo.outOfStock = product.Product__r.RemainingQuantity__c == 0 || product.Product__r.RemainingQuantity__c == null;
            productInfo.productLink = productLink;
            result.add(productInfo);
        }
        System.debug('Result : ' + result);
        return result;
    }

    @AuraEnabled(Cacheable=true scope='global')
    public static List<ProductTile> getProductsOnLoad() { 
        return getProducts(null);
    }

    /* Product Detail Page */
    @AuraEnabled(cacheable=true)
    public static ProductTile getProductDetails(Id recordId){
        ProductTile productInfo = new ProductTile();

        // get Product Info
        productInfo.product2 = getProductInfo(recordId)[0];
        // get Image URLs    
        productInfo.imageUrls = getAllRelatedImages(recordId); 


        // get Product Price
        return productInfo;             
    }

    private static Set<String> getAllRelatedImages(Id recordId){
        Set<String> imageUrls = new Set<String>();
        for(ProductImage__c image: [SELECT Product__c, Type__c, ResourceURL__c
                                    FROM ProductImage__c
                                    WHERE Product__c =: recordId]){
            if (String.isNotBlank(image.ResourceURL__c)){
                imageUrls.add(image.ResourceURL__c);                             
            }
        }    
        return imageUrls;                 
    }

    private static List<Product2> getProductInfo(Id recordId){
        System.debug('product Id: ' + recordId);
        return [SELECT Name, Description, RemainingQuantity__c
                FROM Product2
                WHERE Id =:recordId
                LIMIT 1];
    }

    private static List<Product_Category__c> getProductInfo (String[] categoriesToFilter){
        String key, whereClause = '';
        String [] criteria = new List<String>{};
        //System.debug('searchKey: ' + searchKey);
        System.debug('categoriesToFilter: ' + categoriesToFilter);
/*
            if (String.isNotEmpty(searchKey)){
                key = '%' + searchKey + '%';
                criteria.add('(Product__r.Name LIKE :key OR Category__r.Name LIKE :key)');
            }*/
            if (categoriesToFilter != null && categoriesToFilter.size() > 0) {
                criteria.add('Category__c IN :categoriesToFilter');
            }
            if (criteria.size() > 0) {
                whereClause = ' WHERE ' + String.join(criteria, ' AND ');
            }
        

        System.debug('WHERE Clause: ' + whereClause);

          return Database.query(
            'SELECT Id, Name, Category__c, Category__r.Name, Product__c, Product__r.Name, Product__r.Description, Product__r.RemainingQuantity__c ' +
            'FROM ProductCategory__c' +
            whereClause +
            ' ORDER BY Name LIMIT 100');
    }


    private static Set<Id> getProductIDs (List<Product_Category__c> products){
        Set<Id> productIds = new Set<Id> ();
        for(Product_Category__c product:products){
            productIds.add(product.Product__c);
        }
        return productIds;
    }

    private static Map<Id, Double> getPricesByProductId (Set<Id> productIds){
        Map<Id, Double> listPriceMapByProductId = new Map<Id, Double>();
        for(PricebookEntry pbe:[SELECT IsActive, Product2Id, UnitPrice, UseStandardPrice, Pricebook2Id, Pricebook2.IsStandard
                                FROM PricebookEntry
                                WHERE IsActive = TRUE 
                                AND Product2Id IN :productIds
                                AND Pricebook2.IsStandard = TRUE 
                                AND UnitPrice > 0])
        {
            listPriceMapByProductId.put(pbe.Product2Id, pbe.UnitPrice);
        }
        return listPriceMapByProductId;
    }

    private static Map<Id, String> getImageUrlMapByProductId (Set<Id> productIds) {
        Map<Id, String> imageUrlMapByProductId = new  Map<Id, String> ();
        for(ProductImage__c img:[SELECT Product__c, Type__c, ResourceURL__c
                                    FROM ProductImage__c
                                    WHERE Product__c IN :productIds]) {

            imageUrlMapByProductId.put(img.Product__c, img.ResourceURL__c);
        }
        return imageUrlMapByProductId;
    }
}