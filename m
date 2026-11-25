Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625256;
	b=Oq/dp/kSuWRIhaSgv+tn7hO3XD1WIGs/M9fJy5UaIsj1cC5rEV8qw8fnYD2tTms01Anm
	 jcBnBCK4vD4sMT70j9CPAtfqpeGnE6tpFR5snA0oC6FRICsE1zH1mrnS78Bvbdow2t/ou
	 saU35BnYNEHFXf9X0730d7pdceHuzv9MSpRfVNvu7QsFOfZfQwiPe71ofeGCgE6xmQNiV
	 7Y+NEYJs4WMh+CTaUPVRc3DlSogtd/WSiH+WgWat+7p2BvhyeZ6/DwnzdlgwyMokUz55n
	 GeJKk/+FN/CSyIdaBlLz++1Ii5QTJY6j2tMNU+aN3UUr5HegSrmHe6tvwVfVOg5nCAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d/qmDYJpl2nXhBURLJYadFHaZiLMPIcH40Cwbo7OfgM=;
	b=x+VYgsHWRz14mMeAJFBcBkc5EENiKkknZI3Ru5DiMbaMPqW8HwsRfTTXz4GZgzBvKLmq
	 HhIXeC1zpNwggVq4SGIqmwhTYM3AKV7IiY2XPb1dX+9ie4XNHyF+Xu6YYOGoHm5t2heBD
	 WuydVxSj7Cegmb3ev3yetJxnyLCeZ3PRgOV6AjYGzD0KhLgkqfmg8rbg3aK8FRHKu4DLt
	 yloTwnOvKX6C0+NK8vumBSqZiMaZgGEUptSB43wR/ObdQiGvQKDcKngXulbOGGKc+OsUw
	 Pa7U9NIROgyluWlCRpzhsjB53FEuW+R+mfms0jdyHXl6UDYujIe9hwZAyr6CH44E99A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRiVXDsb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41CA606A31E;
	Wed, 25 Nov 2026 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRiVXDsb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C421F000E6;
	Wed, 25 Nov 2026 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625256;
	bh=d/qmDYJpl2nXhBURLJYadFHaZiLMPIcH40Cwbo7OfgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRiVXDsb8N6LXuYhXPdV8BO7SjsDxk4cbaU2Qci+nJr9yT2oYjc948D/b+V9iw0Ll
	 MBU7Fg1aYnfk9Y1PsvjU35jwsvnAPjCWpXejz2gU3x/22qBrnjT8UlJIFaHEurKy43
	 FoEotIhRotDqKsw4BRQKU8i8w/vQc4AI7EELfJeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 455/816] phy: rockchip: naneng-combphy: Fix TX detect RX termination errata
Date: Wed, 25 Nov 2026 15:33:23 +0100
Message-ID: <20261125143859.722523182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the RK3562 and RK3576 .force_rxterm_det_rdy hunks since those SoC configs don't exist here, and adjusted the context lines for the prefixed register-define layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/rockchip/phy-rockchip-naneng-combphy.c  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index 11b5e43993fea..0fd9b5463f0ab 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -64,6 +64,9 @@
 #define RK3568_PHYREG18			0x44
 #define RK3568_PHYREG18_PLL_LOOP	0x32
 
+#define RK3568_PHYREG26			0x64
+#define RK3568_PHYREG26_FORCE_RTERM_DET_RDY	BIT(5)
+
 #define RK3568_PHYREG32			0x7C
 #define RK3568_PHYREG32_SSC_MASK	GENMASK(7, 4)
 #define RK3568_PHYREG32_SSC_DIR_SHIFT	4
@@ -131,6 +134,7 @@ struct rockchip_combphy_cfg {
 	unsigned int num_phys;
 	unsigned int phy_ids[3];
 	const struct rockchip_combphy_grfcfg *grfcfg;
+	bool force_rxterm_det_rdy;
 	int (*combphy_cfg)(struct rockchip_combphy_priv *priv);
 };
 
@@ -202,6 +206,17 @@ static int rockchip_combphy_init(struct phy *phy)
 
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
@@ -598,6 +613,7 @@ static const struct rockchip_combphy_cfg rk3568_combphy_cfgs = {
 	},
 	.grfcfg		= &rk3568_combphy_grfcfgs,
 	.combphy_cfg	= rk3568_combphy_cfg,
+	.force_rxterm_det_rdy  = true,
 };
 
 static int rk3588_combphy_cfg(struct rockchip_combphy_priv *priv)
@@ -784,6 +800,7 @@ static const struct rockchip_combphy_cfg rk3588_combphy_cfgs = {
 	},
 	.grfcfg		= &rk3588_combphy_grfcfgs,
 	.combphy_cfg	= rk3588_combphy_cfg,
+	.force_rxterm_det_rdy  = true,
 };
 
 static const struct of_device_id rockchip_combphy_of_match[] = {
-- 
2.53.0



