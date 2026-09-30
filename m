Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C494CA784;
	Wed, 30 Sep 2026 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787236; cv=none; b=WrmvG7TsV07DF4OJjUUK6dWHqRp0+G5gj9iIFkmGE18lNNt/E7pqp1Y0txjN8WpR8s35z0ZbZRgTrkRPhy255AKVL0jkKfYW5fv6a83J4UyO2O1ZF3ECfZYVIM1cw+zScgJyHlZgStLWuh+IxJTo0++KC0YcSwHdrQnp1tG1IQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787236; c=relaxed/simple;
	bh=5VPBVV38IpLv6vdW0f0PihT1KT/PGVhkBKS1m2uhvXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw6tUHP8+p1Pz2cAsA9O0F6R9d7kZKngaf/p9km6mwhRRT24g8oi8oDhX0Ow0cGx4ATzz39IV40Zcyu44qF2Ic9SfRZI4797quKLXLxSoG5z+XkODlH5+/W+NbEZc21LPMPRCDeN8vIoJOxXsUpfEV2HUjva+1ekHDhQOV+aVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4etHFhF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4etHFhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0172A1F000FF;
	Wed, 30 Sep 2026 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787234;
	bh=KogmBLLXTLTNw5SU+ixGo3EUoV3ytgcs0PPb5GBeyL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4etHFhF1aC9qAC9PeyHRIRTs9a5VGKewCjExlpnUptJvi+M30zO2bI3Bh3N2Ie6C
	 YPD0+MwSXjvfCXf/tFpOQ2LXAah5xaUh4JCOaDU9RueU8KsnWjCvuwknTYJOSwAgZw
	 BebqonCBQ6IfmQaHGQNV4ALQGOfPtPC6ot0vArZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 114/457] pinctrl: tegra238: Fix register bank for AON pin groups
Date: Wed, 30 Sep 2026 17:23:39 +0200
Message-ID: <20260930152348.513409574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit ae2c5bf969573708cd5b6bb6393631255d83c3fe ]

The AON pin controller has a single register region and therefore,
the bank defined in the tegra238_functions[] and tegra238_aon_groups[]
for the AON pin groups must be 0. However, commit 25cac7292d49
("pinctrl: tegra: Add Tegra238 pinmux driver") incorrectly specified the
bank for these pins as 1 and not 0. This means that in the
tegra_pinctrl_probe() function we use an invalid index when accessing
the pmx->regs[] array which causes an incorrect address to be used for
accessing the pinmux registers.

Fix this by correcting the bank for the AON pin groups.

Fixes: 25cac7292d49 ("pinctrl: tegra: Add Tegra238 pinmux driver")
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra238.c | 204 +++++++++++------------
 1 file changed, 102 insertions(+), 102 deletions(-)

diff --git a/drivers/pinctrl/tegra/pinctrl-tegra238.c b/drivers/pinctrl/tegra/pinctrl-tegra238.c
index ec482365f14f2..40aba285944eb 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra238.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra238.c
@@ -1744,57 +1744,57 @@ static const char * const tegra238_functions[] = {
 #define drive_sdmmc1_dat0_pu2		DRV_PINGROUP_ENTRY_Y(0x8034,	28,	2,	30,	2,	-1,	-1,	-1,	-1,	0)
 #define drive_ufs0_rst_n_pv1		DRV_PINGROUP_ENTRY_Y(0x11004,	12,	5,	24,	5,	-1,	-1,	-1,	-1,	0)
 #define drive_ufs0_ref_clk_pv0		DRV_PINGROUP_ENTRY_Y(0x1100c,	12,	5,	24,	5,	-1,	-1,	-1,	-1,	0)
-#define drive_batt_oc_paa4		    DRV_PINGROUP_ENTRY_Y(0x1024,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_bootv_ctl_n_paa0		DRV_PINGROUP_ENTRY_Y(0x102c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_vcomp_alert_paa2		DRV_PINGROUP_ENTRY_Y(0x105c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_hdmi_cec_pbb0		    DRV_PINGROUP_ENTRY_Y(0x1064,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_touch_clk_pdd3		DRV_PINGROUP_ENTRY_Y(0x106c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart3_rx_pcc6		    DRV_PINGROUP_ENTRY_Y(0x1074,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart3_tx_pcc5		    DRV_PINGROUP_ENTRY_Y(0x107c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_gen8_i2c_sda_pdd2		DRV_PINGROUP_ENTRY_Y(0x1084,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_gen8_i2c_scl_pdd1		DRV_PINGROUP_ENTRY_Y(0x108c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_spi2_mosi_pcc2		DRV_PINGROUP_ENTRY_Y(0x1094,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_gen2_i2c_scl_pcc7		DRV_PINGROUP_ENTRY_Y(0x109c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_spi2_cs0_pcc3		    DRV_PINGROUP_ENTRY_Y(0x10a4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_gen2_i2c_sda_pdd0		DRV_PINGROUP_ENTRY_Y(0x10ac,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_spi2_sck_pcc0		    DRV_PINGROUP_ENTRY_Y(0x10b4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_spi2_miso_pcc1		DRV_PINGROUP_ENTRY_Y(0x10bc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio49_pee2		DRV_PINGROUP_ENTRY_Y(0x10c4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio50_pee4		DRV_PINGROUP_ENTRY_Y(0x10cc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio82_pee3		DRV_PINGROUP_ENTRY_Y(0x10d4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio71_pff2		DRV_PINGROUP_ENTRY_Y(0x10dc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio76_pff7		DRV_PINGROUP_ENTRY_Y(0x10e4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio74_pff5		DRV_PINGROUP_ENTRY_Y(0x10ec,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio00_paa1		DRV_PINGROUP_ENTRY_Y(0x10f4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio19_pdd6		DRV_PINGROUP_ENTRY_Y(0x10fc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio86_phh3		DRV_PINGROUP_ENTRY_Y(0x1104,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio72_pff3		DRV_PINGROUP_ENTRY_Y(0x110c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio77_pgg0		DRV_PINGROUP_ENTRY_Y(0x1114,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio80_pff6		DRV_PINGROUP_ENTRY_Y(0x111c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio84_pgg1		DRV_PINGROUP_ENTRY_Y(0x1124,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio83_pee5		DRV_PINGROUP_ENTRY_Y(0x112c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio73_pff4		DRV_PINGROUP_ENTRY_Y(0x1134,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio70_pff1		DRV_PINGROUP_ENTRY_Y(0x113c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio04_paa5		DRV_PINGROUP_ENTRY_Y(0x1144,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio85_pgg6		DRV_PINGROUP_ENTRY_Y(0x114c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio69_pff0		DRV_PINGROUP_ENTRY_Y(0x1154,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio25_paa6		DRV_PINGROUP_ENTRY_Y(0x115c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_soc_gpio26_paa7		DRV_PINGROUP_ENTRY_Y(0x1164,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart5_tx_pgg7		    DRV_PINGROUP_ENTRY_Y(0x116c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart5_rx_phh0		    DRV_PINGROUP_ENTRY_Y(0x1174,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart2_tx_pgg2		    DRV_PINGROUP_ENTRY_Y(0x117c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart2_rx_pgg3		    DRV_PINGROUP_ENTRY_Y(0x1184,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart2_cts_pgg5		DRV_PINGROUP_ENTRY_Y(0x118c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart2_rts_pgg4		DRV_PINGROUP_ENTRY_Y(0x1194,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart5_cts_phh2		DRV_PINGROUP_ENTRY_Y(0x119c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_uart5_rts_phh1		DRV_PINGROUP_ENTRY_Y(0x11a4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_pwm7_pee1			    DRV_PINGROUP_ENTRY_Y(0x11ac,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_pwm2_pdd7			    DRV_PINGROUP_ENTRY_Y(0x11b4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_pwm3_pee0			    DRV_PINGROUP_ENTRY_Y(0x11bc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_pwm1_paa3			    DRV_PINGROUP_ENTRY_Y(0x11c4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_spi2_cs1_pcc4		    DRV_PINGROUP_ENTRY_Y(0x11cc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_dmic1_clk_pdd4		DRV_PINGROUP_ENTRY_Y(0x11d4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
-#define drive_dmic1_dat_pdd5		DRV_PINGROUP_ENTRY_Y(0x11dc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	1)
+#define drive_batt_oc_paa4		    DRV_PINGROUP_ENTRY_Y(0x1024,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_bootv_ctl_n_paa0		DRV_PINGROUP_ENTRY_Y(0x102c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_vcomp_alert_paa2		DRV_PINGROUP_ENTRY_Y(0x105c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_hdmi_cec_pbb0		    DRV_PINGROUP_ENTRY_Y(0x1064,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_touch_clk_pdd3		DRV_PINGROUP_ENTRY_Y(0x106c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart3_rx_pcc6		    DRV_PINGROUP_ENTRY_Y(0x1074,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart3_tx_pcc5		    DRV_PINGROUP_ENTRY_Y(0x107c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_gen8_i2c_sda_pdd2		DRV_PINGROUP_ENTRY_Y(0x1084,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_gen8_i2c_scl_pdd1		DRV_PINGROUP_ENTRY_Y(0x108c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_spi2_mosi_pcc2		DRV_PINGROUP_ENTRY_Y(0x1094,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_gen2_i2c_scl_pcc7		DRV_PINGROUP_ENTRY_Y(0x109c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_spi2_cs0_pcc3		    DRV_PINGROUP_ENTRY_Y(0x10a4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_gen2_i2c_sda_pdd0		DRV_PINGROUP_ENTRY_Y(0x10ac,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_spi2_sck_pcc0		    DRV_PINGROUP_ENTRY_Y(0x10b4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_spi2_miso_pcc1		DRV_PINGROUP_ENTRY_Y(0x10bc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio49_pee2		DRV_PINGROUP_ENTRY_Y(0x10c4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio50_pee4		DRV_PINGROUP_ENTRY_Y(0x10cc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio82_pee3		DRV_PINGROUP_ENTRY_Y(0x10d4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio71_pff2		DRV_PINGROUP_ENTRY_Y(0x10dc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio76_pff7		DRV_PINGROUP_ENTRY_Y(0x10e4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio74_pff5		DRV_PINGROUP_ENTRY_Y(0x10ec,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio00_paa1		DRV_PINGROUP_ENTRY_Y(0x10f4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio19_pdd6		DRV_PINGROUP_ENTRY_Y(0x10fc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio86_phh3		DRV_PINGROUP_ENTRY_Y(0x1104,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio72_pff3		DRV_PINGROUP_ENTRY_Y(0x110c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio77_pgg0		DRV_PINGROUP_ENTRY_Y(0x1114,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio80_pff6		DRV_PINGROUP_ENTRY_Y(0x111c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio84_pgg1		DRV_PINGROUP_ENTRY_Y(0x1124,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio83_pee5		DRV_PINGROUP_ENTRY_Y(0x112c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio73_pff4		DRV_PINGROUP_ENTRY_Y(0x1134,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio70_pff1		DRV_PINGROUP_ENTRY_Y(0x113c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio04_paa5		DRV_PINGROUP_ENTRY_Y(0x1144,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio85_pgg6		DRV_PINGROUP_ENTRY_Y(0x114c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio69_pff0		DRV_PINGROUP_ENTRY_Y(0x1154,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio25_paa6		DRV_PINGROUP_ENTRY_Y(0x115c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_soc_gpio26_paa7		DRV_PINGROUP_ENTRY_Y(0x1164,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart5_tx_pgg7		    DRV_PINGROUP_ENTRY_Y(0x116c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart5_rx_phh0		    DRV_PINGROUP_ENTRY_Y(0x1174,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart2_tx_pgg2		    DRV_PINGROUP_ENTRY_Y(0x117c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart2_rx_pgg3		    DRV_PINGROUP_ENTRY_Y(0x1184,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart2_cts_pgg5		DRV_PINGROUP_ENTRY_Y(0x118c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart2_rts_pgg4		DRV_PINGROUP_ENTRY_Y(0x1194,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart5_cts_phh2		DRV_PINGROUP_ENTRY_Y(0x119c,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_uart5_rts_phh1		DRV_PINGROUP_ENTRY_Y(0x11a4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_pwm7_pee1			    DRV_PINGROUP_ENTRY_Y(0x11ac,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_pwm2_pdd7			    DRV_PINGROUP_ENTRY_Y(0x11b4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_pwm3_pee0			    DRV_PINGROUP_ENTRY_Y(0x11bc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_pwm1_paa3			    DRV_PINGROUP_ENTRY_Y(0x11c4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_spi2_cs1_pcc4		    DRV_PINGROUP_ENTRY_Y(0x11cc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_dmic1_clk_pdd4		DRV_PINGROUP_ENTRY_Y(0x11d4,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
+#define drive_dmic1_dat_pdd5		DRV_PINGROUP_ENTRY_Y(0x11dc,	12,	5,	20,	5,	-1,	-1,	-1,	-1,	0)
 
 #define drive_sdmmc1_comp		DRV_PINGROUP_ENTRY_N
 
@@ -1961,57 +1961,57 @@ static const struct tegra_pingroup tegra238_groups[] = {
 };
 
 static const struct tegra_pingroup tegra238_aon_groups[] = {
-	PINGROUP(bootv_ctl_n_paa0,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1028,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio00_paa1,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10f0,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(vcomp_alert_paa2,	SOC_THERM_OC1,	RSVD1,			RSVD2,		RSVD3,		0x1058,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(pwm1_paa3,		GP_PWM1,	RSVD1,			RSVD2,		RSVD3,		0x11c0,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(batt_oc_paa4,		SOC_THERM_OC2,	RSVD1,			RSVD2,		RSVD3,		0x1020,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio04_paa5,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1140,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio25_paa6,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1158,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio26_paa7,	RSVD0,		SOC_THERM_OC3,		RSVD2,		RSVD3,		0x1160,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(hdmi_cec_pbb0,		HDMI_CEC,	RSVD1,			RSVD2,		RSVD3,		0x1060,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(spi2_sck_pcc0,		SPI2_SCK,	RSVD1,			RSVD2,		RSVD3,		0x10b0,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(spi2_miso_pcc1,	SPI2_DIN,	RSVD1,			RSVD2,		RSVD3,		0x10b8,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(spi2_mosi_pcc2,	SPI2_DOUT,	RSVD1,			RSVD2,		RSVD3,		0x1090,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(spi2_cs0_pcc3,		SPI2_CS0,	RSVD1,			RSVD2,		RSVD3,		0x10a0,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(spi2_cs1_pcc4,		SPI2_CS1,	RSVD1,			RSVD2,		RSVD3,		0x11c8,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart3_tx_pcc5,		UARTC_TXD,	RSVD1,			RSVD2,		RSVD3,		0x1078,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart3_rx_pcc6,		UARTC_RXD,	RSVD1,			RSVD2,		RSVD3,		0x1070,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(gen2_i2c_scl_pcc7,	I2C2_CLK,	RSVD1,			RSVD2,		RSVD3,		0x1098,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(gen2_i2c_sda_pdd0,	I2C2_DAT,	RSVD1,			RSVD2,		RSVD3,		0x10a8,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(gen8_i2c_scl_pdd1,	I2C8_CLK,	RSVD1,			RSVD2,		RSVD3,		0x1088,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(gen8_i2c_sda_pdd2,	I2C8_DAT,	RSVD1,			RSVD2,		RSVD3,		0x1080,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(touch_clk_pdd3,	GP_PWM4,	TOUCH_CLK,		RSVD2,		RSVD3,		0x1068,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(dmic1_clk_pdd4,	DMIC1_CLK,	RSVD1,			DMIC5_CLK,	RSVD3,		0x11d0,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(dmic1_dat_pdd5,	DMIC1_DAT,	RSVD1,			DMIC5_DAT,	RSVD3,		0x11d8,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio19_pdd6,	RSVD0,		WDT_RESET_OUTB,		RSVD2,		RSVD3,		0x10f8,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio49_pee2,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10c0,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio50_pee4,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10c8,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio82_pee3,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10d0,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio71_pff2,	PPC_MODE_1,	RSVD1,			RSVD2,		RSVD3,		0x10d8,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio76_pff7,	RSVD0,		RSVD1,			TSC_EDGE_OUT0,	TSC_EDGE_OUT0A,	0x10e0,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio74_pff5,	PPC_READY,	PPC_I2C_DAT,		RSVD2,		RSVD3,		0x10e8,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio86_phh3,	RSVD0,		SPI5_CS1,		TSC_EDGE_OUT3,	TSC_EDGE_OUT0D,	0x1100,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio72_pff3,	PPC_MODE_2,	RSVD1,			RSVD2,		RSVD3,		0x1108,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio77_pgg0,	RSVD0,		RSVD1,			TSC_EDGE_OUT1,	TSC_EDGE_OUT0B,	0x1110,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio80_pff6,	RSVD0,		PPC_RST_N,		RSVD2,		RSVD3,		0x1118,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio84_pgg1,	RSVD0,		RSVD1,			TSC_EDGE_OUT2,	TSC_EDGE_OUT0C,	0x1120,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio83_pee5,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1128,		1,	Y,	-1,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio73_pff4,	PPC_CC,		PPC_I2C_CLK,		RSVD2,		RSVD3,		0x1130,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio70_pff1,	PPC_MODE_0,	RSVD1,			RSVD2,		RSVD3,		0x1138,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio85_pgg6,	RSVD0,		SPI4_CS1,		RSVD2,		RSVD3,		0x1148,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(soc_gpio69_pff0,	PPC_INT_N,	RSVD1,			RSVD2,		RSVD3,		0x1150,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart5_tx_pgg7,		UARTE_TXD,	SPI5_SCK,		RSVD2,		RSVD3,		0x1168,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart5_rx_phh0,		UARTE_RXD,	SPI5_MISO,		RSVD2,		RSVD3,		0x1170,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart2_tx_pgg2,		UARTB_TXD,	SPI4_SCK,		RSVD2,		RSVD3,		0x1178,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart2_rx_pgg3,		UARTB_RXD,	SPI4_MISO,		RSVD2,		RSVD3,		0x1180,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart2_cts_pgg5,	UARTB_CTS,	SPI4_CS0,		RSVD2,		RSVD3,		0x1188,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart2_rts_pgg4,	UARTB_RTS,	SPI4_MOSI,		RSVD2,		RSVD3,		0x1190,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart5_cts_phh2,	UARTE_CTS,	SPI5_CS0,		RSVD2,		RSVD3,		0x1198,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(uart5_rts_phh1,	UARTE_RTS,	SPI5_MOSI,		RSVD2,		RSVD3,		0x11a0,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(pwm2_pdd7,		GP_PWM2,	LED_BLINK,		RSVD2,		RSVD3,		0x11b0,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(pwm3_pee0,		GP_PWM3,	RSVD1,			RSVD2,		RSVD3,		0x11b8,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
-	PINGROUP(pwm7_pee1,		GP_PWM7,	RSVD1,			RSVD2,		RSVD3,		0x11a8,		1,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(bootv_ctl_n_paa0,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1028,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio00_paa1,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10f0,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(vcomp_alert_paa2,	SOC_THERM_OC1,	RSVD1,			RSVD2,		RSVD3,		0x1058,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(pwm1_paa3,		GP_PWM1,	RSVD1,			RSVD2,		RSVD3,		0x11c0,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(batt_oc_paa4,		SOC_THERM_OC2,	RSVD1,			RSVD2,		RSVD3,		0x1020,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio04_paa5,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1140,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio25_paa6,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1158,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio26_paa7,	RSVD0,		SOC_THERM_OC3,		RSVD2,		RSVD3,		0x1160,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(hdmi_cec_pbb0,		HDMI_CEC,	RSVD1,			RSVD2,		RSVD3,		0x1060,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(spi2_sck_pcc0,		SPI2_SCK,	RSVD1,			RSVD2,		RSVD3,		0x10b0,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(spi2_miso_pcc1,	SPI2_DIN,	RSVD1,			RSVD2,		RSVD3,		0x10b8,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(spi2_mosi_pcc2,	SPI2_DOUT,	RSVD1,			RSVD2,		RSVD3,		0x1090,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(spi2_cs0_pcc3,		SPI2_CS0,	RSVD1,			RSVD2,		RSVD3,		0x10a0,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(spi2_cs1_pcc4,		SPI2_CS1,	RSVD1,			RSVD2,		RSVD3,		0x11c8,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart3_tx_pcc5,		UARTC_TXD,	RSVD1,			RSVD2,		RSVD3,		0x1078,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart3_rx_pcc6,		UARTC_RXD,	RSVD1,			RSVD2,		RSVD3,		0x1070,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(gen2_i2c_scl_pcc7,	I2C2_CLK,	RSVD1,			RSVD2,		RSVD3,		0x1098,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(gen2_i2c_sda_pdd0,	I2C2_DAT,	RSVD1,			RSVD2,		RSVD3,		0x10a8,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(gen8_i2c_scl_pdd1,	I2C8_CLK,	RSVD1,			RSVD2,		RSVD3,		0x1088,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(gen8_i2c_sda_pdd2,	I2C8_DAT,	RSVD1,			RSVD2,		RSVD3,		0x1080,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(touch_clk_pdd3,	GP_PWM4,	TOUCH_CLK,		RSVD2,		RSVD3,		0x1068,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(dmic1_clk_pdd4,	DMIC1_CLK,	RSVD1,			DMIC5_CLK,	RSVD3,		0x11d0,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(dmic1_dat_pdd5,	DMIC1_DAT,	RSVD1,			DMIC5_DAT,	RSVD3,		0x11d8,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio19_pdd6,	RSVD0,		WDT_RESET_OUTB,		RSVD2,		RSVD3,		0x10f8,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio49_pee2,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10c0,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio50_pee4,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10c8,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio82_pee3,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x10d0,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio71_pff2,	PPC_MODE_1,	RSVD1,			RSVD2,		RSVD3,		0x10d8,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio76_pff7,	RSVD0,		RSVD1,			TSC_EDGE_OUT0,	TSC_EDGE_OUT0A,	0x10e0,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio74_pff5,	PPC_READY,	PPC_I2C_DAT,		RSVD2,		RSVD3,		0x10e8,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio86_phh3,	RSVD0,		SPI5_CS1,		TSC_EDGE_OUT3,	TSC_EDGE_OUT0D,	0x1100,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio72_pff3,	PPC_MODE_2,	RSVD1,			RSVD2,		RSVD3,		0x1108,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio77_pgg0,	RSVD0,		RSVD1,			TSC_EDGE_OUT1,	TSC_EDGE_OUT0B,	0x1110,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio80_pff6,	RSVD0,		PPC_RST_N,		RSVD2,		RSVD3,		0x1118,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio84_pgg1,	RSVD0,		RSVD1,			TSC_EDGE_OUT2,	TSC_EDGE_OUT0C,	0x1120,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio83_pee5,	RSVD0,		RSVD1,			RSVD2,		RSVD3,		0x1128,		0,	Y,	-1,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio73_pff4,	PPC_CC,		PPC_I2C_CLK,		RSVD2,		RSVD3,		0x1130,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio70_pff1,	PPC_MODE_0,	RSVD1,			RSVD2,		RSVD3,		0x1138,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio85_pgg6,	RSVD0,		SPI4_CS1,		RSVD2,		RSVD3,		0x1148,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(soc_gpio69_pff0,	PPC_INT_N,	RSVD1,			RSVD2,		RSVD3,		0x1150,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart5_tx_pgg7,		UARTE_TXD,	SPI5_SCK,		RSVD2,		RSVD3,		0x1168,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart5_rx_phh0,		UARTE_RXD,	SPI5_MISO,		RSVD2,		RSVD3,		0x1170,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart2_tx_pgg2,		UARTB_TXD,	SPI4_SCK,		RSVD2,		RSVD3,		0x1178,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart2_rx_pgg3,		UARTB_RXD,	SPI4_MISO,		RSVD2,		RSVD3,		0x1180,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart2_cts_pgg5,	UARTB_CTS,	SPI4_CS0,		RSVD2,		RSVD3,		0x1188,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart2_rts_pgg4,	UARTB_RTS,	SPI4_MOSI,		RSVD2,		RSVD3,		0x1190,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart5_cts_phh2,	UARTE_CTS,	SPI5_CS0,		RSVD2,		RSVD3,		0x1198,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(uart5_rts_phh1,	UARTE_RTS,	SPI5_MOSI,		RSVD2,		RSVD3,		0x11a0,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(pwm2_pdd7,		GP_PWM2,	LED_BLINK,		RSVD2,		RSVD3,		0x11b0,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(pwm3_pee0,		GP_PWM3,	RSVD1,			RSVD2,		RSVD3,		0x11b8,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
+	PINGROUP(pwm7_pee1,		GP_PWM7,	RSVD1,			RSVD2,		RSVD3,		0x11a8,		0,	Y,	5,	7,	6,	8,	-1,	10,	12),
 };
 
 static const struct tegra_pinctrl_soc_data tegra238_pinctrl_aon = {
-- 
2.53.0



