Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C803309F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpBP+T/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5494C433C9;
	Wed, 15 Nov 2023 19:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077363;
	bh=Dp/AyxDbM/dc3YTL42cCbkehCPspnXj+qIcTQ+tHncI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpBP+T/fdrVYxfwJKQ+zOg3MyoSuYcn+yA4X6i2CB2yENt1KXR0oFGgH9Bby/zArW
	 f5uikvELU4OJphUrdgQNyWrTXJ6zO9skR89YO8vACy5iiLRapk1Klo7mi4KnXhCk1C
	 dlJwkdZ1xJ5R4Yry2IxPDdkuDyMs1BW7HyGrHjkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/603] drm/msm/adreno: Fix SM6375 GPU ID
Date: Wed, 15 Nov 2023 14:13:20 -0500
Message-ID: <20231115191630.930236219@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit beb3542320479cd59a08273be0b19dfea0b36042 ]

SM6375 comes with a patchlevel=1. Fix the chipid up to reflect that.

Fixes: 90b593ce1c9e ("drm/msm/adreno: Switch to chip-id for identifying GPU")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/554527/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 575e7c56219ff..f2d9d34ed50f9 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -331,7 +331,7 @@ static const struct adreno_info gpulist[] = {
 		),
 	}, {
 		.machine = "qcom,sm6375",
-		.chip_ids = ADRENO_CHIP_IDS(0x06010900),
+		.chip_ids = ADRENO_CHIP_IDS(0x06010901),
 		.family = ADRENO_6XX_GEN1,
 		.revn = 619,
 		.fw = {
-- 
2.42.0



