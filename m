Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE9C1A0DF8;
	Thu,  6 Jun 2024 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683697; cv=none; b=DA2Na5rrdxT2MqVxG9Yq2nyHDvN352C89f1HEKCnRADz1fA+m2Zk//Ik4iFo/EuKqvWGw7Ug7acq8LjaWp/rYYxXC03Mu2oEBpUovOeRA1Dn0HQsmTwRfm1Yg2sMLpWcFcujE2O5cRuL0Iz09P41og6xKvtutAA6FzKkRlUvB3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683697; c=relaxed/simple;
	bh=j605snKw3ExaqAjAYUKKZhGffduUYlUd6tW53Fex8Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRTVGjfa7sosuQS5hjZL5Df6rS6InErwq5DfWg2rGuI8cGNUu1FEBkmYNHEEe6yKMof4c5x6w13HBY22CsC0KSSWEZhmcfYjaDpzRXUR3Q98dgYFdvzFips6GOWB4bC0Ig/dl7ZV2duB0rsN308hFQbPls8QcSGIPq9Dw7H/iFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCuo7Mpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCuo7Mpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E7FC2BD10;
	Thu,  6 Jun 2024 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683696;
	bh=j605snKw3ExaqAjAYUKKZhGffduUYlUd6tW53Fex8Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCuo7MpxvfJ8StpwuX3bGAcle4V8xU31T8cuG7s5ic1EqBIJdVtUNvD4Au/H0t/Tt
	 eLH/GEYdVGro9zglzizln/vavrtLRZDeUF7HUqjLDGF+fl61fE0a5Ovm6YCO0jE2Ox
	 f3hevevwsHCRtnneXftiXGTZUdezUE+39sc9YEqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 572/744] drm/msm/dsi: Print dual-DSI-adjusted pclk instead of original mode pclk
Date: Thu,  6 Jun 2024 16:04:04 +0200
Message-ID: <20240606131750.801910181@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit f12e0e12524a34bf145f7b80122e653ffe3d130a ]

When dual-DSI (bonded DSI) was added in commit ed9976a09b48
("drm/msm/dsi: adjust dsi timing for dual dsi mode") some DBG() prints
were not updated, leading to print the original mode->clock rather
than the adjusted (typically the mode clock divided by two, though more
recently also adjusted for DSC compression) msm_host->pixel_clk_rate
which is passed to clk_set_rate() just below.  Fix that by printing the
actual pixel_clk_rate that is being set.

Fixes: ed9976a09b48 ("drm/msm/dsi: adjust dsi timing for dual dsi mode")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/589896/
Link: https://lore.kernel.org/r/20240417-drm-msm-initial-dualpipe-dsc-fixes-v1-1-78ae3ee9a697@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 470866896b9b8..ab393bdaba6cd 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -366,8 +366,8 @@ int dsi_link_clk_set_rate_6g(struct msm_dsi_host *msm_host)
 {
 	int ret;
 
-	DBG("Set clk rates: pclk=%d, byteclk=%lu",
-		msm_host->mode->clock, msm_host->byte_clk_rate);
+	DBG("Set clk rates: pclk=%lu, byteclk=%lu",
+	    msm_host->pixel_clk_rate, msm_host->byte_clk_rate);
 
 	ret = dev_pm_opp_set_rate(&msm_host->pdev->dev,
 				  msm_host->byte_clk_rate);
@@ -440,9 +440,9 @@ int dsi_link_clk_set_rate_v2(struct msm_dsi_host *msm_host)
 {
 	int ret;
 
-	DBG("Set clk rates: pclk=%d, byteclk=%lu, esc_clk=%lu, dsi_src_clk=%lu",
-		msm_host->mode->clock, msm_host->byte_clk_rate,
-		msm_host->esc_clk_rate, msm_host->src_clk_rate);
+	DBG("Set clk rates: pclk=%lu, byteclk=%lu, esc_clk=%lu, dsi_src_clk=%lu",
+	    msm_host->pixel_clk_rate, msm_host->byte_clk_rate,
+	    msm_host->esc_clk_rate, msm_host->src_clk_rate);
 
 	ret = clk_set_rate(msm_host->byte_clk, msm_host->byte_clk_rate);
 	if (ret) {
-- 
2.43.0



