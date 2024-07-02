Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E091BE85E;
	Tue,  2 Jul 2024 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940059; cv=none; b=Z5wC/TMkBFpIDH06q58qnHqJbzfQ2IXL1I1O1XoJkYlsYF6quKE1fXJUSHgGLKQjOWVSvtVQEl6L96YSXT2Ir6pJPPmBlfy0rmzUkj1v5zaoq7kKEgwPdy4lFgUaQBo/jVw6fijKhaJPBdtR4J/CNGubfR1+goZaaDxsLJa8lo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940059; c=relaxed/simple;
	bh=rvTE0d9e6oUQbHH1xOGjwM1AuuaT353F4TqWgqLYjEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO/AkbReRxZ2VXucMvS8XYBq/KIRMyhkWuNKv4jjvinr7sLw6CZQyEXKtvRau1yp3l/ylN7W8lwTipkXlTbpnsg5jWiSe1LxRBeS/GqitqbeMR7HSGdvmrTnm40Fh6twD8MctlK04oB4YITPNGBMw0eIG5o3K68/QsQCcx24me4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPu9QXmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPu9QXmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00011C4AF07;
	Tue,  2 Jul 2024 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940059;
	bh=rvTE0d9e6oUQbHH1xOGjwM1AuuaT353F4TqWgqLYjEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPu9QXmIc7Th7B5FKS69td69QL3p343MTieLcpr8XUPbaQeu8az3rm4YsJ6TGQab+
	 RUaiALOCj/1sO6AoATewuGO8+A1IfEX+KHbxHu5t+3ECQBC0sp3WPiVGczZS1P/LYS
	 aHHXdjBjYdNjrkgRRRVCOOFPLKj6Y2uY58q99bls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 040/222] net: phy: micrel: add Microchip KSZ 9477 to the device table
Date: Tue,  2 Jul 2024 19:01:18 +0200
Message-ID: <20240702170245.507620067@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

[ Upstream commit 54a4e5c16382e871c01dd82b47e930fdce30406b ]

PHY_ID_KSZ9477 was supported but not added to the device table passed to
MODULE_DEVICE_TABLE.

Fixes: fc3973a1fa09 ("phy: micrel: add Microchip KSZ 9477 Switch PHY support")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 4b22bb6393e26..4a28b654ce877 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -5094,6 +5094,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9477, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8841, MICREL_PHY_ID_MASK },
-- 
2.43.0



