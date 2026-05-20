Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6A7372B31;
	Wed, 20 May 2026 16:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295283; cv=none; b=nfcr8hs76oWaRgxVxtcVIpUsrTGrdxWZUYUkR0uC3SXIipQ4Bf6if85Q2en8qxAFKKPGyg2tnvRhd573qV+YPTIcbHxHKnqfwjjSSgDiP/3+10WIoDkaH1fy82xImzbjBBsTf35O6G4MHeRbteoV5lLUt6nLHxwlxTladtHkGAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295283; c=relaxed/simple;
	bh=MyPls/gySHitaSjVyym3xRlC7v51WZqH/GF84C153Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRd1L0EG0uCZ0ZL6bCflqXNO2/EPn0MhD1hV7xP6CVEj3+N3CI8g6SvPLLu+aW9pqyyIGK5zRy4XgLfGlSbD+6N3G85x6sgjU7IyPevovF6/I7UqocHIkBsZjN8f3ryq6p7QpEFDe0XUM48zsSWifG9w2HYFr2w1vHYHH/X6e+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeW39Ql1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeW39Ql1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EACC1F000E9;
	Wed, 20 May 2026 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295282;
	bh=I32KpGJqADVRlRD7mBbvZ1OhtNHhPoqNi0HmoKAJD94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeW39Ql1f1zl3C36bElH6CxpETm5ywQYbkyL6nuCHi87AGGLuF0mYlNWRf4BDsdwx
	 /HkrHdVN782JjLSj14rKIcziQlvSrV9LkBQoQ6G5fZxl+yZdfTTqfE/ZOXNBuP1evP
	 +etAQCn5Az78cbR6BpwEMQIoNbJTdjQOlvH1hldY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0360/1146] drm/msm/a6xx: Switch to preemption safe AO counter
Date: Wed, 20 May 2026 18:10:10 +0200
Message-ID: <20260520162156.348320201@linuxfoundation.org>
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

[ Upstream commit 0c59f258ffd4c9c2a6bd37d71a0ade1db8bc03b7 ]

CP_ALWAYS_ON_COUNTER is not save-restored during preemption, so it won't
provide accurate data about the 'submit' when preemption is enabled.
Switch to CP_ALWAYS_ON_CONTEXT which is preemption safe.

Fixes: e7ae83da4a28 ("drm/msm/a6xx: Implement preemption for a7xx targets")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/714657/
Message-ID: <20260327-a8xx-gpu-batch2-v2-3-2b53c38d2101@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 4fe2b86e7a839..eeecde88e549f 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -347,7 +347,7 @@ static void a6xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	 * GPU registers so we need to add 0x1a800 to the register value on A630
 	 * to get the right value from PM4.
 	 */
-	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_COUNTER,
+	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_CONTEXT,
 		rbmemptr_stats(ring, index, alwayson_start));
 
 	/* Invalidate CCU depth and color */
@@ -388,7 +388,7 @@ static void a6xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 
 	get_stats_counter(ring, REG_A6XX_RBBM_PERFCTR_CP(0),
 		rbmemptr_stats(ring, index, cpcycles_end));
-	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_COUNTER,
+	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_CONTEXT,
 		rbmemptr_stats(ring, index, alwayson_end));
 
 	/* Write the fence to the scratch register */
@@ -457,7 +457,7 @@ static void a7xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
 	struct msm_ringbuffer *ring = submit->ring;
-	u32 rbbm_perfctr_cp0, cp_always_on_counter;
+	u32 rbbm_perfctr_cp0, cp_always_on_context;
 	unsigned int i, ibs = 0;
 
 	adreno_check_and_reenable_stall(adreno_gpu);
@@ -480,14 +480,14 @@ static void a7xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 
 	if (adreno_is_a8xx(adreno_gpu)) {
 		rbbm_perfctr_cp0 = REG_A8XX_RBBM_PERFCTR_CP(0);
-		cp_always_on_counter = REG_A8XX_CP_ALWAYS_ON_COUNTER;
+		cp_always_on_context = REG_A8XX_CP_ALWAYS_ON_CONTEXT;
 	} else {
 		rbbm_perfctr_cp0 = REG_A7XX_RBBM_PERFCTR_CP(0);
-		cp_always_on_counter = REG_A6XX_CP_ALWAYS_ON_COUNTER;
+		cp_always_on_context = REG_A6XX_CP_ALWAYS_ON_CONTEXT;
 	}
 
 	get_stats_counter(ring, rbbm_perfctr_cp0, rbmemptr_stats(ring, index, cpcycles_start));
-	get_stats_counter(ring, cp_always_on_counter, rbmemptr_stats(ring, index, alwayson_start));
+	get_stats_counter(ring, cp_always_on_context, rbmemptr_stats(ring, index, alwayson_start));
 
 	OUT_PKT7(ring, CP_THREAD_CONTROL, 1);
 	OUT_RING(ring, CP_SET_THREAD_BOTH);
@@ -535,7 +535,7 @@ static void a7xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	}
 
 	get_stats_counter(ring, rbbm_perfctr_cp0, rbmemptr_stats(ring, index, cpcycles_end));
-	get_stats_counter(ring, cp_always_on_counter, rbmemptr_stats(ring, index, alwayson_end));
+	get_stats_counter(ring, cp_always_on_context, rbmemptr_stats(ring, index, alwayson_end));
 
 	/* Write the fence to the scratch register */
 	if (adreno_is_a8xx(adreno_gpu)) {
-- 
2.53.0



