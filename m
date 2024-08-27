Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C017C96;
	Tue, 27 Aug 2024 15:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772017; cv=none; b=WGwDSOuJBmpF1s2/UDGTUc7AEQ4bmMLWj7x7DHEGmiQp5OjenRwmr7lPEiXGMprJBukR0vtVnSIhc3VruFOZ299ns1oqtcGV5ZV80F8SoywGBce/Ni7GumpDTs6R2MSmEDIVwsVX4OGdcGh45QKVHHsQnQKmEo9Mb4el+YqMhsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772017; c=relaxed/simple;
	bh=xyXp17R8ZThLDgeNEpgcf4ydMCYBErxzGQm7FeifqW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka9byVog5Mace0cpKnS8zkUpv21L7R+tAjEsovb5PVXsmgB6L9n2abr+kytqhbFvVZZcNMvAGKF3vgKknzT/xJWZQxnk+m+A9MMmGwGYe/m/dEoJSXpYTRZzZJVdWQZ5YKohTW+7oTwdQuwKL28nXaCmvhs/DNzGEnjTnTy+4PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVDn12Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVDn12Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB460C4DDEB;
	Tue, 27 Aug 2024 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772017;
	bh=xyXp17R8ZThLDgeNEpgcf4ydMCYBErxzGQm7FeifqW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVDn12UrL0zBv+unImGe1ABS8cG9mGMkQtYmkKPvWThJjOqNMqy7vyba17R7KFdx6
	 2SQuGHiO6Q+F1MDnBOoctYl0gYEXLZ6d6kjrOIeV+VyCHB/keKtS9C6gKRMZuckg15
	 59Usm6CBmBspJgKfmC0KBi6yyrRqV4tdknmO2HBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/321] net: axienet: Fix register defines comment description
Date: Tue, 27 Aug 2024 16:36:36 +0200
Message-ID: <20240827143841.589496628@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 9ff2f816e2aa65ca9a1cdf0954842f8173c0f48d ]

In axiethernet header fix register defines comment description to be
inline with IP documentation. It updates MAC configuration register,
MDIO configuration register and frame filter control description.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 6370c447ac5ca..969bea5541976 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -159,16 +159,16 @@
 #define XAE_RCW1_OFFSET		0x00000404 /* Rx Configuration Word 1 */
 #define XAE_TC_OFFSET		0x00000408 /* Tx Configuration */
 #define XAE_FCC_OFFSET		0x0000040C /* Flow Control Configuration */
-#define XAE_EMMC_OFFSET		0x00000410 /* EMAC mode configuration */
-#define XAE_PHYC_OFFSET		0x00000414 /* RGMII/SGMII configuration */
+#define XAE_EMMC_OFFSET		0x00000410 /* MAC speed configuration */
+#define XAE_PHYC_OFFSET		0x00000414 /* RX Max Frame Configuration */
 #define XAE_ID_OFFSET		0x000004F8 /* Identification register */
-#define XAE_MDIO_MC_OFFSET	0x00000500 /* MII Management Config */
-#define XAE_MDIO_MCR_OFFSET	0x00000504 /* MII Management Control */
-#define XAE_MDIO_MWD_OFFSET	0x00000508 /* MII Management Write Data */
-#define XAE_MDIO_MRD_OFFSET	0x0000050C /* MII Management Read Data */
+#define XAE_MDIO_MC_OFFSET	0x00000500 /* MDIO Setup */
+#define XAE_MDIO_MCR_OFFSET	0x00000504 /* MDIO Control */
+#define XAE_MDIO_MWD_OFFSET	0x00000508 /* MDIO Write Data */
+#define XAE_MDIO_MRD_OFFSET	0x0000050C /* MDIO Read Data */
 #define XAE_UAW0_OFFSET		0x00000700 /* Unicast address word 0 */
 #define XAE_UAW1_OFFSET		0x00000704 /* Unicast address word 1 */
-#define XAE_FMI_OFFSET		0x00000708 /* Filter Mask Index */
+#define XAE_FMI_OFFSET		0x00000708 /* Frame Filter Control */
 #define XAE_AF0_OFFSET		0x00000710 /* Address Filter 0 */
 #define XAE_AF1_OFFSET		0x00000714 /* Address Filter 1 */
 
@@ -307,7 +307,7 @@
  */
 #define XAE_UAW1_UNICASTADDR_MASK	0x0000FFFF
 
-/* Bit masks for Axi Ethernet FMI register */
+/* Bit masks for Axi Ethernet FMC register */
 #define XAE_FMI_PM_MASK			0x80000000 /* Promis. mode enable */
 #define XAE_FMI_IND_MASK		0x00000003 /* Index Mask */
 
-- 
2.43.0



