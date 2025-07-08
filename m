Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF932DAFA3;
	Tue,  8 Jul 2025 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993826; cv=none; b=HMzNIvLdGhYDRGABfHC+fjXyR2FH2ecNR2v8ln4Q/kEE+mB26NtHlDFggH2EUZAv6zF5Jx3e5djviXdzOt5TjjG3ucX09yMDQ85m13VYQ0+GQ+1TKlisoYQS106b3hzcm/meuhppQ3Sh46MFjj5oDZQzCqS0QNCJDZWuKG7xRGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993826; c=relaxed/simple;
	bh=3T1bzfyutb7zYe8+YQBl6eXzrpPo6rH0wrEF+yimHl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maGrfbg0uIP4QHSujUFQECC6x9i5E4GmQdez0mrMU38yPUXY1KGN9jkQQD3SRz0SIm9ga1Ywo+Gb9Nqq6H3J8cCD3hxvsgAhe1deYt3/POeRNyzyo3CyuC1EW2mM0clTnyoudwTR5LthKyLnJm2uLOe1LlB6To7awHLnd8J83x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cb+MRmYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cb+MRmYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2623FC4CEED;
	Tue,  8 Jul 2025 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993826;
	bh=3T1bzfyutb7zYe8+YQBl6eXzrpPo6rH0wrEF+yimHl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cb+MRmYbv8LYmggfkBFS5auA/KO/jjvtUNjmz5mGCf+Ql4CWYoX/0tDy4Q+IP2feU
	 Zj7FCtddQun9JgzrsYhFDbNs4hMd0iDC3j3LoELL83jgaZLptLcRUK4yemwkbKWXuq
	 zi7uKl+RRKv0QcuWiXYPSHVulHwG9BOsCYYPbYJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/160] clk: ti: am43xx: Add clkctrl data for am43xx ADC1
Date: Tue,  8 Jul 2025 18:21:08 +0200
Message-ID: <20250708162232.387337810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 59139ada4a7eacd4db378ee40a3d6ffbf1d0d72f ]

Declare ADC1 clkctrl which feeds the magnetic-reader/ADC1 hardware
module.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211015081506.933180-2-miquel.raynal@bootlin.com
Stable-dep-of: d52b9b7e2f10 ("media: imx-jpeg: Drop the first error frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk-43xx.c       | 1 +
 include/dt-bindings/clock/am4.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/clk/ti/clk-43xx.c b/drivers/clk/ti/clk-43xx.c
index 46c0add995700..6e97a541cfd36 100644
--- a/drivers/clk/ti/clk-43xx.c
+++ b/drivers/clk/ti/clk-43xx.c
@@ -116,6 +116,7 @@ static const struct omap_clkctrl_reg_data am4_l3s_clkctrl_regs[] __initconst = {
 	{ AM4_L3S_VPFE0_CLKCTRL, NULL, CLKF_SW_SUP, "l3_gclk" },
 	{ AM4_L3S_VPFE1_CLKCTRL, NULL, CLKF_SW_SUP, "l3_gclk" },
 	{ AM4_L3S_GPMC_CLKCTRL, NULL, CLKF_SW_SUP, "l3s_gclk" },
+	{ AM4_L3S_ADC1_CLKCTRL, NULL, CLKF_SW_SUP, "l3s_gclk" },
 	{ AM4_L3S_MCASP0_CLKCTRL, NULL, CLKF_SW_SUP, "mcasp0_fck" },
 	{ AM4_L3S_MCASP1_CLKCTRL, NULL, CLKF_SW_SUP, "mcasp1_fck" },
 	{ AM4_L3S_MMC3_CLKCTRL, NULL, CLKF_SW_SUP, "mmc_clk" },
diff --git a/include/dt-bindings/clock/am4.h b/include/dt-bindings/clock/am4.h
index d961e7cb36821..4be6c5961f342 100644
--- a/include/dt-bindings/clock/am4.h
+++ b/include/dt-bindings/clock/am4.h
@@ -158,6 +158,7 @@
 #define AM4_L3S_VPFE0_CLKCTRL	AM4_L3S_CLKCTRL_INDEX(0x68)
 #define AM4_L3S_VPFE1_CLKCTRL	AM4_L3S_CLKCTRL_INDEX(0x70)
 #define AM4_L3S_GPMC_CLKCTRL	AM4_L3S_CLKCTRL_INDEX(0x220)
+#define AM4_L3S_ADC1_CLKCTRL	AM4_L3S_CLKCTRL_INDEX(0x230)
 #define AM4_L3S_MCASP0_CLKCTRL	AM4_L3S_CLKCTRL_INDEX(0x238)
 #define AM4_L3S_MCASP1_CLKCTRL	AM4_L3S_CLKCTRL_INDEX(0x240)
 #define AM4_L3S_MMC3_CLKCTRL	AM4_L3S_CLKCTRL_INDEX(0x248)
-- 
2.39.5



