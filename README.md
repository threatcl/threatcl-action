# threatcl-action

This action wraps https://github.com/threatcl/threatcl, the threat modelling with HCL tool, and allows practitioners to easily generate Dashboards, or validate `threatcl` threat model files with [GitHub Actions](https://github.com/features/actions).

## Usage Examples

### Automatically validate `threatcl` spec HCL files

This example workflow will kick off for any `push` or `pull requests`, and will validate all `.hcl` files in the `hcl-files` folder.

```yaml
name: threatcl validate

on: [push, pull_request]

jobs:
  threatcl-validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: threatcl validate
        uses: threatcl/threatcl-action@v0.0.2
        with:
          command: 'validate'
          files: './hcl-files/*'
```

You can see a working example of this workflow at [threatcl-actions-example](https://github.com/threatcl/threatcl-action-example/actions).

### Generate a Dashboard and re-commit it to the repo

This example workflow will kick off any pushes to the `main` branch, and will also run the validation first. It will then commit back to the repo.

```yaml
name: threatcl dashboard

on:
  push:
    branches:
      - main

jobs:
  threatcl-dashboard:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: threatcl validate
        uses: threatcl/threatcl-action@v0.0.2
        with:
          command: 'validate'
          files: './hcl-files/*'
      - name: threatcl dashboard
        uses: threatcl/threatcl-action@v0.0.2
        with:
          command: 'dashboard'
          files: './hcl-files/*'
          outdir: './dashboard'
      - name: Commit dashboard
        run: |
          git config --global user.name "threatcl Git Action"
          git config --global user.email "yourname@users.noreply.github.com"
          git add ./dashboard
          git commit -m "Automated updated dashboard"
          git push
```

You can see a working example of this workflow at [threatcl-actions-example](https://github.com/threatcl/threatcl-action-example/actions).

### Generate DFD files

This example workflow will kick off any pushes to the `main` branch, but will not re-write back to the repo.

```yaml
name: threatcl dfd

on:
  push:
    branches:
      - main

jobs:
  threatcl-dashboard:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: threatcl DFD
        uses: threatcl/threatcl-action@v0.0.2
        with:
          command: 'dfd'
          files: './hcl-files/*'
          outdir: './dfd'
```

You can see a working example of this workflow at [threatcl-actions-example](https://github.com/threatcl/threatcl-action-example/actions).

### Export JSON files

This example workflow will kick off any pushes to the `main` branch, but will not re-write back to the repo. OTM formatted JSON file will be written to `./output/tm.json`

```yaml
name: threatcl export

on:
  push:
    branches:
      - main

jobs:
  threatcl-export:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: threatcl export
        uses: threatcl/threatcl-action@v0.0.2
        with:
          command: 'export'
          files: './hcl-files/*'
          export-format: 'otm'
          export-output: './output/tm.json'
```

You can see a working example of this workflow at [threatcl-actions-example](https://github.com/threatcl/threatcl-action-example/actions).


## Supported Parameters

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `command` | This is the `threatcl` command to execute. Needs to be `validate`, `dashboard`, `export`, or `dfd` | `validate` | Y |
| `files` | This is the location of files in the repo to parse with `threatcl` | `*` | Y |
| `outdir` | For the `dashboard` or `dfd` mode, this is required, and is where the generated output will be written | | N |
| `outext` | For the `dashboard` mode, allows you to specify the extension of generated files | | N |
| `dashboard-template` | For the `dashboard` mode, allows you to specify a dashboard template file | | N |
| `dashboard-filename` | For the `dashboard` mode, allows you to specify a dashboard filename | | N |
| `dashboard-html` | For the `dashboard` mode, allows you to specify whether the output is html. Needs to be `true` or `false` | `false` | N |
| `threatmodel-template` | For the `dashboard` mode, allows you to specify a threatmodel template file | | N |
| `dfd-type` | For the `dfd` mode, allows you to set the output type. Needs to be `png`, `svg`, or `dot` | `png` | N |
| `export-format` | For the `export` mode, allows you to set the export format. Needs to be `json`, `hcl`, or `otm` | `json` | N |
| `export-output` | For the `export` mode, allows you to set where the exported file is saved. | | N |

## Event Triggers

The GitHub Actions framework allows you to trigger this (and other) actions on _many combinations_ of events. Read through [Workflow syntax for GitHub Actions](https://help.github.com/en/articles/workflow-syntax-for-github-actions) for ideas and advanced examples.

## Versioning

The latest updates will always be tagged `latest`. See [CHANGELOG.md](CHANGELOG.md) for previous releases. The current version is:

```yaml
- uses: threatcl/threatcl-action:v0.0.2
```

## Releasing

There are a few steps involved in updating the github action.

After you've updated any contents in the [Dockerfile](Dockerfile) or [entrypoint.sh](entrypoint.sh), you'll need to re-build the image, and push it to Docker hub. To do this:

1. Update the `VERSION` in the [Makefile](Makefile) and the image tag in the [Dockerfile](Dockerfile) < particularly if this is for a new threatcl version
2. Merge this into `main` and see if the `pre-release` action runs. The image should be built correctly, but not pushed into ghcr.
3. Update the image docker version referenced in [action.yml](action.yml)
4. Update the [CHANGELOG.md](CHANGELOG.md)
5. Update the version number references and examples in the [README.md](README.md)
6. Git push these updates to `main` branch as well
7. Tag the repo with the new version: `$ git tag -a v0.0.x -m 'v0.0.x' && git push origin --tags`
8. This should run the `release` action, which should build and push the image into ghcr
9. (I don't think we need to do this anymore ) Tag the repo with the `latest` tag: `$ git tag -f latest && git push --force origin latest`
9. Make sure you update the examples in https://github.com/threatcl/threatcl-action-example

## License

The source code for this project is released under the [MIT License](LICENSE). This project is not associated with GitHub.
