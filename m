Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1D119AD78;
	Thu,  6 Jun 2024 14:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683345; cv=none; b=LibZDDAP8uEjbwXyK03Ry3Eq3zFo5gDB/DUVaAj6u1vRbYtXmmZo++pEmHG8isPLQQc0pwE11A0LYF7tF7bou44QvGNeNxfW32lUx+IBVv7vU40fu0tJzln0m+Ebbiz4eUlc62Jvek2r1CPbsMvp2kfEvhZnNK+juFhlKNn09wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683345; c=relaxed/simple;
	bh=SVdIbJvfoAQUAAbBC09gBdlV1Ne1qWv7nDMFayfXNko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3Kr45d3wy0hi4Dtp2d6ZOroDP1SLl7zRVIUtoCHteOcMoqciqNAyzs5dJX1mIQFXzEofegebaVZc/E//nveJPatwlQpZTIASjkfiEWWgmoqLmE0LPXH0L8end4uEGETZFsA2b/XX4lrBOgU5/q0XpPD+8oPacNjZuAw06fWETE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0HzVslm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0HzVslm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACBAC32782;
	Thu,  6 Jun 2024 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683345;
	bh=SVdIbJvfoAQUAAbBC09gBdlV1Ne1qWv7nDMFayfXNko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0HzVslmIebW6TbehWemJZYtJp0EUdqMOEVF1addK/nWFb2IlfAj1XFvlC84/UZ1+
	 a0IBDH7mNnDh3IoPUYpVts+l4ARDm5PwuqjQg5/Gx8X0fWW1CJk2riXG4tZwXxE5rk
	 us/uWN/JFChmzFUjl/W1yUY2Mz1IpN2Dhc3ixZvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helen Koike <helen.koike@collabora.com>,
	Vignesh Raman <vignesh.raman@collabora.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	David Heidelberg <david.heidelberg@collabora.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/744] drm/ci: uprev mesa version: fix container build & crosvm
Date: Thu,  6 Jun 2024 15:59:00 +0200
Message-ID: <20240606131740.976769277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <helen.koike@collabora.com>

[ Upstream commit 1887de00867d7a700babefc9647ccb9e0d11ee56 ]

When building containers, some rust packages were installed without
locking the dependencies version, which got updated and started giving
errors like:

error: failed to compile `bindgen-cli v0.62.0`, intermediate artifacts can be found at `/tmp/cargo-installkNKRwf`
Caused by:
  package `rustix v0.38.13` cannot be built because it requires rustc 1.63 or newer, while the currently active rustc version is 1.60.0

A patch to Mesa was added fixing this error, so update it.

Also, commit in linux kernel 6.6 rc3 broke booting in crosvm.
Mesa has upreved crosvm to fix this issue.

Signed-off-by: Helen Koike <helen.koike@collabora.com>
[crosvm mesa update]
Co-Developed-by: Vignesh Raman <vignesh.raman@collabora.com>
Signed-off-by: Vignesh Raman <vignesh.raman@collabora.com>
[v1 container build uprev]
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: David Heidelberg <david.heidelberg@collabora.com>
Link: https://lore.kernel.org/r/20231024004525.169002-2-helen.koike@collabora.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: a2c71b711e7e ("drm/ci: update device type for volteer devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ci/build.yml      |  1 +
 drivers/gpu/drm/ci/gitlab-ci.yml  | 20 +++++++++++++++++++-
 drivers/gpu/drm/ci/image-tags.yml |  2 +-
 drivers/gpu/drm/ci/lava-submit.sh |  2 +-
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ci/build.yml b/drivers/gpu/drm/ci/build.yml
index e6503f1c5927b..17ab38304885c 100644
--- a/drivers/gpu/drm/ci/build.yml
+++ b/drivers/gpu/drm/ci/build.yml
@@ -1,6 +1,7 @@
 .build:
   extends:
     - .build-rules
+    - .container+build-rules
   stage: build
   artifacts:
     paths:
diff --git a/drivers/gpu/drm/ci/gitlab-ci.yml b/drivers/gpu/drm/ci/gitlab-ci.yml
index 2c4df53f5dfe3..452b9c2532ae5 100644
--- a/drivers/gpu/drm/ci/gitlab-ci.yml
+++ b/drivers/gpu/drm/ci/gitlab-ci.yml
@@ -1,6 +1,6 @@
 variables:
   DRM_CI_PROJECT_PATH: &drm-ci-project-path mesa/mesa
-  DRM_CI_COMMIT_SHA: &drm-ci-commit-sha 0dc961645c4f0241f8512cb0ec3ad59635842072
+  DRM_CI_COMMIT_SHA: &drm-ci-commit-sha edfbf74df1d4d6ce54ffe24566108be0e1a98c3d
 
   UPSTREAM_REPO: git://anongit.freedesktop.org/drm/drm
   TARGET_BRANCH: drm-next
@@ -24,6 +24,8 @@ variables:
   PIPELINE_ARTIFACTS_BASE: ${S3_HOST}/artifacts/${CI_PROJECT_PATH}/${CI_PIPELINE_ID}
   # per-job artifact storage on MinIO
   JOB_ARTIFACTS_BASE: ${PIPELINE_ARTIFACTS_BASE}/${CI_JOB_ID}
+  # default kernel for rootfs before injecting the current kernel tree
+  KERNEL_IMAGE_BASE: https://${S3_HOST}/mesa-lava/gfx-ci/linux/v6.4.12-for-mesa-ci-f6b4ad45f48d
 
   LAVA_JOB_PRIORITY: 30
 
@@ -86,6 +88,17 @@ include:
       - '/.gitlab-ci/container/gitlab-ci.yml'
       - '/.gitlab-ci/test/gitlab-ci.yml'
       - '/.gitlab-ci/lava/lava-gitlab-ci.yml'
+      - '/src/microsoft/ci/gitlab-ci-inc.yml'
+      - '/src/gallium/drivers/zink/ci/gitlab-ci-inc.yml'
+      - '/src/gallium/drivers/crocus/ci/gitlab-ci-inc.yml'
+      - '/src/gallium/drivers/softpipe/ci/gitlab-ci-inc.yml'
+      - '/src/gallium/drivers/llvmpipe/ci/gitlab-ci-inc.yml'
+      - '/src/gallium/drivers/virgl/ci/gitlab-ci-inc.yml'
+      - '/src/gallium/drivers/nouveau/ci/gitlab-ci-inc.yml'
+      - '/src/gallium/frontends/lavapipe/ci/gitlab-ci-inc.yml'
+      - '/src/intel/ci/gitlab-ci-inc.yml'
+      - '/src/freedreno/ci/gitlab-ci-inc.yml'
+      - '/src/amd/ci/gitlab-ci-inc.yml'
   - drivers/gpu/drm/ci/image-tags.yml
   - drivers/gpu/drm/ci/container.yml
   - drivers/gpu/drm/ci/static-checks.yml
@@ -154,6 +167,11 @@ stages:
     # Run automatically once all dependency jobs have passed
     - when: on_success
 
+# When to automatically run the CI for container jobs
+.container+build-rules:
+  rules:
+    - !reference [.no_scheduled_pipelines-rules, rules]
+    - when: manual
 
 .ci-deqp-artifacts:
   artifacts:
diff --git a/drivers/gpu/drm/ci/image-tags.yml b/drivers/gpu/drm/ci/image-tags.yml
index f051b6c547c53..157d987149f07 100644
--- a/drivers/gpu/drm/ci/image-tags.yml
+++ b/drivers/gpu/drm/ci/image-tags.yml
@@ -1,5 +1,5 @@
 variables:
-   CONTAINER_TAG: "2023-08-10-mesa-uprev"
+   CONTAINER_TAG: "2023-10-11-mesa-uprev"
    DEBIAN_X86_64_BUILD_BASE_IMAGE: "debian/x86_64_build-base"
    DEBIAN_BASE_TAG: "${CONTAINER_TAG}"
 
diff --git a/drivers/gpu/drm/ci/lava-submit.sh b/drivers/gpu/drm/ci/lava-submit.sh
index 0c4456b21b0fc..379f26ea87cc0 100755
--- a/drivers/gpu/drm/ci/lava-submit.sh
+++ b/drivers/gpu/drm/ci/lava-submit.sh
@@ -22,7 +22,7 @@ cp "$SCRIPTS_DIR"/setup-test-env.sh results/job-rootfs-overlay/
 
 # Prepare env vars for upload.
 section_start variables "Variables passed through:"
-KERNEL_IMAGE_BASE_URL="https://${BASE_SYSTEM_HOST_PATH}" \
+KERNEL_IMAGE_BASE="https://${BASE_SYSTEM_HOST_PATH}" \
 	artifacts/ci-common/generate-env.sh | tee results/job-rootfs-overlay/set-job-env-vars.sh
 section_end variables
 
-- 
2.43.0



