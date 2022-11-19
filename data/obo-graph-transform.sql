-- create temporary tables to accept the TSV files for import
--
-- we don't enforce constraints here (except making sure we get values
-- where we expect them), so as not to slow down import
CREATE TEMPORARY TABLE Node_Labels_Import (
  ID INTEGER NOT NULL,
  IRI Text NOT NULL,
  Label Text
);

CREATE TEMPORARY TABLE Edge_Labels_Import (
  ID INTEGER NOT NULL,
  IRI Text NOT NULL,
  Label Text
);

CREATE TEMPORARY TABLE Edges_Import (
  Subject_ID INTEGER NOT NULL,
  Predicate_ID INTEGER NOT NULL,
  Object_ID INTEGER NOT NULL
);

.separator 
.import node-labels.tsv Node_Labels_Import
.import edge-labels.tsv Edge_Labels_Import
.import edges.tsv Edges_Import

-- There's one edge in the import that's faulty. We'll create
-- two indexes to speed up getting rid of it.
CREATE UNIQUE INDEX Node_Labels_IRI ON Node_Labels_Import (IRI);
CREATE INDEX Edges_Subjects ON Edges_Import (Subject_ID);
DELETE FROM Edges_Import
WHERE Subject_ID = (
  SELECT ID FROM Node_Labels_Import WHERE IRI = 'http://purl.obolibrary.org/obo/RO_0000052'
);
DELETE FROM Node_Labels_Import WHERE IRI = 'http://purl.obolibrary.org/obo/RO_0000052';

-- Also, translate zero-length string to NULL
UPDATE Node_Labels_Import SET Label = NULL WHERE LENGTH(LABEL) = 0;
UPDATE Edge_Labels_Import SET Label = NULL WHERE LENGTH(LABEL) = 0;

-- And finally, delete all edges where the subject isn't either a CL or a UBERON term.
-- This seems to get rid of the cycle(s) we otherwise seem to have somewhere.
DELETE FROM Edges_Import
WHERE Subject_ID NOT IN (
  SELECT ID FROM Node_Labels_Import
  WHERE IRI LIKE 'http://purl.obolibrary.org/obo/CL_%'
     OR IRI LIKE 'http://purl.obolibrary.org/obo/UBERON_%'
);

-- now create our actual model, with full constraints
CREATE TABLE Node (
  ID INTEGER PRIMARY KEY,
  Label Text,
  IRI Text NOT NULL UNIQUE
);

CREATE TABLE Edge (
  Subject_ID INTEGER NOT NULL
    REFERENCES Node (ID),
  Predicate_ID INTEGER NOT NULL
    REFERENCES Node (ID),
  Object_ID INTEGER NOT NULL
    REFERENCES Node (ID),
  PRIMARY KEY (Subject_ID, Object_ID, Predicate_ID)
);

-- Populate our model from the temporary import tables
INSERT INTO Node (ID, Label, IRI)
SELECT ID, Label, IRI FROM Edge_Labels_Import;
-- The IDs for both node and "edge" (predicate) labels start from 1,
-- so we need to make them unique to go into the same table.
INSERT INTO Node (ID, Label, IRI)
SELECT ID + 1 + (SELECT MAX(ID) FROM Edge_Labels_Import), Label, IRI
FROM Node_Labels_Import;

INSERT INTO Edge (Subject_ID, Predicate_ID, Object_ID)
SELECT Subject_ID + 1 + (SELECT MAX(ID) FROM Edge_Labels_Import),
       Predicate_ID,
       Object_ID + 1 + (SELECT MAX(ID) FROM Edge_Labels_Import)
FROM Edges_Import;

-- Now create remaining indexes on our model:
CREATE INDEX Node_Label on Node (Label);
CREATE INDEX Edge_Subj ON Edge (Subject_ID);
CREATE INDEX Edge_Pred ON Edge (Predicate_ID);
CREATE INDEX Edge_Obj  ON Edge (Object_ID);
