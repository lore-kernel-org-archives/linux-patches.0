Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049108;
	b=rvgtqTE5iM2rn2CQD+VuXuvZgOpl9acOy6gur9fU116MxmKhteoS3zvbg8pjTABiaEhB
	 nlQHFVageBMzlaTRPItp62nLGCvTP8R4n2sU7cYiGNua/b48qqhkwlpRFBDoRoQAkwKsq
	 9cTwJ/8Uh7gjXRunOK2XA+p5NwsrFAJvKq+CeMLbtgIJP2YZcHpp/Ghy5GBP32/ftJu8f
	 Xmxvni57aWRYZfO9ckg1WeFWqzgyScDNvcLi/U9QU5QOldVKIdrswf/n3oxT5E+61GQVr
	 KS/R0jozRTmh+aQaBO6Dyzw8paP719QsSHcUbGRtFHNL5qZA7BfqYNjYT/Hkn+PFdZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gk00+hmTrkNPFhIxHamBcE9R1t9vkCDgi/jnAEwiiT0=;
	b=RLF9FWiAnVGaI/SPv2p+7FXVO4/xqbMn4UHoEulE27Z8epKLKm3Ks90k2AEFwZ9Gzxfk
	 uAQMQHhYe7p15pPyOMCYyp/kiIcqs45KqC3221suHGcrPmhemQ+7/JG1ePQTNEFgtD5cB
	 0g2CLTOX4Li0vLRZ+fqsDczrz3G6xsjhgFLyN8RZ7ksnx0WwiV8tfTaVNetK7VTDr2TC1
	 ahwpGUGClbrYUaF2wfS1A0oo/IPJ+L4YMCGGp4X1LIakz2+RqQCV87LFuN30ugnR7mmR0
	 YcxlZQfZXS99DS3U3lq7g4RloPIZtvNSuuFao2+ohdl2CXDXsZhmfaPltmzy4KAcOBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftT4FRUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0F7606A31C;
	Thu, 19 Nov 2026 00:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftT4FRUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DE91F000C4;
	Thu, 19 Nov 2026 00:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049108;
	bh=Gk00+hmTrkNPFhIxHamBcE9R1t9vkCDgi/jnAEwiiT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftT4FRUhjPYW00O5Ltat920heF1Z8/Sjgxns4goGRUjHePDjEw2jibeFe13+I+HwS
	 oFJEM0BfFkyM4mo/hfnCK64CRV8VD7hiryJ2p3erWfY07fj4eZVBWHSNfJbBcuqPdw
	 0kk4rmEx28RsBKtTyhGgzwaU09y7cODQZE+XQBsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2192/2857] drm/msm/dpu: drop core_clk_rate overrides from _dpu_core_perf_calc_crtc
Date: Wed, 18 Nov 2026 15:53:46 +0100
Message-ID: <20261118150320.339737144@linuxfoundation.org>
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
index 3464f1e3162fe..c2ed07d1c3c77 100644
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



