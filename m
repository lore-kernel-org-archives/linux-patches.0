Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DC844C93;
	Sun,  1 Sep 2024 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209914; cv=none; b=RnRdhNacYwlDVua2BQzK8xPJt5qCTue66/cBejKx10ILMIptxLwAgkinq82ptlSRCKGBrikzmF7sxaZ6FvHycYhMSuc53zgvSJ1JcwWhQ0EsTm5TVuyfOzQEytNbG14KICk8vvNGLpDjt28L7XnV4ODenBtvJ0yC1wVxIcsbLMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209914; c=relaxed/simple;
	bh=xzQqqrlBOAmrcBbjLzBcXtTK0+Rx2XV8BW1SPZ1CEiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=br985LVSw1UMBS7xECOkvrRox1WyJnyawAtIGk0Xx8TeeNh6vBm/9/h7YuZOsWrxFmxxt9gNZbWeU5Byg4xPlCgIShtCL2oo1C9SbRSJ+5VCae0k9VmYNPm3i89irdYkyDWX0rH8dGf0cK2uScHVIcY3yxZS47QoHnV8pNhWtNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apOB806u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apOB806u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D025DC4CEC3;
	Sun,  1 Sep 2024 16:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209914;
	bh=xzQqqrlBOAmrcBbjLzBcXtTK0+Rx2XV8BW1SPZ1CEiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apOB806uAhZXLgePjJO7JTBdusSta1Q5b/pRtzIIyWNbNzQrFTCNPd43Ei7s76Zrd
	 YnOIpP3Dq39lvMNTS3YfaDpGF1i4BXN0LZP5fhQhTmUwPmE8f/l1O9mqvcf5X6MG4u
	 3DVFqwnZQxVovvDgZ6Jh5rwygYdCstvqd3ABqkHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/215] net: axienet: Fix register defines comment description
Date: Sun,  1 Sep 2024 18:15:42 +0200
Message-ID: <20240901160824.403063013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5b4d153b1492c..cbf637078c38a 100644
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



