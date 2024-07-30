Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E639D183CBF;
	Tue, 30 Jul 2024 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355535; cv=none; b=SwZRn9WUuAZuKrO4ZyRO9GOtCGSmXKTnVMuq1TZM+H4nSauQT1lTum37Q6sIJ51i2QA2LtN3JdcNVGXwDCm5SxWenq55FaYNLlUYBuhXcOhNJtlF+bAohTmOEIT6VIvniVtFPsqH/2DvWu5zqtXDk+lOSgdpNKA3FolKOJALyL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355535; c=relaxed/simple;
	bh=co+zsGQpn/n9/tbMIvCFVJoKTiWwcjJUR6bMUQV71WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1NY0hRYn3UA/Fp5bCzZLaO8XwmYTZlNyUz56yQlZf6eQBRX55J0eWzGDMSWv9jIoMMOKiyrxE7r0fYtUWIIMoljn+iK32suVCaixJ28Xxlz7vi+J19bDj15NPP5eKq7BHCTOiAJZXKvVEdNnIOrM2+plzznGOp6n6nh2PD2kTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cS8uFwBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cS8uFwBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41637C4AF0E;
	Tue, 30 Jul 2024 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355534;
	bh=co+zsGQpn/n9/tbMIvCFVJoKTiWwcjJUR6bMUQV71WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cS8uFwBrbtgt2Z3PYKua5xY01J4zKoIniZJAOZTi6Lk7kWkBFvaFlTfkPKESlHwxv
	 p+TU1uwzQ3U0Dbkuu8HjH2Yk9+nyOigTc/e553ZJm5ggikP9cqpHfPMW9dJ+F0uRRc
	 HM+M4PwmXPC3jlkdl4MBEZmes/NCpXQmYB0nyGcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/440] net: fec: Refactor: #define magic constants
Date: Tue, 30 Jul 2024 17:45:36 +0200
Message-ID: <20240730151619.911694856@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás Bence <csokas.bence@prolan.hu>

[ Upstream commit ff049886671ccd4e624a30ec464cb20e4c39a313 ]

Add defines for bits of ECR, RCR control registers, TX watermark etc.

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240212153717.10023-1-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c32fe1986f27 ("net: fec: Fix FEC_ECR_EN1588 being cleared on link-down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 46 +++++++++++++++--------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 0a3df468316e5..ef70290beaeb0 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -267,8 +267,8 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define PKT_MINBUF_SIZE		64
 
 /* FEC receive acceleration */
-#define FEC_RACC_IPDIS		(1 << 1)
-#define FEC_RACC_PRODIS		(1 << 2)
+#define FEC_RACC_IPDIS		BIT(1)
+#define FEC_RACC_PRODIS		BIT(2)
 #define FEC_RACC_SHIFT16	BIT(7)
 #define FEC_RACC_OPTIONS	(FEC_RACC_IPDIS | FEC_RACC_PRODIS)
 
@@ -300,8 +300,23 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define FEC_MMFR_TA		(2 << 16)
 #define FEC_MMFR_DATA(v)	(v & 0xffff)
 /* FEC ECR bits definition */
-#define FEC_ECR_MAGICEN		(1 << 2)
-#define FEC_ECR_SLEEP		(1 << 3)
+#define FEC_ECR_RESET           BIT(0)
+#define FEC_ECR_ETHEREN         BIT(1)
+#define FEC_ECR_MAGICEN         BIT(2)
+#define FEC_ECR_SLEEP           BIT(3)
+#define FEC_ECR_EN1588          BIT(4)
+#define FEC_ECR_BYTESWP         BIT(8)
+/* FEC RCR bits definition */
+#define FEC_RCR_LOOP            BIT(0)
+#define FEC_RCR_HALFDPX         BIT(1)
+#define FEC_RCR_MII             BIT(2)
+#define FEC_RCR_PROMISC         BIT(3)
+#define FEC_RCR_BC_REJ          BIT(4)
+#define FEC_RCR_FLOWCTL         BIT(5)
+#define FEC_RCR_RMII            BIT(8)
+#define FEC_RCR_10BASET         BIT(9)
+/* TX WMARK bits */
+#define FEC_TXWMRK_STRFWD       BIT(8)
 
 #define FEC_MII_TIMEOUT		30000 /* us */
 
@@ -1038,7 +1053,7 @@ fec_restart(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	u32 temp_mac[2];
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
-	u32 ecntl = 0x2; /* ETHEREN */
+	u32 ecntl = FEC_ECR_ETHEREN;
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
@@ -1116,18 +1131,18 @@ fec_restart(struct net_device *ndev)
 		    fep->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID)
 			rcntl |= (1 << 6);
 		else if (fep->phy_interface == PHY_INTERFACE_MODE_RMII)
-			rcntl |= (1 << 8);
+			rcntl |= FEC_RCR_RMII;
 		else
-			rcntl &= ~(1 << 8);
+			rcntl &= ~FEC_RCR_RMII;
 
 		/* 1G, 100M or 10M */
 		if (ndev->phydev) {
 			if (ndev->phydev->speed == SPEED_1000)
 				ecntl |= (1 << 5);
 			else if (ndev->phydev->speed == SPEED_100)
-				rcntl &= ~(1 << 9);
+				rcntl &= ~FEC_RCR_10BASET;
 			else
-				rcntl |= (1 << 9);
+				rcntl |= FEC_RCR_10BASET;
 		}
 	} else {
 #ifdef FEC_MIIGSK_ENR
@@ -1186,13 +1201,13 @@ fec_restart(struct net_device *ndev)
 
 	if (fep->quirks & FEC_QUIRK_ENET_MAC) {
 		/* enable ENET endian swap */
-		ecntl |= (1 << 8);
+		ecntl |= FEC_ECR_BYTESWP;
 		/* enable ENET store and forward mode */
-		writel(1 << 8, fep->hwp + FEC_X_WMRK);
+		writel(FEC_TXWMRK_STRFWD, fep->hwp + FEC_X_WMRK);
 	}
 
 	if (fep->bufdesc_ex)
-		ecntl |= (1 << 4);
+		ecntl |= FEC_ECR_EN1588;
 
 	if (fep->quirks & FEC_QUIRK_DELAYED_CLKS_SUPPORT &&
 	    fep->rgmii_txc_dly)
@@ -1291,7 +1306,7 @@ static void
 fec_stop(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
+	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & FEC_RCR_RMII;
 	u32 val;
 
 	/* We cannot expect a graceful transmit stop without link !!! */
@@ -1310,7 +1325,7 @@ fec_stop(struct net_device *ndev)
 		if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 			writel(0, fep->hwp + FEC_ECNTRL);
 		} else {
-			writel(1, fep->hwp + FEC_ECNTRL);
+			writel(FEC_ECR_RESET, fep->hwp + FEC_ECNTRL);
 			udelay(10);
 		}
 	} else {
@@ -1324,12 +1339,11 @@ fec_stop(struct net_device *ndev)
 	/* We have to keep ENET enabled to have MII interrupt stay working */
 	if (fep->quirks & FEC_QUIRK_ENET_MAC &&
 		!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		writel(2, fep->hwp + FEC_ECNTRL);
+		writel(FEC_ECR_ETHEREN, fep->hwp + FEC_ECNTRL);
 		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
 	}
 }
 
-
 static void
 fec_timeout(struct net_device *ndev, unsigned int txqueue)
 {
-- 
2.43.0



