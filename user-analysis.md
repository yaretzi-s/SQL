# 电商用户消费分析 SQL 查询
## 需求描述
查询 2024 年 3 月 - 2024 年 7 月期间，**购买过至少 3 种不同品类商品** 且 **总消费金额超过 2000 元** 的用户信息。

输出字段：用户ID、用户姓名、购买不同品类商品数量、总消费金额，并按总消费金额从高到低排序。

## 完整数据表结构
### 1. users（用户信息表）
| user_id | user_name | register_date |
|---------|-----------|---------------|
| 1001    | 林晓      | 2023-09-05    |
| 1002    | 赵宇      | 2023-11-12    |
| 1003    | 孙悦      | 2024-01-20    |

### 2. products（商品信息表）
| product_id | product_name | category | price |
|------------|--------------|----------|-------|
| 201        | 智能手表A    | 数码产品 | 1200  |
| 202        | 无线耳机B    | 数码产品 | 800   |
| 203        | 纯棉T恤C     | 服装     | 80    |
| 204        | 运动跑鞋D    | 鞋类     | 350   |
| 205        | 双肩背包E    | 箱包     | 220   |
| 206        | 连衣裙F      | 服装     | 180   |

### 3. orders（订单信息表）
| order_id | user_id | order_date  |
|----------|---------|-------------|
| 1        | 1001    | 2024-03-18  |
| 2        | 1001    | 2024-04-25  |
| 3        | 1002    | 2024-05-10  |
| 4        | 1002    | 2024-06-15  |
| 5        | 1003    | 2024-07-22  |

### 4. order_items（订单商品详情表）
| item_id | order_id | product_id | quantity |
|---------|----------|------------|----------|
| 1       | 1        | 201        | 1        |
| 2       | 1        | 203        | 2        |
| 3       | 2        | 202        | 1        |
| 4       | 2        | 204        | 1        |
| 5       | 3        | 205        | 1        |
| 6       | 4        | 206        | 2        |
| 7       | 5        | 201        | 1        |
| 8       | 5        | 202        | 1        |

## 标准 SQL 查询语句
```sql
-- 筛选符合条件的用户：3类及以上不同商品 + 总消费>2000元（2024.3-7月）
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
| 字段名          | 含义                     |
|-----------------|--------------------------|
| user_id         | 用户ID                   |
| user_name       | 用户姓名                 |
| category_count  | 购买的不同商品品类数量   |
| total_spend     | 统计周期内总消费金额     |

## 执行结果
| user_id | user_name | category_count | total_spend |
|---------|-----------|----------------|-------------|
| 1001    | 林晓      | 3              | 2460        |

## 核心知识点
1. **多表关联**：使用 INNER JOIN 关联用户、订单、订单商品、商品四张表
2. **去重统计**：COUNT(DISTINCT p.category) 统计不重复的商品品类
3. **聚合计算**：SUM(oi.quantity * p.price) 精准计算总消费金额
4. **分组过滤**：HAVING 子句对分组聚合结果进行条件筛选
5. **日期筛选**：BETWEEN 实现指定时间范围的订单数据过滤
