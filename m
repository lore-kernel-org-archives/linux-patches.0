Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441762367B0;
	Mon, 23 Jun 2025 13:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685108; cv=none; b=tw9KjepgvRe6GXzrocqp/eiIb5yN46+OqDEA/bVln2XzEo8g8oTBIWcO9I1oVL+cnXdmB1acMFGl6F5kAdCZy562oEtGwnph8EqmMKW0sSGyhmQZRfsnSqk2suWNO7KG9oohTkYh2O2SwOyGOmXlWZq1JsvhTnTt4JNtRTXnUK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685108; c=relaxed/simple;
	bh=PfMjCBijlM5tc5bV/nR6PAu0OmVjpgYSoT8hfEQTxs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmWHUFWWyDItcOQK68M+PmFrT/x/OdkzcMEZeIGN26bcqkqHe+P30nVFOjDkAm5p00dLM/056KDXEz1xaCmwoDyiYHRtArlYvIruogAmyKvPo/q1gKPjahzeBzAQ4cp8WIUNIwBPCjDiogGYoMqx9lZPC6ZvRduhLG/5nE27Ea0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWxxahvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWxxahvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD399C4CEEA;
	Mon, 23 Jun 2025 13:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685108;
	bh=PfMjCBijlM5tc5bV/nR6PAu0OmVjpgYSoT8hfEQTxs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWxxahvusfzdfr/VTkKPXTD0MCocBEV8DhqmKfNYv9HM03d1/vE3WWIbRMv/vrxaU
	 ZyFYYKE2x3HC/wzjGU+WVBG6npR0O6fWNgrsC9cBtQq9YDrr7Z89dLl84jwY9C2ZwE
	 XkTd4U5/gZ4qryS8K6jjFFGvtXX3MwiUIYi5mqvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/355] net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy
Date: Mon, 23 Jun 2025 15:04:15 +0200
Message-ID: <20250623130628.454687226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0f490a907573..26a230c60efb7 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -918,7 +918,7 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
 }
 
 /* PHY */
-static int lan743x_phy_reset(struct lan743x_adapter *adapter)
+static int lan743x_hw_reset_phy(struct lan743x_adapter *adapter)
 {
 	u32 data;
 
@@ -952,7 +952,7 @@ static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
 
 static int lan743x_phy_init(struct lan743x_adapter *adapter)
 {
-	return lan743x_phy_reset(adapter);
+	return lan743x_hw_reset_phy(adapter);
 }
 
 static void lan743x_phy_link_status_change(struct net_device *netdev)
-- 
2.39.5



