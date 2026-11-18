Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030627;
	b=rMgC438eB3RIYlmSbMabFvYbMbh2Fo/jCYG02XR2zxuDDTB4Sl+UyghlyE6iQOvo234e
	 twTT0QPUc1se23taMJDcKxaeXHb76F3f7xh9hiNpNsUtHYP+n7Zyh0T/cpRAe6mW7ubT5
	 9UiKUYgTzgRc9oqWToEl+G7xAODZyaV3dNpGQROuN8Ur1Pta2g7jpH5aR6AwkJDmN7cRx
	 7XmD0rSsyqx1TLI1P59QBI7PEWeL0thdpZa3iYiod7ClFQ4auqH1d6b+lS9EL0w2WD9f+
	 spS+hNpEnGwIbkISn+HwtEPeT64WO3oDgUCxohQIyk4p9+VdnJaZfthLU7g+1/jnBtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ypHMaTf+VUZ3tFLrzr5y430w877E1FUlJFZBX6aLTQY=;
	b=4J/+OQJ6HpPlPWFDnE+XZnjyEiMO49brb07FL/M6AL+zFQwanyKzOhdJhZNiFXbDztw/
	 uuHdBNPHDmF1Lb4Rg+8mB4hq15NKapfYLc0/YiXTZPc0ID/QmfOeFVfIB14tuYj8GTQDb
	 rxf6Qm3LOTW9jCtsAUVvW0Dtk56EL8EPAhH2LvLyblDfa85DQbDadyO2pvYdY4mGm/GOb
	 asF1u/vtLlfSfh7D/2UmuRSQ8+s0zZSpQoKo5fChTy23rBG72CB/Ew5Yoi0lgl2pi/z0a
	 rGF011jRGAeIAzuS3Udh1HoezWE7oP/y+ZT6DHL+LQdrfcp4RA3Gwv51HKZfwmmTwcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIfkakRK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2677B606F500;
	Wed, 18 Nov 2026 19:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIfkakRK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BACB1F000C4;
	Wed, 18 Nov 2026 19:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030626;
	bh=ypHMaTf+VUZ3tFLrzr5y430w877E1FUlJFZBX6aLTQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIfkakRK+G0WdizUmXyg4hEcaYL9qdLWAvlJDGsNnYw5SfALfKgkNQ6REdgottOWQ
	 byOy+XTgslV4d2qbuFspiYMHELCZyheNVsEwdivW6qU+k8W2POcBLdvY6wlvAM1hKO
	 8j68Q8qXH6whu8QpQi4PSRq4B8K4QHeUbChDDABg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0771/1756] drm/msm/dpu: change ib values to u32
Date: Wed, 18 Nov 2026 15:48:18 +0100
Message-ID: <20261118150040.333164837@linuxfoundation.org>
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

[ Upstream commit c54b61102f468cef440423a57341a95763a287a3 ]

The IB values in core_perf calculations (max_per_pipe_ib,
fix_core_ib_vote) are expressed in KBps and are passed to icc_set_bw
without additional division. Change type of those values to u32.

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/636061/
Link: https://lore.kernel.org/r/20250209-dpu-perf-rework-v5-3-87e936cf3004@linaro.org
Stable-dep-of: 480ba24aa340 ("drm/msm/dpu: compute the CRTC bandwidth from the state being checked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 4 ++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h | 6 +++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c      | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 63080510456cf..4f30e8e0276fe 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -135,7 +135,7 @@ static void _dpu_core_perf_calc_crtc(const struct dpu_core_perf *core_perf,
 	}
 
 	DRM_DEBUG_ATOMIC(
-		"crtc=%d clk_rate=%llu core_ib=%llu core_ab=%llu\n",
+		"crtc=%d clk_rate=%llu core_ib=%u core_ab=%llu\n",
 			crtc->base.id, perf->core_clk_rate,
 			perf->max_per_pipe_ib, perf->bw_ctl);
 }
@@ -482,7 +482,7 @@ int dpu_core_perf_debugfs_init(struct dpu_kms *dpu_kms, struct dentry *parent)
 			(u32 *)perf, &dpu_core_perf_mode_fops);
 	debugfs_create_u64("fix_core_clk_rate", 0600, entry,
 			&perf->fix_core_clk_rate);
-	debugfs_create_u64("fix_core_ib_vote", 0600, entry,
+	debugfs_create_u32("fix_core_ib_vote", 0600, entry,
 			&perf->fix_core_ib_vote);
 	debugfs_create_u64("fix_core_ab_vote", 0600, entry,
 			&perf->fix_core_ab_vote);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
index 4186977390bd8..bfbcb84a27064 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
@@ -19,7 +19,7 @@
  * @core_clk_rate: core clock rate request
  */
 struct dpu_core_perf_params {
-	u64 max_per_pipe_ib;
+	u32 max_per_pipe_ib;
 	u64 bw_ctl;
 	u64 core_clk_rate;
 };
@@ -40,7 +40,7 @@ struct dpu_core_perf_tune {
  * @perf_tune: debug control for performance tuning
  * @enable_bw_release: debug control for bandwidth release
  * @fix_core_clk_rate: fixed core clock request in Hz used in mode 2
- * @fix_core_ib_vote: fixed core ib vote in bps used in mode 2
+ * @fix_core_ib_vote: fixed core ib vote in KBps used in mode 2
  * @fix_core_ab_vote: fixed core ab vote in bps used in mode 2
  */
 struct dpu_core_perf {
@@ -50,7 +50,7 @@ struct dpu_core_perf {
 	struct dpu_core_perf_tune perf_tune;
 	u32 enable_bw_release;
 	u64 fix_core_clk_rate;
-	u64 fix_core_ib_vote;
+	u32 fix_core_ib_vote;
 	u64 fix_core_ab_vote;
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index ecd595215a6be..7486c19bb35d9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1386,7 +1386,7 @@ static int dpu_crtc_debugfs_state_show(struct seq_file *s, void *v)
 	seq_printf(s, "core_clk_rate: %llu\n",
 			dpu_crtc->cur_perf.core_clk_rate);
 	seq_printf(s, "bw_ctl: %llu\n", dpu_crtc->cur_perf.bw_ctl);
-	seq_printf(s, "max_per_pipe_ib: %llu\n",
+	seq_printf(s, "max_per_pipe_ib: %u\n",
 				dpu_crtc->cur_perf.max_per_pipe_ib);
 
 	return 0;
-- 
2.53.0



