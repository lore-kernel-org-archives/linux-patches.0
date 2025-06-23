Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E7A238C19;
	Mon, 23 Jun 2025 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685918; cv=none; b=ONp9h7ohRZedVFjw1lIJCABKUVM5tmTLcAqJwAqdiwXuRZf67yVmstEYc4h7ZU8hoG8UrblaEiNlK18hrj2s4+oDla2o6Vn8jZkX69oS4qYtGzN3sFGQVinWWt/oxD47wlOuzhjXKzeOv31tQoKRZxfRHTu6yzAMJJX1aPQXUmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685918; c=relaxed/simple;
	bh=h4WsBxgo5ydhSw3mt78JvODGfULnEd5HB3Q4vjF3i5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYQMu2NpdCRl7CrB6tRv71GDen9PWGKx+eKrJspwP0VYAGehsgMjbHxoAfYfKnB36fg4BywHIsomgusVwVGCEB54UlZPSwjxGcfOgA4QtOdCRDQXjaHggBaJ0ETiQcoMIl7AomGy1xpgUQgQtlyscKkroZj0+bsT/5aezKdNqfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsAXzLD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsAXzLD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08781C4CEEA;
	Mon, 23 Jun 2025 13:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685918;
	bh=h4WsBxgo5ydhSw3mt78JvODGfULnEd5HB3Q4vjF3i5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsAXzLD5qM99EhUodfe9hmKnA4gRYIUT1qHpohRclnI5/YcA+L3No2WW0nZCqX95J
	 WvjDfGTHsRMc8MQAfqbqYV7RezdK9S8W4ggS9Bxh9Ne6Y6ayW1yMyNQ0EWBHc0Bf8A
	 KKLTh0wx7Ltdynm20E1lbAPodDD4R9mmdz2uGJAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/411] net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy
Date: Mon, 23 Jun 2025 15:03:33 +0200
Message-ID: <20250623130635.069630256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fe919c1974505..49d40685136d4 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -910,7 +910,7 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
 }
 
 /* PHY */
-static int lan743x_phy_reset(struct lan743x_adapter *adapter)
+static int lan743x_hw_reset_phy(struct lan743x_adapter *adapter)
 {
 	u32 data;
 
@@ -944,7 +944,7 @@ static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
 
 static int lan743x_phy_init(struct lan743x_adapter *adapter)
 {
-	return lan743x_phy_reset(adapter);
+	return lan743x_hw_reset_phy(adapter);
 }
 
 static void lan743x_phy_link_status_change(struct net_device *netdev)
-- 
2.39.5



