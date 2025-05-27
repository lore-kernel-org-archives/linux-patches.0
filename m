Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072FC7263B;
	Tue, 27 May 2025 17:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367997; cv=none; b=oHt5FpyAQG3tSgop9bikx3PTGdcaAVbn2nbhh86Uu08GsXU1smNxPZIw4pPJ6YlQb8OVzLW6JezGASjeeqPxQkHpPeKHZWUfES6iI6glUI+/IBSmR0n2Ozsarb0eCX+e5ERRzmIUHcUQmOZ9/VRR1zki33bMa5/6NpRSdCZ+jgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367997; c=relaxed/simple;
	bh=xV0SXz17XN26d3Oi5Cla/pQA+2Cr6DHTnvpZf+dK5Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2s1p+vWNQo2SLRtR+r6jU3WsUKJ3IeJI0x+ndOGpFZ1z9OBL653sBtRc1fTN+JyQ5gx2M2OQUyvP3moEev7zuEP3g+qbzVRM0k+DzFY+U4vX4fcdXlisAyviq1iMdQsOmztETPdpplnYZpijjlsQbBnLyBlxzhI+9fE6yCDb/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOwv7g+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOwv7g+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6980AC4CEE9;
	Tue, 27 May 2025 17:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367996;
	bh=xV0SXz17XN26d3Oi5Cla/pQA+2Cr6DHTnvpZf+dK5Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOwv7g+Fyx8uEsbvX32CT8dY/5Ne1qQmq9waSCeKGwJfQnNnHkh57BFTZL0vqpo/Y
	 xXug/Qop8x4y0K6j6dDMF/JwDZ9gtsUX/xHgzeOsQ3MVZ5r5FvPmt+oU2KY63Lzxa/
	 2L0vZMUWTIFpRRUoAGhzE5kph4Diu78ISGV7xDQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 565/783] r8169: dont scan PHY addresses > 0
Date: Tue, 27 May 2025 18:26:02 +0200
Message-ID: <20250527162536.151750896@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 485ecd62e585d..267105ba92744 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5250,6 +5250,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
+	new_bus->phy_mask = GENMASK(31, 1);
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
 		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
 
-- 
2.39.5



