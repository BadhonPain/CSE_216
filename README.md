# CSE 216 — Database Sessional (Section B)

Online assessments, practice problems, and the course project for the **CSE 216 Database Lab**, Section B, Department of Computer Science and Engineering, Bangladesh University of Engineering and Technology (BUET).

## Repository Structure

```
CSE_216/
├── Online/              # Solutions to online lab assessments
├── Practice Problem/    # Weekly practice problem sets and solutions
└── Project/             # Course project
```

| Directory | Description |
| --- | --- |
| `Online` | Solutions to the online tests conducted during the lab sessions |
| `Practice Problem` | Practice sets covering DDL, DML, queries, and PL/SQL |
| `Project` | Database-driven course project |

## Topics Covered

- Data Definition Language (`CREATE`, `ALTER`, `DROP`, constraints)
- Data Manipulation Language (`INSERT`, `UPDATE`, `DELETE`)
- Single-row and aggregate functions
- Joins and subqueries
- Views, sequences, and indexes
- PL/SQL: procedures, functions, triggers, and cursors

## Getting Started

### Prerequisites

- Oracle Database (XE 21c or later recommended)
- SQL*Plus, SQL Developer, or any Oracle-compatible client
- The Oracle `HR` sample schema

### Usage

```bash
git clone https://github.com/BadhonPain/CSE_216.git
cd CSE_216
```

Open the desired `.sql` file in your SQL client, connect to the `HR` schema, and run the script.

```sql
@"Practice Problem/<file_name>.sql"
```

## Conventions

- One script per problem set
- Each script is self-contained and can be re-run after dropping the tables it creates
- Table and column names follow the problem statements

## Author

**Badhon Pain**
<br>
CSE '24
<br>
Bangladesh University of Engineering and Technology (BUET)
<br>
GitHub: [@BadhonPain](https://github.com/BadhonPain)

## Disclaimer

This repository is for learning and reference purposes. Students are encouraged to attempt the problems independently before consulting the solutions.