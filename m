Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E8F375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301755; cv=none; b=Fa6c2ou3Xr9FUCkJbTPXj+OIwNzpaEDAwjtm694lKxv1LPOYzfK2L3ut23WLH0zcMOI3tkFxqDo9v4jdpdOisF80DDG4KWW9ntdI36+f4NPPVgIi9UCaGqlBs1Ywj9jqkuxxnX1jL2DX/+D23pss/at6+Qho7ZLJizE4v/Jux3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301755; c=relaxed/simple;
	bh=l2in+QHNmA1FaZOpmBizMW6OFdm2SV8XYTgT9KypZPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj+9n/QCYmOqNbeIMR6nDTiLCFIFUCRRHloPa0u02/bW8c/luIBtGUD8CrNsqmVD1yp5DjYIOYNeZXohlsKeXJK4bnujKPbsBoKLpGva2Ca/C9EE+0R15ekPF6FeaVfFV+4Ghl0OMEUHHVmNPbPm/S7cOmtXsUI2fAzXDJ8sdgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uYikh701; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uYikh701"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F33C19423;
	Sat, 28 Feb 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301755;
	bh=l2in+QHNmA1FaZOpmBizMW6OFdm2SV8XYTgT9KypZPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYikh7018XKyutglQmozuiJ+cBBRbN4cEwzxVup6yBtRcgPZTMpaOsSG7mZmJvKaQ
	 6Iio7qCawr+a3gZ2j+IuZziuhZ3818DX8Ooa8lzCU1nuOOHEodVKcM5CkeIDxIG5Yi
	 odSrv/MMsnZukFMSiM58aX7EY3NFrg5fOaeMN0nffH3vVJB3oADyPbJAueaX/i/gOi
	 hA2hnuO0LAofdXujZI9wa3Ti/wZ2zn6cdFg96H2JIFR5awShaKp/CaFtVMkBRtyjgJ
	 OVGuJMfNKjkbHqXm9u3JTsX9KyTUlaunsu/Fn+J2DYRBtZtzMnBh+ficuFPa0UrKIY
	 SOB2bWnMEV4dQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/385] drm/msm/a2xx: fix pixel shader start on A225
Date: Sat, 28 Feb 2026 12:56:21 -0500
Message-ID: <20260228180011.1568201-159-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 2e25af3462ab6..a0ca41f4818a3 100644
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

