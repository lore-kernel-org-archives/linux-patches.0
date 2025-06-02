Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F4623372E;
	Mon,  2 Jun 2025 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873951; cv=none; b=fqg+JAM1kGBYuVKjyFxCFjkyJGHUnUI2isBMS7sa07vjnw/IOBn45hOvZhWADpfPWYWg9mgPwkmxw9F0jsH6T/ycQAAmnkOoyYs1gAbg9qEh+R9wnnISYPQF4CBbanSGZGBCXp/QpPyfA6fDZMgBBycFisvpHl7trgfdk8MS6N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873951; c=relaxed/simple;
	bh=cpZ9dW+ngSL2DYsBbno5q2iMp5l6oujpiKcJ5k4pg+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wn/JhRdlU7307ZVAddBXJFVpacT6SYVvw80JVpXx1QtVOIysl3TLbAkC0vgVuEgzGf6AHTz8Yi1+lfbK7dBzYgtVAOyBjUHIUduMG9zb52X25YT3esqe/9YT8tZunmr5TqScNgsRH9+PEsn6Vv02Ynbtuz8X8gv1zWV4zOwWc4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ak2k5T9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ak2k5T9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B59EC4CEF0;
	Mon,  2 Jun 2025 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873950;
	bh=cpZ9dW+ngSL2DYsBbno5q2iMp5l6oujpiKcJ5k4pg+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak2k5T9rhfXcrCbF+etaiacf/PTQhqRne+Tc+91e4gP/FQT03uF7IAN4Kn7usqoU4
	 cxh1hbDT/0eKOgKizbte3w+HJ7QKp6kLSy7NBX81pHwhH4KIntvxlmlPfnSst+0Ohc
	 8WD7ffYS06aPR71gbD50NbG+QXUOad/iQIY1Pfm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/444] r8169: dont scan PHY addresses > 0
Date: Mon,  2 Jun 2025 15:45:41 +0200
Message-ID: <20250602134352.201727182@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7e5258b2c4290..5af932a5e70c4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5125,6 +5125,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
+	new_bus->phy_mask = GENMASK(31, 1);
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
 		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
 
-- 
2.39.5



