# Datasets used in rendering

## Recursive data structures in SQL

### Tree (species taxonomy tree)

-   The [lesson slides](../Lesson-06.qmd) use the [NCBI Taxonomy Database](https://www.ncbi.nlm.nih.gov/taxonomy) *"from a database dump downloaded from the NCBI FTP server on 2017-02-3, imported in a SQLite database table as a phylogenetic tree"* by R. Vos:

    > Vos, Rutger (2017): NCBI taxonomy database files. figshare. Dataset. <https://doi.org/10.6084/m9.figshare.4620733.v1>

    Download the file (ncbi-2017-02-03.db), then open in SQLite and apply the SQL (DDL) statements in [`ncbi-transform.sql`](ncbi-transform.sql).

### Graph (Ontology relation graph)

The [Ubergraph project](https://github.com/INCATools/ubergraph) within the [INCA Tools effort](https://reporter.nih.gov/search/Ah2TPoNbR0i36EpF0YKQbw/project-details/9545836) is integrating numerous bio-ontologies and transforming them into a simplified graph model (for example, existential property restrictions on classes are simplified to direct relations between nodes that represent classses). We will use one of their downloads: https://ubergraph.apps.renci.org/downloads/current/nonredundant-graph-table-labeled.tgz

-   Download the file (using `curl` or other means), and unpack its contents. For example (on macOS/Unix command line):

        curl -LO https://ubergraph.apps.renci.org/downloads/current/nonredundant-graph-table-labeled.tgz
        tar zxf nonredundant-graph-table-labeled.tgz

-   Change into the directory where the unpacked files are:

          cd nonredundant-graph-table-labeled

-   Open SQLite3 on a new database file:

          sqlite3 obo-graph.db

-   In the SQLite shell, execute the commands in [`obo-graph-transform.sql`](obo-graph-transform.sql).

    -   The commands create temporary tables and persistent tables. The temporary tables will disappear once you exit the SQLite shell, but the persistent ones (`Node` and `Edge`) will remain, and will be there next time you open the database in SQLite.
