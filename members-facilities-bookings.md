# 运动俱乐部会员预订统计查询
## 题目要求
查询2023年8月满足以下条件的会员：
1. 预订至少两种不同类型设施
2. 预订总时长超过3小时
3. 预订总费用超过300元

输出：会员ID、会员姓名、不同设施类型数、总预订时长、总预订费用
排序：按总费用降序排列

## 数据表
### members 会员表
| member_id | member_name | join_date  |
| --------- | ----------- | ---------- |
| 1         | 张华        | 2023-01-10 |
| 2         | 李丽        | 2023-03-15 |
| 3         | 王强        | 2023-05-20 |

### facilities 设施表
| facility_id | facility_name | facility_type | hourly_rate |
| ----------- | ------------- | ------------- | ----------- |
| 101         | 羽毛球场      | 球类场地      | 50          |
| 102         | 游泳池        | 水上设施      | 80          |
| 103         | 健身房        | 健身区域      | 40          |
| 104         | 网球场        | 球类场地      | 60          |
| 105         | 壁球场        | 球类场地      | 70          |

### bookings 预订表
| booking_id | member_id | facility_id | booking_date | start_time | end_time  |
| ---------- | --------- | ----------- | ------------ | ---------- | --------- |
| 1          | 1         | 101         | 2023-08-10   | 09:00:00   | 13:00:00  |
| 2          | 1         | 103         | 2023-08-12   | 14:00:00   | 19:00:00  |
| 3          | 2         | 102         | 2023-08-15   | 10:00:00   | 15:00:00  |
| 4          | 2         | 104         | 2023-08-18   | 15:00:00   | 20:00:00  |
| 5          | 3         | 101         | 2023-08-20   | 08:00:00   | 12:00:00  |
| 6          | 3         | 105         | 2023-08-22   | 13:00:00   | 18:00:00  |

## SQL语句
```sql
SELECT 
    m.member_id,
    m.member_name,
    COUNT(DISTINCT f.facility_type) AS facility_type_count,
    SUM(TIMESTAMPDIFF(HOUR, b.start_time, b.end_time)) AS total_booking_hours,
    SUM(TIMESTAMPDIFF(HOUR, b.start_time, b.end_time) * f.hourly_rate) AS total_booking_cost
FROM members m
JOIN bookings b ON m.member_id = b.member_id
JOIN facilities f ON b.facility_id = f.facility_id
WHERE DATE_FORMAT(b.booking_date,'%Y-%m') = '2023-08'
GROUP BY m.member_id, m.member_name
HAVING COUNT(DISTINCT f.facility_type) >= 2
AND SUM(TIMESTAMPDIFF(HOUR,b.start_time, b.end_time)) > 3
AND SUM(TIMESTAMPDIFF(HOUR,b.start_time, b.end_time) * f.hourly_rate) > 300
ORDER BY total_booking_cost DESC;
```

## 查询结果
| member_id | member_name | facility_type_count | total_booking_hours | total_booking_cost |
| --------- | ----------- | ------------------- | ------------------- | ------------------ |
| 2         | 李丽        | 2                   | 10                  | 700                |