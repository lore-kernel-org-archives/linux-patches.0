Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034761;
	b=KJXO6ujj21diF3ei6ysCnMyttFeakBu3FunCunICoOptGGBpBDQwYRLqE6AbcX2ReGOA
	 wW21vjVeNUoECa9/csDDE1dPOb7513Gu8p2zWZvzagZqTc81zgUq1cSXev0S8gOp9PpMC
	 l0cgCOzRwbka9WADHLFc3Ib0bB6IRc5yghUA5NlMlhhtcLcsla7c0JsvHrurb3n5Z9dqG
	 ri5dFv3lKuh6Q7qqB3BfGu1JLDNWcnU8p6/Lc0qRMClED3kKF2dHSsI3QvwLxY7+PooU5
	 RIoI0tiVCkab1pR9w3jOw5/n2mtlA4m0DhNF9Dq1klNLfaxruJKcJKYfGmvzXGnVrCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dm2IC2W524526You2ofgjjIEWLXqDgWX+0ckkGL9chU=;
	b=3zWENAL2mV2m6c7Q2mGMxVU1Bhm8z7ZU+QbkiOkSKCOr4EZ8ZRIfSx4OOTDWSMxG2vY3
	 we5epCeDlG7mJ8DPvTNRzLz5MJ+3aQw5g6NM6F93UgtzDF6ffbWh1soH48ZbU8Q41qVnx
	 g0UmezeZNtOeSwYQK9jiBTOVsvcVrlofjhd70y+pMqZz65hV4dzLy9tMuSy+f1HZQE7tb
	 b7LvB0C2u8k8shTtGHwhlh9q7itm+botjdoFfcFB4iV3c6OD/KQLc/sN5Dmsd/y85JsfK
	 HpkiWr8/6LaRCfzEPE7aVN2kZUfoUV33XJxbk9MarpOHg+AtlJcToKuTFoJt069VWPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McR5D8cw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143E6606A31C;
	Wed, 18 Nov 2026 20:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McR5D8cw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915E41F000C4;
	Wed, 18 Nov 2026 20:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034760;
	bh=Dm2IC2W524526You2ofgjjIEWLXqDgWX+0ckkGL9chU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McR5D8cw/rhSHp6jkRL33fgP9jlQgxhZPjFo2cf8Dml39SE+JFkgeb4fZAAd6DImt
	 ZG1xdBSl5TU3/BZH5gZULQYbPAZ7R0QaDXhFE6vzNGVDzlM1aIw9+Mg8fm1GUzbK0r
	 qPIlXaELfTUIAmWEyQjYwz0GDIAnSz/syOAUuYnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0481/3318] net: phy: mediatek: do not report link and per-speed LED rules together
Date: Wed, 18 Nov 2026 15:18:23 +0100
Message-ID: <20261118150331.385962965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit bde5212360bd44506edec073ebbd6d0c72f75820 ]

mtk_phy_led_hw_ctrl_get() reports TRIGGER_NETDEV_LINK whenever any of the
speed bits in on_set is on, and in addition reports every individual
TRIGGER_NETDEV_LINK_* bit that is set. The netdev trigger refuses that
combination: netdev_led_attr_store() rejects TRIGGER_NETDEV_LINK together
with any per-speed rule, and it validates the whole resulting mode rather
than just the bit being written. Once the hardware has any link bit
programmed, every write to the trigger attributes of that LED therefore
fails with -EINVAL and the LED can no longer be configured.

The rules are also fed back into the hardware: the trigger stores what is
read back, and a later write of device_name programs it again, expanding
TRIGGER_NETDEV_LINK to every speed in on_set. An LED configured for a
single speed is thereby silently widened to "on at any link speed".

Both are easy to see on the EcoNet EN7528, whose four PHYs share one LED
block. The first LED programs the block correctly, the second reads those
rules back and rewrites them widened, and the remaining two then read the
widened value, so an LED configured for "link_10 link_100" ends up lit on a
1000 Mbps link.

on_set holds every speed the LED can indicate and is exactly what
mtk_phy_led_hw_ctrl_set() programs for TRIGGER_NETDEV_LINK, so report the
speed independent rule only when all of them are on, and the individual
speeds otherwise. The mapping is then the inverse of the one used when
programming the LED and round trips without changing the register.

Fixes: c66937b0f8db ("net: phy: mediatek-ge-soc: support PHY LEDs")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260912134306.3544329-1-naseefkm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Ported the fix to the single-file MediaTek driver and its LED get function, using the local link mask in place of on_set and dropping the 2500M branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mediatek-ge-soc.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/mediatek-ge-soc.c b/drivers/net/phy/mediatek-ge-soc.c
index 4b2a9a5444c57..5a1dda88a80c6 100644
--- a/drivers/net/phy/mediatek-ge-soc.c
+++ b/drivers/net/phy/mediatek-ge-soc.c
@@ -1276,17 +1276,25 @@ static int mt798x_phy_led_hw_control_get(struct phy_device *phydev, u8 index,
 	if (!rules)
 		return 0;
 
-	if (on & MTK_PHY_LED_ON_LINK)
+	/* TRIGGER_NETDEV_LINK must not be reported together with any of the
+	 * per-speed rules, the netdev trigger rejects that combination.
+	 * MTK_PHY_LED_ON_LINK holds every speed this LED can indicate and is
+	 * what mt798x_phy_led_hw_control_set() programs for
+	 * TRIGGER_NETDEV_LINK, so report the speed independent rule only when
+	 * they are all on.
+	 */
+	if ((on & MTK_PHY_LED_ON_LINK) == MTK_PHY_LED_ON_LINK) {
 		*rules |= BIT(TRIGGER_NETDEV_LINK);
+	} else {
+		if (on & MTK_PHY_LED_ON_LINK10)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_10);
 
-	if (on & MTK_PHY_LED_ON_LINK10)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_10);
-
-	if (on & MTK_PHY_LED_ON_LINK100)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_100);
+		if (on & MTK_PHY_LED_ON_LINK100)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_100);
 
-	if (on & MTK_PHY_LED_ON_LINK1000)
-		*rules |= BIT(TRIGGER_NETDEV_LINK_1000);
+		if (on & MTK_PHY_LED_ON_LINK1000)
+			*rules |= BIT(TRIGGER_NETDEV_LINK_1000);
+	}
 
 	if (on & MTK_PHY_LED_ON_FDX)
 		*rules |= BIT(TRIGGER_NETDEV_FULL_DUPLEX);
-- 
2.53.0



