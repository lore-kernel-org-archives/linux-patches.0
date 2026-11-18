Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030632;
	b=Kozh8rRuDI2cClGsUBhkqfP0GPI27bLHfRvCfYWDv6DWLYTRPo/rVqUe4xZNA1ofPCYE
	 PqkXwsltLi2Icb7zHDUDqCvHRMEJv4DxGhRcrzBcSdBgjAizrwzahuicgaBbZWDft7GNq
	 rR7qY+cdZCjFzvo1M9gr9Ryfk6k+jaYPTegMMe0WnZ3uxTSbBOaO5AflpNz4GN4qk9zj3
	 MrpdSRmtHmv9Rn1AcbQmlgZGdSXz3ga2xG5BgrxDtvTjBptwMtMEZhnfSFAxlLvB3IEsN
	 rXPJK4AhzokV+QgTAsL4hCPVBjZRV2gyNhLmwNbDZOWkv8NiOptcVddsmg1+mvPVFug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V+tUwJfJ8qZ1qrhk361Lhmgb434bHimX6G4J25cFK9A=;
	b=nl9H4SnfIn9GQPOsnB54n6AWxTJDZ1BVpaAmrUe9lIzeIuOJzPRocdxQWBMI6Mfiac+W
	 V/Dp8I8MKi6JCKSOv5VqD0Mape6jabJPQ4io0eb4H0nfTvbXVGsEtOZTUYdoGqBWtAqGd
	 +zfRS/Ihpv4UyOL/94sXyrojL2dk/dJf5PfPGiji2WFuc8NBhJsR8UBb8V38OEeLem5TA
	 IN/2vHrkLmlw93pu1GoTgeNHuSEoafzGcHgr6YRg5RP/qAbp8qBVa4OehnalcFPdc44bX
	 8jKRSZLn3uPTXw0UZ3o17Qd0+h4SMyU9VCb2tULY3F5Z89NcYXqhPAjEN8VyqkVeE+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQxLltCE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141B1606F505;
	Wed, 18 Nov 2026 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQxLltCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3E41F000C4;
	Wed, 18 Nov 2026 19:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030631;
	bh=V+tUwJfJ8qZ1qrhk361Lhmgb434bHimX6G4J25cFK9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQxLltCEPB1hT5yY0wwMrbdwBAAHRulMXkcEzOemwATIZnwPy1ncioxujmtCPDHPK
	 7eQsB+0i+dPFnc2y4v66Gx43FxybE4Fk8v/Mi9Fm+7iISrUmm57ALNXp+SC7+Wse8L
	 /cCW+1lqpMRUJsqYu13lM6Jw6V00zlbuSyVVDO8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0772/1756] drm/msm/dpu: make fix_core_ab_vote consistent with fix_core_ib_vote
Date: Wed, 18 Nov 2026 15:48:19 +0100
Message-ID: <20261118150040.368339518@linuxfoundation.org>
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



