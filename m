Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153C41A8F7B;
	Sat, 12 Sep 2026 10:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207536; cv=none; b=Nk9woXvMv1g09EBiTOxTxW1YTi3rpQYK6GwoyC8bB/L35zxHRhE2Z3+yUkBuAd7g3HRdDljyeRNb+yJZ84oBTArdBNHc4Uw3i2co0bC3dmpH+HRMjpZUoQ9z+2PMN8QcSMjVpZBC4oZG6oYinDFEp4hZD75Ds26A/W+fOfgUIuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207536; c=relaxed/simple;
	bh=WASfj61P933xP6rmHcXHJyPviClfi0Pu1ZX5EbiD2R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc+UkYUcC8yOeYUl01iBt8pzG1Ds3jIgicj4nZqroGU9/w+HbNmFG/f0uQY2W/L/N71A8p3NeoYAmjQ7zG6YTV9isiCqh30JuIpYArOJTBgnc4o7gHX9WXZkVp0b00oxUzZgp58BNDq/mJEJGLsbYp3EEDpHIi9RL8aj6B2Eou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pJot+fM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pJot+fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3211F000FF;
	Sat, 12 Sep 2026 10:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207535;
	bh=KL4ULGtt+4SjfqBKbgnfDrxD1Y390wnGCz826U6Zdek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pJot+fMnwVt9Rdh2VYY7mHKCVtBQFhkQb+12aPsWX6ZVDjHf+5KaLpaeSE/NEZ8S
	 Rswf9zBV0PV1dsJ9EUGKg4CpTWst81shCZ4aY9LzL7r+9oOeHTnkoWZbGeA7yu+Upk
	 X+DwBF/YC416je7XroabjwjEvwJ6bjU7L3NRqQNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0432/1518] drm/msm/a6xx: Fix A621 GPUCC register list for state capture
Date: Sat, 12 Sep 2026 08:43:21 +0200
Message-ID: <20260912065633.223332232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit d052d0358fb89b59718b9c24871d72006d4b89b0 ]

A621 uses an incorrect GPUCC register list during state capture.

The existing list matches A623/A663. Rename it accordingly and add a
dedicated A621 GPUCC register list.

Fixes: 11cdb81b3c1b ("drm/msm/a6xx: Fix gpucc register block for A621")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730659/
Message-ID: <20260605-assorted-fixes-june-v1-4-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c |  7 ++++---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h | 12 ++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 8a412b7d3129f..cdd1a27ab8106 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -1244,11 +1244,12 @@ static void a6xx_get_gmu_registers(struct msm_gpu *gpu,
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[1],
 		&a6xx_state->gmu_registers[1], true);
 
-	if (adreno_is_a621(adreno_gpu) ||
-	    adreno_is_a623(adreno_gpu) ||
-	    adreno_is_a663(adreno_gpu))
+	if (adreno_is_a621(adreno_gpu))
 		_a6xx_get_gmu_registers(gpu, a6xx_state, &a621_gpucc_reg,
 			&a6xx_state->gmu_registers[2], false);
+	else if (adreno_is_a623(adreno_gpu) || adreno_is_a663(adreno_gpu))
+		_a6xx_get_gmu_registers(gpu, a6xx_state, &a623_gpucc_reg,
+			&a6xx_state->gmu_registers[2], false);
 	else
 		_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gpucc_reg,
 			&a6xx_state->gmu_registers[2], false);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h
index 4753b71837f33..e6fcae8d4bd34 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h
@@ -377,6 +377,17 @@ static const u32 a6xx_gmu_gpucc_registers[] = {
 };
 
 static const u32 a621_gmu_gpucc_registers[] = {
+	/* GPU CC */
+	0x24000, 0x2400e, 0x24400, 0x2440e, 0x24800, 0x24805, 0x24c00, 0x24cff,
+	0x25800, 0x25804, 0x25c00, 0x25c04, 0x26000, 0x26004, 0x26400, 0x26405,
+	0x26414, 0x2641d, 0x2642a, 0x26430, 0x26432, 0x26432, 0x26441, 0x26455,
+	0x26466, 0x26468, 0x26478, 0x2647a, 0x26489, 0x2648a, 0x2649c, 0x2649e,
+	0x264a0, 0x264a3, 0x264b3, 0x264b5, 0x264c5, 0x264c7, 0x264d6, 0x264d8,
+	0x264e8, 0x264e9, 0x264f9, 0x264fc, 0x2650b, 0x2650c, 0x2651c, 0x2651e,
+	0x26540, 0x26570, 0x26600, 0x26616, 0x26620, 0x2662d,
+};
+
+static const u32 a623_gmu_gpucc_registers[] = {
 	/* GPU CC */
 	0x24000, 0x2400e, 0x24400, 0x2440e, 0x25800, 0x25804, 0x25c00, 0x25c04,
 	0x26000, 0x26004, 0x26400, 0x26405, 0x26414, 0x2641d, 0x2642a, 0x26430,
@@ -402,6 +413,7 @@ static const struct a6xx_registers a6xx_gmu_reglist[] = {
 
 static const struct a6xx_registers a6xx_gpucc_reg = REGS(a6xx_gmu_gpucc_registers, 0, 0);
 static const struct a6xx_registers a621_gpucc_reg = REGS(a621_gmu_gpucc_registers, 0, 0);
+static const struct a6xx_registers a623_gpucc_reg = REGS(a623_gmu_gpucc_registers, 0, 0);
 
 static u32 a6xx_get_cp_roq_size(struct msm_gpu *gpu);
 static u32 a7xx_get_cp_roq_size(struct msm_gpu *gpu);
-- 
2.53.0



