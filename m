Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D861C4C10C4;
	Thu, 17 Sep 2026 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659176; cv=none; b=C67FhEQ6tAb4QGH9kpS++yaAB+PPjGJZhkc/DugURZVeQVRgcrzi+uzSiEFuv/WxIft8YWoo6asNRpUvoUS9f4+n1TFiT8KJpTJu54AWwz+c56WB9ehjTm5uJsuckD8qoTbsXfj5mawNFFbpQBn+QQEASWJ4ngdDTxgAfkXfHFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659176; c=relaxed/simple;
	bh=KgWNSq26r29WFa6GmokZrk+JnjzVuDprJqPjL+R9+9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h58/8+81LKKTQLZlUR+ous1/YP8bz28vqWusjYOHIQvh7ZcK4nzXgjN3mQtXgnbYWlIWzJW+omULmQWOuND8V/fISiPq4jM5LUjJR21Jz6jqWJ/ypcvEh5FroA2Qw+2F4NQVPCkq88lV+JpoELPaSZ1oP4TCpl9iVexDjUq858Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOirYQMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOirYQMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12FF1F0089C;
	Thu, 17 Sep 2026 15:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659170;
	bh=LvO/ytMgrjq2PGizZuXAbO9eQy21CcjTatI3uxm/Oc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOirYQMRcy/U36v3q0XpDmMUKMFRK0ZxG/4+F9jgAqW6JD3B9CryswePHv3pDoBj2
	 BLGMDmubYAkHeBDCukSoeFhwYPtOTnPn8Er/Q7iCgDEXgn1hfNfDcpbHTCEwv+F/YG
	 bd+VtGb+SebhYO9jO6KGIlx8TGBIr6NWs5bEJreQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Ciprian Regus <ciprian.regus@analog.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 128/733] net: ethernet: oa_tc6: Add the OA_TC6_ prefix to standard registers
Date: Thu, 17 Sep 2026 16:07:16 +0100
Message-ID: <20260917151354.212277605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ciprian Regus <ciprian.regus@analog.com>

[ Upstream commit 31bc75f17c1f5ff989fa896aae3e4e411d9b0b7a ]

The OA TC6 standard registers are currently exported in a header file.
Add the OA_TC6_ prefix to the register address and subfield mask macros
to avoid future naming conflicts.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ciprian Regus <ciprian.regus@analog.com>
Link: https://patch.msgid.link/20260708-adin1140-driver-v5-6-4aca7b51a58b@analog.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 5443d9c4f55d ("net: ethernet: oa_tc6: Protect skb pointer used by two different kernel instances")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 37 ++++++++++++++++----------------
 include/linux/oa_tc6.h        | 40 +++++++++++++++++------------------
 2 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index 88fc8456bd64e..fb219542e90d3 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -395,7 +395,7 @@ static int oa_tc6_check_phy_reg_direct_access_capability(struct oa_tc6 *tc6)
 	if (ret)
 		return ret;
 
-	if (!(regval & STDCAP_DIRECT_PHY_REG_ACCESS))
+	if (!(regval & OA_TC6_STDCAP_DIRECT_PHY_REG_ACCESS))
 		return -ENODEV;
 
 	return 0;
@@ -588,7 +588,7 @@ static int oa_tc6_read_status0(struct oa_tc6 *tc6)
 
 static int oa_tc6_sw_reset_macphy(struct oa_tc6 *tc6)
 {
-	u32 regval = RESET_SWRESET;
+	u32 regval = OA_TC6_RESET_SWRESET;
 	int ret;
 
 	ret = oa_tc6_write_register(tc6, OA_TC6_REG_RESET, regval);
@@ -597,7 +597,7 @@ static int oa_tc6_sw_reset_macphy(struct oa_tc6 *tc6)
 
 	/* Poll for soft reset complete for every 1ms until 1s timeout */
 	ret = readx_poll_timeout(oa_tc6_read_status0, tc6, regval,
-				 regval & STATUS0_RESETC,
+				 regval & OA_TC6_STATUS0_RESETC,
 				 STATUS0_RESETC_POLL_DELAY,
 				 STATUS0_RESETC_POLL_TIMEOUT);
 	if (ret)
@@ -616,10 +616,10 @@ static int oa_tc6_unmask_macphy_error_interrupts(struct oa_tc6 *tc6)
 	if (ret)
 		return ret;
 
-	regval &= ~(INT_MASK0_TX_PROTOCOL_ERR_MASK |
-		    INT_MASK0_RX_BUFFER_OVERFLOW_ERR_MASK |
-		    INT_MASK0_LOSS_OF_FRAME_ERR_MASK |
-		    INT_MASK0_HEADER_ERR_MASK);
+	regval &= ~(OA_TC6_INT_MASK0_TX_PROTOCOL_ERR_MASK |
+		    OA_TC6_INT_MASK0_RX_BUFFER_OVERFLOW_ERR_MASK |
+		    OA_TC6_INT_MASK0_LOSS_OF_FRAME_ERR_MASK |
+		    OA_TC6_INT_MASK0_HEADER_ERR_MASK);
 
 	return oa_tc6_write_register(tc6, OA_TC6_REG_INT_MASK0, regval);
 }
@@ -634,7 +634,7 @@ static int oa_tc6_enable_data_transfer(struct oa_tc6 *tc6)
 		return ret;
 
 	/* Enable configuration synchronization for data transfer */
-	value |= CONFIG0_SYNC;
+	value |= OA_TC6_CONFIG0_SYNC;
 
 	return oa_tc6_write_register(tc6, OA_TC6_REG_CONFIG0, value);
 }
@@ -679,7 +679,7 @@ static void oa_tc6_free_pending_skbs(struct oa_tc6 *tc6)
  */
 static void oa_tc6_disable_traffic(struct oa_tc6 *tc6)
 {
-	u32 regval = INT_MASK0_ALL_INTERRUPTS;
+	u32 regval = OA_TC6_INT_MASK0_ALL_INTERRUPTS;
 
 	tc6->disable_traffic = true;
 	oa_tc6_free_pending_skbs(tc6);
@@ -709,25 +709,25 @@ static int oa_tc6_process_extended_status(struct oa_tc6 *tc6)
 		return ret;
 	}
 
-	if (FIELD_GET(STATUS0_RX_BUFFER_OVERFLOW_ERROR, value)) {
+	if (FIELD_GET(OA_TC6_STATUS0_RX_BUFFER_OVERFLOW_ERROR, value)) {
 		tc6->rx_buf_overflow = true;
 		oa_tc6_cleanup_ongoing_rx_skb(tc6);
 		net_err_ratelimited("%s: Receive buffer overflow error\n",
 				    tc6->netdev->name);
 		return -EAGAIN;
 	}
-	if (FIELD_GET(STATUS0_TX_PROTOCOL_ERROR, value)) {
+	if (FIELD_GET(OA_TC6_STATUS0_TX_PROTOCOL_ERROR, value)) {
 		netdev_err(tc6->netdev, "Transmit protocol error\n");
 		return -ENODEV;
 	}
 	/* TODO: Currently loss of frame and header errors are treated as
 	 * non-recoverable errors. They will be handled in the next version.
 	 */
-	if (FIELD_GET(STATUS0_LOSS_OF_FRAME_ERROR, value)) {
+	if (FIELD_GET(OA_TC6_STATUS0_LOSS_OF_FRAME_ERROR, value)) {
 		netdev_err(tc6->netdev, "Loss of frame error\n");
 		return -ENODEV;
 	}
-	if (FIELD_GET(STATUS0_HEADER_ERROR, value)) {
+	if (FIELD_GET(OA_TC6_STATUS0_HEADER_ERROR, value)) {
 		netdev_err(tc6->netdev, "Header error\n");
 		return -ENODEV;
 	}
@@ -1174,9 +1174,10 @@ static int oa_tc6_update_buffer_status_from_register(struct oa_tc6 *tc6)
 	if (ret)
 		return ret;
 
-	tc6->tx_credits = FIELD_GET(BUFFER_STATUS_TX_CREDITS_AVAILABLE, value);
-	tc6->rx_chunks_available = FIELD_GET(BUFFER_STATUS_RX_CHUNKS_AVAILABLE,
-					     value);
+	tc6->tx_credits = FIELD_GET(OA_TC6_BUFFER_STATUS_TX_CREDITS_AVAILABLE,
+				    value);
+	tc6->rx_chunks_available =
+		FIELD_GET(OA_TC6_BUFFER_STATUS_RX_CHUNKS_AVAILABLE, value);
 
 	return 0;
 }
@@ -1220,7 +1221,7 @@ int oa_tc6_zero_align_receive_frame_enable(struct oa_tc6 *tc6)
 		return ret;
 
 	/* Set Zero-Align Receive Frame Enable */
-	regval |= CONFIG0_ZARFE_ENABLE;
+	regval |= OA_TC6_CONFIG0_ZARFE_ENABLE;
 
 	return oa_tc6_write_register(tc6, OA_TC6_REG_CONFIG0, regval);
 }
@@ -1268,7 +1269,7 @@ static int oa_tc6_check_ctrl_protection(struct oa_tc6 *tc6)
 	if (ret)
 		return ret;
 
-	tc6->prot_ctrl = FIELD_GET(CONFIG0_PROTE, regval);
+	tc6->prot_ctrl = FIELD_GET(OA_TC6_CONFIG0_PROTE, regval);
 
 	return 0;
 }
diff --git a/include/linux/oa_tc6.h b/include/linux/oa_tc6.h
index 97c6ed0bf34df..71cffcb041b1c 100644
--- a/include/linux/oa_tc6.h
+++ b/include/linux/oa_tc6.h
@@ -13,39 +13,39 @@
 /* OPEN Alliance TC6 registers */
 /* Standard Capabilities Register */
 #define OA_TC6_REG_STDCAP			0x0002
-#define STDCAP_DIRECT_PHY_REG_ACCESS		BIT(8)
+#define OA_TC6_STDCAP_DIRECT_PHY_REG_ACCESS	BIT(8)
 
 /* Reset Control and Status Register */
 #define OA_TC6_REG_RESET			0x0003
-#define RESET_SWRESET				BIT(0)	/* Software Reset */
+#define OA_TC6_RESET_SWRESET			BIT(0)	/* Software Reset */
 
 /* Configuration Register #0 */
 #define OA_TC6_REG_CONFIG0			0x0004
-#define CONFIG0_SYNC				BIT(15)
-#define CONFIG0_ZARFE_ENABLE			BIT(12)
-#define CONFIG0_PROTE				BIT(5)
+#define OA_TC6_CONFIG0_SYNC			BIT(15)
+#define OA_TC6_CONFIG0_ZARFE_ENABLE		BIT(12)
+#define OA_TC6_CONFIG0_PROTE			BIT(5)
 
 /* Status Register #0 */
 #define OA_TC6_REG_STATUS0			0x0008
-#define STATUS0_RESETC				BIT(6)	/* Reset Complete */
-#define STATUS0_HEADER_ERROR			BIT(5)
-#define STATUS0_LOSS_OF_FRAME_ERROR		BIT(4)
-#define STATUS0_RX_BUFFER_OVERFLOW_ERROR	BIT(3)
-#define STATUS0_TX_PROTOCOL_ERROR		BIT(0)
+#define OA_TC6_STATUS0_RESETC			BIT(6)	/* Reset Complete */
+#define OA_TC6_STATUS0_HEADER_ERROR		BIT(5)
+#define OA_TC6_STATUS0_LOSS_OF_FRAME_ERROR	BIT(4)
+#define OA_TC6_STATUS0_RX_BUFFER_OVERFLOW_ERROR	BIT(3)
+#define OA_TC6_STATUS0_TX_PROTOCOL_ERROR	BIT(0)
 
 /* Buffer Status Register */
-#define OA_TC6_REG_BUFFER_STATUS		0x000B
-#define BUFFER_STATUS_TX_CREDITS_AVAILABLE	GENMASK(15, 8)
-#define BUFFER_STATUS_RX_CHUNKS_AVAILABLE	GENMASK(7, 0)
+#define OA_TC6_REG_BUFFER_STATUS			0x000B
+#define OA_TC6_BUFFER_STATUS_TX_CREDITS_AVAILABLE	GENMASK(15, 8)
+#define OA_TC6_BUFFER_STATUS_RX_CHUNKS_AVAILABLE	GENMASK(7, 0)
 
 /* Interrupt Mask Register #0 */
-#define OA_TC6_REG_INT_MASK0			0x000C
-#define INT_MASK0_HEADER_ERR_MASK		BIT(5)
-#define INT_MASK0_LOSS_OF_FRAME_ERR_MASK	BIT(4)
-#define INT_MASK0_RX_BUFFER_OVERFLOW_ERR_MASK	BIT(3)
-#define INT_MASK0_TX_PROTOCOL_ERR_MASK		BIT(0)
-#define INT_MASK0_ALL_INTERRUPTS                (GENMASK(5, 0) | \
-						 GENMASK(12, 7))
+#define OA_TC6_REG_INT_MASK0				0x000C
+#define OA_TC6_INT_MASK0_HEADER_ERR_MASK		BIT(5)
+#define OA_TC6_INT_MASK0_LOSS_OF_FRAME_ERR_MASK		BIT(4)
+#define OA_TC6_INT_MASK0_RX_BUFFER_OVERFLOW_ERR_MASK	BIT(3)
+#define OA_TC6_INT_MASK0_TX_PROTOCOL_ERR_MASK		BIT(0)
+#define OA_TC6_INT_MASK0_ALL_INTERRUPTS                 (GENMASK(5, 0) | \
+							 GENMASK(12, 7))
 
 /* PHY Clause 22 registers base address and mask */
 #define OA_TC6_PHY_STD_REG_ADDR_BASE		0xFF00
-- 
2.53.0



