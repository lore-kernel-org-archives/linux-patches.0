Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027953;
	b=wDkfT6Vbvz6S1m9aALOBnqHJ/XDAFJt0hRkCE2nTBMxicP+Bb9mkiC6AfpVAhufCS9qQ
	 z80+B/tw4BzkqfPzWL5Zqe+rKo1LQHX84ox8xKu9vdew7bnzNKmK3ntKmBcIJByp0ix/d
	 amfbuUA8zNJ0ilSqjy2HzRy7suLz9HKlR9BKIZtsvJnQVquWqYsJhI7n0J/jqe/SK7SPU
	 ys/yuJkmMtIYGgvjapwwvY4/l5CPKDlmau4KfWZEvEguESnsjWpamAREX0iaEaz9m01ky
	 J7WwmV0zT/gnFPzy2yjS2OT/o40E1P0sFVUaaYc+rTaXoJ6b6XQwDPdkikI0EM4jZlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=syPUgtx3c9lK5hNhVaj0pEBHP47AddO00GRVlUe5ni8=;
	b=NCb9B1f3bFbZHBktvtmAOxvJ2cG5vTBl34/p0VIXwPEAuBwTXXz7+7C+o5Upc88n7ImH
	 O65UDO7XXepRR/P+2C2/mD8hcHp4OekzFWTzJGIfmz79m73FXVlFF9+iC41DAtJ+6S9Bq
	 OEjyd9KyyO+3qXvsv17yeagODK0ooQaOf8dekDH3ZGfJmHwDO6BZf/TUkC9Y9DN9tGmLZ
	 JKjpnl07qd9HidGeJQXJ9IfMCHYXqzs7zWRfh/SC4c4SMCL3nLvMdMvXc0XlE4eHuq5eO
	 AKPHrye4bNay+JeNkSWmtR0hhk6jSJPR9QrMJaXKixBdjHE/rL1mm7K4ckLyh13yKIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvoHK2gV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D6C606A31C;
	Wed, 18 Nov 2026 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OvoHK2gV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D221F000C4;
	Wed, 18 Nov 2026 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027953;
	bh=syPUgtx3c9lK5hNhVaj0pEBHP47AddO00GRVlUe5ni8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvoHK2gVHyEuOd3EWxHmRxOU5G2nTx7QPgGDV5akbBqCFR3h1ccfJ7+OTN0R9qNba
	 7hrg41rydYMeUEPAfA7henE8UVGmSU5osKVdKGjMrvdItosoUDI0JfGS2+Pfu0hOnm
	 juOTLQ1S/PmnBPFyLoU8WKsZxWHceJ30IDZKfyQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Sengar <prashantsengar25031@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1973/2151] net: usb: lan78xx: avoid NULL PHY dereference in WoL setup
Date: Wed, 18 Nov 2026 16:01:48 +0100
Message-ID: <20261118150233.614569822@linuxfoundation.org>
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

From: Prashant Sengar <prashantsengar25031@gmail.com>

[ Upstream commit dacb77e32e2bba78f90a8637fd27e13e2c9775dd ]

LAN7801 supports fixed-link configurations without an attached PHY.
However, lan78xx_set_wol() unconditionally passes netdev->phydev
to phy_ethtool_set_wol(), causing a NULL pointer dereference when
a userspace WoL request reaches this path.

Report no WoL capabilities when no PHY is attached, and return
-EOPNOTSUPP from lan78xx_set_wol() before modifying the wakeup
configuration. Keep the existing phylib WoL handling for devices
with an attached PHY.

The issue was reproduced using USB Raw Gadget and dummy_hcd in QEMU.
An ETHTOOL_SWOL ioctl triggered a kernel Oops with the original
driver. With this change, the PHY-less configuration no longer
advertises unsupported WoL operations, avoiding the crash.

Fixes: e110bc825897 ("net: usb: lan78xx: Convert to PHYLINK for improved PHY and MAC management")
Signed-off-by: Prashant Sengar <prashantsengar25031@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20261020201537.2465655-1-prashantsengar25031@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3597ae6a542ef..133ea36388147 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1767,6 +1767,12 @@ static void lan78xx_get_wol(struct net_device *netdev,
 	u32 buf;
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 
+	if (!netdev->phydev) {
+		wol->supported = 0;
+		wol->wolopts = 0;
+		return;
+	}
+
 	if (usb_autopm_get_interface(dev->intf) < 0)
 		return;
 
@@ -1798,6 +1804,9 @@ static int lan78xx_set_wol(struct net_device *netdev,
 	if (wol->wolopts & ~WAKE_ALL)
 		return -EINVAL;
 
+	if (!netdev->phydev)
+		return -EOPNOTSUPP;
+
 	ret = usb_autopm_get_interface(dev->intf);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



