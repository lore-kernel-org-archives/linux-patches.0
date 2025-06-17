Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D9C2ECE80;
	Tue, 17 Jun 2025 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175163; cv=none; b=SY/fioZxz/0eGgubgxQsC7sCpmlxpOBlitNRSokDn3muCuXFPvC+1jvQSuDMs0vy+8sw0ENR5OSay1Gxf7lfFPSS/md1/zc45/WTMsXdZno7XMSpM+Fd1qTZNHJMp04u0H2W4l6fIc93zB/JwJ02lEwFqYAWpsxoQR/7JImHW80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175163; c=relaxed/simple;
	bh=u8GGos/xzkwc7FWUM845t+NcERwOfboI9BKg3jN1dQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFuqfFjuIF/pMvrTFw2S/Az9pFj+xSEf9CD1E3xcNQFH/Yokyyy9gBay/vctpvIoqGzjtl/+ptiBHJvgQupTl73woLKKu+bfctacLefxqN2UDFP66ZvAwvkamtevGiYzwrzBkhdkWmPyHCsm5axbRKK3RqvCnvOrJHruKNKaH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ED9+lOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ED9+lOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A3FC4CEE3;
	Tue, 17 Jun 2025 15:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175163;
	bh=u8GGos/xzkwc7FWUM845t+NcERwOfboI9BKg3jN1dQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ED9+lOyJ1VSdRvxnR2N9mlquoJARm0PQ95Wh7E2kVGnfaXrMDgAT3B8pWUgjlD1P
	 q6lzkIfYvHaE8QhVEkTqE8yGNpgGMD5Y8m3uBWy0Gmh+Ndb9bJU0L3azL/XQvtnfm/
	 HaqEH6qJwyN59zcWGIAXcznFPLWdx9r3z6ZXy2Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/356] net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy
Date: Tue, 17 Jun 2025 17:24:24 +0200
Message-ID: <20250617152344.234263572@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index f971d60484f06..781440d5756f3 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1373,7 +1373,7 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
 }
 
 /* PHY */
-static int lan743x_phy_reset(struct lan743x_adapter *adapter)
+static int lan743x_hw_reset_phy(struct lan743x_adapter *adapter)
 {
 	u32 data;
 
@@ -1407,7 +1407,7 @@ static void lan743x_phy_update_flowcontrol(struct lan743x_adapter *adapter,
 
 static int lan743x_phy_init(struct lan743x_adapter *adapter)
 {
-	return lan743x_phy_reset(adapter);
+	return lan743x_hw_reset_phy(adapter);
 }
 
 static void lan743x_phy_link_status_change(struct net_device *netdev)
-- 
2.39.5



