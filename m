Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAE44431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4105FC433EF;
	Wed, 15 Mar 2023 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883601;
	bh=fuxfY8BldNgYHJGYH97MjHxU+GKUwlRu0vKm5XhsZOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8zZz0FYMReplOV5ZSCe2GYiql2BFA0+bYWuVvDA23JonxnKIy/jMRm13J+iOsg5i
	 7sH47cSywecFX+DNOlFTu7jynUaD3fRtNlsO6Rg1s7iUTLSplSgWSjt7Nrpzc7kCB8
	 KWppAV3Hh+UzlV2MQoMdY1x4P9VrfRTR1ICMXR1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/143] drm/msm/a5xx: fix highest bank bit for a530
Date: Wed, 15 Mar 2023 13:12:27 +0100
Message-Id: <20230315115742.381438755@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 141f66ebbfa17cc7e2075f06c50107da978c965b ]

A530 has highest bank bit equal to 15 (like A540). Fix values written to
REG_A5XX_RB_MODE_CNTL and REG_A5XX_TPL1_MODE_CNTL registers.

Fixes: 1d832ab30ce6 ("drm/msm/a5xx: Add support for Adreno 508, 509, 512 GPUs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/522639/
Link: https://lore.kernel.org/r/20230214020956.164473-3-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index f8634fbeffda0..4f0dbeebb79fb 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -808,7 +808,7 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	gpu_write(gpu, REG_A5XX_RBBM_AHB_CNTL2, 0x0000003F);
 
 	/* Set the highest bank bit */
-	if (adreno_is_a540(adreno_gpu))
+	if (adreno_is_a540(adreno_gpu) || adreno_is_a530(adreno_gpu))
 		regbit = 2;
 	else
 		regbit = 1;
-- 
2.39.2



