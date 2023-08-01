Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F65E1F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B81C433C7;
	Tue,  1 Aug 2023 09:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881956;
	bh=sZpLXBOSZs+p35NUojSHl725Dy4CJ+EYfkebGlWbPRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uuMjirX2xY6zruz+QRd1ZjnD5ohyEw4umXqk/CAL199iCIbFGwCY4WF8py0m9Tc/
	 KRqUE5wzp+1dpjDZRXk1G0d43hlFzkfJuDkAvL+a6QWmRECJPwTEcBK9pe2wHaEaTp
	 V8n2i2MzGPtNOt70q5Gm1gpFMnysZ+w+6HRhOPOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/155] drm/msm: Fix IS_ERR_OR_NULL() vs NULL check in a5xx_submit_in_rb()
Date: Tue,  1 Aug 2023 11:20:02 +0200
Message-ID: <20230801091913.394321054@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 6e8a996563ecbe68e49c49abd4aaeef69f11f2dc ]

The msm_gem_get_vaddr() returns an ERR_PTR() on failure, and a null
is catastrophic here, so we should use IS_ERR_OR_NULL() to check
the return value.

Fixes: 6a8bd08d0465 ("drm/msm: add sudo flag to submit ioctl")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/547712/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index ef62900b06128..e9c8111122bd6 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -90,7 +90,7 @@ static void a5xx_submit_in_rb(struct msm_gpu *gpu, struct msm_gem_submit *submit
 			 * since we've already mapped it once in
 			 * submit_reloc()
 			 */
-			if (WARN_ON(!ptr))
+			if (WARN_ON(IS_ERR_OR_NULL(ptr)))
 				return;
 
 			for (i = 0; i < dwords; i++) {
-- 
2.40.1



