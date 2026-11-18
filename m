Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032481;
	b=x0rOV6AuBq9v3Q03Pc+yk2HdkGDKO7XRVK/TAmMgzCanKk3j8KTGFxrrWhdVTggdKYFX
	 ica+bu9df67uxOEWG9X74h55EHUJ74ZGdTlVRLcyHJ7el9GurFi/OeemkVuz4OmQkO5k6
	 chIjuqkQx24yA/yloiy15l04axb/yGYYa5t4WSwbNVFJQ+XL5dzCJKkz3DjqhGgwL+FYl
	 IlE7i4KnnAiIkWeEZ0NQ7XJu7ZzTSHPXbiU9uUkCEBl4Ezf/K5PNlyZjmshgvae76EP4j
	 LYI+Pw+roTftXhCZdqGiat6RHjMnJyCCFpcLhMUpJrgFuab35CYua8Cdx6t8L+TiDOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n71iGR7eQkidXX+NzvrDRAeA2eBrGw1EP1tk5QUk5yM=;
	b=zO8hr52uodJTQpLzO3iABEoT9Eg/rCPZgly2wgTNOHG5aDqj0Os1ihwheUhfwBSOgJA4
	 ALNIGAHsB3ePEMA1VZqVMPcyJtiW4wvaJ6nI1wKt/7GNTIY1D9ic4MuWlt6wAf47EXXje
	 G/4Gzz2w1Cb7Ef8Z2kj6SJgax1M1T6yL5aDRKZllejIayKtaDOp0x/jOJBP/dKoKgPIW7
	 hTNJW04l3n4tD/aSGe7PVsfJ49XL9+kP73C2YRzTLgaER+H+qwc9OfxESR2WJPcb1aJIW
	 giEvIAh7/E3jkFMKKcrA6c+u4NK0NongKbp+D/JZCrhHG8Yi1nUID/5COq3ooyOt8bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l7t/eC3V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B96606A846;
	Wed, 18 Nov 2026 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7t/eC3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E3B1F000C6;
	Wed, 18 Nov 2026 20:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032480;
	bh=n71iGR7eQkidXX+NzvrDRAeA2eBrGw1EP1tk5QUk5yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7t/eC3Va5VwlesXFFvddRKehyPlAxYj2Vm2FUUMtvmYJxs6xbiTDpPiVZKW6a4Qy
	 q3Y3OWCFyN6P9oCQ16e+fbV8+QQiRka9WOuE5Ew5AGB7BqA5Ds0ej91REgmDc3bIjK
	 O5d1+KdYZOGtDFFN2GnhBVYEpgC2DP2zM+2R1A+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Yongzhao Chen <yongzhao.derek@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1428/1756] net: phy: qca83xx: read resolved QCA8337 link status
Date: Wed, 18 Nov 2026 15:59:15 +0100
Message-ID: <20261118150106.054508735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Yongzhao Chen <yongzhao.derek@gmail.com>

[ Upstream commit 42a91cbfc7a3ab99d05cb2ed0de5a24b9652cfed ]

After a QCA8337 SmartSpeed downshift, genphy_read_status() can report
1000 Mbit/s from the advertised modes when the PHY is running at
100 Mbit/s. On a Redmi AX5400 running downstream OpenWrt Linux 6.18.52,
this caused qca8k to program the user-port MAC for 1000 Mbit/s and
traffic failed. An earlier prototype that read the resolved speed
from the PHY restored traffic.

Wrap genphy_read_status() and use at803x_read_specific_status() to
replace its speed and duplex result when an autonegotiated link comes
up. Resolve pause for the resulting duplex. Until the PHY reports a
resolved speed and duplex, report the link as down so that the next
poll reads them again, as marvell_read_status_page_an() does. In that
case also clear the duplex, master/slave state and link partner modes
that genphy_read_status() read for an up link. QCA8337's register
layout matches the helper (data sheet 80-Y0619-3 Rev. D, pages
327-328).

Keep the generic master/slave read order and the early return for a
steady autonegotiated link. This avoids additional reads of the
clear-on-read idle error count in MII_STAT1000. Forced mode continues
to use BMCR. Report the MDI-X state read at link-up and invalidate it
when the link goes down or autonegotiation is disabled. Clear
mdix_ctrl because this driver does not implement MDI-X configuration.

The QCA8327 entries keep genphy_read_status(). The AR8327 data sheet
(MKG-15791 Rev. 1.0) lists the QCA8327-A PHY ID and documents the same
PHY-specific status layout, with SmartSpeed enabled after a hardware
reset, so those PHYs may have the same problem. That is untested on
QCA8327 hardware, so limit this change to QCA8337.

Fixes: b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Yongzhao Chen <yongzhao.derek@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/20261013190339.51909-1-yongzhao.derek@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/qcom/qca83xx.c | 58 ++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/net/phy/qcom/qca83xx.c b/drivers/net/phy/qcom/qca83xx.c
index a05d0df6fa16b..f8000dab2ccdc 100644
--- a/drivers/net/phy/qcom/qca83xx.c
+++ b/drivers/net/phy/qcom/qca83xx.c
@@ -94,6 +94,63 @@ static int qca83xx_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca8337_read_status(struct phy_device *phydev)
+{
+	struct at803x_ss_mask ss_mask = {
+		.speed_mask = AT803X_SS_SPEED_MASK,
+		.speed_shift = __bf_shf(AT803X_SS_SPEED_MASK),
+	};
+	int ret, old_link = phydev->link;
+
+	ret = genphy_read_status(phydev);
+	if (ret)
+		return ret;
+
+	/* Keep the state resolved at link-up while the link stays up */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		goto out;
+
+	phydev->mdix = ETH_TP_MDI_INVALID;
+
+	/* genphy_read_status() derives speed and duplex from the
+	 * advertisements, which is wrong after a SmartSpeed downshift.
+	 * Use what the PHY resolved instead.
+	 */
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete &&
+	    phydev->link) {
+		phydev->speed = SPEED_UNKNOWN;
+		phydev->duplex = DUPLEX_UNKNOWN;
+		phydev->pause = false;
+		phydev->asym_pause = false;
+
+		ret = at803x_read_specific_status(phydev, ss_mask);
+		if (ret)
+			return ret;
+
+		/* Report the link down until speed and duplex are resolved,
+		 * so that the next poll reads them again. Also clear what
+		 * genphy_read_status() read for an up link, as the
+		 * PHY_HALTED path of the state machine does.
+		 */
+		if (phydev->speed == SPEED_UNKNOWN ||
+		    phydev->duplex == DUPLEX_UNKNOWN) {
+			phydev->link = 0;
+			phydev->duplex = DUPLEX_UNKNOWN;
+			phydev->mdix = ETH_TP_MDI_INVALID;
+			phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+			linkmode_zero(phydev->lp_advertising);
+		} else {
+			phy_resolve_aneg_pause(phydev);
+		}
+	}
+
+out:
+	/* MDI-X configuration is not implemented */
+	phydev->mdix_ctrl = ETH_TP_MDI_INVALID;
+
+	return 0;
+}
+
 static int qca83xx_config_init(struct phy_device *phydev)
 {
 	u8 switch_revision;
@@ -222,6 +279,7 @@ static struct phy_driver qca83xx_driver[] = {
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
 	.soft_reset		= genphy_soft_reset,
+	.read_status		= qca8337_read_status,
 	.get_sset_count		= qca83xx_get_sset_count,
 	.get_strings		= qca83xx_get_strings,
 	.get_stats		= qca83xx_get_stats,
-- 
2.53.0



