# 电商用户消费分析 SQL 查询
## 需求描述
查询 2024 年 3 月 - 2024 年 7 月期间，**购买过至少 3 种不同品类商品** 且 **总消费金额超过 2000 元** 的用户信息。

## 涉及数据表
- `users`：用户基础信息表
- `products`：商品信息表
- `orders`：订单主表
- `order_items`：订单商品明细表

## 标准 SQL 语句
```sql
-- 筛选符合条件的用户：3类以上商品 + 消费超2000元（2024.3-7月）
SELECT 
    u.user_id,
    u.user_name,
    COUNT(DISTINCT p.category) AS category_count,
    SUM(oi.quantity * p.price) AS total_spend
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-03-01' AND '2024-07-31' # 这里不能写成BETWEEN '2024-03' AND '2024-07'
GROUP BY u.user_id, u.user_name
HAVING COUNT(DISTINCT p.category) >= 3 
   AND SUM(oi.quantity * p.price) > 2000
ORDER BY total_spend DESC;
```

## 输出字段说明
| 字段名 | 含义 |
|--------|------|
| user_id | 用户ID |
| user_name | 用户姓名 |
| category_count | 购买的不同商品品类数量 |
| total_spend | 总消费金额 |

## 执行结果
| user_id | user_name | category_count | total_spend |
|---------|-----------|----------------|-------------|
| 1001    | 林晓      | 3              | 2460        |

## 核心知识点
1. **多表关联**：`INNER JOIN` 关联用户、订单、订单商品、商品表
2. **去重统计**：`COUNT(DISTINCT)` 统计不重复的商品品类
3. **聚合计算**：`SUM(quantity * price)` 计算总消费金额
4. **分组过滤**：`HAVING` 对分组后的数据进行条件筛选
5. **日期范围**：`BETWEEN` 精准筛选指定时间段的订单

---