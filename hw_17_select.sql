
-- количество исполнителей в каждом жанре 

select c.genre, count(artist_name) artists_count from artists a 
join genres_and_artists b on a.id = b.artist_id
join genres c on c.id = b.genre_id
group by c.genre;

-- количество треков, вошедших в альбомы 2019-2020 годов

select b.album_year, count(track_name) tracks_count from tracks a
join albums b on a.album_id = b.id
where b.album_year between 2019 and 2020
group by b.album_year;

-- средняя продолжительность треков по каждому альбому

select b.album_name, AVG(duration) average_duration from tracks a
join albums b on a.album_id = b.id
group by b.album_name;

-- все исполнители, которые не выпустили альбомы в 2020 году

select artist_name from artists 
where artist_name not in (select  artist_name from artists a
						join artists_and_albums b on a.id = b.artist_id 
						join tracks c on b.album_id = c.album_id
						join albums d on c.album_id = d.id
						where d.album_year = 2020
						group by artist_name);

-- названия сборников, в которых присутствует конкретный исполнитель (выберите сами)
						
select collection_name from collections c 
join collections_and_tracks cat on c.id = cat.collection_id 
join tracks t on cat.track_id = t.id 
join albums a on t.album_id = a.id 
join artists_and_albums aaa on a.id = aaa.album_id 
join artists art on aaa.artist_id = art.id 
where art.artist_name = 'Николай Андреевич Римский-Корсаков'
group by collection_name;

-- название альбомов, в которых присутствуют исполнители более 1 жанра;

select album_name, COUNT(*) genres_count from albums a 
join artists_and_albums aaa on aaa.album_id = a.id 
join artists a2 on a2.id = aaa.artist_id 
join genres_and_artists gaa on gaa.artist_id = a2.id 
join genres g on g.id = gaa.genre_id
group by album_name
having COUNT(*) > 1;

-- наименование треков, которые не входят в сборники;

select track_name from tracks t2 
where track_name not in (select track_name from tracks t
					join collections_and_tracks cat on cat.track_id = t.id
					group by track_name);
				
-- исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)

select artist_name, t.duration, t.track_name from artists a 
join artists_and_albums aaa on a.id = aaa.artist_id 
join tracks t on aaa.album_id = t.album_id 
where t.duration = (select min(duration) from tracks)
group by artist_name, t.duration, t.track_name;

-- название альбомов, содержащих наименьшее количество треков.

select album_name, count(*) from albums a2 
join tracks t2 on t2.album_id = a2.id 
group by album_name 
having count(*) = (select min(track_count) from (select album_name, count(*) track_count from albums a 
								join tracks t ON t.album_id = a.id 
								group by album_name) as query);


