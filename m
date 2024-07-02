Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213591B5814;
	Tue,  2 Jul 2024 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940786; cv=none; b=InN+8v/0tmRybBbU0Gu9eDt2Rb2UDiJ3bqJID1mgTr+xUAnZDvB6DbvHlNKw+1gEH4TohB2jBAObolZzcyvciQJSlvsSxSz6zrTcZYDYaOpGIgQZY0dxZWtK2hDy3cCpRgKSbhTObOBm6VDqO8MB2R3jZcg6ODUuQCPveIeRe+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940786; c=relaxed/simple;
	bh=IU0SHoL8aakp/WONAUKcZxeBawD8Je5V2vRup08wx/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2fVifZXWaVUj89rVF8IuqkL58AjIsJA4h545pvZj1/ZAKJCSov+nybvQL0aFTrzek6JjukHrYwcv4ubjLNlhjwCjLMx24wWeVOE2mVIPFalzcc4IaKPfYMm0izxYQ9O92NuYz4c0RmJBi2vGhkzqLfY6qL+b/URqQ2kihE2W44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gd2xyZHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gd2xyZHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DC5C116B1;
	Tue,  2 Jul 2024 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940786;
	bh=IU0SHoL8aakp/WONAUKcZxeBawD8Je5V2vRup08wx/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gd2xyZHSUjul0psZbCUogDE8XhS60YokXNCgGmfzI9iyLVbcDnblqLaAvySz7iPvd
	 2Ax98QeFDJz90Yd0oy04egPuPV3LbY02a3heVv4lTrZG6Ubos1nYZy/zp8NcCMllBw
	 Yewu57WVZ4e+S887oh8WzB7t+zEuGXF/u8ELjMuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Woojung Huh <Woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/163] net: dsa: microchip: use collision based back pressure mode
Date: Tue,  2 Jul 2024 19:02:28 +0200
Message-ID: <20240702170234.349197184@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

[ Upstream commit d963c95bc9840d070a788c35e41b715a648717f7 ]

Errata DS80000758 states that carrier sense back pressure mode can cause
link down issues in 100BASE-TX half duplex mode. The datasheet also
recommends to always use the collision based back pressure mode.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Woojung Huh <Woojung.huh@microchip.com>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c     | 4 ++++
 drivers/net/dsa/microchip/ksz9477_reg.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 353c41e031f1a..a7e8fcdf25768 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1112,6 +1112,10 @@ int ksz9477_setup(struct dsa_switch *ds)
 	/* Enable REG_SW_MTU__2 reg by setting SW_JUMBO_PACKET */
 	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_JUMBO_PACKET, true);
 
+	/* Use collision based back pressure mode. */
+	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_BACK_PRESSURE,
+		SW_BACK_PRESSURE_COLLISION);
+
 	/* Now we can configure default MTU value */
 	ret = regmap_update_bits(ksz_regmap_16(dev), REG_SW_MTU__2, REG_SW_MTU_MASK,
 				 VLAN_ETH_FRAME_LEN + ETH_FCS_LEN);
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index cba3dba58bc37..a2ef4b18349c4 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -267,6 +267,7 @@
 #define REG_SW_MAC_CTRL_1		0x0331
 
 #define SW_BACK_PRESSURE		BIT(5)
+#define SW_BACK_PRESSURE_COLLISION	0
 #define FAIR_FLOW_CTRL			BIT(4)
 #define NO_EXC_COLLISION_DROP		BIT(3)
 #define SW_JUMBO_PACKET			BIT(2)
-- 
2.43.0



