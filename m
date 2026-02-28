Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BADE35AC39
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302756; cv=none; b=Oo1QHECEajd+N44JyreF4l6UJnBLLYnmgl1AtnK6TTxJ6joSzviz+M+xkLohXce2xq4zbAHi3FAvOSkH2k3nPtJl3oCqe//EApeCDYMq3y4/BuBnVwDbiyEHG0DSoBSpJ3hxptwaGvutuJdGrrN5KiGmQ9Tq3MtgEBamdV0/X18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302756; c=relaxed/simple;
	bh=I6OtY2Wuoq6UZpd+Un9Iabyqr8b2reT2PW8V3DK2Crk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8FThMlWCd7OjaMxPHAaEh6dCufPed0HiHsjSr+UxNwzTg/vVc8CXNrdtR71yqr3S8zOUKgtZgpwBX3k2ObIPdpm6kwp0HpGkd78pGSDoljuCdj1ytKZc4ePgbfXP2eccgDIfSwqQibv5idMy3D7YLaUCnYVyhHyIqu/w1gh0Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SA7gzBpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SA7gzBpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92657C19423;
	Sat, 28 Feb 2026 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302756;
	bh=I6OtY2Wuoq6UZpd+Un9Iabyqr8b2reT2PW8V3DK2Crk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SA7gzBpCctRvs9oprUw9wUOMhnilNGMfGDbcM5UvUprYnHD2au2cAl8I3Wp2tcwrl
	 VFLnnzDZor5Dtxu+X34vsR+LXWLI497QWpMkRDWbZ6mHEZZQ9hWun3DhmFevLCngxD
	 VGSKguV55bF+f00b2jCoLazK1X2bp8czcZT1SkodR/bSdjKNcG6XQrbP1EcWPTkEAS
	 sCWOLniA73Vl7rkzD6lAE2ht3eCqbsAvEelNZH9+6yjk/cNyUmVQm3XFuPz9U2P0PO
	 0YTwPS3Cxe54qfRc1khK6wfpwnK9STErDQOAa48JAfd6VUJFcJ7vxduMsGuKig/LkL
	 hqc9oQkmALcBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Rui Feng <rui_feng@realsil.com.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/147] misc: rtsx: Add SD Express mode support for RTS5261
Date: Sat, 28 Feb 2026 13:17:13 -0500
Message-ID: <20260228181736.1605592-125-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Rui Feng <rui_feng@realsil.com.cn>

[ Upstream commit 5afe802132f242f5520d2acac09ea05d31e3c7cf ]

RTS5261 support SD mode and PCIe/NVMe mode. The workflow is as follows.
1.RTS5261 work in SD mode and set MMC_CAPS2_SD_EXP flag.
2.If card is plugged in, Host send CMD8 to ask card's PCIe availability.
3.If the card has PCIe availability and WP is not set, init_sd_express() will be invoked,
RTS5261 switch to PCIe/NVMe mode.
4.Mmc driver handover it to NVMe driver.
5.If card is unplugged, RTS5261 will switch to SD mode.

Signed-off-by: Rui Feng <rui_feng@realsil.com.cn>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/1603936668-3363-1-git-send-email-rui_feng@realsil.com.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: aced969e9bf3 ("mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rts5261.c  |  4 ++++
 drivers/misc/cardreader/rts5261.h  | 23 -----------------------
 drivers/misc/cardreader/rtsx_pcr.c |  5 +++++
 include/linux/rtsx_pci.h           | 23 +++++++++++++++++++++++
 4 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/cardreader/rts5261.c b/drivers/misc/cardreader/rts5261.c
index 471961487ff8f..536c90d4fd763 100644
--- a/drivers/misc/cardreader/rts5261.c
+++ b/drivers/misc/cardreader/rts5261.c
@@ -738,8 +738,12 @@ void rts5261_init_params(struct rtsx_pcr *pcr)
 {
 	struct rtsx_cr_option *option = &pcr->option;
 	struct rtsx_hw_param *hw_param = &pcr->hw_param;
+	u8 val;
 
 	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
+	rtsx_pci_read_register(pcr, RTS5261_FW_STATUS, &val);
+	if (!(val & RTS5261_EXPRESS_LINK_FAIL_MASK))
+		pcr->extra_caps |= EXTRA_CAPS_SD_EXPRESS;
 	pcr->num_slots = 1;
 	pcr->ops = &rts5261_pcr_ops;
 
diff --git a/drivers/misc/cardreader/rts5261.h b/drivers/misc/cardreader/rts5261.h
index ebfdd236a553e..8d80f0d5d5d63 100644
--- a/drivers/misc/cardreader/rts5261.h
+++ b/drivers/misc/cardreader/rts5261.h
@@ -65,23 +65,6 @@
 #define RTS5261_FW_EXPRESS_TEST_MASK	(0x01<<0)
 #define RTS5261_FW_EA_MODE_MASK		(0x01<<5)
 
-/* FW config register */
-#define RTS5261_FW_CFG0			0xFF54
-#define RTS5261_FW_ENTER_EXPRESS	(0x01<<0)
-
-#define RTS5261_FW_CFG1			0xFF55
-#define RTS5261_SYS_CLK_SEL_MCU_CLK	(0x01<<7)
-#define RTS5261_CRC_CLK_SEL_MCU_CLK	(0x01<<6)
-#define RTS5261_FAKE_MCU_CLOCK_GATING	(0x01<<5)
-/*MCU_bus_mode_sel: 0=real 8051 1=fake mcu*/
-#define RTS5261_MCU_BUS_SEL_MASK	(0x01<<4)
-/*MCU_clock_sel:VerA 00=aux16M 01=aux400K 1x=REFCLK100M*/
-/*MCU_clock_sel:VerB 00=aux400K 01=aux16M 10=REFCLK100M*/
-#define RTS5261_MCU_CLOCK_SEL_MASK	(0x03<<2)
-#define RTS5261_MCU_CLOCK_SEL_16M	(0x01<<2)
-#define RTS5261_MCU_CLOCK_GATING	(0x01<<1)
-#define RTS5261_DRIVER_ENABLE_FW	(0x01<<0)
-
 /* FW status register */
 #define RTS5261_FW_STATUS		0xFF56
 #define RTS5261_EXPRESS_LINK_FAIL_MASK	(0x01<<7)
@@ -121,12 +104,6 @@
 #define RTS5261_DV3318_19		(0x04<<4)
 #define RTS5261_DV3318_33		(0x07<<4)
 
-#define RTS5261_LDO1_CFG0		0xFF72
-#define RTS5261_LDO1_OCP_THD_MASK	(0x07<<5)
-#define RTS5261_LDO1_OCP_EN		(0x01<<4)
-#define RTS5261_LDO1_OCP_LMT_THD_MASK	(0x03<<2)
-#define RTS5261_LDO1_OCP_LMT_EN		(0x01<<1)
-
 /* CRD6603-433 190319 request changed */
 #define RTS5261_LDO1_OCP_THD_740	(0x00<<5)
 #define RTS5261_LDO1_OCP_THD_800	(0x01<<5)
diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 358b000b3a552..4c57ecb2be404 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -990,6 +990,11 @@ static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
 		} else {
 			pcr->card_removed |= SD_EXIST;
 			pcr->card_inserted &= ~SD_EXIST;
+			if (PCI_PID(pcr) == PID_5261) {
+				rtsx_pci_write_register(pcr, RTS5261_FW_STATUS,
+					RTS5261_EXPRESS_LINK_FAIL_MASK, 0);
+				pcr->extra_caps |= EXTRA_CAPS_SD_EXPRESS;
+			}
 		}
 		pcr->dma_error_count = 0;
 	}
diff --git a/include/linux/rtsx_pci.h b/include/linux/rtsx_pci.h
index 745f5e73f99ac..b47959f48ccd4 100644
--- a/include/linux/rtsx_pci.h
+++ b/include/linux/rtsx_pci.h
@@ -658,6 +658,19 @@
 #define   PM_WAKE_EN			0x01
 #define PM_CTRL4			0xFF47
 
+#define RTS5261_FW_CFG0			0xFF54
+#define   RTS5261_FW_ENTER_EXPRESS	(0x01 << 0)
+
+#define RTS5261_FW_CFG1			0xFF55
+#define   RTS5261_SYS_CLK_SEL_MCU_CLK	(0x01 << 7)
+#define   RTS5261_CRC_CLK_SEL_MCU_CLK	(0x01 << 6)
+#define   RTS5261_FAKE_MCU_CLOCK_GATING	(0x01 << 5)
+#define   RTS5261_MCU_BUS_SEL_MASK	(0x01 << 4)
+#define   RTS5261_MCU_CLOCK_SEL_MASK	(0x03 << 2)
+#define   RTS5261_MCU_CLOCK_SEL_16M	(0x01 << 2)
+#define   RTS5261_MCU_CLOCK_GATING	(0x01 << 1)
+#define   RTS5261_DRIVER_ENABLE_FW	(0x01 << 0)
+
 #define REG_CFG_OOBS_OFF_TIMER 0xFEA6
 #define REG_CFG_OOBS_ON_TIMER 0xFEA7
 #define REG_CFG_VCM_ON_TIMER 0xFEA8
@@ -701,6 +714,13 @@
 #define   RTS5260_DVCC_TUNE_MASK	0x70
 #define   RTS5260_DVCC_33		0x70
 
+/*RTS5261*/
+#define RTS5261_LDO1_CFG0		0xFF72
+#define   RTS5261_LDO1_OCP_THD_MASK	(0x07 << 5)
+#define   RTS5261_LDO1_OCP_EN		(0x01 << 4)
+#define   RTS5261_LDO1_OCP_LMT_THD_MASK	(0x03 << 2)
+#define   RTS5261_LDO1_OCP_LMT_EN	(0x01 << 1)
+
 #define LDO_VCC_CFG1			0xFF73
 #define   LDO_VCC_REF_TUNE_MASK		0x30
 #define   LDO_VCC_REF_1V2		0x20
@@ -741,6 +761,8 @@
 
 #define RTS5260_AUTOLOAD_CFG4		0xFF7F
 #define   RTS5260_MIMO_DISABLE		0x8A
+/*RTS5261*/
+#define   RTS5261_AUX_CLK_16M_EN		(1 << 5)
 
 #define RTS5260_REG_GPIO_CTL0		0xFC1A
 #define   RTS5260_REG_GPIO_MASK		0x01
@@ -1191,6 +1213,7 @@ struct rtsx_pcr {
 #define EXTRA_CAPS_MMC_HS200		(1 << 4)
 #define EXTRA_CAPS_MMC_8BIT		(1 << 5)
 #define EXTRA_CAPS_NO_MMC		(1 << 7)
+#define EXTRA_CAPS_SD_EXPRESS		(1 << 8)
 	u32				extra_caps;
 
 #define IC_VER_A			0
-- 
2.51.0

