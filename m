Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4159F216605;
	Tue, 29 Apr 2025 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949418; cv=none; b=uBGAL28ZlzN21pU8/Aon4S0Q0Gh+LCj3s/Ar19xxT3lQviOz9dPZBLSyWNl0wyg+IUhrhmLBfjHovhF06gW0/Y5e/c2UxJGmAfA7CTP9c3gaaZfom8kxhulc6eLjop1CMqLU1CoJsMp42HoLuvJ3lzpZZjbZay44Ia7DpbWcUW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949418; c=relaxed/simple;
	bh=4eKRWPyi0xJBsS8A47+j7OQDLGsPgqrQwRIe4GBMEbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRgTC+LZZcAjLKUqkT8cqi3zOAw2CU5D5GKhGw88bY5+hYVPfUE0fpogJsfBltQEkweUKXfXQurkIuhD1WBN6rHeGf8DzPi1CC1aWE/CwtFV+YLVsPLZ1et49DTl+dJpdwmj7GYbTexDeVHNpLZLhqKFlR881LB/WgN0DhPHbuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R66RTB4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R66RTB4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F1C4CEE3;
	Tue, 29 Apr 2025 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949417;
	bh=4eKRWPyi0xJBsS8A47+j7OQDLGsPgqrQwRIe4GBMEbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R66RTB4kUB6TN+LiVEN9PNrWSecY1KNxet5H/zPn5G6MNB1C3ASwhxeze2X097FeD
	 zytK+iak3Ay3ni+6uPCcKEvjVRga0ZarsfC79GV1vwdHDMTjGfS/1wAQV7uJ1s9B0n
	 OinPgmocYZCXFWJreQI4jAgi1NfCFNKCxTE6d0O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/373] drm/msm/a6xx: Avoid gx gbit halt during rpm suspend
Date: Tue, 29 Apr 2025 18:42:41 +0200
Message-ID: <20250429161134.792722529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit f4a75b5933c998e60fd812a7680e0971eb1c7cee ]

As per the downstream driver, gx gbif halt is required only during
recovery sequence. So lets avoid it during regular rpm suspend.

Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/515279/
Link: https://lore.kernel.org/r/20221216223253.1.Ice9c47bfeb1fddb8dc377a3491a043a3ee7fca7d@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: f561db72a663 ("drm/msm/a6xx: Fix stale rpmh votes from GPU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 15 +++++++++------
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |  7 +++++++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 65ba58c712c93..ea59c54437dec 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -872,7 +872,8 @@ static void a6xx_gmu_rpmh_off(struct a6xx_gmu *gmu)
 #define GBIF_CLIENT_HALT_MASK             BIT(0)
 #define GBIF_ARB_HALT_MASK                BIT(1)
 
-static void a6xx_bus_clear_pending_transactions(struct adreno_gpu *adreno_gpu)
+static void a6xx_bus_clear_pending_transactions(struct adreno_gpu *adreno_gpu,
+		bool gx_off)
 {
 	struct msm_gpu *gpu = &adreno_gpu->base;
 
@@ -885,9 +886,11 @@ static void a6xx_bus_clear_pending_transactions(struct adreno_gpu *adreno_gpu)
 		return;
 	}
 
-	/* Halt the gx side of GBIF */
-	gpu_write(gpu, REG_A6XX_RBBM_GBIF_HALT, 1);
-	spin_until(gpu_read(gpu, REG_A6XX_RBBM_GBIF_HALT_ACK) & 1);
+	if (gx_off) {
+		/* Halt the gx side of GBIF */
+		gpu_write(gpu, REG_A6XX_RBBM_GBIF_HALT, 1);
+		spin_until(gpu_read(gpu, REG_A6XX_RBBM_GBIF_HALT_ACK) & 1);
+	}
 
 	/* Halt new client requests on GBIF */
 	gpu_write(gpu, REG_A6XX_GBIF_HALT, GBIF_CLIENT_HALT_MASK);
@@ -925,7 +928,7 @@ static void a6xx_gmu_force_off(struct a6xx_gmu *gmu)
 	/* Halt the gmu cm3 core */
 	gmu_write(gmu, REG_A6XX_GMU_CM3_SYSRESET, 1);
 
-	a6xx_bus_clear_pending_transactions(adreno_gpu);
+	a6xx_bus_clear_pending_transactions(adreno_gpu, true);
 
 	/* Reset GPU core blocks */
 	gpu_write(gpu, REG_A6XX_RBBM_SW_RESET_CMD, 1);
@@ -1079,7 +1082,7 @@ static void a6xx_gmu_shutdown(struct a6xx_gmu *gmu)
 			return;
 		}
 
-		a6xx_bus_clear_pending_transactions(adreno_gpu);
+		a6xx_bus_clear_pending_transactions(adreno_gpu, a6xx_gpu->hung);
 
 		/* tell the GMU we want to slumber */
 		ret = a6xx_gmu_notify_slumber(gmu);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index a1dff22b02a7a..1c38c3acacbeb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1178,6 +1178,12 @@ static void a6xx_recover(struct msm_gpu *gpu)
 	if (hang_debug)
 		a6xx_dump(gpu);
 
+	/*
+	 * To handle recovery specific sequences during the rpm suspend we are
+	 * about to trigger
+	 */
+	a6xx_gpu->hung = true;
+
 	/* Halt SQE first */
 	gpu_write(gpu, REG_A6XX_CP_SQE_CNTL, 3);
 
@@ -1191,6 +1197,7 @@ static void a6xx_recover(struct msm_gpu *gpu)
 	gpu->funcs->pm_resume(gpu);
 
 	msm_gpu_hw_init(gpu);
+	a6xx_gpu->hung = false;
 }
 
 static const char *a6xx_uche_fault_block(struct msm_gpu *gpu, u32 mid)
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
index 86e0a7c3fe6df..79d0cecff8e91 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.h
@@ -32,6 +32,7 @@ struct a6xx_gpu {
 	void *llc_slice;
 	void *htw_llc_slice;
 	bool have_mmu500;
+	bool hung;
 };
 
 #define to_a6xx_gpu(x) container_of(x, struct a6xx_gpu, base)
-- 
2.39.5



