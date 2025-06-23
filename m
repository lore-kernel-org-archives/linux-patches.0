Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA4C25291B;
	Mon, 23 Jun 2025 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684841; cv=none; b=Uw97nwABFqFQ9I5tTYduPzmNceEo0/DwOjb/8vZ4nZgTBF+jiuK7n7cZMhptHU31MI6k4/79eTzQW6UpTyk91ssZVOAjM7UvTKfOEy9rYsg/3lzGEj5gpTdMJn6XgufZ1MPC3A2Z4SvJWQ43OOLTvThXuPm5pMmMd6w7xLyssB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684841; c=relaxed/simple;
	bh=gGWVCnwMq2Ytt2iuvEasjxcjY+9KTDwacRYgTzzCNk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTQqyGSIVQbAJeTAswAFHBTZZIZN9Q3PIpk3GFnjj/XPSGN9tCPceAitAX342jvdYHqtrk+NCg2KbMqniKw9iYr59Hkfh1St7hkZuCkP935ZOPZ4BRUoMiXZBNaNtw16BT7kANk28SCCvbjkXmRKwjcl0nnFobr/n9hr95TXQ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfEMFXZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfEMFXZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FA9C4CEEA;
	Mon, 23 Jun 2025 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684841;
	bh=gGWVCnwMq2Ytt2iuvEasjxcjY+9KTDwacRYgTzzCNk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfEMFXZimaqp3Rk0VZJu+XE0PMhD/1kjmOQ2c3ao6pwNq0uVDYEkOfmHmfDbbWSNn
	 BuPX1mVKVlamDUuSmr6Ya0RpurJRjI10xMKlqEfGOGFe/rl/IxYuPLVORW5uMbtNaD
	 BkF/Tr19BP7EV4SSb5/0anLIWuEikZtWdWJnHj40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/222] net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy
Date: Mon, 23 Jun 2025 15:06:13 +0200
Message-ID: <20250623130613.046498497@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

[ Upstream commit 68927eb52d0af04863584930db06075d2610e194 ]

rename the function to lan743x_hw_reset_phy to better describe it
operation.

Fixes: 23f0703c125be ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250526053048.287095-2-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a69a34d93ad62..22e1143c58467 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -912,7 +912,7 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
 }
 
 /* PHY */
-static int lan743x_phy_reset(struct lan743x_adapter *adapter)
+static int lan743x_hw_reset_phy(struct lan743x_adapter *adapter)
 {
 	u32 data;
 
@@ -946,7 +946,7 @@ static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
 
 static int lan743x_phy_init(struct lan743x_adapter *adapter)
 {
-	return lan743x_phy_reset(adapter);
+	return lan743x_hw_reset_phy(adapter);
 }
 
 static void lan743x_phy_link_status_change(struct net_device *netdev)
-- 
2.39.5



