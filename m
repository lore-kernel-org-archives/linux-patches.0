Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6072E5B09;
	Tue,  8 Jul 2025 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992804; cv=none; b=p/QFXTHa1ttd0nPe5SeVxw8FmUO/9FK6FhADRIy99PxzZQiKW8WO/x9BfncvM4SON35W2DVyMAXGRTCpH4F9/42CXNrSRnZOFefjT1X/yh+/qu9k15c7TqP/mopw6GPjly24oSESrZUUs6bliiHOZDip6rjKF4/EHkh+hMf3NSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992804; c=relaxed/simple;
	bh=XonC8lEnpBBZTipyu5EU4xEnPA3AzMAQftz0RO1Uy0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTBATTw0YjA07ODVfwrwZfx4wfdZen+rB5luk447qNZZWWpIc5of2ONCYD2TkgOFMLgZ5k2BnX7TDk3/j/PWTWpLN8ZWm6p3bRkmoKanLSZVh5J4tOXG77WynJ33+rAZr3SrkM4EvDj9VblwzLEmiet6VVUqKo/loQ6363F+3Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0D3/JPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0D3/JPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543B3C4CEED;
	Tue,  8 Jul 2025 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992804;
	bh=XonC8lEnpBBZTipyu5EU4xEnPA3AzMAQftz0RO1Uy0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0D3/JPYl7BxUhW62wuYwwhc9/R9f/NIIOXFMjt5HZ4m5yGwM5KxrSFsYB/INf/N4
	 Jm8m02zU52zQwx+thYJYn3NPVzvipKJmKJcKPPYbX1Wqvy8zIuWnPTmp9kKXHxYDFa
	 EHr7jHQZIgLVCC4ft5XhW+zHkNnx6gy4OJ6CJvDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/232] amd-xgbe: align CL37 AN sequence as per databook
Date: Tue,  8 Jul 2025 18:21:22 +0200
Message-ID: <20250708162243.700048971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 42fd432fe6d320323215ebdf4de4d0d7e56e6792 ]

Update the Clause 37 Auto-Negotiation implementation to properly align
with the PCS hardware specifications:
- Fix incorrect bit settings in Link Status and Link Duplex fields
- Implement missing sequence steps 2 and 7

These changes ensure CL37 auto-negotiation protocol follows the exact
sequence patterns as specified in the hardware databook.

Fixes: 1bf40ada6290 ("amd-xgbe: Add support for clause 37 auto-negotiation")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Link: https://patch.msgid.link/20250630192636.3838291-1-Raju.Rangoju@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 2 ++
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   | 9 +++++++++
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 4 ++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index 3b70f67376331..aa25a8a0a106f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1373,6 +1373,8 @@
 #define MDIO_VEND2_CTRL1_SS13		BIT(13)
 #endif
 
+#define XGBE_VEND2_MAC_AUTO_SW		BIT(9)
+
 /* MDIO mask values */
 #define XGBE_AN_CL73_INT_CMPLT		BIT(0)
 #define XGBE_AN_CL73_INC_LINK		BIT(1)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 07f4f3418d018..3316c719f9f8c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -375,6 +375,10 @@ static void xgbe_an37_set(struct xgbe_prv_data *pdata, bool enable,
 		reg |= MDIO_VEND2_CTRL1_AN_RESTART;
 
 	XMDIO_WRITE(pdata, MDIO_MMD_VEND2, MDIO_CTRL1, reg);
+
+	reg = XMDIO_READ(pdata, MDIO_MMD_VEND2, MDIO_PCS_DIG_CTRL);
+	reg |= XGBE_VEND2_MAC_AUTO_SW;
+	XMDIO_WRITE(pdata, MDIO_MMD_VEND2, MDIO_PCS_DIG_CTRL, reg);
 }
 
 static void xgbe_an37_restart(struct xgbe_prv_data *pdata)
@@ -1003,6 +1007,11 @@ static void xgbe_an37_init(struct xgbe_prv_data *pdata)
 
 	netif_dbg(pdata, link, pdata->netdev, "CL37 AN (%s) initialized\n",
 		  (pdata->an_mode == XGBE_AN_MODE_CL37) ? "BaseX" : "SGMII");
+
+	reg = XMDIO_READ(pdata, MDIO_MMD_AN, MDIO_CTRL1);
+	reg &= ~MDIO_AN_CTRL1_ENABLE;
+	XMDIO_WRITE(pdata, MDIO_MMD_AN, MDIO_CTRL1, reg);
+
 }
 
 static void xgbe_an73_init(struct xgbe_prv_data *pdata)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index ed5d43c16d0e2..7526a0906b391 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -292,12 +292,12 @@
 #define XGBE_LINK_TIMEOUT		5
 #define XGBE_KR_TRAINING_WAIT_ITER	50
 
-#define XGBE_SGMII_AN_LINK_STATUS	BIT(1)
+#define XGBE_SGMII_AN_LINK_DUPLEX	BIT(1)
 #define XGBE_SGMII_AN_LINK_SPEED	(BIT(2) | BIT(3))
 #define XGBE_SGMII_AN_LINK_SPEED_10	0x00
 #define XGBE_SGMII_AN_LINK_SPEED_100	0x04
 #define XGBE_SGMII_AN_LINK_SPEED_1000	0x08
-#define XGBE_SGMII_AN_LINK_DUPLEX	BIT(4)
+#define XGBE_SGMII_AN_LINK_STATUS	BIT(4)
 
 /* ECC correctable error notification window (seconds) */
 #define XGBE_ECC_LIMIT			60
-- 
2.39.5



