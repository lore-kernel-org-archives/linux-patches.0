Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8841CAA5;
	Sat,  3 Feb 2024 04:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933865; cv=none; b=PX21AE4BwT57zV+pd2y5XJN1NV3YUOGApppmSYHTe95AsnN53aVmHuVPNMkAInuBvW2RbvolD54Efxt1NYKwe4bkHI/ztLWavQqW+yYLypo6mK/HIcZgOcLC0z+wIvhw508HRrpQQb9Buwt7NXbupI1eqIHg+hn360mfAtWldWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933865; c=relaxed/simple;
	bh=GMNe0tOERPXZEvJCZOJE0Y6DPMeCkWFXrFPjUChrNdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/mYgxHWxGox37KTYKkYUrDu8sWsmX75/t9JZ19ys/oKmWooYoTMShpLYFfLlPRRSO2gdsIX4u7rB/q3xDHK2JK3xLnQhMahO7o+vxZcsDv3YRYm6pt6ihOIqYiBP1qQsAzp6YpfYjocduIK58ZgkhHrxEidYwUbxSKtdL4U0Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yByvuOri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yByvuOri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB496C433C7;
	Sat,  3 Feb 2024 04:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933864;
	bh=GMNe0tOERPXZEvJCZOJE0Y6DPMeCkWFXrFPjUChrNdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yByvuOriQEgGLI2X6vWDLBEm9D3SVnJn3CAVoDOFpzBxNIov2XhMjygYulCdED4G7
	 oCR/Q9e/bEDN83LA6Jd10i9zeT37Uyrs2M1mBn1lnEWz0GtMCd+2lSL7UPk7HCbPcN
	 2GE9887aldPV3McZWoYAiZP5A9aE9ycKWEJUWyfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danylo Piliaiev <dpiliaiev@igalia.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 167/353] drm/msm/a690: Fix reg values for a690
Date: Fri,  2 Feb 2024 20:04:45 -0800
Message-ID: <20240203035408.921724019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danylo Piliaiev <dpiliaiev@igalia.com>

[ Upstream commit 07e6de738aa6f0e873463e9ca88bdb7081c4bfd4 ]

KGSL doesn't support a690 so all reg values were the same as
on a660. Now we know the values and they are different from the
windows driver.

This fixes hangs on D3D12 games and some CTS tests.

Signed-off-by: Danylo Piliaiev <dpiliaiev@igalia.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/568931/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 7a0220d29a23..500ed2d183fc 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1312,6 +1312,7 @@ static void a6xx_set_ubwc_config(struct msm_gpu *gpu)
 
 	if (adreno_is_a650(adreno_gpu) ||
 	    adreno_is_a660(adreno_gpu) ||
+	    adreno_is_a690(adreno_gpu) ||
 	    adreno_is_a730(adreno_gpu) ||
 	    adreno_is_a740_family(adreno_gpu)) {
 		/* TODO: get ddr type from bootloader and use 2 for LPDDR4 */
@@ -1321,13 +1322,6 @@ static void a6xx_set_ubwc_config(struct msm_gpu *gpu)
 		uavflagprd_inv = 2;
 	}
 
-	if (adreno_is_a690(adreno_gpu)) {
-		hbb_lo = 2;
-		amsbc = 1;
-		rgb565_predicator = 1;
-		uavflagprd_inv = 2;
-	}
-
 	if (adreno_is_7c3(adreno_gpu)) {
 		hbb_lo = 1;
 		amsbc = 1;
@@ -1741,7 +1735,9 @@ static int hw_init(struct msm_gpu *gpu)
 	/* Setting the primFifo thresholds default values,
 	 * and vccCacheSkipDis=1 bit (0x200) for A640 and newer
 	*/
-	if (adreno_is_a650(adreno_gpu) || adreno_is_a660(adreno_gpu) || adreno_is_a690(adreno_gpu))
+	if (adreno_is_a690(adreno_gpu))
+		gpu_write(gpu, REG_A6XX_PC_DBG_ECO_CNTL, 0x00800200);
+	else if (adreno_is_a650(adreno_gpu) || adreno_is_a660(adreno_gpu))
 		gpu_write(gpu, REG_A6XX_PC_DBG_ECO_CNTL, 0x00300200);
 	else if (adreno_is_a640_family(adreno_gpu) || adreno_is_7c3(adreno_gpu))
 		gpu_write(gpu, REG_A6XX_PC_DBG_ECO_CNTL, 0x00200200);
@@ -1775,6 +1771,8 @@ static int hw_init(struct msm_gpu *gpu)
 	if (adreno_is_a730(adreno_gpu) ||
 	    adreno_is_a740_family(adreno_gpu))
 		gpu_write(gpu, REG_A6XX_RBBM_INTERFACE_HANG_INT_CNTL, (1 << 30) | 0xcfffff);
+	else if (adreno_is_a690(adreno_gpu))
+		gpu_write(gpu, REG_A6XX_RBBM_INTERFACE_HANG_INT_CNTL, (1 << 30) | 0x4fffff);
 	else if (adreno_is_a619(adreno_gpu))
 		gpu_write(gpu, REG_A6XX_RBBM_INTERFACE_HANG_INT_CNTL, (1 << 30) | 0x3fffff);
 	else if (adreno_is_a610(adreno_gpu))
@@ -1808,12 +1806,17 @@ static int hw_init(struct msm_gpu *gpu)
 	a6xx_set_cp_protect(gpu);
 
 	if (adreno_is_a660_family(adreno_gpu)) {
-		gpu_write(gpu, REG_A6XX_CP_CHICKEN_DBG, 0x1);
+		if (adreno_is_a690(adreno_gpu))
+			gpu_write(gpu, REG_A6XX_CP_CHICKEN_DBG, 0x00028801);
+		else
+			gpu_write(gpu, REG_A6XX_CP_CHICKEN_DBG, 0x1);
 		gpu_write(gpu, REG_A6XX_RBBM_GBIF_CLIENT_QOS_CNTL, 0x0);
 	}
 
+	if (adreno_is_a690(adreno_gpu))
+		gpu_write(gpu, REG_A6XX_UCHE_CMDQ_CONFIG, 0x90);
 	/* Set dualQ + disable afull for A660 GPU */
-	if (adreno_is_a660(adreno_gpu))
+	else if (adreno_is_a660(adreno_gpu))
 		gpu_write(gpu, REG_A6XX_UCHE_CMDQ_CONFIG, 0x66906);
 	else if (adreno_is_a7xx(adreno_gpu))
 		gpu_write(gpu, REG_A6XX_UCHE_CMDQ_CONFIG,
-- 
2.43.0



