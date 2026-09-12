Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304C41DA62E;
	Sat, 12 Sep 2026 07:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198900; cv=none; b=dzPC7cKvT/m5CoAdZfeS9uTtdRR+9LmzqiBcnR6KD/2i3VJriC2gvc6v6fRJYC0x/n11+N2b8yZMiPQgWsJGh4vauH2eKRQ6/k8txRhA4PamJp681vJMxYa4R0/LFU0gJXGUNzhlq5tfb9D7d/+woA75Xwhix8vg0sqJLZM7XtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198900; c=relaxed/simple;
	bh=SrLllE6okvx7wuQTDHRbmpRb48E6hf326PaeMpFRHxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5HF/77yHOfQP7fLaPfkU904sYQeBuH6NseYM7dm+rOTllPSuuDSrutLMbOD+nPL2IiTQH7bPjfEmspG0Gnz3nRXoSSlSqh9Wqv/zpoPQhuNnO4sWKHqwAUz/QMWIuPtlpYEA2OTejy5lMoMJxJ9WinVrpK9MM0TZMOnYjC2isU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdoYagti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdoYagti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74BF1F000FF;
	Sat, 12 Sep 2026 07:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198899;
	bh=LZuZoIZqIr52s74pOs/iNCR9sJIIEW2tYNwfOS8GXK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdoYagtiZuBv17T9z29PXV4ER6yIv+8/rzE0gf2Vxay4qhUOQeTbXWAiAY8RdLZ+z
	 MeNAIt0lhzduLlPiXGxuQuDLYUPPpV2+TUuGb8BYbRPcEofky/j5oodH9Nk/RCOPfw
	 loehcDD2ip60lIIXJs5Gw7vD2zzbhcQhB5uiphfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0475/1815] drm/msm/a6xx: Fix A663 GPUCC register list for state capture
Date: Sat, 12 Sep 2026 08:37:05 +0200
Message-ID: <20260912065700.037381939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit fc7ccbc6174b79ffab5be5dca5b6e253df22f030 ]

The GPUCC register list for A663 is incorrect, which can cause
out-of-bounds register access during GPU state capture.

Update it to use the correct register ranges.

Fixes: 5773cce8615c ("drm/msm/a6xx: Add support for A663")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730656/
Message-ID: <20260605-assorted-fixes-june-v1-3-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 166365359fa6d..2a62a22077f92 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -1244,7 +1244,9 @@ static void a6xx_get_gmu_registers(struct msm_gpu *gpu,
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[1],
 		&a6xx_state->gmu_registers[1], true);
 
-	if (adreno_is_a621(adreno_gpu) || adreno_is_a623(adreno_gpu))
+	if (adreno_is_a621(adreno_gpu) ||
+	    adreno_is_a623(adreno_gpu) ||
+	    adreno_is_a663(adreno_gpu))
 		_a6xx_get_gmu_registers(gpu, a6xx_state, &a621_gpucc_reg,
 			&a6xx_state->gmu_registers[2], false);
 	else
-- 
2.53.0



