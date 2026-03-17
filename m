Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E7F3EBF00;
	Tue, 17 Mar 2026 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765540; cv=none; b=TSn7cXv/Tv2s7skbSiUn9BUHkWQm4xnZEs05uoA7lW193OE3v2PVgzniZM1Kep2OSrQw5seBpTDjWPUMeJVHjUJ5tcTaW0tjpx2ELPFwEfmcXLYwiAf7QAsUaqRYdrD4Tsdkll5zvq/Nfdl3avHmNFn1dpZZoA8+RWk5TfTbHSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765540; c=relaxed/simple;
	bh=bgIp18f0BOflQ+uuJ4eak6WjATKG96+OdeZE2V1veOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmZCeDSwUctM0/xm1wp7MZNr81rIg0iqmS5G28m/2CNYvQqYhTf29RgzlX+wlGiufiW7l1ds4u6a12ofO3/SYNuzwvE8/hhFeAsbHvZTWtWv9eE4NID6TWKbC4p+3ettOo/hYsy9GHfvlXrWM+2sYRXckNPm0kG+y6aPW0pwc8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSL+HWwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSL+HWwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C80EC4CEF7;
	Tue, 17 Mar 2026 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765540;
	bh=bgIp18f0BOflQ+uuJ4eak6WjATKG96+OdeZE2V1veOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSL+HWwPzGp70nKyT84wxOUhIUlMifKNL6AySHDOkKTa6I9eIVWtT7k2i2JCG1XV8
	 E6dFABcgNmM4lfTAUHIE7uBqUBh/GaDE2dLiFJTmrOfhXhHFHPrhcImXLtPkh905bs
	 HUhm/zeuk/3Vu4ofe4BmnBc1XH5shj3squG0yxuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 034/378] drm/msm/a8xx: Fix ubwc config related to swizzling
Date: Tue, 17 Mar 2026 17:29:51 +0100
Message-ID: <20260317163008.237603556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 7e459c41264fdd87b096ede8da796a302d569722 ]

To disable l2/l3 swizzling in A8x, set the respective bits in both
GRAS_NC_MODE_CNTL and RB_CCU_NC_MODE_CNTL registers. This is required
for Glymur where it is recommended to keep l2/l3 swizzling disabled.

Fixes: 288a93200892 ("drm/msm/adreno: Introduce A8x GPU Support")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Message-ID: <20260305-a8xx-ubwc-fix-v1-1-d99b6da4c5a9@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
index 30de078e9dfd2..3b17ddac07532 100644
--- a/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a8xx_gpu.c
@@ -306,11 +306,21 @@ static void a8xx_set_ubwc_config(struct msm_gpu *gpu)
 	hbb = cfg->highest_bank_bit - 13;
 	hbb_hi = hbb >> 2;
 	hbb_lo = hbb & 3;
-	a8xx_write_pipe(gpu, PIPE_BV, REG_A8XX_GRAS_NC_MODE_CNTL, hbb << 5);
-	a8xx_write_pipe(gpu, PIPE_BR, REG_A8XX_GRAS_NC_MODE_CNTL, hbb << 5);
+
+	a8xx_write_pipe(gpu, PIPE_BV, REG_A8XX_GRAS_NC_MODE_CNTL,
+			hbb << 5 |
+			level3_swizzling_dis << 4 |
+			level2_swizzling_dis << 3);
+
+	a8xx_write_pipe(gpu, PIPE_BR, REG_A8XX_GRAS_NC_MODE_CNTL,
+			hbb << 5 |
+			level3_swizzling_dis << 4 |
+			level2_swizzling_dis << 3);
 
 	a8xx_write_pipe(gpu, PIPE_BR, REG_A8XX_RB_CCU_NC_MODE_CNTL,
 			yuvnotcomptofc << 6 |
+			level3_swizzling_dis << 5 |
+			level2_swizzling_dis << 4 |
 			hbb_hi << 3 |
 			hbb_lo << 1);
 
-- 
2.51.0



