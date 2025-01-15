Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F99248BC1;
	Wed, 15 Jan 2025 10:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938164; cv=none; b=fJJrbN6ASW8kGnIAPl7azdZz4bg7oeatSyQq7W7G1fsLahNQg2hbjVRniyeIEtcZpHZd8bU6rnKvVXaU8UwLegaNrd6Y+sAbz6BUuLoyhW3s4Flk3zOtxhrj3P8ZNaPFoXE0giQM+M5ub3KSqB/1HZ14XjfD+bsVfN+QxwYbSmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938164; c=relaxed/simple;
	bh=AmSCOq8FXZIpIK4FJT74DaJVbMVCSP/mpl56CnRK40o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQjb7k1HP8HdI0AKQthoCxfILSAl465o/OQ3O7bqPCf2K1TtlcbZwpZO9LcuYNeP5H5kSnHptCpMJ/BcJ9jOtnNLixdYWDFTPt6smjBV0ttARGAJ6CZ9LlukDlLHCVjOKz3itZnsfyGeWiRDF8+hJziIS1dWSaCN1LBEmpkk0zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KftgEvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KftgEvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EE1C4CEDF;
	Wed, 15 Jan 2025 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938164;
	bh=AmSCOq8FXZIpIK4FJT74DaJVbMVCSP/mpl56CnRK40o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KftgEvZgAK6PTsq4LX5DJlnp8gDYCcze9pgHllKIw9bPcBdi0WNJOVS3dHy9kGdM
	 dnznyq0F5ZMrtv6jTZ+gOT/MiWNXEhCOfumr9U5P8/FpkV+3+mGv637yxhknZdythK
	 9944BRU6NqbQeeOwPZKOASVyOugoX1xldGiWfNBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuijing Li <shuijing.li@mediatek.com>,
	Jens Ziller <zillerbaer@gmx.de>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 103/189] Revert "drm/mediatek: dsi: Correct calculation formula of PHY Timing"
Date: Wed, 15 Jan 2025 11:36:39 +0100
Message-ID: <20250115103610.430609107@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chun-Kuang Hu <chunkuang.hu@kernel.org>

commit d08555758fb1dbfb48f0cb58176fdc98009e6070 upstream.

This reverts commit 417d8c47271d5cf1a705e997065873b2a9a36fd4.

With that patch the panel in the Tentacruel ASUS Chromebook CM14
(CM1402F) flickers. There are 1 or 2 times per second a black panel.
Stable Kernel 6.11.5 and mainline 6.12-rc4 works only when reverse
that patch.

Fixes: 417d8c47271d ("drm/mediatek: dsi: Correct calculation formula of PHY Timing")
Cc: stable@vger.kernel.org
Cc: Shuijing Li <shuijing.li@mediatek.com>
Reported-by: Jens Ziller <zillerbaer@gmx.de>
Closes: https://patchwork.kernel.org/project/dri-devel/patch/20240412031208.30688-1-shuijing.li@mediatek.com/
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241212001908.6056-1-chunkuang.hu@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -248,23 +248,22 @@ static void mtk_dsi_phy_timconfig(struct
 	u32 data_rate_mhz = DIV_ROUND_UP(dsi->data_rate, HZ_PER_MHZ);
 	struct mtk_phy_timing *timing = &dsi->phy_timing;
 
-	timing->lpx = (80 * data_rate_mhz / (8 * 1000)) + 1;
-	timing->da_hs_prepare = (59 * data_rate_mhz + 4 * 1000) / 8000 + 1;
-	timing->da_hs_zero = (163 * data_rate_mhz + 11 * 1000) / 8000 + 1 -
+	timing->lpx = (60 * data_rate_mhz / (8 * 1000)) + 1;
+	timing->da_hs_prepare = (80 * data_rate_mhz + 4 * 1000) / 8000;
+	timing->da_hs_zero = (170 * data_rate_mhz + 10 * 1000) / 8000 + 1 -
 			     timing->da_hs_prepare;
-	timing->da_hs_trail = (78 * data_rate_mhz + 7 * 1000) / 8000 + 1;
+	timing->da_hs_trail = timing->da_hs_prepare + 1;
 
-	timing->ta_go = 4 * timing->lpx;
-	timing->ta_sure = 3 * timing->lpx / 2;
-	timing->ta_get = 5 * timing->lpx;
-	timing->da_hs_exit = (118 * data_rate_mhz / (8 * 1000)) + 1;
+	timing->ta_go = 4 * timing->lpx - 2;
+	timing->ta_sure = timing->lpx + 2;
+	timing->ta_get = 4 * timing->lpx;
+	timing->da_hs_exit = 2 * timing->lpx + 1;
 
-	timing->clk_hs_prepare = (57 * data_rate_mhz / (8 * 1000)) + 1;
-	timing->clk_hs_post = (65 * data_rate_mhz + 53 * 1000) / 8000 + 1;
-	timing->clk_hs_trail = (78 * data_rate_mhz + 7 * 1000) / 8000 + 1;
-	timing->clk_hs_zero = (330 * data_rate_mhz / (8 * 1000)) + 1 -
-			      timing->clk_hs_prepare;
-	timing->clk_hs_exit = (118 * data_rate_mhz / (8 * 1000)) + 1;
+	timing->clk_hs_prepare = 70 * data_rate_mhz / (8 * 1000);
+	timing->clk_hs_post = timing->clk_hs_prepare + 8;
+	timing->clk_hs_trail = timing->clk_hs_prepare;
+	timing->clk_hs_zero = timing->clk_hs_trail * 4;
+	timing->clk_hs_exit = 2 * timing->clk_hs_trail;
 
 	timcon0 = FIELD_PREP(LPX, timing->lpx) |
 		  FIELD_PREP(HS_PREP, timing->da_hs_prepare) |


