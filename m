Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625128;
	b=BUC8SmjdwS6W1x38I6l4SAOFwCPk5fKom/R1o+qt93XYfnGsiD8BhV1FO3APTHwmL+XN
	 qiJZoGphwbpVNlsTKarY7MPUy4hL4cC0brLObIiOizBsG5TGJ7GuSy1rIVckIK7iYEpjc
	 vXsscGoRhQ4qFURS7FNAhEnf0085ABmhedHtMw4uGtlsZrNvvaBvZij4iplEjkJp9qBru
	 aTnfikMBtbXrRIxbcOtIwLAuyY5x8zxQrlVLhxeKlnMwS/JnxaLtAKUSgYQC5TSCoG21/
	 KOOzJ+355XZ9Xb+8uvFy8i6XiBiyfa5zJBecxMX9Qzb5Z4kkmwH+lguLSS0oarKBmXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiXe+KyAL5+dRnmb/uLZBFpwBnLTELMIiwiZaznwXG8=;
	b=f/aVXyzoMqJGz1a/vc8mD5iAsgqPNkeSx2IDgfzooLs9Wz5kBT9MU1AVhePPxvfykyDa
	 P+2o8OXxYIgqFrjC8XibbckVTbqYRlcDLGKauD6GeCpH6KYaLXVCyKS5y25kErU+HtLfA
	 N4T9GOtF7kmQ/fSg+kIPfdWGTSilE+2dHuXKGYHbH2edjJlR9Qh/fzYuDW6QYxIAjjbci
	 jX11xJoESWJzrg47nzyod7f6byJBroJnyVamSejgDp8bWbT9UJIwP9WjKYJKb0SeArKZF
	 hLyfdRgBCvPscYrjoGwnxoEUCXwA/aPZV5gVBDeII7vWP8t/p8QDZEwcCC8+r1otJgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MN2RQ7jG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9310606A32E;
	Wed, 25 Nov 2026 16:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MN2RQ7jG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45491F000C6;
	Wed, 25 Nov 2026 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625128;
	bh=xiXe+KyAL5+dRnmb/uLZBFpwBnLTELMIiwiZaznwXG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MN2RQ7jGh5SMJkjPLJP1qbUInGGamOauNTtRgzN7dH+R9g8+VvEkDE0BvIvl63Wcx
	 BM1rRpN5ycco+gQyuCwoYP+CdnPHnXfuAhXPjMKqBhj9Wj3eDPhA8LRzHFU7qoNxb3
	 ZJf08uuVUY62DQKP1x55+6j+5ymMKIGgsW7fX/4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 414/816] i3c: mipi-i3c-hci: Process multiple IBIs per interrupt
Date: Wed, 25 Nov 2026 15:32:42 +0100
Message-ID: <20261125143858.779308094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 5fbd0790af9484c251341e3ba2ebbb2887c570c8 ]

INTR_IBI_READY indicates that one or more IBI Status Descriptors are
present in the IBI ring.  After clearing interrupt status, the interrupt
handler processes only a single IBI even though additional IBIs may
already be queued.

The controller does not reassert INTR_IBI_READY solely because entries
remain in the ring after interrupt status has been cleared.  Consequently,
the remaining IBIs are not processed until some later interrupt occurs,
and can accumulate if IBIs arrive more often than the interrupt handler
runs.

Process all IBIs that are pending when the handler runs: capture the IBI
enqueue pointer up front and continue until the dequeue pointer reaches
that position.

Fixes: 9ad9a52cce28 ("i3c/master: introduce the mipi-i3c-hci driver")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-10-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ sashal: Kept the tree's DBG() and the rh->lock around the IBI dequeue-pointer update, re-reading RING_OPERATION1 under the lock instead of writing back the cached value. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 40 +++++++++++++++++----------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index d61d88b3a47a6..90bc62bacbebe 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -603,24 +603,23 @@ static void hci_dma_recycle_ibi_slot(struct i3c_hci *hci,
 	i3c_generic_ibi_recycle_slot(dev_ibi->pool, slot);
 }
 
-static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
+static bool hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh,
+				u32 *op1_val, unsigned int enq_ptr)
 {
 	struct i3c_dev_desc *dev;
 	struct i3c_hci_dev_data *dev_data;
 	struct hci_dma_dev_ibi_data *dev_ibi;
 	struct i3c_ibi_slot *slot;
-	u32 op1_val, op2_val, ibi_status_error;
-	unsigned int ptr, enq_ptr, deq_ptr;
+	u32 ibi_status_error;
+	unsigned int ptr, deq_ptr;
 	unsigned int ibi_size, ibi_chunks, ibi_data_offset, first_part;
 	int ibi_addr, last_ptr;
 	void *ring_ibi_data;
 	dma_addr_t ring_ibi_data_dma;
 
-	op1_val = rh_reg_read(RING_OPERATION1);
-	deq_ptr = FIELD_GET(RING_OP1_IBI_DEQ_PTR, op1_val);
-
-	op2_val = rh_reg_read(RING_OPERATION2);
-	enq_ptr = FIELD_GET(RING_OP2_IBI_ENQ_PTR, op2_val);
+	deq_ptr = FIELD_GET(RING_OP1_IBI_DEQ_PTR, *op1_val);
+	if (deq_ptr == enq_ptr)
+		return false;
 
 	ibi_status_error = 0;
 	ibi_addr = -1;
@@ -668,7 +667,7 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
 	if (last_ptr == -1) {
 		/* this IBI sequence is not yet complete */
 		DBG("no LAST_STATUS available (e=%d d=%d)", enq_ptr, deq_ptr);
-		return;
+		return false;
 	}
 	deq_ptr = last_ptr + 1;
 	deq_ptr %= rh->ibi_status_entries;
@@ -741,10 +740,10 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
 done:
 	/* take care to update the ibi dequeue pointer atomically */
 	spin_lock(&rh->lock);
-	op1_val = rh_reg_read(RING_OPERATION1);
-	op1_val &= ~RING_OP1_IBI_DEQ_PTR;
-	op1_val |= FIELD_PREP(RING_OP1_IBI_DEQ_PTR, deq_ptr);
-	rh_reg_write(RING_OPERATION1, op1_val);
+	*op1_val = rh_reg_read(RING_OPERATION1);
+	*op1_val &= ~RING_OP1_IBI_DEQ_PTR;
+	*op1_val |= FIELD_PREP(RING_OP1_IBI_DEQ_PTR, deq_ptr);
+	rh_reg_write(RING_OPERATION1, *op1_val);
 	spin_unlock(&rh->lock);
 
 	/* update the chunk pointer */
@@ -753,6 +752,19 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
 
 	/* and tell the hardware about freed chunks */
 	rh_reg_write(CHUNK_CONTROL, rh_reg_read(CHUNK_CONTROL) + ibi_chunks);
+
+	return true;
+}
+
+static void hci_dma_drain_ibi_ring(struct i3c_hci *hci, struct hci_rh_data *rh)
+{
+	u32 op1_val = rh_reg_read(RING_OPERATION1);
+	u32 op2_val = rh_reg_read(RING_OPERATION2);
+	unsigned int enq_ptr = FIELD_GET(RING_OP2_IBI_ENQ_PTR, op2_val);
+
+	/* Loop is bounded by enq_ptr. Further IBIs will re-assert INTR_IBI_READY */
+	while (hci_dma_process_ibi(hci, rh, &op1_val, enq_ptr))
+		;
 }
 
 static bool hci_dma_irq_handler(struct i3c_hci *hci, unsigned int mask)
@@ -777,7 +789,7 @@ static bool hci_dma_irq_handler(struct i3c_hci *hci, unsigned int mask)
 		rh_reg_write(INTR_STATUS, status);
 
 		if (status & INTR_IBI_READY)
-			hci_dma_process_ibi(hci, rh);
+			hci_dma_drain_ibi_ring(hci, rh);
 		if (status & (INTR_TRANSFER_COMPLETION | INTR_TRANSFER_ERR))
 			hci_dma_xfer_done(hci, rh);
 		if (status & INTR_RING_OP)
-- 
2.53.0



