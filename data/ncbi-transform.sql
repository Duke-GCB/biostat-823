CREATE TABLE Node1 (
  ID INTEGER PRIMARY KEY,
  Name TEXT,
  Parent_ID INTEGER
    REFERENCES Node1(ID),
  "Left" INTEGER,
  "Right" INTEGER
);

INSERT INTO Node1 (ID, Name, Parent_ID, "Left", "Right")
SELECT n.id, n.name, n.parent, n.left, n.right
FROM   Node AS n, Node AS p
WHERE  p.name = 'Eukaryota' 
AND    n.left >= p.left and n.right <= p.right
;

ALTER TABLE Node RENAME TO Node_Original;
ALTER TABLE Node1 RENAME TO Node;
CREATE INDEX Node_Parent_Idx ON Node(Parent_ID);
CREATE INDEX Node_Name_Idx ON Node(Name);
CREATE INDEX Node_Left_Idx ON Node(Left);
CREATE INDEX Node_Right_Idx ON Node(Right);