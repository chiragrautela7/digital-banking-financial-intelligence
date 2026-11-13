-- ============================================================
-- PHASE 9: Transactions + Indexes + EXPLAIN
-- ============================================================
USE digital_banking;

-- 1. Check current indexes
SHOW INDEX FROM customers;
SHOW INDEX FROM accounts;
SHOW INDEX FROM transactions;
SHOW INDEX FROM loans;

-- 2. Baseline execution plan
EXPLAIN
SELECT a.customer_id, SUM(t.amount) AS total_transaction_value
FROM accounts a
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY a.customer_id;

-- 3. Add indexes on frequently filtered/joined columns.
-- PKs and UNIQUE constraints already create indexes automatically.
CREATE INDEX idx_transactions_account_id
    ON transactions(account_id);

CREATE INDEX idx_transactions_status_date
    ON transactions(transaction_status, transaction_date);

CREATE INDEX idx_loans_customer_id
    ON loans(customer_id);

CREATE INDEX idx_loan_payments_loan_id
    ON loan_payments(loan_id);

CREATE INDEX idx_support_customer_id
    ON support_tickets(customer_id);

-- 4. Inspect indexes after creation
SHOW INDEX FROM transactions;
SHOW INDEX FROM loans;
SHOW INDEX FROM loan_payments;
SHOW INDEX FROM support_tickets;

-- 5. Compare the execution plan after indexing
EXPLAIN
SELECT a.customer_id, SUM(t.amount) AS total_transaction_value
FROM accounts a
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY a.customer_id;

-- 6. Transaction example: transfer money between accounts safely.
-- Demo only. Always test in a development database first.
START TRANSACTION;

UPDATE accounts
SET balance = balance - 10000
WHERE account_id = 1001
  AND balance >= 10000;

UPDATE accounts
SET balance = balance + 10000
WHERE account_id = 1002;

-- Verify both affected balances before COMMIT.
SELECT account_id, balance
FROM accounts
WHERE account_id IN (1001, 1002);

-- If the checks are correct:
COMMIT;

-- If something is wrong instead, use:
-- ROLLBACK;
