Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065A5139579;
	Tue, 27 May 2025 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365762; cv=none; b=XjnMPexMC79bYMgokBwuC+udhRpUTSOFMszDUG/dVZcEJLr7N890Bw9UcxjdtrRrlanQ1zMN9sISpIAf/Nl3LjnKI0xwBUi1BvMPRQTgMn1DKetJ3iKxmt3tHlwSAejHHbNk5YhdFjQm7GP72KVX5Z18uZ6KciXQQ7iyIPHy79Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365762; c=relaxed/simple;
	bh=7/2RzS/+zdU2mOfnrpPL/cDci1FESIcHd1WYwDNLXOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3VJKDkb2fG1/GVYqffc5Ws4QgJ2+wwRMLf3WJBpFIvexl1Wwmg/eNOiQq6BXWiaeA6IdM0iiCBus5WaBwQbm1LcGjGU4BKlQC1ZIkjHu/DmTr5eIDSP52O9UgsPo7CilMMh9DmWHb0OrL5xJ3fOl3ZN5rwrDuTgjnDhr9toDok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2SNIJSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2SNIJSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7656EC4CEED;
	Tue, 27 May 2025 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365761;
	bh=7/2RzS/+zdU2mOfnrpPL/cDci1FESIcHd1WYwDNLXOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2SNIJStyCjSLnYvuNR9I/UJ2C0IpnG7HCwV3cdY/gQlfFs8dfpgxufUDGyfoM8rz
	 VvKQ+pDNUsZUphHtMx/DRsidoKqyZIx2J9ZorRegfBOl9nwKEH1m1+VC0Hm5RQeP0K
	 PYQ5sI9LE5s4jivwXD9hIHVEeKcAASzx6M9M9jIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 450/626] r8169: dont scan PHY addresses > 0
Date: Tue, 27 May 2025 18:25:43 +0200
Message-ID: <20250527162503.286070205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit faac69a4ae5abb49e62c79c66b51bb905c9aa5ec ]

The PHY address is a dummy, because r8169 PHY access registers
don't support a PHY address. Therefore scan address 0 only.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/830637dd-4016-4a68-92b3-618fcac6589d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3420b6cf8189f..85bb5121cd245 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5258,6 +5258,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
+	new_bus->phy_mask = GENMASK(31, 1);
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
 		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
 
-- 
2.39.5



