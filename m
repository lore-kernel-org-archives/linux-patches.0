Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECB03559C4;
	Tue,  6 Jan 2026 18:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722542; cv=none; b=nzIbztjbIliAWq678x0nzYFFVsDnDvDEb6g1sJX9Yygm2ShVUNJeZqI8CEhK71UioPRa+UuHQBG1xzzTVDI8QZEu/CElCCM6m9K2Dss/sjDa5qF/cWO0QZdcJn95GS0aKhWn3mTAJrwf3FevTK3h9uOZ04VEk+lYqcfawB0dlus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722542; c=relaxed/simple;
	bh=2GRUWnoBu+POPtjH1/15m5iZdBlkuMLKQcAuwPvgj1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dp180PoYkyERQS3MQvmOJaWEo/UgjJENAC38OFjGKFTnYBf6q99ZOoD+gk4vHfKcHsA7M1NCpevqBHRzNrg9ZA1XSPukQxIcfRbiTL122IA2TpQF2uMBmlgxAhNhF0y4lq+o/PbDrUrL04kJyJSXUqu6ErKA2tZzzZBcfdBtxHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnMocbJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnMocbJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A2FC116C6;
	Tue,  6 Jan 2026 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722541;
	bh=2GRUWnoBu+POPtjH1/15m5iZdBlkuMLKQcAuwPvgj1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnMocbJ83loDiHblVOaQcwRFRGiHbm4od4mgCDfyx6UXimSLuIonSDFFpE6ddSR6g
	 VCYIDOxu/hjvoa/jtHhG9kMOBRYGW/xn+YZbyln+9o6zmIt7d5WkqxnD2vBQqCz3R+
	 DP4t4rm07ULFJJOcgY+Zy/kydIMASMsxcRJQRFts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 268/312] drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers
Date: Tue,  6 Jan 2026 18:05:42 +0100
Message-ID: <20260106170557.540416401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

commit 779b68a5bf2764c8ed3aa800e41ba0d5d007e1e7 upstream.

REG_A6XX_GMU_AO_AHB_FENCE_CTRL register falls under GMU's register
range. So, use gmu_write() routines to write to this register.

Fixes: 1707add81551 ("drm/msm/a6xx: Add a6xx gpu state")
Cc: stable@vger.kernel.org
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/688993/
Message-ID: <20251118-kaana-gpu-support-v4-1-86eeb8e93fb6@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -1255,7 +1255,7 @@ static void a6xx_get_gmu_registers(struc
 		return;
 
 	/* Set the fence to ALLOW mode so we can access the registers */
-	gpu_write(gpu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
+	gmu_write(&a6xx_gpu->gmu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
 
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[2],
 		&a6xx_state->gmu_registers[3], false);


