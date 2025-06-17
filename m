Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACB2F94B2;
	Tue, 17 Jun 2025 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177671; cv=none; b=P0sv3lC9XrY8DakGj7Q+a06UJhYju8HIrr+1YMd7DMPCn9GoBWE3OZQL6SIV/hAUKNW1G/NOWMoQakpFqgaHccmX49kcSRLkptUTro3+9FIlaWRqiRhfFDASV4UABEKMnatcS2gy4DxEU1W9e/AQ0sxqYnLa7Ez5VwYk5GXd5f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177671; c=relaxed/simple;
	bh=dKEV5BToBJya2/Z+9kgozc0cggKe7d3Eth2MUtSXFKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2Qe3dZRQbRdeaQvELVsnweg6Ej1pzCspias5zZL3A3k2wi96vjKNKIP+fqVez6M7vkK0oZfAcF9peJwl6wCR5w1Z0ojenVQeLNJQl8TVg8laF8lwE27RJJt9GD0YJ2dfqaPqezIIyMeQqleqw4mQR6S2kgMLe+OT1q8a+1lhXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQ6xtIG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQ6xtIG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B52FC4CEE3;
	Tue, 17 Jun 2025 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177671;
	bh=dKEV5BToBJya2/Z+9kgozc0cggKe7d3Eth2MUtSXFKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQ6xtIG1/oQE2ONdcRrYTgGNS39bdYt7y6sVyJf/pL5S83KERNVE3Upyudra8dgvL
	 HlzJX8xzVTdkfS/NGOVOMGULa6SkPrXONhQlHwAZws+sqI9iAl7Cnlnv/IQg/UbZc7
	 upcq2D7rq+jc0X7F39d4JLTQuqd19xJy1gInOvSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 330/780] net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy
Date: Tue, 17 Jun 2025 17:20:38 +0200
Message-ID: <20250617152504.890971017@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a70b88037a208..da5bd54208dd5 100644
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



