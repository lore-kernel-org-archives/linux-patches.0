Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030640;
	b=EncTHZaFMFMUXaoHkg33yPMfoNrALci3x9I8z6r3+yWbFi5O6UFckkl0k7nVhpxu9Zm3
	 9sjvszMUyMOKG2YCCb+gG6z2ECKz9ixfzeaeeWO8fWhS49tjioj9st2cOB84Je++ZNkMo
	 ljC4dIbjoFbEl8vcOlWPwSGBKzkyWh6oaGz7aZ+2kE1DykuYKXlRXesUdmRzIpfiXZAav
	 EXlDrShhdxO/0rvQ7ZgVbT0h3QXCCEeiGZtOqmU2Xl8HFOhw+eFtma+dZHJYCpLHuhOtP
	 ZV050syeuC5F3szwx8YVC6Y2CDel0ClHNJ8x120iDXtvVPRC+QPl90aiUNcBLaX9eKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBoUtg/qGDQflZUmC6+YWhtJDEGSAySv85OKkp57EVw=;
	b=XwbanKYnc5dhV5vHapEFMlxoHSpY8nuF7pdEGwylTjK08e6uellFI1UGSAW+bRHV4K+i
	 gDUyDU3f/pPhriK/Gv9hpCJncT2pf1htxU975D+aiIgTpNMxoJVdl+VvgnlBAOeMZoz+b
	 DrhXU89OO+7zf0KEQACPpUC2sEroelP7H1GdKpFC00wgnhG7cdieNL4GcNFOq9s6hOhtz
	 fcQY/6CfnbcwXh13eXvflcd98XaZr2aHdux7mA/wJwY/0AlY9hvII9SJi6+FAzgxZ7C8V
	 leCWYSOy2LAa+m8u2Sgo5in8sHMj47SCsHk104pORdVFjAn3yuIfY8qVRWJ5nhQLnIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnQ8h7LZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680D8606A31C;
	Wed, 18 Nov 2026 19:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnQ8h7LZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1BE1F000C8;
	Wed, 18 Nov 2026 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030640;
	bh=iBoUtg/qGDQflZUmC6+YWhtJDEGSAySv85OKkp57EVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnQ8h7LZLRHgLjXRvgF+MgBFcqd7k58q/113Fbm9pVUz0FprAHILnYyba4se/G8nA
	 5AKgvce09X8b3MT9Q5UKmqyit3i7WgVbtEWVvmuI037Ha61YnK+Z5ED96miz/2963T
	 Rku3xEXwPoMU2MdGdy+XNsly+TFshNLL0g8vZzgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonhoe Kim <26rote@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0775/1756] drm/msm/dpu: compute the CRTC bandwidth from the state being checked
Date: Wed, 18 Nov 2026 15:48:22 +0100
Message-ID: <20261118150040.480613638@linuxfoundation.org>
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
index f9631806ec807..170184941b1f2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -34,24 +34,19 @@ enum dpu_perf_mode {
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
@@ -118,7 +113,7 @@ static void _dpu_core_perf_calc_crtc(const struct dpu_core_perf *core_perf,
 		return;
 	}
 
-	perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, crtc);
+	perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, state);
 	perf->max_per_pipe_ib = perf_cfg->min_dram_ib;
 	perf->core_clk_rate = _dpu_core_perf_calc_clk(perf_cfg, crtc, state);
 	DRM_DEBUG_ATOMIC(
-- 
2.53.0



