Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016704;
	b=EswNvTtrxjDl8qCQzGtFZapFI8y7kr3vJ8wPrdrrRkDMOMn4de8TLRoizM3owO1boE03
	 bZ0VhiXAs5T2Wfg/ReEZufZAHJGnBHpD9grYJJdBEKiGo8OA1L6mNX1aJBrVbSKZ2pP8A
	 ONH1FwRxlV7bjFcvxeLRuTcxBaCBdcKs+tH2rSARuMeaM/iPxQMYomFNYVKxKVadRKWrB
	 D9UbP8xOGqQzZeI1pj/ecvVReQ7b9DT2ptB+Kz9ol7aYX18jQhnXx3zvxnsHdrsTL13al
	 2PGxEnSsgaGnIyuz956/5GHJiq8LlS3qH+4FwGmExtIgzLMg6yyzaJGjYBQVcnNBodQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qR30RFhrftvuSEOP8U5GwosbpNlsc1SakLn/EzDM6xM=;
	b=TSWjxr3h1CX8+kE1ooAAFyCxRAFMQ+USfgLDqn/2PR+o0jNNWhRiRN0/HH1CcQOOLmwD
	 IosfCi0WzDBGBlYv2kOoNsulcyzXaJBCq293CA5Q6/psHBoKDSiuJOFwqPiL+hW6j+zz2
	 FAcFsvy24eHzRwWkOO347hqm3kt/5XCpj1RiY7WF90NiG5V17XTlCyEmZRhMHw7qRni7V
	 zruFvQ6+HUoZiYWnDb48cS/8CKD/wQtFUU6DqiotAxUCdzK9cnKWd7Rcjgf50JONOVljb
	 jL88AKTBpP+OExv2PnsCVcILNpzyzEgMXPMeb1Nbrk5xW0fRYFydy6hqGQK+INUt8ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGwRLnii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861D1606A33A;
	Wed, 18 Nov 2026 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGwRLnii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DCA1F000C6;
	Wed, 18 Nov 2026 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016704;
	bh=qR30RFhrftvuSEOP8U5GwosbpNlsc1SakLn/EzDM6xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGwRLniibl7JVRs2J+2sMk3213o6LaODwCDNc4VA+0nF59tZGzf0ENIHqSo5xPCe5
	 4dZPPmLr10GnOubOGB9PuAAJ4VJSK8ULSLO+JblxKrHY69aB3cqFA+RxS3l0TwFo1r
	 D9QkkayQOo3rcU7bf+N7nocrt7LCZqWaAJd+1xy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0623/2651] i3c: mipi-i3c-hci: Process multiple IBIs per interrupt
Date: Wed, 18 Nov 2026 15:31:03 +0100
Message-ID: <20261118150310.124528434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 39 +++++++++++++++++----------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 5b195978f3762..a798b0648922a 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -868,25 +868,24 @@ static void hci_dma_recycle_ibi_slot(struct i3c_hci *hci,
 	i3c_generic_ibi_recycle_slot(dev_ibi->pool, slot);
 }
 
-static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
+static bool hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh,
+				u32 *op1_val, unsigned int enq_ptr)
 {
 	struct hci_rings_data *rings = hci->io_data;
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
@@ -936,7 +935,7 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
 		dev_dbg(&hci->master.dev,
 			"no LAST_STATUS available (e=%d d=%d)",
 			enq_ptr, deq_ptr);
-		return;
+		return false;
 	}
 	deq_ptr = last_ptr + 1;
 	deq_ptr %= rh->ibi_status_entries;
@@ -1015,10 +1014,9 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
 	i3c_master_queue_ibi(dev, slot);
 
 done:
-	op1_val = rh_reg_read(RING_OPERATION1);
-	op1_val &= ~RING_OP1_IBI_DEQ_PTR;
-	op1_val |= FIELD_PREP(RING_OP1_IBI_DEQ_PTR, deq_ptr);
-	rh_reg_write(RING_OPERATION1, op1_val);
+	*op1_val &= ~RING_OP1_IBI_DEQ_PTR;
+	*op1_val |= FIELD_PREP(RING_OP1_IBI_DEQ_PTR, deq_ptr);
+	rh_reg_write(RING_OPERATION1, *op1_val);
 
 	/* update the chunk pointer */
 	rh->ibi_chunk_ptr += ibi_chunks;
@@ -1026,6 +1024,19 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
 
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
 
 static bool hci_dma_irq_handler(struct i3c_hci *hci)
@@ -1047,7 +1058,7 @@ static bool hci_dma_irq_handler(struct i3c_hci *hci)
 		rh_reg_write(INTR_STATUS, status);
 
 		if (status & INTR_IBI_READY)
-			hci_dma_process_ibi(hci, rh);
+			hci_dma_drain_ibi_ring(hci, rh);
 		if (status & (INTR_TRANSFER_COMPLETION | INTR_TRANSFER_ERR))
 			hci_dma_xfer_done(hci, rh);
 		if (status & INTR_RING_OP)
-- 
2.53.0



