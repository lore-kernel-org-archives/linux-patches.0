Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14C86F097;
	Mon, 29 Jan 2024 17:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548467; cv=none; b=LIGwiXLdSyo7aoGYwnrZoHrU8ubU5BdYm77ACI5hGOleo7/3jeKWqO+4x7faJyNVGNXvXnOUPVjsucO7o9vzFNDwrNB6M34Wz4G6jwKRZkESc8z2eYwwFrGDWbGJdYJa0eXL1TxggE7Qen7IJI4oGeYbevOG3sDqQzuc02dQrRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548467; c=relaxed/simple;
	bh=SSKICmRnXboUoDIpwwdxx4G1qiKKcx3zZrb0tFQtQiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoH9cIGRw3gKnZqlLfDbPpfnhO1ymc4H3TTKzreOXm52NjCFVAafEqyS6Bvi+Ord9VVC14cCTDwFrJ8Iz35/gy/G9srZQMHzmp6B5tml5B/xnymbVeWqmQh2KZhIVMCsPHb0ZBBM/Atk+hmOQb0s6Dy367XqM4eGqUrpyxoHFMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+t/Ljci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+t/Ljci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B840AC433F1;
	Mon, 29 Jan 2024 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548466;
	bh=SSKICmRnXboUoDIpwwdxx4G1qiKKcx3zZrb0tFQtQiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+t/LjciTljJDUG9nYeOSotI0LfHB+7TxDQmyKanD4qF6aIf2rBeJju2nRW9myyWe
	 EXzgQDfdkJK6k5Qc94BKnoV+0NN0ebbbx/qSroyCnP1SPiLedFRnMCPAAlIIi8MUEF
	 nGW1mJx0cmXkKY44L3XMGzPAN7tUkcW+69f5xXPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 057/331] soc: fsl: cpm1: qmc: Fix __iomem addresses declaration
Date: Mon, 29 Jan 2024 09:02:01 -0800
Message-ID: <20240129170016.596269738@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit a5ec3a21220da06bdda2e686012ca64fdb6c513d upstream.

Running sparse (make C=1) on qmc.c raises a lot of warning such as:
  ...
  warning: incorrect type in assignment (different address spaces)
     expected struct cpm_buf_desc [usertype] *[noderef] __iomem bd
     got struct cpm_buf_desc [noderef] [usertype] __iomem *txbd_free
  ...

Indeed, some variable were declared 'type *__iomem var' instead of
'type __iomem *var'.

Use the correct declaration to remove these warnings.

Fixes: 3178d58e0b97 ("soc: fsl: cpm1: Add support for QMC")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20231205152116.122512-3-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/qmc.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index 92ec76c03965..3f3de1351c96 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -175,7 +175,7 @@ struct qmc_chan {
 	struct list_head list;
 	unsigned int id;
 	struct qmc *qmc;
-	void *__iomem s_param;
+	void __iomem *s_param;
 	enum qmc_mode mode;
 	u64	tx_ts_mask;
 	u64	rx_ts_mask;
@@ -203,9 +203,9 @@ struct qmc_chan {
 struct qmc {
 	struct device *dev;
 	struct tsa_serial *tsa_serial;
-	void *__iomem scc_regs;
-	void *__iomem scc_pram;
-	void *__iomem dpram;
+	void __iomem *scc_regs;
+	void __iomem *scc_pram;
+	void __iomem *dpram;
 	u16 scc_pram_offset;
 	cbd_t __iomem *bd_table;
 	dma_addr_t bd_dma_addr;
@@ -218,37 +218,37 @@ struct qmc {
 	struct qmc_chan *chans[64];
 };
 
-static inline void qmc_write16(void *__iomem addr, u16 val)
+static inline void qmc_write16(void __iomem *addr, u16 val)
 {
 	iowrite16be(val, addr);
 }
 
-static inline u16 qmc_read16(void *__iomem addr)
+static inline u16 qmc_read16(void __iomem *addr)
 {
 	return ioread16be(addr);
 }
 
-static inline void qmc_setbits16(void *__iomem addr, u16 set)
+static inline void qmc_setbits16(void __iomem *addr, u16 set)
 {
 	qmc_write16(addr, qmc_read16(addr) | set);
 }
 
-static inline void qmc_clrbits16(void *__iomem addr, u16 clr)
+static inline void qmc_clrbits16(void __iomem *addr, u16 clr)
 {
 	qmc_write16(addr, qmc_read16(addr) & ~clr);
 }
 
-static inline void qmc_write32(void *__iomem addr, u32 val)
+static inline void qmc_write32(void __iomem *addr, u32 val)
 {
 	iowrite32be(val, addr);
 }
 
-static inline u32 qmc_read32(void *__iomem addr)
+static inline u32 qmc_read32(void __iomem *addr)
 {
 	return ioread32be(addr);
 }
 
-static inline void qmc_setbits32(void *__iomem addr, u32 set)
+static inline void qmc_setbits32(void __iomem *addr, u32 set)
 {
 	qmc_write32(addr, qmc_read32(addr) | set);
 }
@@ -318,7 +318,7 @@ int qmc_chan_write_submit(struct qmc_chan *chan, dma_addr_t addr, size_t length,
 {
 	struct qmc_xfer_desc *xfer_desc;
 	unsigned long flags;
-	cbd_t *__iomem bd;
+	cbd_t __iomem *bd;
 	u16 ctrl;
 	int ret;
 
@@ -374,7 +374,7 @@ static void qmc_chan_write_done(struct qmc_chan *chan)
 	void (*complete)(void *context);
 	unsigned long flags;
 	void *context;
-	cbd_t *__iomem bd;
+	cbd_t __iomem *bd;
 	u16 ctrl;
 
 	/*
@@ -425,7 +425,7 @@ int qmc_chan_read_submit(struct qmc_chan *chan, dma_addr_t addr, size_t length,
 {
 	struct qmc_xfer_desc *xfer_desc;
 	unsigned long flags;
-	cbd_t *__iomem bd;
+	cbd_t __iomem *bd;
 	u16 ctrl;
 	int ret;
 
@@ -488,7 +488,7 @@ static void qmc_chan_read_done(struct qmc_chan *chan)
 	void (*complete)(void *context, size_t size);
 	struct qmc_xfer_desc *xfer_desc;
 	unsigned long flags;
-	cbd_t *__iomem bd;
+	cbd_t __iomem *bd;
 	void *context;
 	u16 datalen;
 	u16 ctrl;
@@ -663,7 +663,7 @@ static void qmc_chan_reset_rx(struct qmc_chan *chan)
 {
 	struct qmc_xfer_desc *xfer_desc;
 	unsigned long flags;
-	cbd_t *__iomem bd;
+	cbd_t __iomem *bd;
 	u16 ctrl;
 
 	spin_lock_irqsave(&chan->rx_lock, flags);
@@ -694,7 +694,7 @@ static void qmc_chan_reset_tx(struct qmc_chan *chan)
 {
 	struct qmc_xfer_desc *xfer_desc;
 	unsigned long flags;
-	cbd_t *__iomem bd;
+	cbd_t __iomem *bd;
 	u16 ctrl;
 
 	spin_lock_irqsave(&chan->tx_lock, flags);
-- 
2.43.0



