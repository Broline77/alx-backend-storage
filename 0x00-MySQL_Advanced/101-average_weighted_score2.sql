-- procedure
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
  DECLARE total_weighted_score INT;
  DECLARE total_weight INT;

  DECLARE cur CURSOR FOR
    SELECT SUM(score * weight) AS total_weighted_score, SUM(weight) AS total_weight
    FROM corrections
    INNER JOIN projects
      ON corrections.project_id = projects.id;

  OPEN cur;
    FETCH cur INTO total_weighted_score, total_weight;
    UPDATE users
      SET average_score = IF(total_weight = 0, 0, total_weighted_score / total_weight)
      WHERE id IN (
        SELECT user_id FROM corrections
      );
  CLOSE cur;
END;
