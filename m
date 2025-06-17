Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB2A2CCC5;
	Tue, 17 Jun 2025 16:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176226; cv=none; b=kerFuHAeMCtBI9cbDHmWrE+go2uSInpF6NE4AC8fE1nqW75nJ6RIABM3oGE7va2PWPyAqyIgZeLXjTmG9kHyPQ/jTn3ZWP4ixZ7RaZBCIdVxzeLys8JzaUWOQFnzSNbw+vu/+n3lZRN9yt1fghiARIq6csAR0dnkMzaMSLTgPHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176226; c=relaxed/simple;
	bh=X0SXelOt1ki/g9LXlrGiNzaj8Trw/CVUSOTLRsglKes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wqj2lDhmXQUzdGQOqMeI9MQBHMagz9KtIDSpdm0vg4iXsdWxifkU/qZh0pUO3OP5BOkMthvGLAmnXB97z0Syt9zjc+nJfVrsUe5UqzDMGYDfV9unUDxsn2TewwrP+h9qf4R4EsMCBUOwSDWris8/JHP7gjIWximgiNXFMf5s/po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StJX3+89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StJX3+89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD1CC4CEE3;
	Tue, 17 Jun 2025 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176226;
	bh=X0SXelOt1ki/g9LXlrGiNzaj8Trw/CVUSOTLRsglKes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StJX3+89sPcYiBbZ3cpG+nkFYbn0oSdZZxsnqyaqL7IU0Fzz+vUmy9AvprZucwmnD
	 PXSFtgaK/7mLIjyR+5WTMXFAHEMcgAIdhlJR87xPok4QVg5B+BXm8fBfgY2AG7JoQp
	 msM19eLNLQvUdqGab9Dp/l0+1ONJ09sW5liFqVwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/512] net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy
Date: Tue, 17 Jun 2025 17:22:54 +0200
Message-ID: <20250617152428.060122419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 812ad9d61676a..8d53a35a2b561 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1330,7 +1330,7 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
 }
 
 /* PHY */
-static int lan743x_phy_reset(struct lan743x_adapter *adapter)
+static int lan743x_hw_reset_phy(struct lan743x_adapter *adapter)
 {
 	u32 data;
 
@@ -1348,7 +1348,7 @@ static int lan743x_phy_reset(struct lan743x_adapter *adapter)
 
 static int lan743x_phy_init(struct lan743x_adapter *adapter)
 {
-	return lan743x_phy_reset(adapter);
+	return lan743x_hw_reset_phy(adapter);
 }
 
 static void lan743x_phy_interface_select(struct lan743x_adapter *adapter)
-- 
2.39.5



