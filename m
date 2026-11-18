Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048991;
	b=QoXoR1dVohSJqHn4n4LQiIvXB7QGdaA4fjGplDNOEb/GoUTeneqLFcK3joHX8Q0u0kd3
	 RSoynX6+82oUtJyJbBBug3pDOJikS5ymkIFV1zkqqzMCrZ4knfeQBDxRgpOECSYD6dPiC
	 XVosB5MICfBfjYC2dmuAn22DYREcyx/O7WGo2WJ0L7LM2PHXdK5/zihm4ZwYvU6aeiveW
	 p+oLgrglp1skCHjR3mCmzQhBJPFR4SIa2CCAPCaeAEwHu8EmBCKbBfcaVQdoyThd/xMmW
	 EoyVXCWAJ6fUu2Vb3pk+kBpt2xYWH0h+LkDFHFdgKxo4wHQO25yzSXjZgxmPwWD6M8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXKBfwObfFLA6g57NQUA/d4qJH0Tw7gwytAnJryusYQ=;
	b=pwyfTkwXLGf7vZ1GPYBR9QWp89k8sngDeEV8kdLbEQaEhgP6INy+Jylx+n/grqGxYX+j
	 atOpRSDU+Y5sHjqaP0HDRxWfyf9oVICi8OUebd5OfZDbZTrRQHLyTL+tGj9T7lXtlIvmk
	 3UgsPcoRrSDe7dGG067Fa8BYee5tft+nmSNQkhhmPpJ0fmjQVGY0dfw/Bx+kJwJMox6HD
	 WfbYd3sbl+heHS+C4D5EqzUYjX8NPztQd45k7+bCzsEeSwu1SL1ribdWbqWZKcYgSh0ZR
	 GvPrlaByV50ck+teQEME/fgfrngeBJVC7rrwHMVw8O+0bIOXvzCz71iyHw+ZsupAX7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QB0aE3b2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAE5606A31C;
	Thu, 19 Nov 2026 00:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QB0aE3b2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB431F000C4;
	Thu, 19 Nov 2026 00:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048991;
	bh=YXKBfwObfFLA6g57NQUA/d4qJH0Tw7gwytAnJryusYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QB0aE3b2QaGV1+5g0q90uPVcDxVxWdV4c0zMj7W77apKEXqIRWACm6g9/Y5ju7QiF
	 G0l5JC2JE0xMhrK37RjC3UPxvG7y1gygSyzvrAEASmy46dA3aoco6M6ppV/mmnobIU
	 VWjUgKXQg2TL5zSNgw8E0+uacxuHawNEQykHC+c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2193/2857] drm/msm/dpu: handle perf mode in _dpu_core_perf_crtc_update_bus()
Date: Wed, 18 Nov 2026 15:53:47 +0100
Message-ID: <20261118150320.378006324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c2ed07d1c3c77..3bf04bafb7294 100644
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



