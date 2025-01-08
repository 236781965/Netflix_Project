select * from netflix

-- Analyze the distribution of content (Movies, TV Shows) by country
SELECT 
    country, 
    type, 
    COUNT(*) AS content_count
FROM netflix
GROUP BY country, type
ORDER BY content_count DESC;

-- Examine the trend in content releases over the years
SELECT 
    release_year, 
    COUNT(*) AS release_count
FROM netflix
GROUP BY release_year
ORDER BY release_year;

-- Analyze the duration of content (movies, TV shows, documentaries) by type
SELECT 
    type, 
    AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)) AS avg_duration
FROM netflix
WHERE duration IS NOT NULL
GROUP BY type
ORDER BY avg_duration DESC;

-- Identify the most common genres across Netflix content
SELECT 
    genre, 
    COUNT(*) AS genre_count
FROM netflix, unnest(string_to_array(listed_in, ',')) AS genre
GROUP BY genre
ORDER BY genre_count DESC;

-- Analyze the distribution of ratings across content types
SELECT 
    type, 
    rating, 
    COUNT(*) AS rating_count
FROM netflix
GROUP BY type, rating
ORDER BY rating_count DESC;

-- Examine how Netflix's content library has grown over time
SELECT 
    EXTRACT(YEAR FROM date_added::DATE) AS year_added, 
    COUNT(*) AS additions
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;

-- Identify the most prolific directors on Netflix
SELECT 
    director, 
    COUNT(*) AS content_count
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY content_count DESC
LIMIT 10;

-- Identify the most frequently appearing cast members on Netflix
SELECT 
    actor, 
    COUNT(*) AS appearance_count
FROM netflix, unnest(string_to_array(cast, ',')) AS actor
GROUP BY actor
ORDER BY appearance_count DESC
LIMIT 10;

-- Analyze the relationship between content type and its ratings
SELECT 
    type, 
    rating, 
    COUNT(*) AS rating_count
FROM netflix
GROUP BY type, rating
ORDER BY rating_count DESC;

-- Identify countries with the least content available
SELECT 
    country, 
    COUNT(*) AS content_count
FROM netflix
GROUP BY country
ORDER BY content_count ASC
LIMIT 10;

-- Analyze the relationship between release year and duration
SELECT 
    release_year, 
    AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)) AS avg_duration
FROM netflix
WHERE duration IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

-- Examine how genre availability has changed over time
SELECT 
    genre, 
    EXTRACT(YEAR FROM date_added::DATE) AS year_added, 
    COUNT(*) AS genre_count
FROM netflix, unnest(string_to_array(listed_in, ',')) AS genre
WHERE date_added IS NOT NULL
GROUP BY genre, year_added
ORDER BY year_added, genre_count DESC;

-- Create a heatmap-like result showing content availability by country and average rating
SELECT 
    country, 
    AVG(CAST(SUBSTRING(rating FROM '^[0-9.]+') AS FLOAT)) AS avg_rating, 
    COUNT(*) AS content_count
FROM netflix
WHERE rating ~ '^[0-9.]+' -- Filter numeric ratings
GROUP BY country
ORDER BY avg_rating DESC;

-- Identify the most common combinations of genres
SELECT 
    ARRAY_AGG(DISTINCT genre) AS genre_combination, 
    COUNT(*) AS combination_count
FROM netflix, unnest(string_to_array(listed_in, ',')) AS genre
GROUP BY show_id
ORDER BY combination_count DESC
LIMIT 10;

-- Analyze content additions by season
SELECT 
    EXTRACT(MONTH FROM date_added::DATE) AS month_added, 
    type, 
    COUNT(*) AS additions
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY month_added, type
ORDER BY month_added, additions DESC;

-- Analyze distribution of age-appropriate content by country
SELECT 
    country, 
    rating, 
    COUNT(*) AS content_count
FROM netflix
GROUP BY country, rating
ORDER BY content_count DESC;

-- Analyze diversity in cast representation by country
SELECT 
    country, 
    COUNT(DISTINCT actor) AS unique_cast_count
FROM netflix, unnest(string_to_array(cast, ',')) AS actor
GROUP BY country
ORDER BY unique_cast_count DESC;

-- Track trends in genre popularity over the years
SELECT 
    EXTRACT(YEAR FROM date_added::DATE) AS year_added, 
    genre, 
    COUNT(*) AS genre_count
FROM netflix, unnest(string_to_array(listed_in, ',')) AS genre
WHERE date_added IS NOT NULL
GROUP BY year_added, genre
ORDER BY year_added, genre_count DESC;
