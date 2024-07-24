#!/bin/env bash

PROJECT_FILES_PATH="$PWD"

NPM_PROJECT_SLUG="$(bw generate -l -n --length 4)"
PROJECT_NAME="workshop-gha-$NPM_PROJECT_SLUG"
echo Starting script!!

echo "PROJECT=$PROJECT_NAME"
echo "PATH=/tmp/$PROJECT_NAME"
## Create project on GH

cd /tmp/
gh repo create --private --clone "$PROJECT_NAME"
cd $PROJECT_NAME

npm init -y

cat <<EOF > README.md
# Workshop GHA
EOF

npm install --save-dev jest
git add README.md package.json package-lock.json
git commit -m "chore: initial commit"
git push --set-upstream origin main

mkdir -p .github/workflows
cat <<'EOF' > .github/workflows/pr-checker.yaml
name: PR Checker
on:
  pull_request:
    paths:
      - '**.js'

jobs:
  run-tests:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
        node: [18, 20, 22]
    runs-on: ${{ matrix.os }}
    steps:
      - name: Prepare | Checkout repo
        uses: actions/checkout@v4
      - name: Prepare | Setup node ${{ matrix.node }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}.x

      - name: Prepare | Get npm cache directory
        id: npm-cache
        run: echo "dir=$(npm config get cache)" >> $GITHUB_OUTPUT

      - name: Prepare | Cache dependencies
        id: cache
        uses: actions/cache@v4
        with:
          path: ${{ steps.npm-cache.outputs.dir }}
          key: ${{ runner.os }}-node-${{ matrix.node }}-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-${{ matrix.node }}

      - name: Prepare | Install dependencies
        if: steps.cache.outputs.cache-hit != 'true'
        run: npm i

      - name: Run tests
        run: npm run test
EOF
git add ./.github/workflows/pr-checker.yaml
git commit -m "ci(pr-checker): add workflow"
git push

cat <<EOF > ./package.json
{
  "name": "@jpedrodelacerda/workshop-gha-$NPM_PROJECT_SLUG",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "João Lacerda <dev@jpedrodelacerda.com> (https://ddb.jpedrodelacerda.com/)",
  "license": "(MIT OR Apache-2.0)",
  "description": "",
  "devDependencies": {
    "jest": "^29.7.0"
  },
  "publishConfig": {
    "access": "public"
  }
}
EOF
git add ./package.json
git commit -m "chore(package): additional info"
git push

gh secret set NPM_TOKEN -f $PROJECT_FILES_PATH/.env
gh secret set PAT_TOKEN -b $(gh auth token)
cat <<'EOF' > ./.github/workflows/release-please.yaml
name: Create release and publish
on:
  push:
    branches:
      - main
    paths:
      - '**.js'
      - 'CHANGELOG.md'
      - 'package.json'

jobs:
  release-please:
    permissions:
      contents: write # Permitir a criação do commit de release
      pull-requests: write # Permitir a criação do PR de release

    runs-on: ubuntu-latest
    steps:
      - name: Prepare | Create github release
        uses: googleapis/release-please-action@v4
        id: release
        with:
          token: ${{ secrets.PAT_TOKEN }}
          release-type: node

      - name: Prepare | Checkout repo
        if: ${{ steps.release.outputs.release_created }}
        uses: actions/checkout@v4

      - name: Prepare | Configure Node+NPM
        if: ${{ steps.release.outputs.release_created }}
        uses: actions/setup-node@v4
        with:
          version: 22.x
          registry-url: 'https://registry.npmjs.org'

      - name: Prepare | Install deps
        if: ${{ steps.release.outputs.release_created }}
        run: npm ci

      - name: Publish | Publish package to NPM
        run: npm publish
        if: ${{ steps.release.outputs.release_created }}
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
EOF
git add ./.github/workflows/release-please.yaml
git commit -m "ci(release): add workflow"
git push

git checkout -b feat/add-hello
cat <<'EOF' > ./index.js
const { hello } = require("./src/hello");

console.log(hello());

module.exports = { hello };
EOF
mkdir -p src/
cat <<'EOF' > ./src/hello.js
const hello = () => {
    return "Olá mundo!";
};

module.exports = { hello };
EOF
git add index.js src/hello.js
git commit -m "feat: add greeting function"
git push --set-upstream origin feat/add-hello

gh pr create -B main -t "feat: add greeting function" -b ""
sleep 30

sed -i 's/"test.*/"test": "jest"/' package.json
git add package.json
git commit -m 'chore: use `jest` to run tests'
git push
sleep 30

cat <<'EOF' > src/hello.test.js
const { hello } = require("./hello");

test("Retorna 'Olá mundo!'", () => {
    expect(hello()).toBe("Olá mundo!");
});
EOF
git add src/hello.test.js
git commit -m 'test: add `hello.test.js`'
git push

sleep 30
gh pr merge -s
sleep 10
gh pr merge 2 -s
