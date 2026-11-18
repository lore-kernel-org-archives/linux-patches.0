Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040637;
	b=NtCZbOohJtwpQcKEJjDiqZ48y/Oewm+LgzO0QE82SsHJ+Qk4eAuO9rIafVUCrZ/0WZ5s
	 07TdZYfdShXd3i3P5BDjjfv8hg1C6Z94vBnkuk0mfmuQo/fmhn3Rb+PfLPDaKpWjoN79B
	 5VQZw4Dx/OGfbj9YZ2XOoUgoX/f/ngouMZJMKZFwjRt/qaZktJZqoBmFUuBimevY4NMGJ
	 TIFRrrZIxWv1y060gQXttS4Zrj2Ui3EiD7Gme/qkt6/G4MTWJHsYWI7GKNVdQij4+Rvnx
	 oDduCdSWHcZdcmBNHzfNFqpLwQlf9XIYjs4mI5+hIjLzd3n7wozIGNEc5L3+Xg83J5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oNj+yisYU7Ibd0ZodlYEee4jtFHmyl4KYCNud8h/Oy8=;
	b=4C54y5hia9lTsmSNs+H6Crmek7d2JExlRQRNK7GGP4rfHdt9kGVVe9RyXA9p57IXoAhD
	 lGbARxZakAcb/UGz440mSJNsPLWKTmDVOtHILqZt9Y1gdqEw1fW6r0aNA4BDlnp7+DMGR
	 wG3m/tPA/JDbaN6BczX3xitHZpF0YPAH2oHgCY8diWRBPxvqaR/FWOd8FVueaLNBb1xDo
	 BevpNmW4CWNzFi0JaAYoESj2D9GiBCTuG9AFqm51ubPc+PPYtEDMPLJ/TN4AAQ7hxBQwY
	 ucZPYwOG9QXMS8YdBjWL+ZCMOxuSNR+RcVstjKYF+DYJ70aTCUxI+6CYKWDmTxsinZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zYSvX4NC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2113606A31C;
	Wed, 18 Nov 2026 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zYSvX4NC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6541F000C4;
	Wed, 18 Nov 2026 22:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040637;
	bh=oNj+yisYU7Ibd0ZodlYEee4jtFHmyl4KYCNud8h/Oy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zYSvX4NCIzgZKdECBPMGF6jOiY71dD8kmlriyitzICH+FBEaL+8pGj9pk+Zf98Xy6
	 HVTZTFu98d/4bi3g4vzvXhS+Jig43PWcrW9Jkgne/amwDSJPbIuLwUlMpqex5qXZ6U
	 grq09oFVCP9ojlq5qwoZ+6tPmuQbt/bNhUXgDV6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2527/3318] drm/msm/dpu: make fix_core_ab_vote consistent with fix_core_ib_vote
Date: Wed, 18 Nov 2026 15:52:29 +0100
Message-ID: <20261118150437.158925417@linuxfoundation.org>
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

[ Upstream commit 879a7f8c8c2d727bc4c8ae3238f0dbf52eada6db ]

The fix_core_ab_vote is an average bandwidth value, used for bandwidth
overrides in several cases. However there is an internal inconsistency:
fix_core_ib_vote is defined in KBps, while fix_core_ab_vote is defined
in Bps.

Fix that by changing the type of the variable to u32 and using * 1000ULL
multiplier when setting up the dpu_core_perf_params::bw_ctl value.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/636064/
Link: https://lore.kernel.org/r/20250209-dpu-perf-rework-v5-4-87e936cf3004@linaro.org
Stable-dep-of: 480ba24aa340 ("drm/msm/dpu: compute the CRTC bandwidth from the state being checked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 4 ++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 4f30e8e0276fe..9ddeafe8f8f54 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -125,7 +125,7 @@ static void _dpu_core_perf_calc_crtc(const struct dpu_core_perf *core_perf,
 		perf->max_per_pipe_ib = 0;
 		perf->core_clk_rate = 0;
 	} else if (core_perf->perf_tune.mode == DPU_PERF_MODE_FIXED) {
-		perf->bw_ctl = core_perf->fix_core_ab_vote;
+		perf->bw_ctl = core_perf->fix_core_ab_vote * 1000ULL;
 		perf->max_per_pipe_ib = core_perf->fix_core_ib_vote;
 		perf->core_clk_rate = core_perf->fix_core_clk_rate;
 	} else {
@@ -484,7 +484,7 @@ int dpu_core_perf_debugfs_init(struct dpu_kms *dpu_kms, struct dentry *parent)
 			&perf->fix_core_clk_rate);
 	debugfs_create_u32("fix_core_ib_vote", 0600, entry,
 			&perf->fix_core_ib_vote);
-	debugfs_create_u64("fix_core_ab_vote", 0600, entry,
+	debugfs_create_u32("fix_core_ab_vote", 0600, entry,
 			&perf->fix_core_ab_vote);
 
 	return 0;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
index bfbcb84a27064..7d99dcebb6feb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
@@ -41,7 +41,7 @@ struct dpu_core_perf_tune {
  * @enable_bw_release: debug control for bandwidth release
  * @fix_core_clk_rate: fixed core clock request in Hz used in mode 2
  * @fix_core_ib_vote: fixed core ib vote in KBps used in mode 2
- * @fix_core_ab_vote: fixed core ab vote in bps used in mode 2
+ * @fix_core_ab_vote: fixed core ab vote in KBps used in mode 2
  */
 struct dpu_core_perf {
 	const struct dpu_perf_cfg *perf_cfg;
@@ -51,7 +51,7 @@ struct dpu_core_perf {
 	u32 enable_bw_release;
 	u64 fix_core_clk_rate;
 	u32 fix_core_ib_vote;
-	u64 fix_core_ab_vote;
+	u32 fix_core_ab_vote;
 };
 
 /**
-- 
2.53.0



