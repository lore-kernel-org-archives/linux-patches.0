Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03688134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D24C43391;
	Mon, 26 Jun 2023 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803483;
	bh=/FT13aD7SznVCFsFr3nDHY/e04UdsY5m750Fbe/PcS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wk18X2OZliRdqHBNd8u09BOd1bnVqhDn1fOepBINwU5Kk7U5FSpUM5FIUt3lo7Ez9
	 C3JeG9u73yl6VnyiebU3Y/hlcpFozRnuTjCNkMRTWyc0dwmAJSzAWIZsDyL9u1ZbK2
	 LfCKIax8ZU9ZDS1WMTmhG96B7PWJ0gHjwiF5A2EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 077/199] net: mdio: fix the wrong parameters
Date: Mon, 26 Jun 2023 20:09:43 +0200
Message-ID: <20230626180808.935960706@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 408c090002c8ca5da3da1417d1d675583379fae6 upstream.

PHY address and device address are passed in the wrong order.

Cc: stable@vger.kernel.org
Fixes: 4e4aafcddbbf ("net: mdio: Add dedicated C45 API to MDIO bus drivers")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20230619094948.84452-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 389f33a12534..8b3618d3da4a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1287,7 +1287,7 @@ EXPORT_SYMBOL_GPL(mdiobus_modify_changed);
  * @mask: bit mask of bits to clear
  * @set: bit mask of bits to set
  */
-int mdiobus_c45_modify_changed(struct mii_bus *bus, int devad, int addr,
+int mdiobus_c45_modify_changed(struct mii_bus *bus, int addr, int devad,
 			       u32 regnum, u16 mask, u16 set)
 {
 	int err;
-- 
2.41.0



