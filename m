Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B36145FF0;
	Thu, 11 Apr 2024 10:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830281; cv=none; b=K8LMtKExeNQg59sluUZBLJ9C+4Iv6//ni0m+ebx/KbSSCbwy/L2TEV8sFGxykqiOweFEkp1024TWnWPTfxcK2dngpMGONmWZvaeVkwoG3Nr7/qFjUaG14uUqoNyaFrPdKbLuzNf3OuPA/AjswUDdVJ7uEX26Xt7mS22qORSP2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830281; c=relaxed/simple;
	bh=uRT/FcYPSixVi7rBi99NyFaakCs8TlWMQnVH1OtOWUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgVg0l+2LpS814Q9NLp+Ihe+VT9aSIy4qGZJJBfBOBRhHq1J4KOwZBD0XlESNjKvO0rNr+aNnL4fFGIOm51CD5iv+uFpsH/PJIIPgFTjD5OpvSw3Q+gItQ8/yvDOekOlqblaCklvRvtn1QR/ZLvGnCyakFqjqh3ijzUTByiSarc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXFexpIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXFexpIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DB5C433C7;
	Thu, 11 Apr 2024 10:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830281;
	bh=uRT/FcYPSixVi7rBi99NyFaakCs8TlWMQnVH1OtOWUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXFexpIj3XxOQQx6XpMKZsyanA6yJQdmHWAhb7bG39UYD6vWBO9o6sTsPWVbZ/9n6
	 p/gEqY+aTa1bneu+DqicdccpM9SwKe30vPzjNszhCo+9gf/Xi8cOftj9qMWd2FG8Rw
	 gbwKCnF5CcYxV3W5jaLRXmclJcp31tf1wJRSoPTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david.heidelberg@collabora.com>,
	Helen Koike <helen.koike@collabora.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Vignesh Raman <vignesh.raman@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 058/143] drm/ci: uprev mesa version: fix kdl commit fetch
Date: Thu, 11 Apr 2024 11:55:26 +0200
Message-ID: <20240411095422.662530336@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Raman <vignesh.raman@collabora.com>

[ Upstream commit d315a68e94a76310c349add3f9c914cefda0a87f ]

build-kdl.sh was doing a `clone --depth 1` of the default branch,
then checking out a commit that might not be the latest of that
branch, resulting in container build error.

https://gitlab.freedesktop.org/mesa/mesa/-/commit/5efa4d56 fixes
kdl commit fetch issue. Uprev mesa in drm-ci to fix this.

This commit updates the kernel tag and adds .never-post-merge-rules
due to the mesa uprev. It also fixes an issue where the virtio-gpu
pipeline was not getting created with the mesa uprev.

Reviewed-by: David Heidelberg <david.heidelberg@collabora.com>
Acked-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Vignesh Raman <vignesh.raman@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231222033434.1537761-1-vignesh.raman@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ci/gitlab-ci.yml | 14 ++++++++++++--
 drivers/gpu/drm/ci/test.yml      |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ci/gitlab-ci.yml b/drivers/gpu/drm/ci/gitlab-ci.yml
index dac92cc2777cc..084e3ff8e3f42 100644
--- a/drivers/gpu/drm/ci/gitlab-ci.yml
+++ b/drivers/gpu/drm/ci/gitlab-ci.yml
@@ -1,6 +1,6 @@
 variables:
   DRM_CI_PROJECT_PATH: &drm-ci-project-path mesa/mesa
-  DRM_CI_COMMIT_SHA: &drm-ci-commit-sha edfbf74df1d4d6ce54ffe24566108be0e1a98c3d
+  DRM_CI_COMMIT_SHA: &drm-ci-commit-sha 9d162de9a05155e1c4041857a5848842749164cf
 
   UPSTREAM_REPO: git://anongit.freedesktop.org/drm/drm
   TARGET_BRANCH: drm-next
@@ -25,7 +25,9 @@ variables:
   # per-job artifact storage on MinIO
   JOB_ARTIFACTS_BASE: ${PIPELINE_ARTIFACTS_BASE}/${CI_JOB_ID}
   # default kernel for rootfs before injecting the current kernel tree
-  KERNEL_IMAGE_BASE: https://${S3_HOST}/mesa-lava/gfx-ci/linux/v6.4.12-for-mesa-ci-f6b4ad45f48d
+  KERNEL_REPO: "gfx-ci/linux"
+  KERNEL_TAG: "v6.6.4-for-mesa-ci-e4f4c500f7fb"
+  KERNEL_IMAGE_BASE: https://${S3_HOST}/mesa-lava/${KERNEL_REPO}/${KERNEL_TAG}
   LAVA_TAGS: subset-1-gfx
   LAVA_JOB_PRIORITY: 30
 
@@ -133,6 +135,11 @@ stages:
     - if: &is-pre-merge-for-marge '$GITLAB_USER_LOGIN == "marge-bot" && $CI_PIPELINE_SOURCE == "merge_request_event"'
       when: on_success
 
+.never-post-merge-rules:
+  rules:
+    - if: *is-post-merge
+      when: never
+
 # Rule to filter for only scheduled pipelines.
 .scheduled_pipeline-rules:
   rules:
@@ -150,6 +157,7 @@ stages:
 .build-rules:
   rules:
     - !reference [.no_scheduled_pipelines-rules, rules]
+    - !reference [.never-post-merge-rules, rules]
     # Run automatically once all dependency jobs have passed
     - when: on_success
 
@@ -157,6 +165,7 @@ stages:
 .container+build-rules:
   rules:
     - !reference [.no_scheduled_pipelines-rules, rules]
+    - !reference [.never-post-merge-rules, rules]
     - when: manual
 
 .ci-deqp-artifacts:
@@ -175,6 +184,7 @@ stages:
 .container-rules:
   rules:
     - !reference [.no_scheduled_pipelines-rules, rules]
+    - !reference [.never-post-merge-rules, rules]
     # Run pipeline by default in the main project if any CI pipeline
     # configuration files were changed, to ensure docker images are up to date
     - if: *is-post-merge
diff --git a/drivers/gpu/drm/ci/test.yml b/drivers/gpu/drm/ci/test.yml
index 5e1c727640c40..9faf76e55a56a 100644
--- a/drivers/gpu/drm/ci/test.yml
+++ b/drivers/gpu/drm/ci/test.yml
@@ -327,6 +327,7 @@ virtio_gpu:none:
     GPU_VERSION: none
   extends:
     - .test-gl
+    - .test-rules
   tags:
     - kvm
   script:
-- 
2.43.0



