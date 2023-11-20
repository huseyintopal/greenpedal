import { LightningElement, wire } from 'lwc';
import getCategories from '@salesforce/apex/CategoryController.getCategories';
import getProductsOrSubcategories from '@salesforce/apex/CategoryController.getProductsOrSubcategories';

export default class ProductCategoriesComponent extends LightningElement {
  categories = [];
  products = [];
  subcategories = [];

  @wire(getCategories)
  wiredCategories({ data, error }) {
    if (data) {
      this.categories = data;
    } else if (error) {
      console.error('Error fetching categories:', error);
    }
  }

  // Handle category selection
  handleCategorySelection(event) {
    const categoryId = event.currentTarget.dataset.categoryid;
    console.log('after handlecategoryselection');

    getProductsOrSubcategories({ categoryId })
      .then(result => {
        if (result.products) {
          this.products = result.products;
        }
        if (result.subcategories) {
          this.subcategories = result.subcategories;
        }
      })
      .catch(error => {
        console.error('Error fetching products or subcategories:', error);
      });
  }
}