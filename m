Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5B44C10CB;
	Thu, 17 Sep 2026 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659176; cv=none; b=Kvv/F5sYCXoDsswuCudenzuS8qZkoGySfsE5pUKBxcrvcpse9hYohilLb7fcObIPaxXSwXJxx90Zb6TZI0BDI+g6AS1qMbkVZ5yhyXe09BjvsnNPebeRxzfcevE7DLiSgEDOUv/xaSuKox1efRlZb1Y7ZJXfXo4JaRkJPLRSlAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659176; c=relaxed/simple;
	bh=CLLT0UDk5IOHwC80v0SFUq09tKILlW581aMje8vNFMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5IcH5LVv94vukkfNBLd1WRZoOMeVGV3YmJDpZX8I8qk90sD6j7qE0AFxW3fEdCTVLvm7/Os2kyiku33G6YNUtXIvNiWuIF5dpjDxLyMhyMr2n+KezSvog0yZilPEeEbm7WnhqRci1ld41tJQ1GOBYrPsrpJYMb3bR+x2VwGgvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxF9lLvh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxF9lLvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EFA1F00898;
	Thu, 17 Sep 2026 15:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659167;
	bh=gpfZIfRPuN4L3+co7QhjXWVKfIlDuMb10msc2vQJUM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxF9lLvhKnkDsjFSEVZyi2a48FHQlYCZcar7/DkZ2+Y56S3/wkwsJtBN87j9pWWpS
	 wOAutXTHHCZvVDhs+HU64uMUOWgMkCyUTevfegaR/SjmBrRWetFdeIWoY1J3gTAQsn
	 0MX14YQSvp2qZ00XeP1QKZe79pF7+CJgkp/EgTFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Ciprian Regus <ciprian.regus@analog.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 127/733] net: ethernet: oa_tc6: Export standard defined registers
Date: Thu, 17 Sep 2026 16:07:15 +0100
Message-ID: <20260917151354.184726266@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ciprian Regus <ciprian.regus@analog.com>

[ Upstream commit 9210d402bdf54240b8aec9815b2f9aad360fcb42 ]

Move defines for standard Open Alliance TC6 register addresses and
subfields in the oa_tc6's header. As such, other ethernet drivers
that rely on oa_tc6 can use them directly.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ciprian Regus <ciprian.regus@analog.com>
Link: https://patch.msgid.link/20260708-adin1140-driver-v5-5-4aca7b51a58b@analog.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 5443d9c4f55d ("net: ethernet: oa_tc6: Protect skb pointer used by two different kernel instances")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 50 -----------------------------------
 include/linux/oa_tc6.h        | 50 +++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index 8b96558834960..88fc8456bd64e 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -12,47 +12,6 @@
 #include <linux/phy.h>
 #include <linux/oa_tc6.h>
 
-/* OPEN Alliance TC6 registers */
-/* Standard Capabilities Register */
-#define OA_TC6_REG_STDCAP			0x0002
-#define STDCAP_DIRECT_PHY_REG_ACCESS		BIT(8)
-
-/* Reset Control and Status Register */
-#define OA_TC6_REG_RESET			0x0003
-#define RESET_SWRESET				BIT(0)	/* Software Reset */
-
-/* Configuration Register #0 */
-#define OA_TC6_REG_CONFIG0			0x0004
-#define CONFIG0_SYNC				BIT(15)
-#define CONFIG0_ZARFE_ENABLE			BIT(12)
-#define CONFIG0_PROTE				BIT(5)
-
-/* Status Register #0 */
-#define OA_TC6_REG_STATUS0			0x0008
-#define STATUS0_RESETC				BIT(6)	/* Reset Complete */
-#define STATUS0_HEADER_ERROR			BIT(5)
-#define STATUS0_LOSS_OF_FRAME_ERROR		BIT(4)
-#define STATUS0_RX_BUFFER_OVERFLOW_ERROR	BIT(3)
-#define STATUS0_TX_PROTOCOL_ERROR		BIT(0)
-
-/* Buffer Status Register */
-#define OA_TC6_REG_BUFFER_STATUS		0x000B
-#define BUFFER_STATUS_TX_CREDITS_AVAILABLE	GENMASK(15, 8)
-#define BUFFER_STATUS_RX_CHUNKS_AVAILABLE	GENMASK(7, 0)
-
-/* Interrupt Mask Register #0 */
-#define OA_TC6_REG_INT_MASK0			0x000C
-#define INT_MASK0_HEADER_ERR_MASK		BIT(5)
-#define INT_MASK0_LOSS_OF_FRAME_ERR_MASK	BIT(4)
-#define INT_MASK0_RX_BUFFER_OVERFLOW_ERR_MASK	BIT(3)
-#define INT_MASK0_TX_PROTOCOL_ERR_MASK		BIT(0)
-#define INT_MASK0_ALL_INTERRUPTS                (GENMASK(5, 0) | \
-						 GENMASK(12, 7))
-
-/* PHY Clause 22 registers base address and mask */
-#define OA_TC6_PHY_STD_REG_ADDR_BASE		0xFF00
-#define OA_TC6_PHY_STD_REG_ADDR_MASK		0x1F
-
 /* Control command header */
 #define OA_TC6_CTRL_HEADER_DATA_NOT_CTRL	BIT(31)
 #define OA_TC6_CTRL_HEADER_WRITE_NOT_READ	BIT(29)
@@ -82,15 +41,6 @@
 #define OA_TC6_DATA_FOOTER_END_BYTE_OFFSET	GENMASK(13, 8)
 #define OA_TC6_DATA_FOOTER_TX_CREDITS		GENMASK(5, 1)
 
-/* PHY – Clause 45 registers memory map selector (MMS) as per table 6 in the
- * OPEN Alliance specification.
- */
-#define OA_TC6_PHY_C45_PCS_MMS2			2	/* MMD 3 */
-#define OA_TC6_PHY_C45_PMA_PMD_MMS3		3	/* MMD 1 */
-#define OA_TC6_PHY_C45_VS_PLCA_MMS4		4	/* MMD 31 */
-#define OA_TC6_PHY_C45_AUTO_NEG_MMS5		5	/* MMD 7 */
-#define OA_TC6_PHY_C45_POWER_UNIT_MMS6		6	/* MMD 13 */
-
 #define OA_TC6_CTRL_PROT_REPLY_SIZE		4
 #define OA_TC6_CTRL_HEADER_SIZE			4
 #define OA_TC6_CTRL_REG_VALUE_SIZE		4
diff --git a/include/linux/oa_tc6.h b/include/linux/oa_tc6.h
index 15f58e3c56c74..97c6ed0bf34df 100644
--- a/include/linux/oa_tc6.h
+++ b/include/linux/oa_tc6.h
@@ -10,6 +10,56 @@
 #include <linux/etherdevice.h>
 #include <linux/spi/spi.h>
 
+/* OPEN Alliance TC6 registers */
+/* Standard Capabilities Register */
+#define OA_TC6_REG_STDCAP			0x0002
+#define STDCAP_DIRECT_PHY_REG_ACCESS		BIT(8)
+
+/* Reset Control and Status Register */
+#define OA_TC6_REG_RESET			0x0003
+#define RESET_SWRESET				BIT(0)	/* Software Reset */
+
+/* Configuration Register #0 */
+#define OA_TC6_REG_CONFIG0			0x0004
+#define CONFIG0_SYNC				BIT(15)
+#define CONFIG0_ZARFE_ENABLE			BIT(12)
+#define CONFIG0_PROTE				BIT(5)
+
+/* Status Register #0 */
+#define OA_TC6_REG_STATUS0			0x0008
+#define STATUS0_RESETC				BIT(6)	/* Reset Complete */
+#define STATUS0_HEADER_ERROR			BIT(5)
+#define STATUS0_LOSS_OF_FRAME_ERROR		BIT(4)
+#define STATUS0_RX_BUFFER_OVERFLOW_ERROR	BIT(3)
+#define STATUS0_TX_PROTOCOL_ERROR		BIT(0)
+
+/* Buffer Status Register */
+#define OA_TC6_REG_BUFFER_STATUS		0x000B
+#define BUFFER_STATUS_TX_CREDITS_AVAILABLE	GENMASK(15, 8)
+#define BUFFER_STATUS_RX_CHUNKS_AVAILABLE	GENMASK(7, 0)
+
+/* Interrupt Mask Register #0 */
+#define OA_TC6_REG_INT_MASK0			0x000C
+#define INT_MASK0_HEADER_ERR_MASK		BIT(5)
+#define INT_MASK0_LOSS_OF_FRAME_ERR_MASK	BIT(4)
+#define INT_MASK0_RX_BUFFER_OVERFLOW_ERR_MASK	BIT(3)
+#define INT_MASK0_TX_PROTOCOL_ERR_MASK		BIT(0)
+#define INT_MASK0_ALL_INTERRUPTS                (GENMASK(5, 0) | \
+						 GENMASK(12, 7))
+
+/* PHY Clause 22 registers base address and mask */
+#define OA_TC6_PHY_STD_REG_ADDR_BASE		0xFF00
+#define OA_TC6_PHY_STD_REG_ADDR_MASK		0x1F
+
+/* PHY – Clause 45 registers memory map selector (MMS) as per table 6 in the
+ * OPEN Alliance specification.
+ */
+#define OA_TC6_PHY_C45_PCS_MMS2			2	/* MMD 3 */
+#define OA_TC6_PHY_C45_PMA_PMD_MMS3		3	/* MMD 1 */
+#define OA_TC6_PHY_C45_VS_PLCA_MMS4		4	/* MMD 31 */
+#define OA_TC6_PHY_C45_AUTO_NEG_MMS5		5	/* MMD 7 */
+#define OA_TC6_PHY_C45_POWER_UNIT_MMS6		6	/* MMD 13 */
+
 struct oa_tc6;
 
 struct oa_tc6 *oa_tc6_init(struct spi_device *spi, struct net_device *netdev);
-- 
2.53.0



