Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9761ABEB5;
	Mon, 14 Oct 2024 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917453; cv=none; b=f+xMHMaGs9N16qTXnlCbOUSrMRwDb5Pb2VSPLJwAP08TNjcyV0HiGsulEz3fonr7h5++Ewt8YCTo5yExezKxnzYYyDIIAFgng24McqHRpj36y6nUZKBYeK0xt9To0q3JiR47Snx9zlaF1MtuCwu2zwxaIVLysnFZ9SBmm79VAbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917453; c=relaxed/simple;
	bh=T8iEoPhVihuJSN5pB8Jw4losSgtN08IDP55yBWhL/4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct7srcslM7IwrjeA9QwYOprzLM4vTRKSOu8BQGufVkaJ6YTI646P453R7N62fLDLIhzH+i+DQpxxqeB09ZLcV1Uh3vmBzL2HdtRYhv4C+lYPFJlxYht1voEzdJTNBFwAV2f+hBczMRtlkY3XVxjYptA4wO7Inugk62FQG9STN84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+H4IWqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+H4IWqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0194CC4CEC3;
	Mon, 14 Oct 2024 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917453;
	bh=T8iEoPhVihuJSN5pB8Jw4losSgtN08IDP55yBWhL/4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+H4IWqJLAE+3TOzrCMU62lGfwp0WyrRsxfFDtq/VZ270uUwjYsqfQewjBG9eeq46
	 dbmHtJRgXQ4wpDPAybmayYVteF1qMIJxpcmjAYx7B6wIPjzHGnM4tzYjS+MGrGIqA2
	 TixPOn6tK6EMwr3/rT5TxgfdDWdMznP1uAGX6Nec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/798] crypto: hisilicon/qm - fix coding style issues
Date: Mon, 14 Oct 2024 16:09:53 +0200
Message-ID: <20241014141219.478849019@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit ced18fd1794787d57acff1a4d1b2816d5ec99fbc ]

1. Remove extra blank lines.
2. Remove extra spaces.
3. Use spaces instead of tabs around '=' and '\',
to ensure consistent coding styles.
4. Macros should be capital letters, change 'QM_SQC_VFT_NUM_MASK_v2'
to 'QM_SQC_VFT_NUM_MASK_V2'.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: b04f06fc0243 ("crypto: hisilicon/qm - inject error before stopping queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c  | 29 ++++++++++++-----------------
 drivers/crypto/hisilicon/sgl.c |  1 -
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 5539be1bfb402..8b85cb5ab6f89 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -118,7 +118,7 @@
 #define QM_SQC_VFT_BASE_SHIFT_V2	28
 #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
 #define QM_SQC_VFT_NUM_SHIFT_V2		45
-#define QM_SQC_VFT_NUM_MASK_v2		GENMASK(9, 0)
+#define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
 
 #define QM_ABNORMAL_INT_SOURCE		0x100000
 #define QM_ABNORMAL_INT_MASK		0x100004
@@ -240,23 +240,23 @@
 #define QM_DEV_ALG_MAX_LEN		256
 
 #define QM_MK_CQC_DW3_V1(hop_num, pg_sz, buf_sz, cqe_sz) \
-	(((hop_num) << QM_CQ_HOP_NUM_SHIFT)	| \
-	((pg_sz) << QM_CQ_PAGE_SIZE_SHIFT)	| \
-	((buf_sz) << QM_CQ_BUF_SIZE_SHIFT)	| \
+	(((hop_num) << QM_CQ_HOP_NUM_SHIFT) | \
+	((pg_sz) << QM_CQ_PAGE_SIZE_SHIFT) | \
+	((buf_sz) << QM_CQ_BUF_SIZE_SHIFT) | \
 	((cqe_sz) << QM_CQ_CQE_SIZE_SHIFT))
 
 #define QM_MK_CQC_DW3_V2(cqe_sz, cq_depth) \
 	((((u32)cq_depth) - 1) | ((cqe_sz) << QM_CQ_CQE_SIZE_SHIFT))
 
 #define QM_MK_SQC_W13(priority, orders, alg_type) \
-	(((priority) << QM_SQ_PRIORITY_SHIFT)	| \
-	((orders) << QM_SQ_ORDERS_SHIFT)	| \
+	(((priority) << QM_SQ_PRIORITY_SHIFT) | \
+	((orders) << QM_SQ_ORDERS_SHIFT) | \
 	(((alg_type) & QM_SQ_TYPE_MASK) << QM_SQ_TYPE_SHIFT))
 
 #define QM_MK_SQC_DW3_V1(hop_num, pg_sz, buf_sz, sqe_sz) \
-	(((hop_num) << QM_SQ_HOP_NUM_SHIFT)	| \
-	((pg_sz) << QM_SQ_PAGE_SIZE_SHIFT)	| \
-	((buf_sz) << QM_SQ_BUF_SIZE_SHIFT)	| \
+	(((hop_num) << QM_SQ_HOP_NUM_SHIFT) | \
+	((pg_sz) << QM_SQ_PAGE_SIZE_SHIFT) | \
+	((buf_sz) << QM_SQ_BUF_SIZE_SHIFT) | \
 	((u32)ilog2(sqe_sz) << QM_SQ_SQE_SIZE_SHIFT))
 
 #define QM_MK_SQC_DW3_V2(sqe_sz, sq_depth) \
@@ -720,7 +720,7 @@ static void qm_db_v2(struct hisi_qm *qm, u16 qn, u8 cmd, u16 index, u8 priority)
 
 	doorbell = qn | ((u64)cmd << QM_DB_CMD_SHIFT_V2) |
 		   ((u64)randata << QM_DB_RAND_SHIFT_V2) |
-		   ((u64)index << QM_DB_INDEX_SHIFT_V2)	 |
+		   ((u64)index << QM_DB_INDEX_SHIFT_V2) |
 		   ((u64)priority << QM_DB_PRIORITY_SHIFT_V2);
 
 	writeq(doorbell, io_base);
@@ -1354,7 +1354,7 @@ static int qm_get_vft_v2(struct hisi_qm *qm, u32 *base, u32 *number)
 	sqc_vft = readl(qm->io_base + QM_MB_CMD_DATA_ADDR_L) |
 		  ((u64)readl(qm->io_base + QM_MB_CMD_DATA_ADDR_H) << 32);
 	*base = QM_SQC_VFT_BASE_MASK_V2 & (sqc_vft >> QM_SQC_VFT_BASE_SHIFT_V2);
-	*number = (QM_SQC_VFT_NUM_MASK_v2 &
+	*number = (QM_SQC_VFT_NUM_MASK_V2 &
 		   (sqc_vft >> QM_SQC_VFT_NUM_SHIFT_V2)) + 1;
 
 	return 0;
@@ -3123,7 +3123,6 @@ static int qm_stop_started_qp(struct hisi_qm *qm)
 	return 0;
 }
 
-
 /**
  * qm_clear_queues() - Clear all queues memory in a qm.
  * @qm: The qm in which the queues will be cleared.
@@ -3609,7 +3608,7 @@ static ssize_t qm_algqos_read(struct file *filp, char __user *buf,
 	qos_val = ir / QM_QOS_RATE;
 	ret = scnprintf(tbuf, QM_DBG_READ_LEN, "%u\n", qos_val);
 
-	ret =  simple_read_from_buffer(buf, count, pos, tbuf, ret);
+	ret = simple_read_from_buffer(buf, count, pos, tbuf, ret);
 
 err_get_status:
 	clear_bit(QM_RESETTING, &qm->misc_ctl);
@@ -4116,13 +4115,10 @@ static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
 	if (!qm->err_status.is_dev_ecc_mbit &&
 	    qm->err_status.is_qm_ecc_mbit &&
 	    qm->err_ini->close_axi_master_ooo) {
-
 		qm->err_ini->close_axi_master_ooo(qm);
-
 	} else if (qm->err_status.is_dev_ecc_mbit &&
 		   !qm->err_status.is_qm_ecc_mbit &&
 		   !qm->err_ini->close_axi_master_ooo) {
-
 		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
 		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
 		       qm->io_base + QM_RAS_NFE_ENABLE);
@@ -4566,7 +4562,6 @@ static irqreturn_t qm_abnormal_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-
 /**
  * hisi_qm_dev_shutdown() - Shutdown device.
  * @pdev: The device will be shutdown.
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 0974b00414050..09586a837b1e8 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -249,7 +249,6 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 		dev_err(dev, "Get SGL error!\n");
 		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
 		return ERR_PTR(-ENOMEM);
-
 	}
 	curr_hw_sgl->entry_length_in_sgl = cpu_to_le16(pool->sge_nr);
 	curr_hw_sge = curr_hw_sgl->sge_entries;
-- 
2.43.0



