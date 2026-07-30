Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581122D0602;
	Thu, 30 Jul 2026 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424131; cv=none; b=j2A4+wDn6dUAMJ+YdPu2Qol8zyuetYjG0U3/5VRHd0DpliJq+C9dwmScII3t4i+tb6o3LHseZ8bOhIYmlYQRGCYUtAi23q6ThCOHAd5YeDxQzHtcH56KiEuLuS2XvPvixOBt+4Ac85t2yrn/OVry3bYU/FIijs5GQKZXnmmH+38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424131; c=relaxed/simple;
	bh=UPgOSvtxFAL2Q3I2NxUh7tll1LF+Q6CjMbHSK1S4KPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hwv14hzgHrBk2sODj1mOfKyX2AeTLIw6Zmf2AsaS/LQ6Zn9v1OQED7+6zrXIB9Nsm/bzsJWnka2f4zp+sZFKBr3Q8IZFe8cMpkorerdDh1SDR71r4FOCdvd5UdJJh8U6Fa4Zrd03MGyXWD6+37mSX4BCD+CuV2SsAlxuEIQHopk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytrEqvlG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytrEqvlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7521F00A3A;
	Thu, 30 Jul 2026 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424130;
	bh=Ed/LAwyJflm8gb2zL+wXEBcO4Qbwm08FdbKdb61+Vdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytrEqvlG13JOeEjiAkjFMel8tBHhpgDzARpdEji/jkPaABeRSqDrulYxlI1YnE/N+
	 N2rITGBk41UGX40G31+6s39SVM8QPIBaPPf3DUMpDSZR11ic1lGQOS4S6i8Rl3QX4T
	 BWHIt/nah/mRgYaIFJpgbRg85zs8aCgUTIbaJe7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 286/675] net: stmmac: remove xstats.pcs_* members
Date: Thu, 30 Jul 2026 16:10:16 +0200
Message-ID: <20260730141451.203049887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 14f74bc6dc699f63b5a6dfa9b22229f0caea89f3 ]

As a result of the previous commit, the pcs_link, pcs_duplex and
pcs_speed members are not used outside of the interrupt handling code,
and are only used to print their status using the misleading "Link is"
messages that bear no relation to the actual status of the link.

Remove the printing of these messages, these members, and the code
that decodes them from the hardware.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/E1v9P63-0000000AolI-23Kf@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9fcf274d93af ("net: stmmac: xgmac: fix l4 filter port overwrite on register update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  3 --
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  | 28 +------------------
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 28 +------------------
 3 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index acd7719506b612..83929477b058b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -197,9 +197,6 @@ struct stmmac_extra_stats {
 	unsigned long irq_pcs_ane_n;
 	unsigned long irq_pcs_link_n;
 	unsigned long irq_rgmii_n;
-	unsigned long pcs_link;
-	unsigned long pcs_duplex;
-	unsigned long pcs_speed;
 	/* debug register */
 	unsigned long mtl_tx_status_fifo_full;
 	unsigned long mtl_tx_fifo_not_empty;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index fe776ddf688952..2c5ee59c320864 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -266,34 +266,8 @@ static void dwmac1000_pmt(struct mac_device_info *hw, unsigned long mode)
 /* RGMII or SMII interface */
 static void dwmac1000_rgsmii(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 {
-	u32 status;
-
-	status = readl(ioaddr + GMAC_RGSMIIIS);
+	readl(ioaddr + GMAC_RGSMIIIS);
 	x->irq_rgmii_n++;
-
-	/* Check the link status */
-	if (status & GMAC_RGSMIIIS_LNKSTS) {
-		int speed_value;
-
-		x->pcs_link = 1;
-
-		speed_value = ((status & GMAC_RGSMIIIS_SPEED) >>
-			       GMAC_RGSMIIIS_SPEED_SHIFT);
-		if (speed_value == GMAC_RGSMIIIS_SPEED_125)
-			x->pcs_speed = SPEED_1000;
-		else if (speed_value == GMAC_RGSMIIIS_SPEED_25)
-			x->pcs_speed = SPEED_100;
-		else
-			x->pcs_speed = SPEED_10;
-
-		x->pcs_duplex = (status & GMAC_RGSMIIIS_LNKMOD_MASK);
-
-		pr_info("Link is Up - %d/%s\n", (int)x->pcs_speed,
-			x->pcs_duplex ? "Full" : "Half");
-	} else {
-		x->pcs_link = 0;
-		pr_info("Link is Down\n");
-	}
 }
 
 static int dwmac1000_irq_status(struct mac_device_info *hw,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index d85bc0bb5c3c05..8a19df7b05775d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -592,34 +592,8 @@ static void dwmac4_ctrl_ane(struct stmmac_priv *priv, bool ane, bool srgmi_ral,
 /* RGMII or SMII interface */
 static void dwmac4_phystatus(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 {
-	u32 status;
-
-	status = readl(ioaddr + GMAC_PHYIF_CONTROL_STATUS);
+	readl(ioaddr + GMAC_PHYIF_CONTROL_STATUS);
 	x->irq_rgmii_n++;
-
-	/* Check the link status */
-	if (status & GMAC_PHYIF_CTRLSTATUS_LNKSTS) {
-		int speed_value;
-
-		x->pcs_link = 1;
-
-		speed_value = ((status & GMAC_PHYIF_CTRLSTATUS_SPEED) >>
-			       GMAC_PHYIF_CTRLSTATUS_SPEED_SHIFT);
-		if (speed_value == GMAC_PHYIF_CTRLSTATUS_SPEED_125)
-			x->pcs_speed = SPEED_1000;
-		else if (speed_value == GMAC_PHYIF_CTRLSTATUS_SPEED_25)
-			x->pcs_speed = SPEED_100;
-		else
-			x->pcs_speed = SPEED_10;
-
-		x->pcs_duplex = (status & GMAC_PHYIF_CTRLSTATUS_LNKMOD);
-
-		pr_info("Link is Up - %d/%s\n", (int)x->pcs_speed,
-			x->pcs_duplex ? "Full" : "Half");
-	} else {
-		x->pcs_link = 0;
-		pr_info("Link is Down\n");
-	}
 }
 
 static int dwmac4_irq_mtl_status(struct stmmac_priv *priv,
-- 
2.53.0



