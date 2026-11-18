Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049106;
	b=Txd4PyTGupKvOZ/GPWrevPvpJX4rgIxmjrX9ZXqZRI5MBhV/kblhpYLRP2q6gl6aoxWG
	 Zu3J+k4Q8Xs2DKp234KrNUcPwMIt3JWI/qoGRUYpsahmTox8OsaWlyGm/a1vYKw/CSGTP
	 lFQelyMEkn6/+mP5tDWy/Lm9Ysp+XDw9kcAy4jdEdKl3Z5KTvy6N9O3qqyCj/ioqYnlL5
	 Bx8RGNUiPDcZNLGuiqSaOFR6YS9zxW/J0zcgrPm4k0PgP4KYy6hlz+Bh8bci4b7lJ0CCi
	 hB5zqf+6DYrEi+3SxP4ZmNsy/0i28uwBeWhhb/TqJCGePnKKQi3yxx0Nkv6EbzQwf5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w/vYkBGfM8Fiz+i0e1XPExHJvn3j1prxcVctgt+lOlQ=;
	b=yhUxKA7eCY7+4NHxeytPzCxuG+sWkQ3EQLDhvkL4NNAvJ9msuv3A3LMySDmIfxmCDjJp
	 yvR880qcv4KDZOfVpWF0hZw/k6snmI6i8NyLd03zd42f52GUc9USfEz8ECnfRSu86ofSP
	 B9u1hqW1OZXFgQUAbdg/Uj0N3ryZNFT1knAJsY1FSfCjmd84pqmftiFCQObk3fCgCQc87
	 Pu1ZhZcbQIGDUO5R+HVH12AJeNTFqhJHsRqLWlJjyKNJ7G+sh5SWHu/rApxKHuye9zkIH
	 qo1fxKw29fBFxEuzdLNjtb6G38myNyYfcr/vP8xKEk9dPEuZb2eP7wFfCD8+AAy0tCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INfP6RIx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D98606A331;
	Thu, 19 Nov 2026 00:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INfP6RIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE0E1F000C4;
	Thu, 19 Nov 2026 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049105;
	bh=w/vYkBGfM8Fiz+i0e1XPExHJvn3j1prxcVctgt+lOlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INfP6RIxBkHoS0M66MoRf6kmjUcZwCJI/JButfILp0qkmhLz6OrSW1P1YKPxJCvSV
	 qxOvrT/o6c+pnHmjjhwSeE6qLzKzy0gFaHSFulGEK6z2rbCOBl6czXayH6D39PC1bB
	 1ezIOp/sR8HCfs8BbCW1c86//8UaQzyuOpPd4yMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2191/2857] drm/msm/dpu: make fix_core_ab_vote consistent with fix_core_ib_vote
Date: Wed, 18 Nov 2026 15:53:45 +0100
Message-ID: <20261118150320.302031254@linuxfoundation.org>
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
index 377722d16d408..3464f1e3162fe 100644
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
@@ -487,7 +487,7 @@ int dpu_core_perf_debugfs_init(struct dpu_kms *dpu_kms, struct dentry *parent)
 			&perf->fix_core_clk_rate);
 	debugfs_create_u32("fix_core_ib_vote", 0600, entry,
 			&perf->fix_core_ib_vote);
-	debugfs_create_u64("fix_core_ab_vote", 0600, entry,
+	debugfs_create_u32("fix_core_ab_vote", 0600, entry,
 			&perf->fix_core_ab_vote);
 
 	return 0;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
index fa7de17defec0..e71d2a6175ab3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
@@ -46,7 +46,7 @@ struct dpu_core_perf_tune {
  * @enable_bw_release: debug control for bandwidth release
  * @fix_core_clk_rate: fixed core clock request in Hz used in mode 2
  * @fix_core_ib_vote: fixed core ib vote in KBps used in mode 2
- * @fix_core_ab_vote: fixed core ab vote in bps used in mode 2
+ * @fix_core_ab_vote: fixed core ab vote in KBps used in mode 2
  */
 struct dpu_core_perf {
 	struct drm_device *dev;
@@ -59,7 +59,7 @@ struct dpu_core_perf {
 	u32 enable_bw_release;
 	u64 fix_core_clk_rate;
 	u32 fix_core_ib_vote;
-	u64 fix_core_ab_vote;
+	u32 fix_core_ab_vote;
 };
 
 /**
-- 
2.53.0



