Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0231A171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D61C433D2;
	Mon, 22 May 2023 19:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784474;
	bh=eVObgVYGaBUCFFfzDGHorAtyuHFPD6PGbq0l1GO/YfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UB8X+l5LcaMta5barD6TEN+yNbVgM1KK1k7GClKwANg3T5CAnG30Zsq7cwc6ymxb4
	 pmKSZad1kJjjte5vevZHiYAFBqTVOVr2PkGQ9NhlYmNVnt02UvRQvVOJf0W9pwq5x0
	 nZ0ea9OmtbQeURzvg8IPHbrs3DpCooaA1oO42EVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Hector Martin <marcan@marcan.st>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 094/364] wifi: brcmfmac: pcie: Add IDs/properties for BCM4387
Date: Mon, 22 May 2023 20:06:39 +0100
Message-Id: <20230522190415.098269536@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 117ace4014cce3fb78b40eb8028bb0f4fc37dd6f ]

This chip is present on Apple M1 Pro/Max (t600x) platforms:

* maldives   (apple,j314s): MacBook Pro (14-inch, M1 Pro, 2021)
* maldives   (apple,j314c): MacBook Pro (14-inch, M1 Max, 2021)
* madagascar (apple,j316s): MacBook Pro (16-inch, M1 Pro, 2021)
* madagascar (apple,j316c): MacBook Pro (16-inch, M1 Max, 2021)

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230214092423.15175-7-marcan@marcan.st
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++++++
 .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 8073f31be27d9..9cdbd8d438439 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -737,6 +737,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 		return 0x170000;
 	case BRCM_CC_4378_CHIP_ID:
 		return 0x352000;
+	case BRCM_CC_4387_CHIP_ID:
+		return 0x740000;
 	default:
 		brcmf_err("unknown chip: %s\n", ci->pub.name);
 		break;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 2835ef4edb18f..d2dad5414f396 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -67,6 +67,7 @@ BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 BRCMF_FW_CLM_DEF(4377B3, "brcmfmac4377b3-pcie");
 BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
+BRCMF_FW_CLM_DEF(4387C2, "brcmfmac4387c2-pcie");
 
 /* firmware config files */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
@@ -101,6 +102,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 	BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* revision ID 4 */
 	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* revision ID 3 */
+	BRCMF_FW_ENTRY(BRCM_CC_4387_CHIP_ID, 0xFFFFFFFF, 4387C2), /* revision ID 7 */
 };
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		5000 /* msec */
@@ -2048,6 +2050,11 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
 		base = 0x1120;
 		words = 0x170;
 		break;
+	case BRCM_CC_4387_CHIP_ID:
+		coreid = BCMA_CORE_GCI;
+		base = 0x113c;
+		words = 0x170;
+		break;
 	default:
 		/* OTP not supported on this chip */
 		return 0;
@@ -2662,6 +2669,7 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_DEVICE_ID, CYW),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4377_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4378_DEVICE_ID, WCC),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4387_DEVICE_ID, WCC),
 
 	{ /* end: all zeroes */ }
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 896615f579522..44684bf1b9acc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -54,6 +54,7 @@
 #define BRCM_CC_4371_CHIP_ID		0x4371
 #define BRCM_CC_4377_CHIP_ID		0x4377
 #define BRCM_CC_4378_CHIP_ID		0x4378
+#define BRCM_CC_4387_CHIP_ID		0x4387
 #define CY_CC_4373_CHIP_ID		0x4373
 #define CY_CC_43012_CHIP_ID		43012
 #define CY_CC_43439_CHIP_ID		43439
@@ -95,6 +96,7 @@
 #define BRCM_PCIE_43596_DEVICE_ID	0x4415
 #define BRCM_PCIE_4377_DEVICE_ID	0x4488
 #define BRCM_PCIE_4378_DEVICE_ID	0x4425
+#define BRCM_PCIE_4387_DEVICE_ID	0x4433
 
 /* brcmsmac IDs */
 #define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
-- 
2.39.2



