# 旅行社客户消费排名分析 SQL 查询

## 需求描述
统计所有客户的总预订消费金额，并按照总金额进行**密集排名**。
- 消费金额相同，排名相同（不跳号）
- 输出字段：排名、客户ID、客户姓名、总消费金额
- 按总消费金额从高到低排序

---

## 完整数据表结构

### 1. customers（客户信息表）
| customer_id | customer_name | contact_number |
|-------------|---------------|----------------|
| 1           | 张悦          | 138xxxx1234    |
| 2           | 李阳          | 139xxxx5678    |
| 3           | 王萌          | 150xxxx9012    |

### 2. trips（旅行线路信息表）
| trip_id | trip_name  | destination | price |
|---------|------------|-------------|-------|
| 101     | 海滨之旅   | 青岛        | 3000  |
| 102     | 山区徒步   | 黄山        | 2500  |
| 103     | 古城探秘   | 丽江        | 2800  |
| 104     | 草原驰骋   | 呼伦贝尔    | 3500  |
| 105     | 都市观光   | 上海        | 2200  |

### 3. bookings（预订信息表）
| booking_id | customer_id | trip_id | booking_date |
|------------|-------------|---------|--------------|
| 1          | 1           | 101     | 2024-06-10   |
| 2          | 1           | 103     | 2024-07-15   |
| 3          | 2           | 102     | 2024-08-20   |
| 4          | 2           | 104     | 2024-09-25   |
| 5          | 3           | 101     | 2024-10-05   |
| 6          | 3           | 105     | 2024-11-10   |

---

## 标准 SQL 查询语句

```sql
-- 客户消费总金额 + 并列排名（DENSE_RANK 密集排名）
SELECT
    DENSE_RANK() OVER(ORDER BY SUM(t.price) DESC) AS ranking,
    c.customer_id,
    c.customer_name,
    SUM(t.price) AS total_cost
FROM customers c
JOIN bookings b ON c.customer_id = b.customer_id
JOIN trips t ON b.trip_id = t.trip_id
GROUP BY c.customer_id, c.customer_name
ORDER BY ranking;
```

---

## 输出字段说明
| 字段名        | 含义                                   |
|---------------|----------------------------------------|
| ranking       | 客户消费排名（金额相同排名相同）|
| customer_id   | 客户ID                                 |
| customer_name | 客户姓名                               |
| total_cost    | 总预订消费金额                         |

---

## 执行结果
| ranking | customer_id | customer_name | total_cost |
|---------|-------------|---------------|------------|
| 1       | 1           | 张悦          | 6000       |
| 1       | 2           | 李阳          | 6000       |
| 2       | 3           | 王萌          | 5200       |

---

## 核心知识点
- **窗口函数**：`DENSE_RANK() OVER(ORDER BY ... DESC)` 实现并列排名、不跳号
- **多表关联**：INNER JOIN 关联三张表
- **聚合计算**：`SUM(t.price)` 统计总消费
- **分组过滤**：GROUP BY 按客户分组
- **排名特点**：金额相同 → 排名一致，无跳号
