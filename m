Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF68198A35;
	Thu,  6 Jun 2024 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683390; cv=none; b=jC9LBQvDLdIpgd5F3tEj4F5utPgpxST3qfx8kfLUJ1vle5gtKyyX497Q1+wJ5Z/25Tzs3ooZH5Q3DrxWELjn2mgp3YlaIDkKuZabzhWUa32bbvqwICuQrmOkSv6h0RRZ0KqqVthxKrZckJ2GBaVlY9b4LpO9ndqjMmxmtg08IOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683390; c=relaxed/simple;
	bh=62cEcQcFOJHqZL/baAixI0rzR8EimnZdzqBM2eRkaAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngq4NOiAqoDDpe3Vhko8cKJx/6Vq63qrQc0jCcf33O6mz8w5G5lLA5m2Mx64tDYFweWklPisfdXktEZT9mUOf3Iw4YD35TCo1yiWZ3GNNOCG88ALEC5yzdCqJF4c8vN/fM2YiYm12h46+83gtN5aKC38WTkVtENSKxWMfBF5Y3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCVr61vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCVr61vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC10DC2BD10;
	Thu,  6 Jun 2024 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683389;
	bh=62cEcQcFOJHqZL/baAixI0rzR8EimnZdzqBM2eRkaAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCVr61vvNgK7qInqZE/Bw8qLRlzyzJxogIGicUV5U/pu/idTjI8bTYPvZ4Yq4ojwG
	 KeBl3lC8s6obdFHMjNb8bCMBktudX6WHYrezCCun/mGTxXJBTa9Mzv//bg1bqxrZKq
	 6N1eTwjqGlZH9zCJfKRjpnFDiclCGsjUBr7t1xRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Popescu <catalin.popescu@leica-geosystems.com>,
	Marek Vasut <marex@denx.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/473] clk: rs9: fix wrong default value for clock amplitude
Date: Thu,  6 Jun 2024 16:02:53 +0200
Message-ID: <20240606131707.910363295@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 35b2519f16961..bba0e7c667dc1 100644
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
@@ -196,8 +198,8 @@ static int rs9_get_common_config(struct rs9_driver_data *rs9)
 	int ret;
 
 	/* Set defaults */
-	rs9->pll_amplitude = RS9_REG_SS_AMP_0V7;
-	rs9->pll_ssc = RS9_REG_SS_SSC_100;
+	rs9->pll_amplitude = RS9_REG_SS_AMP_DEFAULT;
+	rs9->pll_ssc = RS9_REG_SS_SSC_DEFAULT;
 
 	/* Output clock amplitude */
 	ret = of_property_read_u32(np, "renesas,out-amplitude-microvolt",
@@ -238,13 +240,13 @@ static void rs9_update_config(struct rs9_driver_data *rs9)
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



