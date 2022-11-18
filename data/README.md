# Datasets used in rendering

## Recursive data structures in SQL

### Tree (species taxonomy tree)

-   The [lesson slides](../Lesson-06.qmd) use the [NCBI Taxonomy Database](https://www.ncbi.nlm.nih.gov/taxonomy) *"from a database dump downloaded from the NCBI FTP server on 2017-02-3, imported in a SQLite database table as a phylogenetic tree"* by R. Vos:

    > Vos, Rutger (2017): NCBI taxonomy database files. figshare. Dataset. <https://doi.org/10.6084/m9.figshare.4620733.v1>

    Download the file (ncbi-2017-02-03.db), then open in SQLite and apply the SQL (DDL) statements in [`ncbi-transform.sql`](ncbi-transform.sql).

### Graph