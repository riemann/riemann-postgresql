Riemann PostgreSQL
=============

A PostgreSQL Riemann client.

Get Started
=============

The Ruby PostgreSQL Client `pg` has a dependency on the PostgreSQL development libraries. You will need to install this package using your OS package manager.

**Ubuntu/Debian :**

```bash
sudo apt-get install postgresql-server-dev-<postgresql-server-version>  (e.g. postgresql-server-dev-9.1)
```

**CentOS :**

```bash
sudo yum install postgresql-devel
```

Then install the `riemann-postgresql` gem.

```bash
gem install riemann-postgresql
```

Use the `--help` option of the `riemann-postgresql` binary to see the available options.

```bash
riemann-postgresql --help
```
