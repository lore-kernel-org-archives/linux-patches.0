Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300EE313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301043; cv=none; b=OVMz//f/TchzbbxiwzEIc2E37Rga+bnyqRnKL6ZiZhwXwpCw2D5XPh1aSMum8Vx7gU3fRQ24utZfoEX8CM8IDGv3Qic0WsYCuQl7HF++itu8/eu5dPjcSDBp5f+lQIk+RO+j2YMhAirzEDBcpu6Ez3mumVWihOp6E+vUZclzD0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301043; c=relaxed/simple;
	bh=nXzmEiLLXrf5EXfhatpWTro5+flNAki6Q+fpz314hb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNtyObJiPKeyePBTGDZpFr2lFt8dVaBI2bbJZexRjTfofDGWUbY4VT2djYCyIoo33r11wrSYvceiW69eH+Qwcx9g0ehXRTdTt5fAinDziqQTsdpivpSpYHX8mqNctJzaOBrxpb8RPV/vpzVhsHteBnu0+RFjUxo+bher61uIwTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfbrLSVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfbrLSVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5393BC19424;
	Sat, 28 Feb 2026 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301043;
	bh=nXzmEiLLXrf5EXfhatpWTro5+flNAki6Q+fpz314hb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfbrLSVR7E6JrEqLmAocmxkYFEBgoKQK/ZQY00fB6p1uAFFTUJ5fzWoaDyeMaqCB7
	 gn4188Zm0ybRLG1lZ9PonI5TQglCfMI/bHEayRJlOETJa7FGGUrIc2mhun36xFjA/h
	 8U9rTUmuqPzqe0GF1i1zfpD9cuPvZ8yDasqxBYZkVuWETWHtv9dxfGsDGWvRB2STuN
	 qLwoKgcjdZzY+igbZClQTBkJWY1YTZ4Mq5wr5w7BWEsySF+MthwdI5EWQX17ea6lWs
	 +j1sVMPGCArWEgwvkxf+bFp9zdyFD+mhQsFc5Iq7HpDpIlTZ8L74mYBnh4zG2dRhgc
	 /Y3stVNcX1VIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Wang, Sung-huai" <Danny.Wang@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/752] drm/amd/display: Revert "init dispclk from bootup clock for DCN315"
Date: Sat, 28 Feb 2026 12:38:12 -0500
Message-ID: <20260228174750.1542406-181-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Wang, Sung-huai" <Danny.Wang@amd.com>

[ Upstream commit a625dc4989a2affb8f06e7b418bf30e1474b99c1 ]

[Why&How]
This reverts commit 14bb17cc37e0.
Due to the change, the display shows garbage on startup.

We have an alternative solution for the original issue:
d24203bb629f ("drm/amd/display: Re-check seamless boot can be enabled or not")

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Wang, Sung-huai <Danny.Wang@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index b315ed91e010b..c49268db85f68 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -138,7 +138,7 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 	if (dc->work_arounds.skip_clock_update)
 		return;
 
-	clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
+	display_count = dcn315_get_active_display_cnt_wa(dc, context);
 	/*
 	 * if it is safe to lower, but we are already in the lower state, we don't have to do anything
 	 * also if safe to lower is false, we just go in the higher state
@@ -151,7 +151,6 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 		}
 		/* check that we're not already in lower */
 		if (clk_mgr_base->clks.pwr_state != DCN_PWR_STATE_LOW_POWER) {
-			display_count = dcn315_get_active_display_cnt_wa(dc, context);
 			/* if we can go lower, go lower */
 			if (display_count == 0) {
 				union display_idle_optimization_u idle_info = { 0 };
-- 
2.51.0

