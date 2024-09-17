# Datasets used in rendering

## Recursive data structures in SQL

### Tree (species taxonomy tree)

-   The [lesson slides](../Lesson-RecurSQL.qmd) use the [NCBI Taxonomy Database](https://www.ncbi.nlm.nih.gov/taxonomy) *"from a database dump downloaded from the NCBI FTP server on 2017-02-3, imported in a SQLite database table as a phylogenetic tree"* by R. Vos:

    > Vos, Rutger (2017): NCBI taxonomy database files. figshare. Dataset. <https://doi.org/10.6084/m9.figshare.4620733.v1>

    Download the file (ncbi-2017-02-03.db), then open in SQLite and apply the SQL (DDL) statements in [`ncbi-transform.sql`](ncbi-transform.sql).

### Graph (Ontology relation graph)

The [Ubergraph project](https://github.com/INCATools/ubergraph) within the [INCA Tools effort](https://reporter.nih.gov/search/Ah2TPoNbR0i36EpF0YKQbw/project-details/9545836) is integrating numerous bio-ontologies and [transforming them into a simplified graph model](https://github.com/INCATools/ubergraph#graph-organization) (for example, existential property restrictions on classes are simplified to direct relations between nodes that represent classes).

> Balhoff, J., Bayindir, U., Caron, A. R., Matentzoglu, N., Osumi-Sutherland, D., & Mungall, C. J. (2022). [Ubergraph: integrating OBO ontologies into a unified semantic graph](https://doi.org/10.5281/zenodo.7249759). In ICBO-2022: International Conference on Biomedical Ontology (Vol. 1613, p. 73). Ann Arbor, Michigan.

We will use one of their [downloads](https://github.com/INCATools/ubergraph#downloads). More specifically, because the downloads currenly maintained by RENCI's Ubergraph database don't include the node (class) and edge (property) labels anymore, we will use a [legacy download obtained in Nov 2022](https://huggingface.co/datasets/hlapp/ubergraph).

-   Download the file (using `curl` or other means), and unpack its contents. For example (on macOS/Unix command line):

    ```
    curl -LO https://huggingface.co/datasets/hlapp/ubergraph/resolve/main/nonredundant-graph-table-labeled.tgz?download=true
    tar zxf nonredundant-graph-table-labeled.tgz
    ```

-   Change into the directory where the unpacked files are:

    ```
    cd nonredundant-graph-table-labeled
    ```

-   Open SQLite3 on a new database file:

    ```
    sqlite3 obo-graph.db
    ```

-   In the SQLite shell, execute the commands in [`obo-graph-transform.sql`](obo-graph-transform.sql).

    - You can do this using copy&paste, but you can also run the whole file at once if you downloaded it, using the `.read` SQLite shell command:

        ```
        sqlite> .read path/to/obo-graph-transform.sql
        ```

    - The commands create temporary tables and persistent tables. The temporary tables will disappear once you exit the SQLite shell (or close the SQLite database connection), but the persistent ones (`Node` and `Edge`) will remain, and will be there next time you open the database in SQLite.
