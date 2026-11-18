Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054887;
	b=vC7gUDbfcaScyPEwtodQRcYF4xXdoZlh4drQXAyV/QRNamkFWx1S6b5z/c0OikHCGMeN
	 8H4ePLCHVb4Mpc4zQQUQTq/9RGlJwxrrvIYMjZKRwpqnLihj4Zd7JvMn7Gc68InUzMmcE
	 E37r50GQxchhd3vylbZxWYUZJMcX6RzWAEKIPUIq+W4cV4IRTZb3J10Sy8oH/m8SqkuBf
	 15CbQaaVSjLLM91Dh/XQqMWx4S0uXnb4xduCzDRDwbCnGaJ/45vqxuJ8trseRwI6XTPiz
	 oJAb36X8qDQOSm+pYHR9QkzSsS05A4LGfrwKXoN9JOBI97nnDvdA45Kq3CO/WOPNwcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1sDJrn835whm0tF95apg/ZANB1yvMFUeUOfPTKmR6HU=;
	b=2t56WZitnl9DozJgfvbORvPoPZtJwedHRFq7YYVniAcMjgRJDDOIXo2ZbBuWiYG/rxmN
	 0rqAfIUe9j2WoXsyszPPN9ey++2HX7qs6uD4fh0oGL0rMOan9CkPE5WryvliX4nwvuiCR
	 Z8ejZ04SUQyI8TmOj7qOLvQT+2rytpQoRzV9DXpb1aojxaiMg6hPq9QMr6Km/F878/nuk
	 kw+HGy3K03kH0drxhMzJCEaxm/45cl/rtWMfEXm1YHuqnn6X1QYAg6PbAG6qBFZHEE0RS
	 VyOmyLll2bBSDa3Y4/T3eFsQxVn/G1mso/3q7YTlmWtkLJsIogryFJr1EG+6yVyt7YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gEmcDc0/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B1B606A325;
	Thu, 19 Nov 2026 02:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gEmcDc0/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221FC1F000C4;
	Thu, 19 Nov 2026 02:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054887;
	bh=1sDJrn835whm0tF95apg/ZANB1yvMFUeUOfPTKmR6HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEmcDc0/oEq8HjTpo7gAWMM3/HELv9OkvS/HBL/pGuxqsyjUxE0F9NJhfW9yh3XI1
	 hh8sLS8vv2VAb3M/HfQF31+ZtlVnj+k5KarlJx2s3uiePpZdlKyTFGqASRZ4QKmEEo
	 4a8rmGS9a7cy0Nas8EH7ruR7k5NjjTD1ikAgTHKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1436/2214] scsi: mpi3mr: Gracefully handle online FW update operation
Date: Wed, 18 Nov 2026 15:51:52 +0100
Message-ID: <20261118150108.613450890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit c5758fc72b9256aae85f5565f5715a3798d337e0 ]

Enhance driver to gracefully handle discrepancies in certain key data sizes
between firmware update operations as mentioned below:

 - The driver displays an error message and marks the controller as
   unrecoverable if the firmware reports ReplyFrameSize that is greater
   than the current ReplyFrameSize.

 - If the firmware reports ReplyFrameSize greater than the current
   ReplyFrameSize then the driver uses the current ReplyFrameSize while
   copying the reply messages.

 - The driver displays an error message and marks the controller as
   unrecoverable if the firmware reports MaxOperationalReplyQueues less
   than the currently allocated operational reply queues count.

 - If the firmware reports MaxOperationalReplyQueues that is greater than
   the currently allocated operational reply queue count then the driver
   ignores the new increased value and uses the previously allocated number
   of operational queues only.

 - If the firmware reports MaxDevHandle greater than the previously used
   MaxDevHandle value after a reset then the driver re-allocates the
   'device remove pending bitmap' buffer with the newer size using
   krealloc().

Link: https://lore.kernel.org/r/20211220141159.16117-18-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: bcf0a5bed59a ("scsi: mpi3mr: Fix out-of-bounds reply frame access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 109 ++++++++++++++++++++++++++------
 2 files changed, 92 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0e6aeaa29076b..3a732a1723718 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -751,6 +751,7 @@ struct mpi3mr_ioc {
 	dma_addr_t reply_buf_dma_max_address;
 
 	u16 reply_free_qsz;
+	u16 reply_sz;
 	struct dma_pool *reply_free_q_pool;
 	__le64 *reply_free_q;
 	dma_addr_t reply_free_q_dma;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 3b978fe2484a6..f672207348385 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -13,6 +13,8 @@
 static int
 mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u32 reset_reason);
 static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
+static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
+	struct mpi3_ioc_facts_data *facts_data);
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
@@ -379,7 +381,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 			if (def_reply) {
 				cmdptr->state |= MPI3MR_CMD_REPLY_VALID;
 				memcpy((u8 *)cmdptr->reply, (u8 *)def_reply,
-				    mrioc->facts.reply_sz);
+				    mrioc->reply_sz);
 			}
 			if (cmdptr->is_waiting) {
 				cmdptr->is_waiting = 0;
@@ -998,6 +1000,66 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_revalidate_factsdata - validate IOCFacts parameters
+ * during reset/resume
+ * @mrioc: Adapter instance reference
+ *
+ * Return zero if the new IOCFacts parameters value is compatible with
+ * older values else return -EPERM
+ */
+static int
+mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
+{
+	u16 dev_handle_bitmap_sz;
+	void *removepend_bitmap;
+
+	if (mrioc->facts.reply_sz > mrioc->reply_sz) {
+		ioc_err(mrioc,
+		    "cannot increase reply size from %d to %d\n",
+		    mrioc->reply_sz, mrioc->facts.reply_sz);
+		return -EPERM;
+	}
+
+	if (mrioc->facts.max_op_reply_q < mrioc->num_op_reply_q) {
+		ioc_err(mrioc,
+		    "cannot reduce number of operational reply queues from %d to %d\n",
+		    mrioc->num_op_reply_q,
+		    mrioc->facts.max_op_reply_q);
+		return -EPERM;
+	}
+
+	if (mrioc->facts.max_op_req_q < mrioc->num_op_req_q) {
+		ioc_err(mrioc,
+		    "cannot reduce number of operational request queues from %d to %d\n",
+		    mrioc->num_op_req_q, mrioc->facts.max_op_req_q);
+		return -EPERM;
+	}
+
+	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
+	if (mrioc->facts.max_devhandle % 8)
+		dev_handle_bitmap_sz++;
+	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
+		removepend_bitmap = krealloc(mrioc->removepend_bitmap,
+		    dev_handle_bitmap_sz, GFP_KERNEL);
+		if (!removepend_bitmap) {
+			ioc_err(mrioc,
+			    "failed to increase removepend_bitmap sz from: %d to %d\n",
+			    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
+			return -EPERM;
+		}
+		memset(removepend_bitmap + mrioc->dev_handle_bitmap_sz, 0,
+		    dev_handle_bitmap_sz - mrioc->dev_handle_bitmap_sz);
+		mrioc->removepend_bitmap = removepend_bitmap;
+		ioc_info(mrioc,
+		    "increased dev_handle_bitmap_sz from %d to %d\n",
+		    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
+		mrioc->dev_handle_bitmap_sz = dev_handle_bitmap_sz;
+	}
+
+	return 0;
+}
+
 /**
  * mpi3mr_bring_ioc_ready - Bring controller to ready state
  * @mrioc: Adapter instance reference
@@ -1870,8 +1932,13 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 	    mrioc->intr_info_count - mrioc->op_reply_q_offset;
 	if (!mrioc->num_queues)
 		mrioc->num_queues = min_t(int, num_queues, msix_count_op_q);
-	num_queues = mrioc->num_queues;
-	ioc_info(mrioc, "Trying to create %d Operational Q pairs\n",
+	/*
+	 * During reset set the num_queues to the number of queues
+	 * that was set before the reset.
+	 */
+	num_queues = mrioc->num_op_reply_q ?
+	    mrioc->num_op_reply_q : mrioc->num_queues;
+	ioc_info(mrioc, "trying to create %d operational queue pairs\n",
 	    num_queues);
 
 	if (!mrioc->req_qinfo) {
@@ -2469,6 +2536,7 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *mrioc,
 		goto out_unlock;
 	}
 	memcpy(facts_data, (u8 *)data, data_len);
+	mpi3mr_process_factsdata(mrioc, facts_data);
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
 	mutex_unlock(&mrioc->init_cmds.mutex);
@@ -2615,12 +2683,6 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	ioc_info(mrioc, "DMA mask %d InitialPE status 0x%x\n",
 	    mrioc->facts.dma_mask, (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK));
-
-	mrioc->max_host_ios = mrioc->facts.max_reqs - MPI3MR_INTERNAL_CMDS_RESVD;
-
-	if (reset_devices)
-		mrioc->max_host_ios = min_t(int, mrioc->max_host_ios,
-		    MPI3MR_HOST_IOS_KDUMP);
 }
 
 /**
@@ -2640,18 +2702,18 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (mrioc->init_cmds.reply)
 		return retval;
 
-	mrioc->init_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	mrioc->init_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
 	if (!mrioc->init_cmds.reply)
 		goto out_failed;
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
-		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->facts.reply_sz,
+		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->reply_sz,
 		    GFP_KERNEL);
 		if (!mrioc->dev_rmhs_cmds[i].reply)
 			goto out_failed;
 	}
 
-	mrioc->host_tm_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	mrioc->host_tm_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
 	if (!mrioc->host_tm_cmds.reply)
 		goto out_failed;
 
@@ -2677,7 +2739,7 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	mrioc->sense_buf_q_sz = mrioc->num_sense_bufs + 1;
 
 	/* reply buffer pool, 16 byte align */
-	sz = mrioc->num_reply_bufs * mrioc->facts.reply_sz;
+	sz = mrioc->num_reply_bufs * mrioc->reply_sz;
 	mrioc->reply_buf_pool = dma_pool_create("reply_buf pool",
 	    &mrioc->pdev->dev, sz, 16, 0);
 	if (!mrioc->reply_buf_pool) {
@@ -2753,10 +2815,10 @@ static void mpimr_initialize_reply_sbuf_queues(struct mpi3mr_ioc *mrioc)
 	u32 sz, i;
 	dma_addr_t phy_addr;
 
-	sz = mrioc->num_reply_bufs * mrioc->facts.reply_sz;
+	sz = mrioc->num_reply_bufs * mrioc->reply_sz;
 	ioc_info(mrioc,
 	    "reply buf pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB), reply_dma(0x%llx)\n",
-	    mrioc->reply_buf, mrioc->num_reply_bufs, mrioc->facts.reply_sz,
+	    mrioc->reply_buf, mrioc->num_reply_bufs, mrioc->reply_sz,
 	    (sz / 1024), (unsigned long long)mrioc->reply_buf_dma);
 	sz = mrioc->reply_free_qsz * 8;
 	ioc_info(mrioc,
@@ -2776,7 +2838,7 @@ static void mpimr_initialize_reply_sbuf_queues(struct mpi3mr_ioc *mrioc)
 
 	/* initialize Reply buffer Queue */
 	for (i = 0, phy_addr = mrioc->reply_buf_dma;
-	    i < mrioc->num_reply_bufs; i++, phy_addr += mrioc->facts.reply_sz)
+	    i < mrioc->num_reply_bufs; i++, phy_addr += mrioc->reply_sz)
 		mrioc->reply_free_q[i] = cpu_to_le64(phy_addr);
 	mrioc->reply_free_q[i] = cpu_to_le64(0);
 
@@ -3501,7 +3563,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
-	mpi3mr_process_factsdata(mrioc, &facts_data);
+	mrioc->max_host_ios = mrioc->facts.max_reqs - MPI3MR_INTERNAL_CMDS_RESVD;
+
+	if (reset_devices)
+		mrioc->max_host_ios = min_t(int, mrioc->max_host_ios,
+		    MPI3MR_HOST_IOS_KDUMP);
+
+	mrioc->reply_sz = mrioc->facts.reply_sz;
 
 	retval = mpi3mr_check_reset_dma_mask(mrioc);
 	if (retval) {
@@ -3624,7 +3692,12 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed;
 	}
 
-	mpi3mr_process_factsdata(mrioc, &facts_data);
+	dprint_reset(mrioc, "validating ioc_facts\n");
+	retval = mpi3mr_revalidate_factsdata(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to revalidate ioc_facts data\n");
+		goto out_failed_noretry;
+	}
 
 	mpi3mr_print_ioc_info(mrioc);
 
-- 
2.53.0



