Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9D94431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFF2C4339B;
	Wed, 15 Mar 2023 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883944;
	bh=LIeaqju1Np+OetMeVCFAficiiVpxENiwJiXZ3XcyRqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A78eeWqCrLq2ijrYBrcELBi/tx2QOD6FIfnSFmhEJyx8VlkZwyYtXsKPQhoJGfLoS
	 AyyBxlRjnUDJtrbRoin5k/0mrJKgrTVTbHXm3CVGT8Sf5h8K9s+THWgYcIc0RrXB67
	 GRPkt1mtSF6i6nQfRZQdFxZ7B5016ivxoh0MR1g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 048/141] drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register
Date: Wed, 15 Mar 2023 13:12:31 +0100
Message-Id: <20230315115741.434839606@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

[ Upstream commit a7a4c19c36de1e4b99b06e4060ccc8ab837725bc ]

Rather than writing CP_PREEMPT_ENABLE_GLOBAL twice, follow the vendor
kernel and set CP_PREEMPT_ENABLE_LOCAL register instead. a5xx_submit()
will override it during submission, but let's get the sequence correct.

Fixes: b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/522638/
Link: https://lore.kernel.org/r/20230214020956.164473-2-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 660ba0db89002..8b2df12d86814 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -151,8 +151,8 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_RING(ring, 1);
 
 	/* Enable local preemption for finegrain preemption */
-	OUT_PKT7(ring, CP_PREEMPT_ENABLE_GLOBAL, 1);
-	OUT_RING(ring, 0x02);
+	OUT_PKT7(ring, CP_PREEMPT_ENABLE_LOCAL, 1);
+	OUT_RING(ring, 0x1);
 
 	/* Allow CP_CONTEXT_SWITCH_YIELD packets in the IB2 */
 	OUT_PKT7(ring, CP_YIELD_ENABLE, 1);
-- 
2.39.2



