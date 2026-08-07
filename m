Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53E2374E7F;
	Fri,  7 Aug 2026 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117531; cv=none; b=GQVgkMOShyOGz+C7GSyVZlm6ZcghBPCEG5sMsYADVEWthY4xOiXStTlIl2WVnjK600YGzFPBVGxM1XC8aC2QTEokBw0gwOlEOiD1q54xPoUrsuibLKEFbKQRYrqq5V323LvhQ5RotMyBXQyILAv2T+3qc5VJrsY0zCzDZKIw8kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117531; c=relaxed/simple;
	bh=z2l10DgiNFcN/l7ZqACA9SKN6LGX2TPMQFrhuq718Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=forJfEB6Jd/y7lBh6b482ZdT45O9ruE766OVtBC2VqvcTImVS+ZXwSkIjmOq/3sO/JKr+Qg3cIzf9Puscb7bvl6nr3+quCUCq6+aJsnF6Vjz+lgxNCyDrToVDbl4bfPwlU28d6/kUImDqaQOFdQKcBHipeY0PoMFshnFlEQGcS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0axXEs1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0axXEs1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058721F000E9;
	Fri,  7 Aug 2026 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117529;
	bh=iEWrwaVViG8RpdSMEni/BXL/QyY8xVW8rbp/Yz45mrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0axXEs1k/8P2Si+J9JCCZafoqs88vSTegEBagtX1zS8dMZeAyk03tKEm+Tkt5/sy0
	 BAKFBkL+xzml5fUJ1N2aRKoGFdaeayp8pEqa6GfpUFmwCuLW8YiJ9Ji/TkW8RFWPKi
	 bVAi2IP1hw+xTdX5V5+M/sAmZMWGtkj+MKtbGXhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.1 349/438] phy: zynqmp: keep SERDES scrambler and 8b/10b enabled for USB
Date: Fri,  7 Aug 2026 16:39:05 +0200
Message-ID: <20260807143435.413030099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -502,15 +502,30 @@ static void xpsgtr_lane_set_protocol(str
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
@@ -531,7 +546,7 @@ static void xpsgtr_phy_init_sata(struct
 {
 	struct xpsgtr_dev *gtr_dev = gtr_phy->dev;
 
-	xpsgtr_bypass_scrambler_8b10b(gtr_phy);
+	xpsgtr_bypass_scrambler_8b10b(gtr_phy, true);
 
 	writel(gtr_phy->lane, gtr_dev->siou + SATA_CONTROL_OFFSET);
 }
@@ -547,7 +562,7 @@ static void xpsgtr_phy_init_sgmii(struct
 	xpsgtr_clr_set(gtr_dev, TX_PROT_BUS_WIDTH, mask, val);
 	xpsgtr_clr_set(gtr_dev, RX_PROT_BUS_WIDTH, mask, val);
 
-	xpsgtr_bypass_scrambler_8b10b(gtr_phy);
+	xpsgtr_bypass_scrambler_8b10b(gtr_phy, true);
 }
 
 /* Configure TX de-emphasis and margining for DP. */
@@ -708,6 +723,10 @@ static int xpsgtr_phy_init(struct phy *p
 	case ICM_PROTOCOL_SGMII:
 		xpsgtr_phy_init_sgmii(gtr_phy);
 		break;
+
+	case ICM_PROTOCOL_USB:
+		xpsgtr_bypass_scrambler_8b10b(gtr_phy, false);
+		break;
 	}
 
 	goto out;


