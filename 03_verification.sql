-- ============================================================
-- Phase 4: Data Verification
-- ============================================================
USE digital_banking;

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'branches', COUNT(*) FROM branches
UNION ALL SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL SELECT 'loans', COUNT(*) FROM loans
UNION ALL SELECT 'loan_payments', COUNT(*) FROM loan_payments
UNION ALL SELECT 'credit_cards', COUNT(*) FROM credit_cards
UNION ALL SELECT 'support_tickets', COUNT(*) FROM support_tickets;

SELECT * FROM customers LIMIT 10;
SELECT * FROM accounts LIMIT 10;
SELECT * FROM transactions LIMIT 10;
SELECT * FROM loans LIMIT 10;

-- Foreign-key integrity checks: expected result = 0
SELECT COUNT(*) AS invalid_accounts
FROM accounts a
LEFT JOIN customers c ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS invalid_transactions
FROM transactions t
LEFT JOIN accounts a ON t.account_id = a.account_id
WHERE a.account_id IS NULL;

SELECT COUNT(*) AS invalid_loans
FROM loans l
LEFT JOIN customers c ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS invalid_loan_payments
FROM loan_payments lp
LEFT JOIN loans l ON lp.loan_id = l.loan_id
WHERE l.loan_id IS NULL;

-- Business-state NULL check: unresolved tickets legitimately have no resolution date.
SELECT ticket_id, ticket_status, resolution_date, satisfaction_score
FROM support_tickets
WHERE resolution_date IS NULL;
