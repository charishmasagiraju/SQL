SELECT *
FROM layoffs_staging2;

SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT industry,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT country,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT MAX(total_laid_off),MIN(total_laid_off),MAX(percentage_laid_off),MIN(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off = (SELECT MAX(total_laid_off) FROM layoffs_staging2);

SELECT company,total_laid_off,funds_raised_millions
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_staging2;

SELECT SUBSTRING(`date`,1,7) AS per_month ,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7) 
ORDER BY 1 DESC;

SELECT *
FROM layoffs_staging2
WHERE `date` IS NULL;

SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

WITH rolling_off AS
(
	SELECT SUBSTRING(`date`,1,7) AS per_month ,SUM(total_laid_off) AS total
	FROM layoffs_staging2
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY SUBSTRING(`date`,1,7) 
	ORDER BY 1 ASC
)
SELECT per_month,total,SUM(total) OVER(ORDER BY per_month) AS rolling_total
FROM rolling_off;

SELECT company,YEAR(`date`),SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH laid_off AS
(
	SELECT company,YEAR(`date`) AS years,SUM(total_laid_off) AS total_laid_off
	FROM layoffs_staging2
    WHERE YEAR(`date`) IS NOT NULL
	GROUP BY company,YEAR(`date`)
),
Ranking_off AS 
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
	FROM laid_off
)
SELECT *
FROM Ranking_off
WHERE ranking <= 5
;