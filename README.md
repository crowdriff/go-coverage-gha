# Go coverage report

A GitHub Action to add a coverage [report][1] and [badge][2] to your Go repo.

Apply it to your repo by adding this step to one of your workflows:

```yaml
- name: Update coverage report
  uses: crowdriff/go-coverage-gha@v0
```

Your repo needs to have a Wiki for the action to work,
and workflows need to have read _and_ write permissions to the repo.

Complete example:

```yaml
- name: Test
  run: go test -v ./...

- name: Update coverage report
  uses: crowdriff/go-coverage-gha@v0
  if: |
    matrix.os == 'ubuntu-latest' &&
    github.event_name == 'push'  
  continue-on-error: true
```

The action generates an [HTML report][1] and [SVG badge][2],
and saves them as “hidden” files in your Wiki.

To add a coverage badge to your `README.md`, use this Markdown snippet:

```markdown
[![Go Coverage](https://github.com/USER/REPO/wiki/coverage.svg)](https://raw.githack.com/wiki/USER/REPO/coverage.html)
```

Clicking on the badge opens the [coverage report][1].

The action will also [log][3] to the Wiki the unix timestamp and coverage of every run,

[1]: https://raw.githack.com/wiki/ncruces/go-sqlite3/coverage.html
[2]: https://github.com/ncruces/go-sqlite3/wiki/coverage.svg
[3]: https://github.com/ncruces/go-sqlite3/wiki/coverage.log
[4]: https://github.com/ncruces/go-sqlite3/wiki/Test-coverage-report

## Use manually or as a pre-commit hook

The [script](coverage.sh) can also be run manually, or as a [pre-commit hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

## Credits
- [@ncruces](https://github.com/ncruces/) for the original action from [ncruces/go-coverage-report](https://github.com/ncruces/go-coverage-report)
- [@vieux](https://github.com/vieux/) for [gocover.io](https://github.com/vieux/gocover.io) which I've used for years before creating this
- [@Prounckk](https://github.com/Prounckk) for the [blog](https://eremeev.ca/posts/golang-test-coverage-github-action/) that prompted this solution
- [raw.githack.com](https://raw.githack.com/) for proxying the HTML report
- [shields.io](https://shields.io/) for SVG badge generation
- [quickchart.io](https://quickchart.io/) for SVG charts