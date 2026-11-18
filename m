Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025401;
	b=5Q3+yBMqWsLZlLtCURE0Pegpvr9V7GDQVEmIUhfYkkfUm7sACKud2ZNYSmTCKxLExKsj
	 42zvaIsoWjfMfKj+r1dZcvVdwomWvNoFvnRuoMZJjhyCmFqfhdULrvZeG9/6nW/ygqMmB
	 Qf31NgOQpwgUXBim5Zr59Qog2eaFcujNbCKO+OGBmihIk/27a4hA1B+keUXJt3ZMJPVtQ
	 WpQz4d+ffO42hxx4iXC37yLiCD5x3AQCXP6zSL2VOVhGvd5svYDgD7Oa4Yq42+EwTTcqt
	 +IC4ades9fdVhtgasyyUCsCHzYNsdkRIQHNlmfFrkNVltRWUfl6i/0vRpKM10I179wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZKSRg9l14BqfrbGU329M6xJNJ2fNyuKQnQ4LYXuWZgw=;
	b=BaA3Xg+FeM++FxKD3us2+IcNRcH0VWgNs2q7FLz/VN89OlGadThW8KMmUYgZKAquH/W2
	 /mfwmnChxPqvHXOHw6Dj6gyl5Xf2NZSNfPFBcV1oWtGaz768usWDoP1VQQD3W6VEVXr/y
	 c56ienIskk5FW/i+UaWe5sTPrg3VuP1l9uy2aRujTyFT0mMMiyWPdOMIhWassSWb37gpZ
	 IMsJTLE77JI5mjqh/0vovoFcCvYWpnB50XDCtBRpWfuWDUlMR632TmbtcSuxNcWpIoyUH
	 711usFljFmKhfmQ9vHlGNj1Tj6yYXXAKjdG6Ajnd6bycIFVDGPKTmU8rmeJ8gs4W4rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OK6P9CrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7D8606A31C;
	Wed, 18 Nov 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OK6P9CrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1531F000C4;
	Wed, 18 Nov 2026 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025401;
	bh=ZKSRg9l14BqfrbGU329M6xJNJ2fNyuKQnQ4LYXuWZgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OK6P9CrRcmTb+YbrvNJSSYTmVcnF4AbCXI2hU7UJrrZLWpESbVqTdIedHFC4TlfL5
	 APMpbV2PwdpOTxIhLwzdUQtlTQ5YUP9cYujrpXka5aRsW+opn+iE3M5eZGX7qlK57Z
	 dTDn021yUXMSZDOwZXBIzn9HS75z5iNgR3BCjY5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1025/2151] phy: rockchip: naneng-combphy: Fix TX detect RX termination errata
Date: Wed, 18 Nov 2026 15:46:00 +0100
Message-ID: <20261118150159.731485465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit d68e47a06c5cdc90cbd29ce2e74fa61eab5d47cc ]

Some PHY revisions may fail to detect the peer RX's termination
resistor (RTERM) under certain critical temperature conditions.
This causes TX detection failures on PCIe links.

Add a workaround to force the RTERM detection ready signal for
affected PHY revisions. This ensures reliable TX-to-RX termination
detection across all operating temperature ranges.

The fix applies to RK3562, RK3568, RK3576 and RK3588 SoCs which share
the same PHY IP with this hardware errata.

Fixes: 7160820d742a ("phy: rockchip: add naneng combo phy for RK3568")
Fixes: f13bff25161b ("phy: rockchip-naneng-combo: Support rk3562")
Fixes: ba8ad7eece66 ("phy: rockchip-naneng-combo: add rk3576 support")
Fixes: a03c44277253 ("phy: rockchip: Add naneng combo phy support for RK3588")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/1788158204-161347-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../rockchip/phy-rockchip-naneng-combphy.c    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index 7f8fc8e6d4890..2b4d5550a311c 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -106,6 +106,9 @@
 #define RK3568_PHYREG18				0x44
 #define RK3568_PHYREG18_PLL_LOOP		0x32
 
+#define RK3568_PHYREG26				0x64
+#define RK3568_PHYREG26_FORCE_RTERM_DET_RDY	BIT(5)
+
 #define RK3568_PHYREG30				0x74
 #define RK3568_PHYREG30_GATE_TX_PCK_SEL         BIT(7)
 #define RK3568_PHYREG30_GATE_TX_PCK_DLY_PLL_OFF BIT(7)
@@ -193,6 +196,7 @@ struct rockchip_combphy_cfg {
 	unsigned int num_phys;
 	unsigned int phy_ids[3];
 	const struct rockchip_combphy_grfcfg *grfcfg;
+	bool force_rxterm_det_rdy;
 	int (*combphy_cfg)(struct rockchip_combphy_priv *priv);
 };
 
@@ -264,6 +268,17 @@ static int rockchip_combphy_init(struct phy *phy)
 
 	switch (priv->type) {
 	case PHY_TYPE_PCIE:
+		/*
+		 * Hardware Errata: TX fails to detect peer RX termination.
+		 * Some PHY revisions may fail to detect remote RX's RTERM
+		 * (receiver termination resistor) under certain critical
+		 * temperature conditions. Set force rterm detect ready to
+		 * fix it.
+		 */
+		if (priv->cfg->force_rxterm_det_rdy)
+			rockchip_combphy_updatel(priv, RK3568_PHYREG26_FORCE_RTERM_DET_RDY,
+					RK3568_PHYREG26_FORCE_RTERM_DET_RDY, RK3568_PHYREG26);
+		fallthrough;
 	case PHY_TYPE_USB3:
 	case PHY_TYPE_SATA:
 	case PHY_TYPE_SGMII:
@@ -747,6 +762,7 @@ static const struct rockchip_combphy_cfg rk3562_combphy_cfgs = {
 	},
 	.grfcfg		= &rk3562_combphy_grfcfgs,
 	.combphy_cfg	= rk3562_combphy_cfg,
+	.force_rxterm_det_rdy  = true,
 };
 
 static int rk3568_combphy_cfg(struct rockchip_combphy_priv *priv)
@@ -964,6 +980,7 @@ static const struct rockchip_combphy_cfg rk3568_combphy_cfgs = {
 	},
 	.grfcfg		= &rk3568_combphy_grfcfgs,
 	.combphy_cfg	= rk3568_combphy_cfg,
+	.force_rxterm_det_rdy  = true,
 };
 
 static int rk3576_combphy_cfg(struct rockchip_combphy_priv *priv)
@@ -1233,6 +1250,7 @@ static const struct rockchip_combphy_cfg rk3576_combphy_cfgs = {
 	},
 	.grfcfg		= &rk3576_combphy_grfcfgs,
 	.combphy_cfg	= rk3576_combphy_cfg,
+	.force_rxterm_det_rdy  = true,
 };
 
 static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
@@ -1420,6 +1438,7 @@ static const struct rockchip_combphy_cfg rk3588_combphy_cfgs = {
 	},
 	.grfcfg		= &rk3588_combphy_grfcfgs,
 	.combphy_cfg	= rk3588_combphy_cfg,
+	.force_rxterm_det_rdy  = true,
 };
 
 static const struct of_device_id rockchip_combphy_of_match[] = {
-- 
2.53.0



