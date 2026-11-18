Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030634;
	b=qoelnE6g0WRhYFkHu/eQBb54Df6Kbm4OeGBtnoPmxcDXolOJDS1RiYfpYiDYIluSafRe
	 3/S+u9wKl7JdsX+sYPaHADnP3zamC2r291LgsO9Gfu0ZOZ8RVnwZIW6jpBrRKemONoAs8
	 htqlMSTyL1Ns4MxtolE3DNMxGp49aHeuu25ZfIoVrVizouXi9Sp1RZ8FN4UjXOSnE4ue5
	 T39sV0QeEBZ+Nv7gVM2p8ySIHFPNX22vTMn61m/e7Shtqps+n5J3gbPxflcL6VAzn7YcQ
	 Je3g6hAuLXsM/0kaTO/pW07iLKItJ0gT/n9LglIFsw5IyKpl1LJsuwtaBJYjUtOtBeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6z4+T3Gg+pUvVJ1jtNk2Na7ZAfCfU7RQxjGEA0onxFs=;
	b=020oZWZojdTe8K4CF7PHxAMMsWm0JG1Wxlntp5Zd5maUSDkc6L6r09l+h/F0eCqVNyvW
	 OEV205B9pYCS5u4Wem1OxI4fvy1E03jwqGovysh+gXs8w5qbdVfYHJO48RWW+rd3mBSd2
	 CMiaPXPEhIy7zHheCoxVsw3mF+jeRj8rGzFV2qAzzmhXlFBpmKn31v+nHu0zit3aIMy6W
	 68eGKdDS5yx0spTv0/YxuYOijiXOwvIH2GGDBLISLQymRnawYfYA2WcELPoZXw3QUB5/k
	 7rAAh5rUO9U3Bnhx65P/xpHfgUVZBc1/y9ceu5W7wZnjuvMf3GiQIwrOjQRGpYUtK6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0lsl5iW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD348606D360;
	Wed, 18 Nov 2026 19:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0lsl5iW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229181F000C6;
	Wed, 18 Nov 2026 19:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030634;
	bh=6z4+T3Gg+pUvVJ1jtNk2Na7ZAfCfU7RQxjGEA0onxFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0lsl5iWwKqCi8Tety5lqrHKenzloUQVLaQhVBSRSrOQXxpzx3n0+yG4g8vYShXo3
	 3KX4ejhWTHG5iQLHFaDxYhN1o5vqbnA6RhrpZRjhUuAMqupjidmV/KeAjoG0dWDltZ
	 6M+y5AQMwsDT0PI+WC/J8meefqINYK7q4PCPNKj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0773/1756] drm/msm/dpu: drop core_clk_rate overrides from _dpu_core_perf_calc_crtc
Date: Wed, 18 Nov 2026 15:48:20 +0100
Message-ID: <20261118150040.408118299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e7e2495595e01839b117e9c08500ff80cd218f6a ]

core_clk_rate override is handled in _dpu_core_perf_get_core_clk_rate().
Drop imperfect duplicating code from _dpu_core_perf_calc_crtc().

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/636070/
Link: https://lore.kernel.org/r/20250209-dpu-perf-rework-v5-7-87e936cf3004@linaro.org
Stable-dep-of: 480ba24aa340 ("drm/msm/dpu: compute the CRTC bandwidth from the state being checked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 9ddeafe8f8f54..2c805356ae207 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -123,16 +123,14 @@ static void _dpu_core_perf_calc_crtc(const struct dpu_core_perf *core_perf,
 	if (core_perf->perf_tune.mode == DPU_PERF_MODE_MINIMUM) {
 		perf->bw_ctl = 0;
 		perf->max_per_pipe_ib = 0;
-		perf->core_clk_rate = 0;
 	} else if (core_perf->perf_tune.mode == DPU_PERF_MODE_FIXED) {
 		perf->bw_ctl = core_perf->fix_core_ab_vote * 1000ULL;
 		perf->max_per_pipe_ib = core_perf->fix_core_ib_vote;
-		perf->core_clk_rate = core_perf->fix_core_clk_rate;
 	} else {
 		perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, crtc);
 		perf->max_per_pipe_ib = perf_cfg->min_dram_ib;
-		perf->core_clk_rate = _dpu_core_perf_calc_clk(perf_cfg, crtc, state);
 	}
+	perf->core_clk_rate = _dpu_core_perf_calc_clk(perf_cfg, crtc, state);
 
 	DRM_DEBUG_ATOMIC(
 		"crtc=%d clk_rate=%llu core_ib=%u core_ab=%llu\n",
-- 
2.53.0



