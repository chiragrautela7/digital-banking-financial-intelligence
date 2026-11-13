-- ============================================================
-- Digital Banking & Financial Intelligence Analytics
-- Schema Creation
-- MySQL 8+
-- ============================================================

DROP DATABASE IF EXISTS digital_banking;
CREATE DATABASE digital_banking;
USE digital_banking;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    customer_since DATE NOT NULL,
    customer_segment VARCHAR(20) NOT NULL,
    CONSTRAINT chk_customer_gender CHECK (gender IN ('Male','Female','Other')),
    CONSTRAINT chk_customer_segment CHECK (customer_segment IN ('Regular','Premium','VIP'))
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    branch_type VARCHAR(20) NOT NULL DEFAULT 'Regular',
    CONSTRAINT chk_branch_type CHECK (branch_type IN ('Regular','Premium','Digital'))
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    opening_date DATE NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    account_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_account_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_account_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    CONSTRAINT chk_account_type CHECK (account_type IN ('Savings','Current','Salary')),
    CONSTRAINT chk_account_balance CHECK (balance >= 0),
    CONSTRAINT chk_account_status CHECK (account_status IN ('Active','Inactive','Closed'))
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL DEFAULT 'Successful',
    channel VARCHAR(20) NOT NULL,
    description VARCHAR(150),
    CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    CONSTRAINT chk_transaction_type CHECK (transaction_type IN ('Deposit','Withdrawal','Transfer','Payment')),
    CONSTRAINT chk_transaction_amount CHECK (amount > 0),
    CONSTRAINT chk_transaction_status CHECK (transaction_status IN ('Successful','Failed','Pending')),
    CONSTRAINT chk_transaction_channel CHECK (channel IN ('ATM','Online','Mobile','Branch'))
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_type VARCHAR(30) NOT NULL,
    loan_amount DECIMAL(12,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    loan_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_loan_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_loan_type CHECK (loan_type IN ('Personal','Home','Auto','Education')),
    CONSTRAINT chk_loan_amount CHECK (loan_amount > 0),
    CONSTRAINT chk_interest_rate CHECK (interest_rate >= 0),
    CONSTRAINT chk_loan_status CHECK (loan_status IN ('Active','Closed','Defaulted'))
);

CREATE TABLE loan_payments (
    payment_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Paid',
    payment_method VARCHAR(20) NOT NULL,
    CONSTRAINT fk_payment_loan FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    CONSTRAINT chk_payment_amount CHECK (payment_amount > 0),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('Paid','Late','Missed')),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Online','Auto Debit','Branch'))
);

CREATE TABLE credit_cards (
    card_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    card_type VARCHAR(20) NOT NULL,
    credit_limit DECIMAL(12,2) NOT NULL,
    issue_date DATE NOT NULL,
    current_balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    card_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_card_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_card_type CHECK (card_type IN ('Classic','Gold','Platinum')),
    CONSTRAINT chk_credit_limit CHECK (credit_limit > 0),
    CONSTRAINT chk_card_balance CHECK (current_balance >= 0),
    CONSTRAINT chk_card_status CHECK (card_status IN ('Active','Blocked','Expired')),
    CONSTRAINT chk_balance_limit CHECK (current_balance <= credit_limit)
);

CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    ticket_date DATE NOT NULL,
    issue_category VARCHAR(40) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    resolution_date DATE,
    ticket_status VARCHAR(20) NOT NULL DEFAULT 'Open',
    satisfaction_score INT,
    CONSTRAINT fk_ticket_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_ticket_priority CHECK (priority IN ('Low','Medium','High')),
    CONSTRAINT chk_ticket_status CHECK (ticket_status IN ('Open','In Progress','Resolved','Closed')),
    CONSTRAINT chk_satisfaction CHECK (satisfaction_score BETWEEN 1 AND 5)
);
