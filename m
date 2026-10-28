Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216708;
	b=VuA0TZUHnb5CfM5o/2HR92Q6/WZ3+3XjMw2jkRlwXYVmQ1s/m6M0L6b6BF/TqBw4I7v2
	 xEZFAY/zBw9Uy1UtQJ9WdFxbC+/Covt04ZtGKLXamyhsXh8/Fp+6RCNwPY2qjgkZnZJ9/
	 1CCNmVNpDFy4fltp1D25x7Xzn4HxcO2ASYck5Q4jTtUDU6FOAtn/3ZyAzh08qxlXBv1DB
	 jVgRAXJ9fe4SFjjQTeY9zpxuzE+alEDKg3SzO84JWGh5p9t6EHtB8nqewSEe84i3RgEUE
	 zxa8QLjglaBCFihJnwPC4mSy1lfumst4ZshTc6JlWOisT9E+OLy0A0qnqw7YWDt9ZXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uXdKjheeyLX4gR3Dfi8fcJRHHVUyBO5HocQhuZ7M8V0=;
	b=sqlW+rRqhYlTk4IwSmjN/A/mKfypF8VFLGmvN2qocwlvPLzq2TWXYXMZd35aMJ6kSuQ5
	 BLikM+dxOOfoV7WXp/OkffppnfROvzTQIBMTJaotk88NI8vX2692XtZEUpjyloaSQQr45
	 bytV9Zxk0aD2IobBuSlqhAKfVkHoOP7XaU0ZdYyv0LUBBRZ5Dw07tOgmcQwz9+i+BiTSw
	 vpTZOmjcpaTWcxZAz45Lyr8Ma6DzNvmJbSEa0kSofnURC+INjEPWlPPgoKxZTjjd1s87Q
	 qNF/zBWSf04iTLp9tzNy9cYiDT7b7TGjBkgD3I/c15DsONnpqiodunfqW+BmioYKJlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Bg/btsjL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4158E606A31A;
	Wed, 28 Oct 2026 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bg/btsjL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911C51F01825;
	Wed, 28 Oct 2026 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216708;
	bh=uXdKjheeyLX4gR3Dfi8fcJRHHVUyBO5HocQhuZ7M8V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bg/btsjLAPoTDOYWCLiVkFzvR2LU1J/7QIqjcteqdo6jGv2EluAFVhWSsGzoXppw5
	 W0Qge33sqjOsDAq0gXKAIU+Tq+aPyJwKxYV5FcEk7fsvqhAA5WGAjbTIKqlIcYeFJT
	 R46lRmt499jFnL5UjtJadUOnzNOLkPVGbPzxCWsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1644/1887] drm/v3d: Clear queue->active_job when v3d_fence_create() fails
Date: Wed, 28 Oct 2026 18:02:20 +0100
Message-ID: <20261028170536.877053187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 25a1669907512e927fab9ad4d4fb74ff57f63cd9 ]

The run_job() callbacks for BIN, RENDER, TFU and CSD assign the incoming
job to queue->active_job before calling v3d_fence_create(). If
v3d_fence_create() fails, the callback returns NULL without clearing
active_job, leaving a dangling pointer.

Create a failure path in all run_job() callbacks that clears the active
job before returning NULL. The BIN path takes queue->queue_lock around the
clear as it races against v3d_overflow_mem_work(); RENDER, TFU and CSD
paths have no concurrent reader, so the clear is lock-free.

Fixes: a783a09ee76d ("drm/v3d: Refactor job management.")
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://patch.msgid.link/20260604-v3d-sched-misc-fixes-v4-2-c068f5bf5ccf@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 60 +++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index ad979e7d33150..e31a3c8ff924f 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -77,15 +77,11 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 	struct v3d_bin_job *job = to_bin_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 	unsigned long irqflags;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		spin_lock_irqsave(&v3d->job_lock, irqflags);
-		v3d->queue[V3D_BIN].active_job = NULL;
-		spin_unlock_irqrestore(&v3d->job_lock, irqflags);
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	/* Lock required around bin_job update vs
 	 * v3d_overflow_mem_work().
@@ -102,7 +98,7 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_BIN);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -129,6 +125,12 @@ static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CLE_CT0QEA, job->end);
 
 	return fence;
+
+out_clean_job:
+	spin_lock_irqsave(&v3d->job_lock, irqflags);
+	v3d->queue[V3D_BIN].active_job = NULL;
+	spin_unlock_irqrestore(&v3d->job_lock, irqflags);
+	return fence;
 }
 
 static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
@@ -136,12 +138,10 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 	struct v3d_render_job *job = to_render_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		v3d->queue[V3D_RENDER].active_job = NULL;
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	v3d->queue[V3D_RENDER].active_job = &job->base;
 
@@ -155,7 +155,7 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_RENDER);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -175,6 +175,10 @@ static struct dma_fence *v3d_render_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CLE_CT1QEA, job->end);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_RENDER].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
@@ -183,18 +187,16 @@ v3d_tfu_job_run(struct drm_sched_job *sched_job)
 	struct v3d_tfu_job *job = to_tfu_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		v3d->queue[V3D_TFU].active_job = NULL;
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	v3d->queue[V3D_TFU].active_job = &job->base;
 
 	fence = v3d_fence_create(v3d, V3D_TFU);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -218,6 +220,10 @@ v3d_tfu_job_run(struct drm_sched_job *sched_job)
 	V3D_WRITE(V3D_TFU_ICFG, job->args.icfg | V3D_TFU_ICFG_IOC);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_TFU].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
@@ -226,13 +232,11 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	struct v3d_csd_job *job = to_csd_job(sched_job);
 	struct v3d_dev *v3d = job->base.v3d;
 	struct drm_device *dev = &v3d->drm;
-	struct dma_fence *fence;
+	struct dma_fence *fence = NULL;
 	int i;
 
-	if (unlikely(job->base.base.s_fence->finished.error)) {
-		v3d->queue[V3D_CSD].active_job = NULL;
-		return NULL;
-	}
+	if (unlikely(job->base.base.s_fence->finished.error))
+		goto out_clean_job;
 
 	/* The HW interprets a workgroup size of 0 as 65536; however, the
 	 * user-space driver exposes a maximum of 65535. Therefore, a 0 in
@@ -250,7 +254,7 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 
 	fence = v3d_fence_create(v3d, V3D_CSD);
 	if (IS_ERR(fence))
-		return NULL;
+		goto out_clean_job;
 
 	if (job->base.irq_fence)
 		dma_fence_put(job->base.irq_fence);
@@ -266,6 +270,10 @@ v3d_csd_job_run(struct drm_sched_job *sched_job)
 	V3D_CORE_WRITE(0, V3D_CSD_QUEUED_CFG0, job->args.cfg[0]);
 
 	return fence;
+
+out_clean_job:
+	v3d->queue[V3D_CSD].active_job = NULL;
+	return fence;
 }
 
 static struct dma_fence *
-- 
2.53.0



