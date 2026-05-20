Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A693A3E90;
	Wed, 20 May 2026 16:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295286; cv=none; b=bSRWkpxwa3WSKJcXbGfPdZz7aJMQE/1skfwf7KXTy7AZAUejFhaDA/sxNXU6TKON/m+Qe3L2TK9m3ZbT+l6dee6x+x0RvQJLGqEuQnVYv3HQ3mWKlzjNHbsHK63yazyJhI74cTpRp/0alSI9E70G0DY539wJaG9SAkSWwFYJkec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295286; c=relaxed/simple;
	bh=JHjo2OvuxdcO4gpQSWgri+e4Bt15IDecadMizOLqQ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfHxPG8j8NW2V4x8GKK6vo2UPWW79KhSqeFdaFex6qLcXrmOuPnXGc/1kaimBmOTtU2N1Rnkozo6uVYlZ7QUTx/XMTaV35YctX5lWz97UTz9CTRQS7z/OMpn/vVI002sz/SwNY+llR3lJ0FULegRTr/dXQWV7XlyM0c/l0ys79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzkZUJHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzkZUJHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7DD1F000E9;
	Wed, 20 May 2026 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295285;
	bh=W969MT7GZyWVsa8JocxVcxrS/HLxMFq/DekBNroSCYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzkZUJHh4eDyzWw81O5YeFE5xU1MgaAUNZ8Ytks4Q33J1bngdbi1gRejOzxglMcmW
	 Fx8iJg97G+KNUf76QHH/RuNhUU0h2zti4KdqGVaKcGUfdKUDii9vWbnQFNKVUJZYF3
	 pxTv54EHU4BekKt42+moIRF76b1EIjQf+icuAi+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0361/1146] drm/msm/a6xx: Correct OOB usage
Date: Wed, 20 May 2026 18:10:11 +0200
Message-ID: <20260520162156.371029477@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit d34b6919798c1a8c93e1d7cca297d0e068146bd5 ]

During the GMU resume sequence, using another OOB other than OOB_GPU may
confuse the internal state of GMU firmware. To align more strictly with
the downstream sequence, move the sysprof related OOB setup after the
OOB_GPU is cleared.

Fixes: 62cd0fa6990b ("drm/msm/adreno: Disable IFPC when sysprof is active")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/714659/
Message-ID: <20260327-a8xx-gpu-batch2-v2-4-2b53c38d2101@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 5 -----
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 6 ++++++
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c | 6 ++++++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 9662201cd2e9d..690d3e53e2738 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1236,11 +1236,6 @@ int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 	/* Set the GPU to the current freq */
 	a6xx_gmu_set_initial_freq(gpu, gmu);
 
-	if (refcount_read(&gpu->sysprof_active) > 1) {
-		ret = a6xx_gmu_set_oob(gmu, GMU_OOB_PERFCOUNTER_SET);
-		if (!ret)
-			set_bit(GMU_STATUS_OOB_PERF_SET, &gmu->status);
-	}
 out:
 	/* On failure, shut down the GMU to leave it in a good state */
 	if (ret) {
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index eeecde88e549f..4e0d67e3acb7e 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1605,6 +1605,12 @@ static int hw_init(struct msm_gpu *gpu)
 		a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_BOOT_SLUMBER);
 	}
 
+	if (!ret && (refcount_read(&gpu->sysprof_active) > 1)) {
+		ret = a6xx_gmu_set_oob(gmu, GMU_OOB_PERFCOUNTER_SET);
+		if (!ret)
+			set_bit(GMU_STATUS_OOB_PERF_SET, &gmu->status);
+	}
+
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
index 840af9c4d718c..fafeac62aebf5 100644
--- a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
@@ -711,6 +711,12 @@ static int hw_init(struct msm_gpu *gpu)
 	 */
 	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_GPU_SET);
 
+	if (!ret && (refcount_read(&gpu->sysprof_active) > 1)) {
+		ret = a6xx_gmu_set_oob(gmu, GMU_OOB_PERFCOUNTER_SET);
+		if (!ret)
+			set_bit(GMU_STATUS_OOB_PERF_SET, &gmu->status);
+	}
+
 	return ret;
 }
 
-- 
2.53.0



