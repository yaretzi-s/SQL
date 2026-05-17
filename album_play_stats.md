### 题目：多表关联与条件聚合
业务场景：一个音乐平台有 songs 表记录歌曲信息，albums 表记录专辑信息，artists 表记录歌手信息，plays 表记录歌曲播放信息。现在要找出播放次数超过1000次且属于流行音乐（genre 为 '流行'）的专辑，显示专辑ID（album_id）、专辑名称（album_name）、歌手姓名（artist_name）以及总播放次数（命名为 total_plays），按总播放次数从高到低排序。

### 原表：
`songs` 表：
| song_id | song_name | album_id | artist_id | genre  |
|---------|-----------|----------|-----------|--------|
| 1       | 青春之歌  | 101      | 201       | 流行   |
| 2       | 梦想起航  | 101      | 201       | 流行   |
| 3       | 宁静之音  | 102      | 202       | 古典   |
| 4       | 夏日微风  | 102      | 202       | 流行   |

`albums` 表：
| album_id | album_name | artist_id |
|----------|------------|-----------|
| 101      | 流行精选集 | 201       |
| 102      | 经典专辑   | 202       |

`artists` 表：
| artist_id | artist_name |
|-----------|-------------|
| 201       | 李华        |
| 202       | 张明        |

`plays` 表：
| play_id | song_id | play_count |
|---------|---------|------------|
| 1       | 1       | 500        |
| 2       | 1       | 300        |
| 3       | 2       | 400        |
| 4       | 3       | 200        |
| 5       | 4       | 600        |

### SQL：
```sql
SELECT 
 al.album_id, 
 al.album_name, 
 ar.artist_name, 
 SUM(p.play_count) AS total_plays
FROM albums al 
JOIN artists ar 
ON al.artist_id = ar.artist_id 
JOIN songs s 
ON al.album_id = s.album_id
JOIN plays p 
ON s.song_id = p.song_id 
WHERE s.genre = '流行'
GROUP BY al.album_id, al.album_name, ar.artist_name
HAVING SUM(p.play_count) > 1000
ORDER BY total_plays DESC
```
### 结果：
| album_id | album_name | artist_name | total_plays |
|----------|------------|-------------|-------------|
| 101      | 流行精选集   | 李华         | 1200        |
