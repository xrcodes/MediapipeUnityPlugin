load("@rules_pkg//:pkg.bzl", "pkg_zip")

cc_binary(
    name = "mediapipe_c",
    deps = [
        ":calculators",
        ":protobuf",
        "//mediapipe_api/framework:calculator_graph",
        "//mediapipe_api/framework/formats:classification",
        "//mediapipe_api/framework/formats:detection",
        "//mediapipe_api/framework/formats:image_frame",
        "//mediapipe_api/framework/formats:landmark",
        "//mediapipe_api/framework/formats:rect",
        "//mediapipe_api/framework/port:logging",
    ] + select({
        "@com_google_mediapipe//mediapipe/gpu:disable_gpu": [],
        "//conditions:default": [
            "//mediapipe_api/gpu:gl_base",
            "//mediapipe_api/gpu:gl_context",
            "//mediapipe_api/gpu:gl_calculator_helper",
            "//mediapipe_api/gpu:gpu_buffer_format",
            "//mediapipe_api/gpu:gpu_shared_data_internal",
        ],
    }),
    visibility = None,
    linkshared = True,
)

# It is recommended that you include only neccessary calculators.
cc_library(
    name = "calculators",
    deps = [
        "@com_google_mediapipe//mediapipe/calculators/core:pass_through_calculator",
        "@com_google_mediapipe//mediapipe/calculators/core:packet_presence_calculator",
    ] + select({
        "@com_google_mediapipe//mediapipe/gpu:disable_gpu": [
            "@com_google_mediapipe//mediapipe/graphs/face_detection:desktop_tflite_calculators",
            "@com_google_mediapipe//mediapipe/graphs/face_mesh:desktop_live_calculators",
            "@com_google_mediapipe//mediapipe/graphs/iris_tracking:iris_tracking_cpu_deps",
            "@com_google_mediapipe//mediapipe/graphs/hand_tracking:desktop_tflite_calculators",
            "@com_google_mediapipe//mediapipe/graphs/hand_tracking:multi_hand_desktop_tflite_calculators",
            "@com_google_mediapipe//mediapipe/graphs/pose_tracking:upper_body_pose_tracking_cpu_deps",
            # "@com_google_mediapipe//mediapipe/graphs/hair_segmentation:desktop_calculators",
            "@com_google_mediapipe//mediapipe/graphs/object_detection:desktop_tflite_calculators",
        ],
        "//conditions:default": [
            "@com_google_mediapipe//mediapipe/graphs/face_detection:mobile_calculators",
            "@com_google_mediapipe//mediapipe/graphs/face_mesh:desktop_live_gpu_calculators",
            "@com_google_mediapipe//mediapipe/graphs/iris_tracking:iris_tracking_gpu_deps",
            "@com_google_mediapipe//mediapipe/graphs/hand_tracking:mobile_calculators",
            "@com_google_mediapipe//mediapipe/graphs/hand_tracking:multi_hand_mobile_calculators",
            "@com_google_mediapipe//mediapipe/graphs/pose_tracking:upper_body_pose_tracking_gpu_deps",
            "@com_google_mediapipe//mediapipe/graphs/hair_segmentation:mobile_calculators",
            "@com_google_mediapipe//mediapipe/graphs/object_detection:mobile_calculators",
        ],
    }),
)

cc_library(
    name = "common",
    hdrs = ["common.h"],
    deps = [],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "protobuf",
    srcs = ["protobuf.cc"],
    hdrs = ["protobuf.h"],
    deps = [
        "@com_google_protobuf//:protobuf",
        ":common",
    ],
    alwayslink = True,
)

pkg_zip(
    name = "mediapipe_models",
    srcs = [
        "@com_google_mediapipe//mediapipe/models:face_detection_front.tflite",
        "@com_google_mediapipe//mediapipe/models:face_detection_front_labelmap.txt",
        "@com_google_mediapipe//mediapipe/models:face_landmark.tflite",
        "@com_google_mediapipe//mediapipe/models:hair_segmentation.tflite",
        "@com_google_mediapipe//mediapipe/models:hand_landmark.tflite",
        "@com_google_mediapipe//mediapipe/models:handedness.txt",
        "@com_google_mediapipe//mediapipe/models:iris_landmark.tflite",
        "@com_google_mediapipe//mediapipe/models:palm_detection.tflite",
        "@com_google_mediapipe//mediapipe/models:palm_detection_labelmap.txt",
        "@com_google_mediapipe//mediapipe/models:ssdlite_object_detection.tflite",
        "@com_google_mediapipe//mediapipe/models:ssdlite_object_detection_labelmap.txt",
        "@com_google_mediapipe//mediapipe/modules/pose_detection:pose_detection.tflite",
        "@com_google_mediapipe//mediapipe/modules/pose_landmark:pose_landmark_upper_body.tflite",
    ],
)
