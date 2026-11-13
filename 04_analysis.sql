-- ============================================================
-- Phases 5-8: Analysis
-- Digital Banking & Financial Intelligence Analytics
-- MySQL 8+
-- ============================================================
USE digital_banking;

-- =========================
-- PHASE 5: BASIC ANALYSIS
-- =========================

-- Q1. Total customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Q2. Customer segment distribution
SELECT customer_segment, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- Q3. Customers by state
SELECT state, COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;

-- Q4. Accounts by account type
SELECT account_type, COUNT(*) AS account_count
FROM accounts
GROUP BY account_type
ORDER BY account_count DESC;

-- Q5. Average account balance
SELECT ROUND(AVG(balance), 2) AS average_account_balance
FROM accounts;

-- Q6. Highest account balance
SELECT account_id, customer_id, balance
FROM accounts
ORDER BY balance DESC
LIMIT 5;

-- Q7. Total successful transaction value
SELECT ROUND(SUM(amount), 2) AS total_successful_transaction_value
FROM transactions
WHERE transaction_status = 'Successful';

-- Q8. Transaction count by type
SELECT transaction_type, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_count DESC;

-- Q9. Transaction value by type
SELECT transaction_type, ROUND(SUM(amount), 2) AS transaction_value
FROM transactions
GROUP BY transaction_type
ORDER BY transaction_value DESC;

-- Q10. Successful vs failed transactions
SELECT transaction_status, COUNT(*) AS transaction_count
FROM transactions
GROUP BY transaction_status
ORDER BY transaction_count DESC;

-- Q11. Transaction channel analysis
SELECT channel, COUNT(*) AS transaction_count, ROUND(SUM(amount), 2) AS total_value
FROM transactions
GROUP BY channel
ORDER BY total_value DESC;

-- Q12. Monthly transaction analysis
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
       COUNT(*) AS transaction_count,
       ROUND(SUM(amount), 2) AS transaction_value
FROM transactions
WHERE transaction_status = 'Successful'
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY transaction_month;

-- Q13. Total loan amount
SELECT ROUND(SUM(loan_amount), 2) AS total_loan_amount
FROM loans;

-- Q14. Loan type performance
SELECT loan_type,
       COUNT(*) AS loan_count,
       ROUND(SUM(loan_amount), 2) AS total_loan_amount,
       ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loans
GROUP BY loan_type
ORDER BY total_loan_amount DESC;

-- Q15. Loan status analysis
SELECT loan_status, COUNT(*) AS loan_count,
       ROUND(SUM(loan_amount), 2) AS total_loan_amount
FROM loans
GROUP BY loan_status;

-- Q16. Loan payment status
SELECT payment_status, COUNT(*) AS payment_count,
       ROUND(SUM(payment_amount), 2) AS payment_value
FROM loan_payments
GROUP BY payment_status
ORDER BY payment_count DESC;

-- Q17. Credit utilization
SELECT card_id, customer_id, credit_limit, current_balance,
       ROUND(current_balance / credit_limit * 100, 2) AS utilization_percentage
FROM credit_cards
ORDER BY utilization_percentage DESC;

-- Q18. High credit utilization
SELECT card_id, customer_id, credit_limit, current_balance,
       ROUND(current_balance / credit_limit * 100, 2) AS utilization_percentage
FROM credit_cards
WHERE current_balance / credit_limit >= 0.50
ORDER BY utilization_percentage DESC;

-- Q19. Support ticket categories
SELECT issue_category, COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY issue_category
ORDER BY ticket_count DESC;

-- Q20. Support priority
SELECT priority, COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY priority
ORDER BY ticket_count DESC;

-- Q21. Average customer satisfaction
SELECT ROUND(AVG(satisfaction_score), 2) AS average_satisfaction
FROM support_tickets
WHERE satisfaction_score IS NOT NULL;

-- Q22. Average resolution time
SELECT ROUND(AVG(DATEDIFF(resolution_date, ticket_date)), 2) AS avg_resolution_days
FROM support_tickets
WHERE resolution_date IS NOT NULL;


-- =========================
-- PHASE 6: JOINS + INTERMEDIATE
-- =========================

-- Q23. Customer + Account details
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       a.account_id, a.account_type, a.balance, a.account_status
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
ORDER BY a.balance DESC;

-- Q24. Customer + Account + Branch
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       a.account_id, a.account_type, a.balance,
       b.branch_name, b.branch_type
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN branches b ON a.branch_id = b.branch_id
ORDER BY a.balance DESC;

-- Q25. Branch-wise account analysis
SELECT b.branch_name,
       COUNT(a.account_id) AS account_count,
       ROUND(AVG(a.balance), 2) AS avg_balance,
       ROUND(SUM(a.balance), 2) AS total_balance
FROM branches b
LEFT JOIN accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY total_balance DESC;

-- Q26. Customer transaction analysis
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(t.transaction_id) AS transaction_count,
       ROUND(SUM(t.amount), 2) AS total_transaction_value
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_id, customer_name
ORDER BY total_transaction_value DESC;

-- Q27. Top 5 customers by transaction value
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ROUND(SUM(t.amount), 2) AS total_transaction_value
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_id, customer_name
ORDER BY total_transaction_value DESC
LIMIT 5;

-- Q28. Branch-wise transaction performance
SELECT b.branch_name,
       COUNT(t.transaction_id) AS transaction_count,
       ROUND(SUM(t.amount), 2) AS transaction_value
FROM branches b
JOIN accounts a ON b.branch_id = a.branch_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY b.branch_id, b.branch_name
ORDER BY transaction_value DESC;

-- Q29. Customer segment transaction analysis
SELECT c.customer_segment,
       COUNT(DISTINCT c.customer_id) AS customer_count,
       COUNT(t.transaction_id) AS transaction_count,
       ROUND(SUM(t.amount), 2) AS transaction_value
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_segment
ORDER BY transaction_value DESC;

-- Q30. Customer activity classification
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ROUND(SUM(t.amount), 2) AS total_transaction_value,
       CASE
           WHEN SUM(t.amount) >= 300000 THEN 'High Activity'
           WHEN SUM(t.amount) >= 150000 THEN 'Medium Activity'
           ELSE 'Low Activity'
       END AS activity_level
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_id, customer_name
ORDER BY total_transaction_value DESC;

-- Q31. Loan + customer analysis
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       l.loan_id, l.loan_type, l.loan_amount, l.interest_rate, l.loan_status
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
ORDER BY l.loan_amount DESC;

-- Q32. Loan type performance
SELECT loan_type,
       COUNT(*) AS loan_count,
       ROUND(SUM(loan_amount), 2) AS total_loan_amount,
       ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loans
GROUP BY loan_type
ORDER BY total_loan_amount DESC;

-- Q33. Customer loan exposure
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(l.loan_id) AS loan_count,
       COALESCE(SUM(l.loan_amount), 0) AS total_loan_amount
FROM customers c
LEFT JOIN loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_loan_amount DESC;

-- Q34. Loan payment performance
SELECT l.loan_id,
       l.customer_id,
       COUNT(lp.payment_id) AS payment_count,
       SUM(lp.payment_amount) AS total_payment_amount,
       SUM(CASE WHEN lp.payment_status = 'Paid' THEN 1 ELSE 0 END) AS paid_count,
       SUM(CASE WHEN lp.payment_status = 'Late' THEN 1 ELSE 0 END) AS late_count,
       SUM(CASE WHEN lp.payment_status = 'Missed' THEN 1 ELSE 0 END) AS missed_count
FROM loans l
LEFT JOIN loan_payments lp ON l.loan_id = lp.loan_id
GROUP BY l.loan_id, l.customer_id
ORDER BY late_count DESC, missed_count DESC;

-- Q35. Customers with late/missed payments
SELECT DISTINCT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN loan_payments lp ON l.loan_id = lp.loan_id
WHERE lp.payment_status IN ('Late','Missed');

-- Q36. Credit card analysis
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       cc.card_type, cc.credit_limit, cc.current_balance, cc.card_status,
       ROUND(cc.current_balance / cc.credit_limit * 100, 2) AS utilization_percentage
FROM customers c
JOIN credit_cards cc ON c.customer_id = cc.customer_id
ORDER BY utilization_percentage DESC;

-- Q37. Credit utilization category
SELECT card_id, customer_id,
       ROUND(current_balance / credit_limit * 100, 2) AS utilization_percentage,
       CASE
           WHEN current_balance / credit_limit >= 0.75 THEN 'High'
           WHEN current_balance / credit_limit >= 0.50 THEN 'Medium'
           ELSE 'Low'
       END AS utilization_category
FROM credit_cards
ORDER BY utilization_percentage DESC;

-- Q38. Support + customer segment
SELECT c.customer_segment,
       COUNT(s.ticket_id) AS ticket_count,
       ROUND(AVG(s.satisfaction_score), 2) AS avg_satisfaction
FROM customers c
JOIN support_tickets s ON c.customer_id = s.customer_id
GROUP BY c.customer_segment
ORDER BY ticket_count DESC;

-- Q39. Support resolution time by issue
SELECT issue_category,
       COUNT(*) AS ticket_count,
       ROUND(AVG(DATEDIFF(resolution_date, ticket_date)), 2) AS avg_resolution_days
FROM support_tickets
WHERE resolution_date IS NOT NULL
GROUP BY issue_category
ORDER BY avg_resolution_days DESC;

-- Q40. Customer 360: simple version
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       c.customer_segment,
       COALESCE(SUM(t.amount), 0) AS transaction_value,
       COALESCE(SUM(l.loan_amount), 0) AS loan_value,
       COUNT(DISTINCT cc.card_id) AS card_count,
       COUNT(DISTINCT s.ticket_id) AS ticket_count
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
LEFT JOIN loans l ON c.customer_id = l.customer_id
LEFT JOIN credit_cards cc ON c.customer_id = cc.customer_id
LEFT JOIN support_tickets s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, customer_name, c.customer_segment;


-- =========================
-- PHASE 7: SUBQUERIES + CTE
-- =========================

-- Q41. Transactions above overall average
SELECT t.transaction_id, c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       t.amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.amount > (SELECT AVG(amount) FROM transactions)
ORDER BY t.amount DESC;

-- Q42. Accounts above overall average balance
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.balance > (SELECT AVG(balance) FROM accounts)
ORDER BY a.balance DESC;

-- Q43. Loans above overall average
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       l.loan_type, l.loan_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_amount > (SELECT AVG(loan_amount) FROM loans)
ORDER BY l.loan_amount DESC;

-- Q44. Customers above average customer transaction value
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       SUM(t.amount) AS total_transaction_value
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_id, customer_name
HAVING SUM(t.amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT a2.customer_id,
               SUM(t2.amount) AS customer_total
        FROM accounts a2
        JOIN transactions t2 ON a2.account_id = t2.account_id
        WHERE t2.transaction_status = 'Successful'
        GROUP BY a2.customer_id
    ) AS customer_summary
)
ORDER BY total_transaction_value DESC;

-- Q45. CTE customer transaction summary
WITH customer_transactions AS (
    SELECT a.customer_id,
           SUM(t.amount) AS total_transaction_value,
           COUNT(t.transaction_id) AS transaction_count
    FROM accounts a
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY a.customer_id
)
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ct.total_transaction_value,
       ct.transaction_count
FROM customers c
JOIN customer_transactions ct ON c.customer_id = ct.customer_id
ORDER BY ct.total_transaction_value DESC;

-- Q46. CTE + CASE customer activity
WITH customer_transactions AS (
    SELECT a.customer_id,
           SUM(t.amount) AS total_transaction_value
    FROM accounts a
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY a.customer_id
)
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ct.total_transaction_value,
       CASE
           WHEN ct.total_transaction_value >= 300000 THEN 'High Activity'
           WHEN ct.total_transaction_value >= 150000 THEN 'Medium Activity'
           ELSE 'Low Activity'
       END AS activity_level
FROM customers c
JOIN customer_transactions ct ON c.customer_id = ct.customer_id
ORDER BY ct.total_transaction_value DESC;

-- Q47. Customer loan exposure
WITH customer_loans AS (
    SELECT customer_id,
           SUM(loan_amount) AS total_loan_amount,
           COUNT(loan_id) AS loan_count
    FROM loans
    GROUP BY customer_id
)
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       c.customer_segment,
       COALESCE(cl.loan_count, 0) AS loan_count,
       COALESCE(cl.total_loan_amount, 0) AS total_loan_amount
FROM customers c
LEFT JOIN customer_loans cl ON c.customer_id = cl.customer_id
ORDER BY total_loan_amount DESC;

-- Q48. Loan exposure classification
WITH customer_loans AS (
    SELECT customer_id, SUM(loan_amount) AS total_loan_amount
    FROM loans
    GROUP BY customer_id
)
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COALESCE(cl.total_loan_amount, 0) AS total_loan_amount,
       CASE
           WHEN COALESCE(cl.total_loan_amount, 0) >= 3000000 THEN 'High Exposure'
           WHEN COALESCE(cl.total_loan_amount, 0) >= 1000000 THEN 'Medium Exposure'
           WHEN COALESCE(cl.total_loan_amount, 0) > 0 THEN 'Low Exposure'
           ELSE 'No Loan'
       END AS loan_exposure_category
FROM customers c
LEFT JOIN customer_loans cl ON c.customer_id = cl.customer_id
ORDER BY total_loan_amount DESC;

-- Q49. Customers above their segment average
WITH customer_transactions AS (
    SELECT c.customer_id,
           c.customer_segment,
           SUM(t.amount) AS total_transaction_value
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY c.customer_id, c.customer_segment
)
SELECT customer_id, customer_segment, total_transaction_value
FROM customer_transactions ct
WHERE total_transaction_value > (
    SELECT AVG(ct2.total_transaction_value)
    FROM customer_transactions ct2
    WHERE ct2.customer_segment = ct.customer_segment
)
ORDER BY customer_segment, total_transaction_value DESC;

-- Q50. Correct Customer 360 aggregation
WITH transaction_summary AS (
    SELECT a.customer_id,
           COUNT(t.transaction_id) AS transaction_count,
           SUM(t.amount) AS total_transaction_value
    FROM accounts a
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY a.customer_id
),
loan_summary AS (
    SELECT customer_id,
           COUNT(loan_id) AS loan_count,
           SUM(loan_amount) AS total_loan_amount
    FROM loans
    GROUP BY customer_id
),
card_summary AS (
    SELECT customer_id,
           COUNT(card_id) AS card_count,
           SUM(current_balance) AS total_card_balance
    FROM credit_cards
    GROUP BY customer_id
),
ticket_summary AS (
    SELECT customer_id,
           COUNT(ticket_id) AS ticket_count,
           AVG(satisfaction_score) AS avg_satisfaction
    FROM support_tickets
    GROUP BY customer_id
)
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       c.customer_segment,
       COALESCE(ts.transaction_count, 0) AS transaction_count,
       COALESCE(ts.total_transaction_value, 0) AS total_transaction_value,
       COALESCE(ls.loan_count, 0) AS loan_count,
       COALESCE(ls.total_loan_amount, 0) AS total_loan_amount,
       COALESCE(cs.card_count, 0) AS card_count,
       COALESCE(cs.total_card_balance, 0) AS total_card_balance,
       COALESCE(tks.ticket_count, 0) AS ticket_count,
       ROUND(COALESCE(tks.avg_satisfaction, 0), 2) AS avg_satisfaction
FROM customers c
LEFT JOIN transaction_summary ts ON c.customer_id = ts.customer_id
LEFT JOIN loan_summary ls ON c.customer_id = ls.customer_id
LEFT JOIN card_summary cs ON c.customer_id = cs.customer_id
LEFT JOIN ticket_summary tks ON c.customer_id = tks.customer_id
ORDER BY total_transaction_value DESC;


-- =========================
-- PHASE 8: WINDOW FUNCTIONS
-- =========================

-- Q51. Customer transaction ranking
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       SUM(t.amount) AS total_transaction_value,
       RANK() OVER (ORDER BY SUM(t.amount) DESC) AS transaction_rank
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_id, customer_name
ORDER BY transaction_rank;

-- Q52. ROW_NUMBER ranking
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       SUM(t.amount) AS total_transaction_value,
       ROW_NUMBER() OVER (ORDER BY SUM(t.amount) DESC) AS row_number
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_id, customer_name
ORDER BY row_number;

-- Q53. DENSE_RANK
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       SUM(t.amount) AS total_transaction_value,
       DENSE_RANK() OVER (ORDER BY SUM(t.amount) DESC) AS dense_rank
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_status = 'Successful'
GROUP BY c.customer_id, customer_name
ORDER BY dense_rank;

-- Q54. Top 3 customers per segment
WITH customer_transactions AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           c.customer_segment,
           SUM(t.amount) AS total_transaction_value
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY c.customer_id, customer_name, c.customer_segment
),
ranked_customers AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_segment
               ORDER BY total_transaction_value DESC
           ) AS segment_rank
    FROM customer_transactions
)
SELECT *
FROM ranked_customers
WHERE segment_rank <= 3
ORDER BY customer_segment, segment_rank;

-- Q55. Transaction percentage contribution
WITH customer_transactions AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(t.amount) AS total_transaction_value
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY c.customer_id, customer_name
)
SELECT customer_id,
       customer_name,
       total_transaction_value,
       ROUND(
           total_transaction_value / SUM(total_transaction_value) OVER () * 100,
           2
       ) AS transaction_percentage
FROM customer_transactions
ORDER BY total_transaction_value DESC;

-- Q56. Monthly running total
WITH monthly_transactions AS (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
           SUM(amount) AS monthly_transaction_value
    FROM transactions
    WHERE transaction_status = 'Successful'
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
)
SELECT transaction_month,
       monthly_transaction_value,
       SUM(monthly_transaction_value) OVER (
           ORDER BY transaction_month
       ) AS running_total
FROM monthly_transactions
ORDER BY transaction_month;

-- Q57. Monthly growth using LAG
WITH monthly_transactions AS (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
           SUM(amount) AS monthly_transaction_value
    FROM transactions
    WHERE transaction_status = 'Successful'
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
),
monthly_comparison AS (
    SELECT transaction_month,
           monthly_transaction_value,
           LAG(monthly_transaction_value) OVER (
               ORDER BY transaction_month
           ) AS previous_month_value
    FROM monthly_transactions
)
SELECT transaction_month,
       monthly_transaction_value,
       previous_month_value,
       ROUND(
           (monthly_transaction_value - previous_month_value)
           / NULLIF(previous_month_value, 0) * 100,
           2
       ) AS growth_percentage
FROM monthly_comparison
ORDER BY transaction_month;

-- Q58. Next month using LEAD
WITH monthly_transactions AS (
    SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
           SUM(amount) AS monthly_transaction_value
    FROM transactions
    WHERE transaction_status = 'Successful'
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
)
SELECT transaction_month,
       monthly_transaction_value,
       LEAD(monthly_transaction_value) OVER (
           ORDER BY transaction_month
       ) AS next_month_value
FROM monthly_transactions
ORDER BY transaction_month;

-- Q59. Segment-specific customer ranking
WITH customer_transactions AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           c.customer_segment,
           SUM(t.amount) AS total_transaction_value
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY c.customer_id, customer_name, c.customer_segment
)
SELECT customer_id,
       customer_name,
       customer_segment,
       total_transaction_value,
       RANK() OVER (
           PARTITION BY customer_segment
           ORDER BY total_transaction_value DESC
       ) AS segment_rank
FROM customer_transactions
ORDER BY customer_segment, segment_rank;

-- Q60. Customer vs segment average
WITH customer_transactions AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           c.customer_segment,
           SUM(t.amount) AS total_transaction_value
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Successful'
    GROUP BY c.customer_id, customer_name, c.customer_segment
)
SELECT customer_id,
       customer_name,
       customer_segment,
       total_transaction_value,
       ROUND(
           AVG(total_transaction_value) OVER (
               PARTITION BY customer_segment
           ),
           2
       ) AS segment_average,
       CASE
           WHEN total_transaction_value >
                AVG(total_transaction_value) OVER (
                    PARTITION BY customer_segment
                )
           THEN 'Above Segment Average'
           ELSE 'Below Segment Average'
       END AS performance
FROM customer_transactions
ORDER BY customer_segment, total_transaction_value DESC;

-- Q61. Loan payment ranking
WITH customer_payments AS (
    SELECT l.customer_id,
           l.loan_id,
           SUM(lp.payment_amount) AS total_paid
    FROM loans l
    JOIN loan_payments lp ON l.loan_id = lp.loan_id
    WHERE lp.payment_status = 'Paid'
    GROUP BY l.customer_id, l.loan_id
)
SELECT customer_id,
       loan_id,
       total_paid,
       RANK() OVER (
           PARTITION BY customer_id
           ORDER BY total_paid DESC
       ) AS loan_payment_rank
FROM customer_payments
ORDER BY customer_id, loan_payment_rank;

-- Q62. Top 3 loans by amount
WITH ranked_loans AS (
    SELECT loan_id, customer_id, loan_type, loan_amount,
           RANK() OVER (ORDER BY loan_amount DESC) AS loan_rank
    FROM loans
)
SELECT *
FROM ranked_loans
WHERE loan_rank <= 3
ORDER BY loan_rank;
