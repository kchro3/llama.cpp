// swift-tools-version:5.3

import PackageDescription

let platforms: [SupportedPlatform]? = [
    .macOS(.v11),
    .iOS(.v11),
    .watchOS(.v4),
    .tvOS(.v11)
]
let exclude: [String] = []
let additionalSources: [String] = ["ggml-metal.m"]
let additionalSettings: [CSetting] = [
    .unsafeFlags(["-fno-objc-arc"]),
    .define("GGML_SWIFT"),
    .define("GGML_USE_METAL")
]

let package = Package(
    name: "llama",
    platforms: platforms,
    products: [
        .library(name: "llama", targets: ["llama"]),
    ],
    targets: [
        .target(
            name: "llama",
            path: ".",
            exclude: exclude,
            sources: [
                "ggml.c",
                "llama.cpp",
                "ggml-alloc.c",
                "k_quants.c",
            ] + additionalSources,
            publicHeadersPath: "spm-headers",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32"]),
                .define("GGML_USE_K_QUANTS"),
                .define("GGML_USE_ACCELERATE")
            ] + additionalSettings,
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        )
    ],
    cxxLanguageStandard: .cxx11
)
