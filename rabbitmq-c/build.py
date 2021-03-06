from conan.packager import ConanMultiPackager

if __name__ == "__main__":
    builder = ConanMultiPackager(build_policy="missing", gcc_versions=["5"], archs=["x86_64"], username="is")
    builder.add_common_builds(pure_c=True)
    builder.run()