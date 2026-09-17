Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C863AFB01;
	Thu, 17 Sep 2026 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665346; cv=none; b=q+7v7cBjg6DrV8lezU0G2qTOwMgeEnMQTOblvmb6ujbAtQNb4ELbtLiTxaUu3zqaEne+hp4HRyVpVrGAod2iyZejXQS0QNvZWFOalz965utNoaLNsbfHL08DQQdgeEaCaPQQC6UMVTSZ+TigKpvdSConC+hc8x7nbqsGT3poqj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665346; c=relaxed/simple;
	bh=hQb0qOZgIAoyK8oIyOGLg5j2oWS3ElbEdxqdom9LtEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sF+kCWID3y5G2JG2k1jSX+3jU7pU2JmJDiVAPy9INA0gA4nROKW/+W99AL23RYzD77iMI9lBhcVO0tlaxfiOimFO06IEAGkddr2Gosd2aK+3jYWFEIS0g9Rf1E8AK8NW0Py6BbxDYyMzDXluGvD6vkZFrCanAR9bAsi/GlUSQac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gy8JIeIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gy8JIeIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1942F1F000FF;
	Thu, 17 Sep 2026 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665344;
	bh=iTLM2Nqcv8/Kgf0/mZ1k49U9Porh+92ileVGgrmJIsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gy8JIeIkGwjI2fT+BBdxhxzUO3a1r5JBKzv5Q5uY3sZ4WJ6TosVdx124mssz2yXe6
	 P5UtRta8WwjnmQDQtFTyD7Im5Km+XGlRC2y/z+2woWWIbzE7XmM9VhZXCRnsUcQRkN
	 UCV+UaSQT+Gf/HkYxT7BiinZoQ/WC9GW1xuiaVVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Ciprian Regus <ciprian.regus@analog.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0674/1250] net: ethernet: oa_tc6: Export standard defined registers
Date: Thu, 17 Sep 2026 16:07:49 +0100
Message-ID: <20260917151610.156058199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 172c974113bf ("net: ethernet: oa_tc6: Improve the error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 50 -----------------------------------
 include/linux/oa_tc6.h        | 50 +++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index 3321ed4201963..6a01c5e3f14c6 100644
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



