Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5487917AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4BCC433C7;
	Wed,  9 Aug 2023 11:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580525;
	bh=sKx8U7hKkA7P7iEjnCeFXEoD91iSuFfhE0nT1fM+Azg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/5xRCjyMnKC1FVHPEQeoB8RFMSeT5SKE+kDOD1rGO7XFLqXc50ojyV6XC7Ff850l
	 y7Zfmj4U/QJ75Z1/ADVWyQBOgtQ1vUfe452V2qyN4uA6To3bDC8HKWEmozejdsb08V
	 t95Hs33j9uUlfiwO3FHsHZsyTWvpSqYtAmDXr7Dg=
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
Subject: [PATCH 5.4 048/154] drm/msm: Fix IS_ERR_OR_NULL() vs NULL check in a5xx_submit_in_rb()
Date: Wed,  9 Aug 2023 12:41:19 +0200
Message-ID: <20230809103638.609680539@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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
index 593b8d83179c9..65c2c5361e5fc 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -71,7 +71,7 @@ static void a5xx_submit_in_rb(struct msm_gpu *gpu, struct msm_gem_submit *submit
 			 * since we've already mapped it once in
 			 * submit_reloc()
 			 */
-			if (WARN_ON(!ptr))
+			if (WARN_ON(IS_ERR_OR_NULL(ptr)))
 				return;
 
 			for (i = 0; i < dwords; i++) {
-- 
2.40.1



