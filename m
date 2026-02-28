Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A4F346E66
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302107; cv=none; b=vE1OXmIHYpgKVaCmV6586MWk+i05LdP21YUxlfAjtgQ8a8z8PmIZWbt8WlYj2647VUU5y3e1lw6pFNVNig/SgUKB0FfCdPXgbD+/Ncxdsk0u6dVj5UnO/RPKfE5o+0k9ZZVGd4M9zcE046bjPM04C+GtOwEtQLVc2E6PJAobp0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302107; c=relaxed/simple;
	bh=5RjqraSWHasI5Tjbv5Xu85BXQd91p3R5w2mr6LD0caQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO8LvtRL/uA/UE9vRXV49rGq4S1x+JK47MUbFlXBOW8uyqMAgbRtgCZSYinzwXQmlx6t0vrjG304q06itZDVQlZXswQyt0Dqy7gJvBbzcF9qmzkbjR0Tj+3cmbcmJE9wuspeFx+4Ou06dw2uMSljfDRdeBwPv0xVeoAVJkrpqiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FG5q3Zop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FG5q3Zop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D974C116D0;
	Sat, 28 Feb 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302107;
	bh=5RjqraSWHasI5Tjbv5Xu85BXQd91p3R5w2mr6LD0caQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FG5q3ZopmwMGzZrG7vdcMbac8/BhA+xbstyDnjFjPiQdDPkRTkJa8D3Ad9B78yv1m
	 BLKAVuJMxTzp+0qBcg4f5kj/o/PGRgheQ7FF9bjwQBjK7AVpAcmzEm9NlTMD2lng7M
	 VIyo7VqACxm42BSmS1Ereq5+HrfTawBy6/Gch6+FrqU+WYd5gAA4jXSIErBL/lRMjD
	 yzJJ7ck9g0xVFhgxoQMLPEtmqRDqcEhdUsbMYR9XBfWFKZ4k0niihTD29X/tZukun1
	 FkhZGDcov9gRIVVh/TQ7ZBJe9zIXlBp1YgthBRXhOUtyqCc2Pw9Ppe+1RBSg4ohiFy
	 GcmOh4h8V8Tmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/283] drm/msm/a2xx: fix pixel shader start on A225
Date: Sat, 28 Feb 2026 13:03:57 -0500
Message-ID: <20260228180709.1583486-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 6a7b0a670ba4d283285d76d45233cbecc5af5e40 ]

A225 has a different PixelShader start address, write correct address
while initializing GPU.

Fixes: 21af872cd8c6 ("drm/msm/adreno: add a2xx")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/689906/
Message-ID: <20251121-a225-v1-1-a1bab651d186@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index 535c89ce5d62e..0410a1657b15e 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -77,7 +77,10 @@ static bool a2xx_me_init(struct msm_gpu *gpu)
 
 	/* Vertex and Pixel Shader Start Addresses in instructions
 	 * (3 DWORDS per instruction) */
-	OUT_RING(ring, 0x80000180);
+	if (adreno_is_a225(adreno_gpu))
+		OUT_RING(ring, 0x80000300);
+	else
+		OUT_RING(ring, 0x80000180);
 	/* Maximum Contexts */
 	OUT_RING(ring, 0x00000001);
 	/* Write Confirm Interval and The CP will wait the
-- 
2.51.0

