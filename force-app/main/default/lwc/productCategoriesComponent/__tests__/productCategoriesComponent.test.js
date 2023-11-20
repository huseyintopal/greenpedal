import { createElement } from 'lwc';
import ProductCategoriesComponent from 'c/productCategoriesComponent';

describe('c-product-categories-component', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('displays categories', () => {
        // Arrange
        const element = createElement('c-product-categories-component', {
            is: ProductCategoriesComponent
        });

        // Act
        document.body.appendChild(element);

        // Assert
        const categories = element.shadowRoot.querySelectorAll('a');
        expect(categories.length).toBeGreaterThan(0);
        // You can add more assertions to test the actual behavior of your component.
    });
});
