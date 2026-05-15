Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E64F3FBB62;
	Fri, 15 May 2026 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861811; cv=none; b=Cy3VL7z1NPp0I+bn5wQS0HxxBuC/MyPGz+mxPEzrGG3Mi16bsF75kvt4gj/CSSOwY755WGgoHDIRDIHXAo9LTxOjX8UAlO0ZhvBYtlbEAAMmTU5RsJzLSb3Q4lB/zbQY8s3fqLq8Pxagi08VRYsPRBT12C01/y6XAtVbxel7i0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861811; c=relaxed/simple;
	bh=jBHp3wLYuJoLiYG/OGhugh4fhxkXhYPHHAUVupZkbzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQ1wpjExkPAGgUUPEqXj7Jf+SvkUdF+yqiQkQh6yXtJBEe18U0IrYJYvGu9ubVmviert1wzyzJEFUWA6mWiV73AxWemTQgxmEMycs/PIPAxKH5/IOFjMz2TkKE3E/ENUH5T1XVjdMSCT3e9L24yX+7KSGVLKm/7PkGAPx2JmtrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4HP54k+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4HP54k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E58C2BCC7;
	Fri, 15 May 2026 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861811;
	bh=jBHp3wLYuJoLiYG/OGhugh4fhxkXhYPHHAUVupZkbzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4HP54k+Sl6pfmL3eHYLA+q45ZwqJ8HMcjz1O6ngbfrkbwR84xvS35iwwgTZ3dlqD
	 I4mNf+6hZi4inFu0a3jPx4TxDrefoEZ9w69RkNDU1n7TwnLx4wc0s3FZoMUrevsU64
	 sDMmbUnVbdYaolLDCOHL/dGvShSrEc7CPJYRYL5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 430/474] spi: zynq-qspi: switch to use modern name
Date: Fri, 15 May 2026 17:48:59 +0200
Message-ID: <20260515154724.374525922@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 178ebb0c505b0a35edb4fb2a0e23a1f29e1db14d ]

Change legacy name master/slave to modern name host/target or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://msgid.link/r/20231128093031.3707034-24-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c9c012706c9f ("spi: zynq-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynq-qspi.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -54,10 +54,10 @@
 #define ZYNQ_QSPI_CONFIG_MSTREN_MASK	BIT(0) /* Master Mode */
 
 /*
- * QSPI Configuration Register - Baud rate and slave select
+ * QSPI Configuration Register - Baud rate and target select
  *
  * These are the values used in the calculation of baud rate divisor and
- * setting the slave select.
+ * setting the target select.
  */
 #define ZYNQ_QSPI_CONFIG_BAUD_DIV_MAX	GENMASK(2, 0) /* Baud rate maximum */
 #define ZYNQ_QSPI_CONFIG_BAUD_DIV_SHIFT	3 /* Baud rate divisor shift */
@@ -164,14 +164,14 @@ static inline void zynq_qspi_write(struc
  *
  * The default settings of the QSPI controller's configurable parameters on
  * reset are
- *	- Master mode
+ *	- Host mode
  *	- Baud rate divisor is set to 2
  *	- Tx threshold set to 1l Rx threshold set to 32
  *	- Flash memory interface mode enabled
  *	- Size of the word to be transferred as 8 bit
  * This function performs the following actions
  *	- Disable and clear all the interrupts
- *	- Enable manual slave select
+ *	- Enable manual target select
  *	- Enable manual start
  *	- Deselect all the chip select lines
  *	- Set the size of the word to be transferred as 32 bit
@@ -289,7 +289,7 @@ static void zynq_qspi_txfifo_op(struct z
  */
 static void zynq_qspi_chipselect(struct spi_device *spi, bool assert)
 {
-	struct spi_controller *ctlr = spi->master;
+	struct spi_controller *ctlr = spi->controller;
 	struct zynq_qspi *xqspi = spi_controller_get_devdata(ctlr);
 	u32 config_reg;
 
@@ -377,7 +377,7 @@ static int zynq_qspi_config_op(struct zy
  */
 static int zynq_qspi_setup_op(struct spi_device *spi)
 {
-	struct spi_controller *ctlr = spi->master;
+	struct spi_controller *ctlr = spi->controller;
 	struct zynq_qspi *qspi = spi_controller_get_devdata(ctlr);
 	int ret;
 
@@ -534,7 +534,7 @@ static irqreturn_t zynq_qspi_irq(int irq
 static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 				 const struct spi_mem_op *op)
 {
-	struct zynq_qspi *xqspi = spi_controller_get_devdata(mem->spi->master);
+	struct zynq_qspi *xqspi = spi_controller_get_devdata(mem->spi->controller);
 	int err = 0, i;
 	u8 *tmpbuf;
 
@@ -646,7 +646,7 @@ static int zynq_qspi_probe(struct platfo
 	struct zynq_qspi *xqspi;
 	u32 num_cs;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*xqspi));
+	ctlr = spi_alloc_host(&pdev->dev, sizeof(*xqspi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -656,14 +656,14 @@ static int zynq_qspi_probe(struct platfo
 	xqspi->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(xqspi->regs)) {
 		ret = PTR_ERR(xqspi->regs);
-		goto remove_master;
+		goto remove_ctlr;
 	}
 
 	xqspi->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(xqspi->pclk)) {
 		dev_err(&pdev->dev, "pclk clock not found.\n");
 		ret = PTR_ERR(xqspi->pclk);
-		goto remove_master;
+		goto remove_ctlr;
 	}
 
 	init_completion(&xqspi->data_completion);
@@ -672,13 +672,13 @@ static int zynq_qspi_probe(struct platfo
 	if (IS_ERR(xqspi->refclk)) {
 		dev_err(&pdev->dev, "ref_clk clock not found.\n");
 		ret = PTR_ERR(xqspi->refclk);
-		goto remove_master;
+		goto remove_ctlr;
 	}
 
 	ret = clk_prepare_enable(xqspi->pclk);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to enable APB clock.\n");
-		goto remove_master;
+		goto remove_ctlr;
 	}
 
 	ret = clk_prepare_enable(xqspi->refclk);
@@ -724,7 +724,7 @@ static int zynq_qspi_probe(struct platfo
 
 	ret = devm_spi_register_controller(&pdev->dev, ctlr);
 	if (ret) {
-		dev_err(&pdev->dev, "spi_register_master failed\n");
+		dev_err(&pdev->dev, "devm_spi_register_controller failed\n");
 		goto clk_dis_all;
 	}
 
@@ -734,7 +734,7 @@ clk_dis_all:
 	clk_disable_unprepare(xqspi->refclk);
 clk_dis_pclk:
 	clk_disable_unprepare(xqspi->pclk);
-remove_master:
+remove_ctlr:
 	spi_controller_put(ctlr);
 
 	return ret;


