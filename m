Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903DA19B3F3;
	Thu,  6 Jun 2024 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683402; cv=none; b=Vja+htpRZNku1KgCBRipP9+CazTvGG6WSYIL55C1XmXv5e6eJfDgNEzqH3M6D6wCM9SqHCgKQz45MbBxOaTi3vv5qxlcsMEJgr+WwD3YP364fiHgG9JouQeRKx0eew07BLUztGWtLbQxKE70l+YVy420cUvDJ8eutmUZ8TZlFx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683402; c=relaxed/simple;
	bh=rS3E/BIzXBtG/Sg0fJKq/WW/xrN8I+QtwWEoiLcrglM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIuaCdw1Uq+99tYNYs6eIBStX4VFaugFEMBu7PWoWe0KZhFiCHwz1JqWqkR00O0OSnN0r5JpGSBkxEAlbWnIStzFOy0OuG60lGpBA/0nRXACbRSLn3pcwU0J7XghtiB/6Hh4D7i46RS5UL4DwXbSaT8fVFp6rLTsq5qOKMqzP64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PllaH59p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PllaH59p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718FDC32782;
	Thu,  6 Jun 2024 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683402;
	bh=rS3E/BIzXBtG/Sg0fJKq/WW/xrN8I+QtwWEoiLcrglM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PllaH59pK4kZfRttPWlvpQXXgo7UmLx15J3D2FDQjSuzBb65M0F+mJZBDxIatqbid
	 8K1/9/R/GLEARt+YT2FA0U1H6hbG+5Kf0Zu6Dwtogc9VS2rr8mvOFBiGbMf0JK3fPJ
	 afHRMQ2abKaZJUbo4WbMvEZ8xOi0GqdlAk/ZrFy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Popescu <catalin.popescu@leica-geosystems.com>,
	Marek Vasut <marex@denx.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 346/744] clk: rs9: fix wrong default value for clock amplitude
Date: Thu,  6 Jun 2024 16:00:18 +0200
Message-ID: <20240606131743.565577775@linuxfoundation.org>
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

From: Catalin Popescu <catalin.popescu@leica-geosystems.com>

[ Upstream commit 1758c68c81b8b881818fcebaaeb91055362a82f8 ]

According to 9FGV0241, 9FGV0441 & 9FGV0841 datasheets, the default
value for the clock amplitude is 0.8V, while the driver assumes 0.7V.

Additionally, define constants for default values for both clock
amplitude and spread spectrum and use them.

Fixes: 892e0ddea1aa ("clk: rs9: Add Renesas 9-series PCIe clock generator driver")
Signed-off-by: Catalin Popescu <catalin.popescu@leica-geosystems.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240415140348.2887619-1-catalin.popescu@leica-geosystems.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-renesas-pcie.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-renesas-pcie.c b/drivers/clk/clk-renesas-pcie.c
index 3b6ad2307a41f..b00c38469cfad 100644
--- a/drivers/clk/clk-renesas-pcie.c
+++ b/drivers/clk/clk-renesas-pcie.c
@@ -24,10 +24,12 @@
 #define RS9_REG_SS_AMP_0V7			0x1
 #define RS9_REG_SS_AMP_0V8			0x2
 #define RS9_REG_SS_AMP_0V9			0x3
+#define RS9_REG_SS_AMP_DEFAULT			RS9_REG_SS_AMP_0V8
 #define RS9_REG_SS_AMP_MASK			0x3
 #define RS9_REG_SS_SSC_100			0
 #define RS9_REG_SS_SSC_M025			(1 << 3)
 #define RS9_REG_SS_SSC_M050			(3 << 3)
+#define RS9_REG_SS_SSC_DEFAULT			RS9_REG_SS_SSC_100
 #define RS9_REG_SS_SSC_MASK			(3 << 3)
 #define RS9_REG_SS_SSC_LOCK			BIT(5)
 #define RS9_REG_SR				0x2
@@ -211,8 +213,8 @@ static int rs9_get_common_config(struct rs9_driver_data *rs9)
 	int ret;
 
 	/* Set defaults */
-	rs9->pll_amplitude = RS9_REG_SS_AMP_0V7;
-	rs9->pll_ssc = RS9_REG_SS_SSC_100;
+	rs9->pll_amplitude = RS9_REG_SS_AMP_DEFAULT;
+	rs9->pll_ssc = RS9_REG_SS_SSC_DEFAULT;
 
 	/* Output clock amplitude */
 	ret = of_property_read_u32(np, "renesas,out-amplitude-microvolt",
@@ -253,13 +255,13 @@ static void rs9_update_config(struct rs9_driver_data *rs9)
 	int i;
 
 	/* If amplitude is non-default, update it. */
-	if (rs9->pll_amplitude != RS9_REG_SS_AMP_0V7) {
+	if (rs9->pll_amplitude != RS9_REG_SS_AMP_DEFAULT) {
 		regmap_update_bits(rs9->regmap, RS9_REG_SS, RS9_REG_SS_AMP_MASK,
 				   rs9->pll_amplitude);
 	}
 
 	/* If SSC is non-default, update it. */
-	if (rs9->pll_ssc != RS9_REG_SS_SSC_100) {
+	if (rs9->pll_ssc != RS9_REG_SS_SSC_DEFAULT) {
 		regmap_update_bits(rs9->regmap, RS9_REG_SS, RS9_REG_SS_SSC_MASK,
 				   rs9->pll_ssc);
 	}
-- 
2.43.0



