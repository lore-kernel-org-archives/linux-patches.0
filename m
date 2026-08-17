Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A173D5C07;
	Mon, 17 Aug 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980204; cv=none; b=QYw54/3djQbadP71BM/hOX7YNiNEmvieY2bTlQnsCAGtI/R9hRAEoAdIlY/zdyimb1vVyw6l1iDN7oLA0bvUR1TbRaah8RDT6OOEiTabzHy91JU+B/R6nI2BuzNaTDUCYSySMGdq8jxBtLgSyA7Y8Lh8mf6512aS2hbKEHnrr6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980204; c=relaxed/simple;
	bh=BI8vgkXAH8wOC9xgsXePpgvJuD2e03WmVWE439FTiHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He9tAU06MMupWKlDgcP4+Wrcs29nk5jVDXEjIir6pgvD+q5uhIhzPXSSfT3+3afzypzmgDV2r+Mp5JmEbw2QVvI1865xRkf53fgjcbqvCzroaNOWFqIFCX0qh60QQUQs4/Pfi321xUJt251hD7hjJ8mqZvlcdgx1keZQYxvqpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4K0w4iT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4K0w4iT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384031F000E9;
	Mon, 17 Aug 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980202;
	bh=jj1V8VXctL+mxzhjTnHvBtsr6Z+I/8NZfQ3K7tam0Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4K0w4iTihhce/WYIQjGTot3M2kEAeRzS1FrCQ1kqRNRnA8uILLIU5USpuzW6NgXH
	 9ssXfACuEK5B9AA/jAUU+fN+O21ooUmdjx9+f9WvwwzMQMbuGTah/xH4aJUtif6vAO
	 h/rPEh/6tZJ+T5AGVOGzr6QIdaJENLBfpPa0SuNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 442/609] phy: zynqmp: keep SERDES scrambler and 8b/10b enabled for USB
Date: Mon, 17 Aug 2026 15:32:18 +0200
Message-ID: <20260817132558.880345536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nava kishore Manne <nava.kishore.manne@amd.com>

commit 7eb61caf45607e1e1270f51f8f93f0ded53146da upstream.

USB Gen1 requires scrambling and 8b/10b encoding to be performed in the
physical layer. Do not bypass PHY-side scrambler or encoder/decoder for
USB operation, as mandated by the USB 3.x specification.

Scrambler and 8b/10b bypass remain restricted to SATA and SGMII
modes, where encoding is handled in the controller.

Fixes: 4a33bea00314 ("phy: zynqmp: Add PHY driver for the Xilinx ZynqMP Gigabit Transceiver")
Cc: stable@vger.kernel.org
Signed-off-by: Nava kishore Manne <nava.kishore.manne@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260627155229.2791113-4-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/xilinx/phy-zynqmp.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -488,15 +488,30 @@ static void xpsgtr_lane_set_protocol(str
 	}
 }
 
-/* Bypass (de)scrambler and 8b/10b decoder and encoder. */
-static void xpsgtr_bypass_scrambler_8b10b(struct xpsgtr_phy *gtr_phy)
+/**
+ * xpsgtr_bypass_scrambler_8b10b - Configure scrambler/encoder behavior
+ * @gtr_phy: pointer to lane context
+ * @bypass: true to enable scrambler/encoder bypass (SATA/SGMII),
+ *          false to disable scrambler/encoder bypass (USB3)
+ *
+ * Uses RMW to preserve reserved and unrelated register fields.
+ */
+static void xpsgtr_bypass_scrambler_8b10b(struct xpsgtr_phy *gtr_phy,
+					  bool bypass)
 {
-	xpsgtr_clr_set_phy(gtr_phy, L0_TM_DIG_6,
-			   L0_TM_DIS_DESCRAMBLE_DECODER,
-			   L0_TM_DIS_DESCRAMBLE_DECODER);
-	xpsgtr_clr_set_phy(gtr_phy, L0_TX_DIG_61,
-			   L0_TM_DISABLE_SCRAMBLE_ENCODER,
-			   L0_TM_DISABLE_SCRAMBLE_ENCODER);
+	if (bypass) {
+		xpsgtr_clr_set_phy(gtr_phy, L0_TM_DIG_6,
+				   L0_TM_DIS_DESCRAMBLE_DECODER,
+				   L0_TM_DIS_DESCRAMBLE_DECODER);
+		xpsgtr_clr_set_phy(gtr_phy, L0_TX_DIG_61,
+				   L0_TM_DISABLE_SCRAMBLE_ENCODER,
+				   L0_TM_DISABLE_SCRAMBLE_ENCODER);
+	} else {
+		xpsgtr_clr_set_phy(gtr_phy, L0_TM_DIG_6,
+				   L0_TM_DIS_DESCRAMBLE_DECODER, 0);
+		xpsgtr_clr_set_phy(gtr_phy, L0_TX_DIG_61,
+				   L0_TM_DISABLE_SCRAMBLE_ENCODER, 0);
+	}
 }
 
 /* DP-specific initialization. */
@@ -517,7 +532,7 @@ static void xpsgtr_phy_init_sata(struct
 {
 	struct xpsgtr_dev *gtr_dev = gtr_phy->dev;
 
-	xpsgtr_bypass_scrambler_8b10b(gtr_phy);
+	xpsgtr_bypass_scrambler_8b10b(gtr_phy, true);
 
 	writel(gtr_phy->lane, gtr_dev->siou + SATA_CONTROL_OFFSET);
 }
@@ -533,7 +548,7 @@ static void xpsgtr_phy_init_sgmii(struct
 	xpsgtr_clr_set(gtr_dev, TX_PROT_BUS_WIDTH, mask, val);
 	xpsgtr_clr_set(gtr_dev, RX_PROT_BUS_WIDTH, mask, val);
 
-	xpsgtr_bypass_scrambler_8b10b(gtr_phy);
+	xpsgtr_bypass_scrambler_8b10b(gtr_phy, true);
 }
 
 /* Configure TX de-emphasis and margining for DP. */
@@ -694,6 +709,10 @@ static int xpsgtr_phy_init(struct phy *p
 	case ICM_PROTOCOL_SGMII:
 		xpsgtr_phy_init_sgmii(gtr_phy);
 		break;
+
+	case ICM_PROTOCOL_USB:
+		xpsgtr_bypass_scrambler_8b10b(gtr_phy, false);
+		break;
 	}
 
 	goto out;


