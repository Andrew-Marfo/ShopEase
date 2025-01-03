USE shop_ease_new;

-- Lab exercise 5.1
DELIMITER //

CREATE TRIGGER update_inventory
AFTER INSERT ON order_Items
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Get the current stock quantity of the ordered product
    SELECT stock_quantity INTO current_stock
    FROM inventory
    WHERE product_id = NEW.product_id;

    -- Check if the stock is sufficient
    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for product';
    ELSE
        -- Decrease the inventory count by the ordered quantity
        UPDATE inventory
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END //

DELIMITER ;

-- Lab exercise 5.2

DELIMITER //

CREATE PROCEDURE UpdateCustomerStatus(IN cust_id INT)
BEGIN
    DECLARE total_order_value DECIMAL(10, 2);

    -- Calculate the total order value for the customer
    SELECT SUM(total_revenue) INTO total_order_value
    FROM sales_data
    WHERE customer_id = cust_id;

    -- Update customer status based on total order value
    IF total_order_value > 10000 THEN
        UPDATE customers
        SET customer_status = 'VIP'
        WHERE customer_id = cust_id;
    ELSE
        UPDATE customers
        SET customer_status = 'Regular'
        WHERE customer_id = cust_id;
    END IF;
END //

DELIMITER ;