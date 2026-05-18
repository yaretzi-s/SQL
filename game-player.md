# 游戏玩家多表联合分析查询
## 业务需求
一家游戏公司有 `games` 表记录游戏信息，`players` 表记录玩家信息，`play_records` 表记录玩家游戏游玩记录，`achievements` 表记录游戏成就信息。现在要找出等级大于10级且在射击类游戏（`game_type` 为 '射击'）中获得过至少2个不同成就的玩家，显示玩家ID（`player_id`）、玩家姓名（`player_name`）、玩家等级（`level`）以及获得的成就数量（命名为 `achievement_count`），按成就数量从高到低排序。

## 涉及数据表
涉及数据表
1. games 游戏信息表
表格
game_id	game_name	game_type
1001	使命战场	射击
1002	幻想大陆	角色扮演
1003	火线对决	射击
2. players 玩家信息表
表格
player_id	player_name	level
1	王强	12
2	刘辉	8
3	张敏	15
3. play_records 游玩记录表
表格
record_id	player_id	game_id	play_time
1	1	1001	2024-01-10
2	1	1002	2024-02-15
3	2	1001	2024-03-20
4	3	1003	2024-04-25
4. achievements 成就表
表格
achievement_id	game_id	player_id	achievement_name
1	1001	1	百步穿杨
2	1001	1	枪王之王
3	1002	2	新手入门
4	1003	3	一击必杀
5	1003	3	战场主宰

## 标准 SQL 查询语句
```sql
-- 需求：查询等级>10级、射击类游戏中获得≥2个不同成就的玩家信息
SELECT 
    p.player_id,        -- 玩家ID
    p.player_name,      -- 玩家姓名
    p.level,            -- 玩家等级
    COUNT(DISTINCT a.achievement_id) AS achievement_count  -- 不同成就数量
FROM players p 
-- 关联玩家游玩记录
JOIN play_records pr 
    ON p.player_id = pr.player_id 
-- 关联游戏信息表
JOIN games g 
    ON g.game_id = pr.game_id
-- 关联成就表（双字段精准匹配：玩家ID+游戏ID）
JOIN achievements a 
    ON a.player_id = p.player_id 
    AND g.game_id = a.game_id
-- 基础条件筛选
WHERE p.level > 10
  AND g.game_type = '射击'
-- 按玩家分组
GROUP BY p.player_id, p.player_name, p.level
-- 分组后筛选：成就数量≥2
HAVING COUNT(DISTINCT a.achievement_id) >= 2
-- 按成就数量降序排序
ORDER BY achievement_count DESC;
```

## 查询结果
| player_id | player_name | level | achievement_count |
|-----------|-------------|-------|-------------------|
| 1         | 王强        | 12    | 2                 |
| 3         | 张敏        | 15    | 2                 |

## 核心知识点说明
1. **多表内连接**：使用 `JOIN` 关联4张业务表，通过外键保证数据关联准确性
2. **精准关联条件**：成就表使用 `player_id + game_id` 双字段匹配，避免数据错误
3. **去重统计**：`COUNT(DISTINCT)` 确保统计的是**不同成就**数量
4. **分组筛选**：`WHERE` 过滤原始数据，`HAVING` 过滤聚合后结果
5. **结果排序**：`ORDER BY ... DESC` 实现成就数量降序排列

---
