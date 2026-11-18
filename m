Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025174;
	b=WeokuRzwX0QMwpF7YcVIjDtvRSmvoLZuHPTYWO6maW47kamsPS2kvuZ+ow6QQTq+lN3+
	 bzvyy+dSz8ZD6nht2GXcZ7Ks9n5tTprkR62U+F2aVLtfHpt6IV0Wd9J9u/x6yiMwQoIAo
	 3sLxh9L+1ffEiNu0dh6cAdGTnULMUWpujyFzLYH77A71gJZaycuDo39PwHlXmCmV2ACI7
	 /LcDupac9WoHeHIE4ZwVG/Ui9SxdPCetSPUjDiptypbkTmlo3o5YnJF3LlmWqhzOstlQC
	 /OJkQWZ+WKQAb31yY+95Ng9BjW4UO+VGz17O6m+IaP+iy/MhbGKrZRRs47GF6dB+4Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dEmfzzaVyjjrFSMqrDBFj1W6HinJE3YEcLLd2AR4/qU=;
	b=PjGTJliGRtk32mxsLp6H4FS7oNbozX4tYZAcMxikzomWKjTD3BTQ/Z/md81KA7JH0UVa
	 epgDZy6UsD0Xw1xj6wnCV4yJkVkLo2+r1EQ2BpwR9CrjEaWR8SbGCqWh2ekP2kmxFWBZw
	 pTELTdJk+B5MHaLEfv61SSKTdiFJhCSatwupziwVBxHjW74T4Uht0e6pFuv3DfYIx9JXJ
	 d5+GjahpnljwvgLYFqgeRAEuWTyHbAgcyKsraYmxUdNDfS3/+JPs3PFDcJxbRQQsL1bnW
	 pTSBV/Gbwk5WwNN5D1U3ORCvHvbL94LNqrCITnYAfMq08Z63IRj22BDla2EH+lWEJZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bGQ344aO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA4660A2612;
	Wed, 18 Nov 2026 18:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bGQ344aO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5701F000C4;
	Wed, 18 Nov 2026 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025174;
	bh=dEmfzzaVyjjrFSMqrDBFj1W6HinJE3YEcLLd2AR4/qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGQ344aO0QWB2Ru23JOoSc50AvAJVLglnzY59HNLjL+fweN99Vhr47ohaJngO62vU
	 JmWWiENlGk/Z4djAhgZiiLnFm084ITBrsNu/pVWoToT++TwDVnZmwG/CEZiPczJP9k
	 sIKmAOKp2URuaKu4p8di9OhVYBVnMW0ypSx5VdcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonhoe Kim <26rote@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0987/2151] drm/msm/dpu: compute the CRTC bandwidth from the state being checked
Date: Wed, 18 Nov 2026 15:45:22 +0100
Message-ID: <20261118150158.427297225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonhoe Kim <26rote@gmail.com>

[ Upstream commit 480ba24aa34031c898d0a711405664cd947bbee4 ]

_dpu_core_perf_calc_bw() is called with the new CRTC state but sums
plane_fetch_bw over drm_atomic_crtc_for_each_plane(), i.e. the planes
of the committed state. When the CRTC is re-enabled (DPMS on, system
resume) the committed state has no planes attached, so the check
computes bw_ctl = 0 and the display runs without an average bandwidth
vote on the MDP path until some later commit changes a plane -- which
may not happen for a long time on a static screen such as a lock
screen.

Seen on a Lenovo TB323FU (SM8850) through the interconnect and DPU
tracepoints: after DPMS off/on or s2idle, dpu_perf_crtc_update reported
bw_ctl=0 and qnm_mdp was left at avg_bw=0 (peak 800000) instead of the
3728793 kBps voted before, until the next mode change.

Iterate the plane states of the CRTC state being checked instead.
drm_atomic_crtc_state_for_each_plane_state() falls back to the current
plane state for planes that are not part of the commit, so the result
is unchanged for commits that do touch the planes.

With this, bw_ctl is 3728793600 right after DPMS on and after resume.
Only tested on this device.

Fixes: c33b7c0389e1 ("drm/msm/dpu: add support for clk and bw scaling for display")
Assisted-by: LLM
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757683/
Link: https://lore.kernel.org/r/20261002130656.50577-1-26rote@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 6524531bd8bdc..0b4d2c6be2e2f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -54,24 +54,19 @@ u64 dpu_core_perf_adjusted_mode_clk(u64 mode_clk_rate,
 /**
  * _dpu_core_perf_calc_bw() - to calculate BW per crtc
  * @perf_cfg: performance configuration
- * @crtc: pointer to a crtc
+ * @state: the CRTC state
  * Return: returns aggregated BW for all planes in crtc.
  */
 static u64 _dpu_core_perf_calc_bw(const struct dpu_perf_cfg *perf_cfg,
-		struct drm_crtc *crtc)
+		struct drm_crtc_state *state)
 {
 	struct drm_plane *plane;
-	struct dpu_plane_state *pstate;
+	const struct drm_plane_state *plane_state;
 	u64 crtc_plane_bw = 0;
 	u32 bw_factor;
 
-	drm_atomic_crtc_for_each_plane(plane, crtc) {
-		pstate = to_dpu_plane_state(plane->state);
-		if (!pstate)
-			continue;
-
-		crtc_plane_bw += pstate->plane_fetch_bw;
-	}
+	drm_atomic_crtc_state_for_each_plane_state(plane, plane_state, state)
+		crtc_plane_bw += to_dpu_plane_state(plane_state)->plane_fetch_bw;
 
 	bw_factor = perf_cfg->bw_inefficiency_factor;
 	if (bw_factor) {
@@ -131,7 +126,7 @@ static void _dpu_core_perf_calc_crtc(const struct dpu_core_perf *core_perf,
 		return;
 	}
 
-	perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, crtc);
+	perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, state);
 	perf->max_per_pipe_ib = perf_cfg->min_dram_ib;
 	perf->core_clk_rate = _dpu_core_perf_calc_clk(perf_cfg, crtc, state);
 	DRM_DEBUG_ATOMIC(
-- 
2.53.0



