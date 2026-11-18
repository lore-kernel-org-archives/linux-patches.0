Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040643;
	b=WKi62W1kIQuH7mLt9da52ctBoxHOkiPZbEMJITZildHaNRf5YrQNOH+dqq03z+yoBovt
	 NPMCwlsehp+yI7dbMasnfqN9VNiUzg4MBEBjrJLAdWqQRLcas3ijh/xlJViI+Y4dftXPn
	 0fDmSOEB5cqrZoj9eIzVGQHHY1LDywttjlKiUBEv5UUn4XjPd7a9MXhgB6fXpooVvhnJ+
	 EiJ+njC7OckfKk/pFvHKpQyFg2Zi8gNeIa6NAjB3Au3kXSxfVNKGR/Q3pezXmupxiIFZF
	 n3XqCouEzPywkIYF46kIcR2wwxh8ZzXC/WbFbAPG6dAJ/65fW1f3YIeSpvTk3LF7RlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JwcS4r5CS/tbkeAIGRJAQQhmBJDdxfASimcLQX05jAQ=;
	b=Vp3YUEOhj3ZnwnbVQfhYVdyjngXScB5VAsiUZoxg5cHYfnY+dX+Q6XfEz8Ldy+hNQqNl
	 5JUuA971XdZGtUSkr3N+ETPOPgGR5ao82RkAXSKkDnvVmvM8ur19pPRM42GMv3ZGZo6mj
	 ANxR1sxqQnRqyo3djNsxYDczmILsj8O6GW43IGmjoR1m0MTZUwj9WfRD5YFHOO9OYr9Rb
	 QhfkuD7K2v6P0ev2lnnvdsdEVIN7nZRpHK5ncZsFnYkOVPI77ZA9aSGUutCKCJXzsPFTb
	 m5jO6CyKX9jlHfXEIjLgybRgGDR6ObNL8dAsufRPVygxgSMbm1FjBZ8Bg2XMbrvQ7Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7kIEBba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AF4606A325;
	Wed, 18 Nov 2026 22:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7kIEBba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328971F000C4;
	Wed, 18 Nov 2026 22:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040643;
	bh=JwcS4r5CS/tbkeAIGRJAQQhmBJDdxfASimcLQX05jAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7kIEBba0lUj76KKO5Mmo+bbnaaGIr7ogB1hBTf5G6CLTamf26lttWS8mLeaKvW6p
	 HwkFEJoPdh5Y8frDO9uXPRt4nHV98K+C8kRIU7ayq1v9lmrJ9eK8bTcRESJlFrI02l
	 VdkYyN+KzwlFWBD0GujvWonwJ0jxM3323tSkfgs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2529/3318] drm/msm/dpu: handle perf mode in _dpu_core_perf_crtc_update_bus()
Date: Wed, 18 Nov 2026 15:52:31 +0100
Message-ID: <20261118150437.211987585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 6d3175a72cc07e90f81fb35841048a8a9b5134cb ]

Move perf mode handling for the bandwidth to
_dpu_core_perf_crtc_update_bus() rather than overriding per-CRTC data
and then aggregating known values.

Note, this changes the fix_core_ab_vote. Previously it would be
multiplied per the CRTC number, now it will be used directly for
interconnect voting. This better reflects user requirements in the case
of different resolutions being set on different CRTCs: instead of using
the same bandwidth for each CRTC (which is incorrect) user can now
calculate overall bandwidth required by all outputs and use that value.

Note #2: this also disables threshold checks for user-entered bandwidth
values. First of all, it doesn't make sense to fail atomic commits
because of the debugfs input. Compositors have no way to correlate
failing commits with debugfs settings. Second, it makes sense to allow
users to go beyond these values and check whether this makes any
difference or fixes the issue.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/636072/
Link: https://lore.kernel.org/r/20250209-dpu-perf-rework-v5-8-87e936cf3004@linaro.org
Stable-dep-of: 480ba24aa340 ("drm/msm/dpu: compute the CRTC bandwidth from the state being checked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 2c805356ae207..f9631806ec807 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -118,20 +118,9 @@ static void _dpu_core_perf_calc_crtc(const struct dpu_core_perf *core_perf,
 		return;
 	}
 
-	memset(perf, 0, sizeof(struct dpu_core_perf_params));
-
-	if (core_perf->perf_tune.mode == DPU_PERF_MODE_MINIMUM) {
-		perf->bw_ctl = 0;
-		perf->max_per_pipe_ib = 0;
-	} else if (core_perf->perf_tune.mode == DPU_PERF_MODE_FIXED) {
-		perf->bw_ctl = core_perf->fix_core_ab_vote * 1000ULL;
-		perf->max_per_pipe_ib = core_perf->fix_core_ib_vote;
-	} else {
-		perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, crtc);
-		perf->max_per_pipe_ib = perf_cfg->min_dram_ib;
-	}
+	perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, crtc);
+	perf->max_per_pipe_ib = perf_cfg->min_dram_ib;
 	perf->core_clk_rate = _dpu_core_perf_calc_clk(perf_cfg, crtc, state);
-
 	DRM_DEBUG_ATOMIC(
 		"crtc=%d clk_rate=%llu core_ib=%u core_ab=%llu\n",
 			crtc->base.id, perf->core_clk_rate,
@@ -231,18 +220,29 @@ static int _dpu_core_perf_crtc_update_bus(struct dpu_kms *kms,
 {
 	struct dpu_core_perf_params perf = { 0 };
 	int i, ret = 0;
-	u64 avg_bw;
+	u32 avg_bw;
+	u32 peak_bw;
 
 	if (!kms->num_paths)
 		return 0;
 
-	dpu_core_perf_aggregate(crtc->dev, dpu_crtc_get_client_type(crtc), &perf);
+	if (kms->perf.perf_tune.mode == DPU_PERF_MODE_MINIMUM) {
+		avg_bw = 0;
+		peak_bw = 0;
+	} else if (kms->perf.perf_tune.mode == DPU_PERF_MODE_FIXED) {
+		avg_bw = kms->perf.fix_core_ab_vote;
+		peak_bw = kms->perf.fix_core_ib_vote;
+	} else {
+		dpu_core_perf_aggregate(crtc->dev, dpu_crtc_get_client_type(crtc), &perf);
+
+		avg_bw = div_u64(perf.bw_ctl, 1000); /*Bps_to_icc*/
+		peak_bw = perf.max_per_pipe_ib;
+	}
 
-	avg_bw = perf.bw_ctl;
-	do_div(avg_bw, (kms->num_paths * 1000)); /*Bps_to_icc*/
+	avg_bw /= kms->num_paths;
 
 	for (i = 0; i < kms->num_paths; i++)
-		icc_set_bw(kms->path[i], avg_bw, perf.max_per_pipe_ib);
+		icc_set_bw(kms->path[i], avg_bw, peak_bw);
 
 	return ret;
 }
-- 
2.53.0



