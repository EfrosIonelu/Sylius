@managing_product_variants
Feature: Product variant validation
    In order to avoid making mistakes when managing a product variant
    As an Administrator
    I want to be prevented from adding it without specifying required fields

    Background:
        Given the store operates on a single channel in "United States"
        And the store has a "Wyborowa Vodka" configurable product
        And I am logged in as an administrator

    @api @ui
    Scenario: Adding a new product variant without specifying its price
        When I want to create a new variant of this product
        And I specify its code as "VODKA_WYBOROWA_PREMIUM"
        But I do not set its price
        And I try to add it
        Then I should be notified that prices in all channels must be defined
        And the "VODKA_WYBOROWA_PREMIUM" variant of the "Wyborowa Vodka" product should not appear in the store

    @api @ui
    Scenario: Adding a new product variant with price below 0
        When I want to create a new variant of this product
        And I specify its code as "VODKA_WYBOROWA_PREMIUM"
        And I set its price to "-$60.00" for "United States" channel
        And I try to add it
        Then I should be notified that price cannot be lower than 0
        And the "VODKA_WYBOROWA_PREMIUM" variant of the "Wyborowa Vodka" product should not appear in the store

    @api @ui
    Scenario: Adding a new product variant without specifying its code
        When I want to create a new variant of this product
        And I set its price to "$80.00" for "United States" channel
        But I do not specify its code
        And I try to add it
        Then I should be notified that code is required
        And the "Wyborowa Vodka" product should have no variants

    @api @ui
    Scenario: Adding a new product variant with duplicated code
        Given this product has "Wyborowa Exquisite" variant priced at "$90.00" identified by "VODKA_WYBOROWA_PREMIUM"
        When I want to create a new variant of this product
        And I set its price to "$80.00" for "United States" channel
        And I specify its code as "VODKA_WYBOROWA_PREMIUM"
        And I try to add it
        Then I should be notified that code has to be unique
        And the "Wyborowa Vodka" product should have only one variant

    @api @ui
    Scenario: Adding a new product variant with same set of options
        Given this product has option "Taste" with values "Orange" and "Melon"
        And this product is available in "Melon" taste priced at "$95.00"
        When I want to create a new variant of this product
        And I specify its code as "VODKA_WYBOROWA_PREMIUM"
        And I set its "Taste" option to "Melon"
        And I set its price to "$100.00" for "United States" channel
        And I try to add it
        Then I should be notified that this variant already exists
        And the "Wyborowa Vodka" product should have only one variant

    @api @no-ui
    Scenario: Adding a new product variant with two values of the same option
        Given this product has option "Taste" with values "Orange" and "Melon"
        When I want to create a new variant of this product
        And I specify its code as "VODKA_WYBOROWA_PREMIUM"
        And I set its "Taste" option to "Orange"
        And I set its "Taste" option to "Melon"
        And I set its price to "$100.00" for "United States" channel
        And I try to add it
        Then I should be notified that the variant can have only one value configured for a single option
        And the "Wyborowa Vodka" product should have no variants

    @api @ui
    Scenario: Adding a new product variant with negative properties
        When I want to create a new variant of this product
        And I specify its code as "VODKA_WYBOROWA_PREMIUM"
        And I set its price to "$100.00" for "United States" channel
        And I set its height, width, depth and weight to "-1"
        And I try to add it
        Then I should be notified that height, width, depth and weight cannot be lower than 0
        And the "VODKA_WYBOROWA_PREMIUM" variant of the "Wyborowa Vodka" product should not appear in the store

    @api @ui
    Scenario: Adding a new product variant without current stock
        When I want to create a new variant of this product
        And I specify its code as "VODKA_WYBOROWA_PREMIUM"
        And I set its price to "$100.00" for "United States" channel
        But I do not specify its current stock
        And I try to add it
        Then I should be notified that current stock is required
        And the "VODKA_WYBOROWA_PREMIUM" variant of the "Wyborowa Vodka" product should not appear in the store
