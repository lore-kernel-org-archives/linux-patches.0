Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114131714B7;
	Tue,  8 Jul 2025 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992335; cv=none; b=FOy/DaC6krzITK5e85+OhWtdhj+VwXk/tBXyGH2bOJvBY8Hsctoh/L3sYauxYB9gIeL/QZHI8iSnC4uFkJV9dwqTnVcKRbkGPt2Y2Di0kGODExcqan5meaR1csTVIJCmb9e2jSs+y5a+qUBpYdUT2DW/LBf31ib7c3etd1GYq9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992335; c=relaxed/simple;
	bh=mIG8fdPWVxPW4GBGpbcyhLRNGgcbjmdg5wAIuO2BzyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyOL159fvCaF5jeT4xIw2YGKr+XdsAPS04OfHCd4UdSU4EA02opJ9wtkT4HnKzvMaorZQ9BLbt4LnntA3btSEOtWqSfkiQZZvVJbZktNtrcr8toSOipLB4UGI+SqJJV8l27kj/3USs2SrSV6duBD80YqH3WmODYsbasdZuInNoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdAN6bSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdAN6bSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CA4C4CEED;
	Tue,  8 Jul 2025 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992334;
	bh=mIG8fdPWVxPW4GBGpbcyhLRNGgcbjmdg5wAIuO2BzyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdAN6bShP8/CLkO7bhbtXupL+r9u2Vj2k75Y8nY6koPkV3eA+wz0R2VSkJk6C6pIv
	 +GyO0+8e7gMqKB3LkzXMMiC7dP2xNeKkWkNQkWTrLtmHm8av+SdGUixMqEYNn3cpiy
	 3Jg3KGlSoJtHAnnhODvp+HGE3IqaCiRJmskgMefI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/132] amd-xgbe: align CL37 AN sequence as per databook
Date: Tue,  8 Jul 2025 18:22:48 +0200
Message-ID: <20250708162232.328001492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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
index 4a2dc705b5280..154e7598a32bf 100644
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
index 173f4dad470f5..a596cd08124fa 100644
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



