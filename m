Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D04C1EABCD;
	Tue, 15 Oct 2024 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992774; cv=none; b=cnneE6rsj1/KDUnY2lvHt+abhk7FObnSkloNBmrFYFBKfPelxaPHDp57H3j4b12IhXQPh8zaSLjOpkH//o1d2xvC9D89Uvcs2fpHYFf/4KH87XDaelvJmBNELOmiSakBr6hssiIW+hx+g4kJgWpK4To8ihEg0GtVXUCkIyP9ejM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992774; c=relaxed/simple;
	bh=fPZLo5zQQnOmfsIe+0MmkU1TpC74Sd1IPQFc7gd/2u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDsqIwRQA4dT1lY4rFC3iNEbsGsyWpmZdxGRGOfafe27tNQb7QtoL4iZIb+WcLajwmT8SOMV7pCqd99uYveOSPCTbK3sd5bkVCciGL9xWKD+rpGUihpnhulLVhVBQR3+l55owPY6VJ71Rkdy8fgpe0E/KeQjcp20gqGJ0l+uV2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuuSBb6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuuSBb6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C132BC4CEC6;
	Tue, 15 Oct 2024 11:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992774;
	bh=fPZLo5zQQnOmfsIe+0MmkU1TpC74Sd1IPQFc7gd/2u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuuSBb6ynEGMWC8+5+SU8YiRqTRg014EnUxOBisKnuFV3e8Q71+y5v0LMGH8WBLV/
	 2D1zzeaUzKv6pFYOuY2QaHAqaFWSAguejgy3DHaY+co7UOmqMNbXXq1oqliXgIs0e2
	 EJQ8MKZ9YnJ2m/fy49CHzt/1paJSyfXsajn8xLj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Akhil P Oommen <akhilpo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/691] drm/msm: Drop priv->lastctx
Date: Tue, 15 Oct 2024 13:22:11 +0200
Message-ID: <20241015112447.623704792@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 1d054c9b8457b56a651109fac21f56f46ccd46b2 ]

cur_ctx_seqno already does the same thing, but handles the edge cases
where a refcnt'd context can live after lastclose.  So let's not have
two ways to do the same thing.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20211109181117.591148-3-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: a30f9f65b5ac ("drm/msm/a5xx: workaround early ring-buffer emptiness check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c |  3 +--
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c |  3 +--
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c |  3 +--
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c |  8 +++-----
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |  9 +++------
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h | 10 ----------
 drivers/gpu/drm/msm/msm_drv.c         |  6 ------
 drivers/gpu/drm/msm/msm_drv.h         |  2 +-
 drivers/gpu/drm/msm/msm_gpu.c         |  2 +-
 drivers/gpu/drm/msm/msm_gpu.h         | 11 +++++++++++
 10 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index 17d6a1ecb1110..b4ca5985f015a 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -12,7 +12,6 @@ static bool a2xx_idle(struct msm_gpu *gpu);
 
 static void a2xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 {
-	struct msm_drm_private *priv = gpu->dev->dev_private;
 	struct msm_ringbuffer *ring = submit->ring;
 	unsigned int i;
 
@@ -23,7 +22,7 @@ static void a2xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 			break;
 		case MSM_SUBMIT_CMD_CTX_RESTORE_BUF:
 			/* ignore if there has not been a ctx switch: */
-			if (priv->lastctx == submit->queue->ctx)
+			if (gpu->cur_ctx_seqno == submit->queue->ctx->seqno)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
diff --git a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
index 8fb847c174ff8..2e481e2692ba9 100644
--- a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
@@ -30,7 +30,6 @@ static bool a3xx_idle(struct msm_gpu *gpu);
 
 static void a3xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 {
-	struct msm_drm_private *priv = gpu->dev->dev_private;
 	struct msm_ringbuffer *ring = submit->ring;
 	unsigned int i;
 
@@ -41,7 +40,7 @@ static void a3xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 			break;
 		case MSM_SUBMIT_CMD_CTX_RESTORE_BUF:
 			/* ignore if there has not been a ctx switch: */
-			if (priv->lastctx == submit->queue->ctx)
+			if (gpu->cur_ctx_seqno == submit->queue->ctx->seqno)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
diff --git a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
index a96ee79cc5e08..c5524d6e8705c 100644
--- a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
@@ -24,7 +24,6 @@ static bool a4xx_idle(struct msm_gpu *gpu);
 
 static void a4xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 {
-	struct msm_drm_private *priv = gpu->dev->dev_private;
 	struct msm_ringbuffer *ring = submit->ring;
 	unsigned int i;
 
@@ -35,7 +34,7 @@ static void a4xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 			break;
 		case MSM_SUBMIT_CMD_CTX_RESTORE_BUF:
 			/* ignore if there has not been a ctx switch: */
-			if (priv->lastctx == submit->queue->ctx)
+			if (gpu->cur_ctx_seqno == submit->queue->ctx->seqno)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 22aa05d08f5ea..1f48d561f39b9 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -65,7 +65,6 @@ void a5xx_flush(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 
 static void a5xx_submit_in_rb(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 {
-	struct msm_drm_private *priv = gpu->dev->dev_private;
 	struct msm_ringbuffer *ring = submit->ring;
 	struct msm_gem_object *obj;
 	uint32_t *ptr, dwords;
@@ -76,7 +75,7 @@ static void a5xx_submit_in_rb(struct msm_gpu *gpu, struct msm_gem_submit *submit
 		case MSM_SUBMIT_CMD_IB_TARGET_BUF:
 			break;
 		case MSM_SUBMIT_CMD_CTX_RESTORE_BUF:
-			if (priv->lastctx == submit->queue->ctx)
+			if (gpu->cur_ctx_seqno == submit->queue->ctx->seqno)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
@@ -126,12 +125,11 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a5xx_gpu *a5xx_gpu = to_a5xx_gpu(adreno_gpu);
-	struct msm_drm_private *priv = gpu->dev->dev_private;
 	struct msm_ringbuffer *ring = submit->ring;
 	unsigned int i, ibs = 0;
 
 	if (IS_ENABLED(CONFIG_DRM_MSM_GPU_SUDO) && submit->in_rb) {
-		priv->lastctx = NULL;
+		gpu->cur_ctx_seqno = 0;
 		a5xx_submit_in_rb(gpu, submit);
 		return;
 	}
@@ -170,7 +168,7 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 		case MSM_SUBMIT_CMD_IB_TARGET_BUF:
 			break;
 		case MSM_SUBMIT_CMD_CTX_RESTORE_BUF:
-			if (priv->lastctx == submit->queue->ctx)
+			if (gpu->cur_ctx_seqno == submit->queue->ctx->seqno)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 2d07c02c59f14..27fae0dc97040 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -106,7 +106,7 @@ static void a6xx_set_pagetable(struct a6xx_gpu *a6xx_gpu,
 	u32 asid;
 	u64 memptr = rbmemptr(ring, ttbr0);
 
-	if (ctx->seqno == a6xx_gpu->cur_ctx_seqno)
+	if (ctx->seqno == a6xx_gpu->base.base.cur_ctx_seqno)
 		return;
 
 	if (msm_iommu_pagetable_params(ctx->aspace->mmu, &ttbr, &asid))
@@ -138,14 +138,11 @@ static void a6xx_set_pagetable(struct a6xx_gpu *a6xx_gpu,
 
 	OUT_PKT7(ring, CP_EVENT_WRITE, 1);
 	OUT_RING(ring, 0x31);
-
-	a6xx_gpu->cur_ctx_seqno = ctx->seqno;
 }
 
 static void a6xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 {
 	unsigned int index = submit->seqno % MSM_GPU_SUBMIT_STATS_COUNT;
-	struct msm_drm_private *priv = gpu->dev->dev_private;
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
 	struct msm_ringbuffer *ring = submit->ring;
@@ -177,7 +174,7 @@ static void a6xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 		case MSM_SUBMIT_CMD_IB_TARGET_BUF:
 			break;
 		case MSM_SUBMIT_CMD_CTX_RESTORE_BUF:
-			if (priv->lastctx == submit->queue->ctx)
+			if (gpu->cur_ctx_seqno == submit->queue->ctx->seqno)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
@@ -1085,7 +1082,7 @@ static int hw_init(struct msm_gpu *gpu)
 	/* Always come up on rb 0 */
 	a6xx_gpu->cur_ring = gpu->rb[0];
 
-	a6xx_gpu->cur_ctx_seqno = 0;
+	gpu->cur_ctx_seqno = 0;
 
 	/* Enable the SQE_to start the CP engine */
 	gpu_write(gpu, REG_A6XX_CP_SQE_CNTL, 1);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
index 8e5527c881b1e..86e0a7c3fe6df 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
@@ -20,16 +20,6 @@ struct a6xx_gpu {
 
 	struct msm_ringbuffer *cur_ring;
 
-	/**
-	 * cur_ctx_seqno:
-	 *
-	 * The ctx->seqno value of the context with current pgtables
-	 * installed.  Tracked by seqno rather than pointer value to
-	 * avoid dangling pointers, and cases where a ctx can be freed
-	 * and a new one created with the same address.
-	 */
-	int cur_ctx_seqno;
-
 	struct a6xx_gmu gmu;
 
 	struct drm_gem_object *shadow_bo;
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index e238d2beb7abe..8e6a9d0d85e59 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -732,14 +732,8 @@ static void context_close(struct msm_file_private *ctx)
 
 static void msm_postclose(struct drm_device *dev, struct drm_file *file)
 {
-	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_file_private *ctx = file->driver_priv;
 
-	mutex_lock(&dev->struct_mutex);
-	if (ctx == priv->lastctx)
-		priv->lastctx = NULL;
-	mutex_unlock(&dev->struct_mutex);
-
 	context_close(ctx);
 }
 
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 8488e49817e1e..164605f0103b1 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -157,7 +157,7 @@ struct msm_drm_private {
 
 	/* when we have more than one 'msm_gpu' these need to be an array: */
 	struct msm_gpu *gpu;
-	struct msm_file_private *lastctx;
+
 	/* gpu is only set on open(), but we need this info earlier */
 	bool is_a2xx;
 	bool has_cached_coherent;
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index a2f21b89d077c..8250d86d11e7a 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -763,7 +763,7 @@ void msm_gpu_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	mutex_unlock(&gpu->active_lock);
 
 	gpu->funcs->submit(gpu, submit);
-	priv->lastctx = submit->queue->ctx;
+	gpu->cur_ctx_seqno = submit->queue->ctx->seqno;
 
 	hangcheck_timer_reset(gpu);
 }
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 461ff5a5aa5bb..bb37878258c8c 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -137,6 +137,17 @@ struct msm_gpu {
 	struct msm_ringbuffer *rb[MSM_GPU_MAX_RINGS];
 	int nr_rings;
 
+	/**
+	 * cur_ctx_seqno:
+	 *
+	 * The ctx->seqno value of the last context to submit rendering,
+	 * and the one with current pgtables installed (for generations
+	 * that support per-context pgtables).  Tracked by seqno rather
+	 * than pointer value to avoid dangling pointers, and cases where
+	 * a ctx can be freed and a new one created with the same address.
+	 */
+	int cur_ctx_seqno;
+
 	/*
 	 * List of GEM active objects on this gpu.  Protected by
 	 * msm_drm_private::mm_lock
-- 
2.43.0



