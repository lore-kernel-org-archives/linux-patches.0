Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF122E7F0B;
	Thu,  3 Jul 2025 14:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554067; cv=none; b=EKcAKu6NnYUHUqZ3jwrYRZKklb/0kuVl4ARAHCX7pWVAt0bdMKNt3hBbIv1bz+7aInIdSaPBxzf0swXkmJT1S62ajQo+kLMt6qFLliTHN59FDh84e1ec9aFUW8qbGmChHg/+0HHxxQzCByNeOOOXHKCOwczsIlMwUNb5jRkW8CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554067; c=relaxed/simple;
	bh=4QoLjxOf/NxqbT8WWBjd5lnBh9Q9yqODhJNg5CGFKms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHGr7LkEZ3rMULNTnBQniybw5wb4K9FsI6xF2Uy8y/LAfpHw5WW9BGahnDi4i2k26unbhzIxGU3JZKLFYFuNMXi8cdNENSJ5G9bf+MQeH4mxDytCmUArr0Rz6qUeCCfGy9nU04j0YIw1BfQuIHRSQk5RByCTXZy8KZmr46oIZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmzuavFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmzuavFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383B7C4CEE3;
	Thu,  3 Jul 2025 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554067;
	bh=4QoLjxOf/NxqbT8WWBjd5lnBh9Q9yqODhJNg5CGFKms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmzuavFni9rRUK2Zbh1tZuZ2x0qmk5CndsO6WnVZOBfu2/9Z03/NMrxOS4LcO7v6T
	 36rti6VIGMka3HG0R/vYlPU0XlnCHxgYj2g8w5jYL0v4baxD8QU/PAB/DezeiN60w8
	 OShToPcuAiQpZVylnii9It0bx09isi1mkEKAqZsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/218] accel/ivpu: Remove copy engine support
Date: Thu,  3 Jul 2025 16:40:19 +0200
Message-ID: <20250703143958.780400320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>

[ Upstream commit 94b2a2c0e7cba3f163609dbd94120ee533ad2a07 ]

Copy engine was deprecated by the FW and is no longer supported.
Compute engine includes all copy engine functionality and should be used
instead.

This change does not affect user space as the copy engine was never
used outside of a couple of tests.

Signed-off-by: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241017145817.121590-4-jacek.lawrynowicz@linux.intel.com
Stable-dep-of: a47e36dc5d90 ("accel/ivpu: Trigger device recovery on engine reset/resume failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_drv.h     |  5 +---
 drivers/accel/ivpu/ivpu_job.c     | 43 +++++++++++--------------------
 drivers/accel/ivpu/ivpu_jsm_msg.c |  8 +++---
 include/uapi/drm/ivpu_accel.h     |  6 +----
 4 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_drv.h b/drivers/accel/ivpu/ivpu_drv.h
index 1fe6a3bd4e36b..4519c93fb377c 100644
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -50,11 +50,8 @@
 #define IVPU_JOB_ID_JOB_MASK		GENMASK(7, 0)
 #define IVPU_JOB_ID_CONTEXT_MASK	GENMASK(31, 8)
 
-#define IVPU_NUM_ENGINES       2
 #define IVPU_NUM_PRIORITIES    4
-#define IVPU_NUM_CMDQS_PER_CTX (IVPU_NUM_ENGINES * IVPU_NUM_PRIORITIES)
-
-#define IVPU_CMDQ_INDEX(engine, priority) ((engine) * IVPU_NUM_PRIORITIES + (priority))
+#define IVPU_NUM_CMDQS_PER_CTX (IVPU_NUM_PRIORITIES)
 
 #define IVPU_PLATFORM_SILICON 0
 #define IVPU_PLATFORM_SIMICS  2
diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 58d64a221a1e0..ed3f60d809bc0 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -224,8 +224,7 @@ static int ivpu_cmdq_fini(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cm
 static struct ivpu_cmdq *ivpu_cmdq_acquire(struct ivpu_file_priv *file_priv, u16 engine,
 					   u8 priority)
 {
-	int cmdq_idx = IVPU_CMDQ_INDEX(engine, priority);
-	struct ivpu_cmdq *cmdq = file_priv->cmdq[cmdq_idx];
+	struct ivpu_cmdq *cmdq = file_priv->cmdq[priority];
 	int ret;
 
 	lockdep_assert_held(&file_priv->lock);
@@ -234,7 +233,7 @@ static struct ivpu_cmdq *ivpu_cmdq_acquire(struct ivpu_file_priv *file_priv, u16
 		cmdq = ivpu_cmdq_alloc(file_priv);
 		if (!cmdq)
 			return NULL;
-		file_priv->cmdq[cmdq_idx] = cmdq;
+		file_priv->cmdq[priority] = cmdq;
 	}
 
 	ret = ivpu_cmdq_init(file_priv, cmdq, engine, priority);
@@ -244,15 +243,14 @@ static struct ivpu_cmdq *ivpu_cmdq_acquire(struct ivpu_file_priv *file_priv, u16
 	return cmdq;
 }
 
-static void ivpu_cmdq_release_locked(struct ivpu_file_priv *file_priv, u16 engine, u8 priority)
+static void ivpu_cmdq_release_locked(struct ivpu_file_priv *file_priv, u8 priority)
 {
-	int cmdq_idx = IVPU_CMDQ_INDEX(engine, priority);
-	struct ivpu_cmdq *cmdq = file_priv->cmdq[cmdq_idx];
+	struct ivpu_cmdq *cmdq = file_priv->cmdq[priority];
 
 	lockdep_assert_held(&file_priv->lock);
 
 	if (cmdq) {
-		file_priv->cmdq[cmdq_idx] = NULL;
+		file_priv->cmdq[priority] = NULL;
 		ivpu_cmdq_fini(file_priv, cmdq);
 		ivpu_cmdq_free(file_priv, cmdq);
 	}
@@ -260,14 +258,12 @@ static void ivpu_cmdq_release_locked(struct ivpu_file_priv *file_priv, u16 engin
 
 void ivpu_cmdq_release_all_locked(struct ivpu_file_priv *file_priv)
 {
-	u16 engine;
 	u8 priority;
 
 	lockdep_assert_held(&file_priv->lock);
 
-	for (engine = 0; engine < IVPU_NUM_ENGINES; engine++)
-		for (priority = 0; priority < IVPU_NUM_PRIORITIES; priority++)
-			ivpu_cmdq_release_locked(file_priv, engine, priority);
+	for (priority = 0; priority < IVPU_NUM_PRIORITIES; priority++)
+		ivpu_cmdq_release_locked(file_priv, priority);
 }
 
 /*
@@ -278,19 +274,15 @@ void ivpu_cmdq_release_all_locked(struct ivpu_file_priv *file_priv)
  */
 static void ivpu_cmdq_reset(struct ivpu_file_priv *file_priv)
 {
-	u16 engine;
 	u8 priority;
 
 	mutex_lock(&file_priv->lock);
 
-	for (engine = 0; engine < IVPU_NUM_ENGINES; engine++) {
-		for (priority = 0; priority < IVPU_NUM_PRIORITIES; priority++) {
-			int cmdq_idx = IVPU_CMDQ_INDEX(engine, priority);
-			struct ivpu_cmdq *cmdq = file_priv->cmdq[cmdq_idx];
+	for (priority = 0; priority < IVPU_NUM_PRIORITIES; priority++) {
+		struct ivpu_cmdq *cmdq = file_priv->cmdq[priority];
 
-			if (cmdq)
-				cmdq->db_registered = false;
-		}
+		if (cmdq)
+			cmdq->db_registered = false;
 	}
 
 	mutex_unlock(&file_priv->lock);
@@ -311,16 +303,11 @@ void ivpu_cmdq_reset_all_contexts(struct ivpu_device *vdev)
 
 static void ivpu_cmdq_fini_all(struct ivpu_file_priv *file_priv)
 {
-	u16 engine;
 	u8 priority;
 
-	for (engine = 0; engine < IVPU_NUM_ENGINES; engine++) {
-		for (priority = 0; priority < IVPU_NUM_PRIORITIES; priority++) {
-			int cmdq_idx = IVPU_CMDQ_INDEX(engine, priority);
-
-			if (file_priv->cmdq[cmdq_idx])
-				ivpu_cmdq_fini(file_priv, file_priv->cmdq[cmdq_idx]);
-		}
+	for (priority = 0; priority < IVPU_NUM_PRIORITIES; priority++) {
+		if (file_priv->cmdq[priority])
+			ivpu_cmdq_fini(file_priv, file_priv->cmdq[priority]);
 	}
 }
 
@@ -703,7 +690,7 @@ int ivpu_submit_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	int idx, ret;
 	u8 priority;
 
-	if (params->engine > DRM_IVPU_ENGINE_COPY)
+	if (params->engine != DRM_IVPU_ENGINE_COMPUTE)
 		return -EINVAL;
 
 	if (params->priority > DRM_IVPU_JOB_PRIORITY_REALTIME)
diff --git a/drivers/accel/ivpu/ivpu_jsm_msg.c b/drivers/accel/ivpu/ivpu_jsm_msg.c
index ae91ad24d10d8..33d597b2a7f53 100644
--- a/drivers/accel/ivpu/ivpu_jsm_msg.c
+++ b/drivers/accel/ivpu/ivpu_jsm_msg.c
@@ -132,7 +132,7 @@ int ivpu_jsm_get_heartbeat(struct ivpu_device *vdev, u32 engine, u64 *heartbeat)
 	struct vpu_jsm_msg resp;
 	int ret;
 
-	if (engine > VPU_ENGINE_COPY)
+	if (engine != VPU_ENGINE_COMPUTE)
 		return -EINVAL;
 
 	req.payload.query_engine_hb.engine_idx = engine;
@@ -155,7 +155,7 @@ int ivpu_jsm_reset_engine(struct ivpu_device *vdev, u32 engine)
 	struct vpu_jsm_msg resp;
 	int ret;
 
-	if (engine > VPU_ENGINE_COPY)
+	if (engine != VPU_ENGINE_COMPUTE)
 		return -EINVAL;
 
 	req.payload.engine_reset.engine_idx = engine;
@@ -174,7 +174,7 @@ int ivpu_jsm_preempt_engine(struct ivpu_device *vdev, u32 engine, u32 preempt_id
 	struct vpu_jsm_msg resp;
 	int ret;
 
-	if (engine > VPU_ENGINE_COPY)
+	if (engine != VPU_ENGINE_COMPUTE)
 		return -EINVAL;
 
 	req.payload.engine_preempt.engine_idx = engine;
@@ -346,7 +346,7 @@ int ivpu_jsm_hws_resume_engine(struct ivpu_device *vdev, u32 engine)
 	struct vpu_jsm_msg resp;
 	int ret;
 
-	if (engine >= VPU_ENGINE_NB)
+	if (engine != VPU_ENGINE_COMPUTE)
 		return -EINVAL;
 
 	req.payload.hws_resume_engine.engine_idx = engine;
diff --git a/include/uapi/drm/ivpu_accel.h b/include/uapi/drm/ivpu_accel.h
index 13001da141c33..4b261eb705bc0 100644
--- a/include/uapi/drm/ivpu_accel.h
+++ b/include/uapi/drm/ivpu_accel.h
@@ -261,7 +261,7 @@ struct drm_ivpu_bo_info {
 
 /* drm_ivpu_submit engines */
 #define DRM_IVPU_ENGINE_COMPUTE 0
-#define DRM_IVPU_ENGINE_COPY    1
+#define DRM_IVPU_ENGINE_COPY    1 /* Deprecated */
 
 /**
  * struct drm_ivpu_submit - Submit commands to the VPU
@@ -292,10 +292,6 @@ struct drm_ivpu_submit {
 	 * %DRM_IVPU_ENGINE_COMPUTE:
 	 *
 	 * Performs Deep Learning Neural Compute Inference Operations
-	 *
-	 * %DRM_IVPU_ENGINE_COPY:
-	 *
-	 * Performs memory copy operations to/from system memory allocated for VPU
 	 */
 	__u32 engine;
 
-- 
2.39.5



