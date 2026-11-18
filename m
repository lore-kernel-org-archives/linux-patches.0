Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021236;
	b=MhBhtxzMuKAOyVkzMv5hbQNrM491fD7ImVXMyp2Ui6vIdSliQJob9LlXde0CM97W3G0m
	 JqwCHJhpqCEWTNWbOq4UMYRQMwm+1O5xfbJSc5GHw0PtzwVCEc0x5xo7M6C5mjdLbP19p
	 upHNU51xQHO3zVEat+gb+wHVGV+mgUjnBMJQwcoobSDihJSZBBguIzcHzzHBnxuA1yfpd
	 0UZo7qooAHC9MUGS7yFEF4nsx2fgXTJP0YG2K98GvfCV8FlVs/OW0y3xSOXuN+HoD2qFD
	 rpwLst0LGs+S6QP6T5k3YqDEASFZRxTS7Wc19SlwhKcYnBqI1ohXIxlT4LxlZ5UcsiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ylM1/Hm5LtSAPacwjJM9TaXrn9R9A8dTuVB7YsGTdKY=;
	b=1Dn9x5cVbkeedbBGU3aN6HTv+08B99OsHWR3tpIT1H1JdOHY3+tJDR2qoZ+MlQT+LIVl
	 GO7I4eOspRsBbNYQZvRQzoxJCQUDKLXs+6vF5PwDUxfEY8VJ/uVcvpjdVNANHuLur8ZxU
	 Fvfkh8wsTEUIsBgdt8Rd/Hhq4BUbo6lMRhSgPjdaQ6ax3hDqPrUqL1YcniZKrQHSI2QKS
	 T/cIKGV/ytsmyzhJqXaTdKITWeng7bOtXkZdwWfHDiBWik7boV52euhfLmB/ZbX9oCyN8
	 +Bhh6zZZESfZG1y/PLw1H00UOnQDv6IxpMS+qOHx6x2WVFF0xlnJhnTxvN9E/H7enFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fj9Sh4mm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A154606A32F;
	Wed, 18 Nov 2026 17:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fj9Sh4mm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4621F000C4;
	Wed, 18 Nov 2026 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021236;
	bh=ylM1/Hm5LtSAPacwjJM9TaXrn9R9A8dTuVB7YsGTdKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fj9Sh4mmIGUB0aex+qfydVJTp2Vf7fFeF9uLFybjAvrNiGjQzBQd0JGOFajaIG8Ee
	 sUzZnp/+FvkCbxdC0LYZQXCSUrZvNW0/VGiVgG/6uZkJWrAIQKsifE9PV5FYh0dhb6
	 lVyvFq7wGUrnQmCBk+jp+wyQVgp04Jv6xg0Pf6nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Yongzhao Chen <yongzhao.derek@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2228/2651] net: phy: qca83xx: read resolved QCA8337 link status
Date: Wed, 18 Nov 2026 15:57:48 +0100
Message-ID: <20261118150405.754433528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bc70ed8efd86a..2c4d085bacdba 100644
--- a/drivers/net/phy/qcom/qca83xx.c
+++ b/drivers/net/phy/qcom/qca83xx.c
@@ -92,6 +92,63 @@ static int qca83xx_probe(struct phy_device *phydev)
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
@@ -220,6 +277,7 @@ static struct phy_driver qca83xx_driver[] = {
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
 	.soft_reset		= genphy_soft_reset,
+	.read_status		= qca8337_read_status,
 	.get_sset_count		= qca83xx_get_sset_count,
 	.get_strings		= qca83xx_get_strings,
 	.get_stats		= qca83xx_get_stats,
-- 
2.53.0



