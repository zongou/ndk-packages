# ndk-packages

build android targeted tools with [mini-ndk](https://github.com/zongou/mini-ndk)

## Find examples

- <https://github.com/termux/termux-packages/tree/master/packages>
- <https://github.com/leleliu008/ndk-pkg-formula-repository-offical-core/tree/master/formula>
- <https://github.com/Zackptg5/Cross-Compiled-Binaries-Android/tree/master/build_script>
- <https://github.com/alpinelinux/aports>

## Common build tools

```sh
curl make cmake automake autoconf libtool binutils gcc llvm python
```

## Setup Rust env

```sh
rustup target add aarch64-linux-android
```

Rust crates.io index

```sh
mkdir -vp ${CARGO_HOME:-$HOME/.cargo}

cat << EOF | tee -a ${CARGO_HOME:-$HOME/.cargo}/config
[source.crates-io]
replace-with = 'mirror'

[source.mirror]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"
EOF

```

## Get github source code archive URLs

Source code archives are available at specific URLs for each repository. For example, consider the repository `github/codeql`. There are different URLs for downloading a branch, a tag, or a specific commit ID.

| Type of archive | Example              | URL                                                                                         |
| --------------- | -------------------- | ------------------------------------------------------------------------------------------- |
| Branch          | `main`               | <https://github.com/github/codeql/archive/refs/**heads/main**.tar.gz>                       |
| Tag             | `codeql-cli/v2.12.0` | <https://github.com/github/codeql/archive/refs/**tags/codeql-cli/v2.12.0**.zip>             |
| Commit          | `aef66c4`            | <https://github.com/github/codeql/archive/**aef66c462abe817e33aad91d97aa782a1e2ad2c7**.zip> |

**Note**: You can use either `.zip` or `.tar.gz` in the URLs above to request a zipball or tarball respectively.
