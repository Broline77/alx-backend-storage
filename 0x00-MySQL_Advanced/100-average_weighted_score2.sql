-- weighted score
CREATE PROCEDURE ComputeAverageWeightedScoreForUser (user_id INT)
BEGIN
  DECLARE total_weighted_score INT;
  DECLARE total_weight INT;

  SELECT SUM(score * weight) INTO total_weighted_score
  FROM corrections
  WHERE user_id = user_id;

  SELECT SUM(weight) INTO total_weight
  FROM projects
  WHERE id IN (
    SELECT project_id FROM corrections
    WHERE user_id = user_id
  );

  IF total_weight = 0 THEN
    UPDATE users
      SET average_score = 0
      WHERE id = user_id;
  ELSE
    UPDATE users
      SET average_score = total_weighted_score / total_weight
      WHERE id = user_id;
  END IF;
END;
