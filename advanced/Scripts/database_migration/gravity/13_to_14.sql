.timeout 30000

PRAGMA FOREIGN_KEYS=OFF;

BEGIN TRANSACTION;

ALTER TABLE adlist ADD COLUMN api_key TEXT;

DROP VIEW vw_adlist;
CREATE VIEW vw_adlist AS SELECT DISTINCT address, adlist.id AS id, api_key
    FROM adlist
    LEFT JOIN adlist_by_group ON adlist_by_group.adlist_id = adlist.id
    LEFT JOIN "group" ON "group".id = adlist_by_group.group_id
    WHERE adlist.enabled = 1 AND (adlist_by_group.group_id IS NULL OR "group".enabled = 1)
    ORDER BY adlist.id;

UPDATE info SET value = 14 WHERE property = 'version';

COMMIT;