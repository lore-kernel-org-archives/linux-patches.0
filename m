Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704288;
	b=MUKVVoAyRU/KJI+A3eKYrgtYPPygthWYTXoMvdA2tObsyADSSsQYBAbb61NfbD6hLuqW
	 guqICw+97I3QrHJPalXYZtpyc0yzAMls39UzRdkEgCMvhViHHkrcHEBmQOQfIJc/H+P4Z
	 Lt1xEtE8vTU6sHTwxKVnB+yI1dl3pFg/6UqW1iIINuR8q4Or9EnxxISWQ8z2HGFgbybVD
	 Vm9E0hifLUrDdo7fkekoXy8crmUAg8f1JSTQjFyOfxiLs4KxsNUri2YCWqd8uC+VKVkJg
	 Z2Tde6zog7hg0uXTSN/+fiJ9yKJjS6yVy3dhnLnGdbhNALvmTy1J3moP1T2P01KqKcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RxWITzqLCRJWxq+43B2iYN64lcek3AFCY1ByDKixwNU=;
	b=ZNqInbH1dJZG231TlFZOMbDAEZL9x5oUMKcHokbylhklHYEkx4Ae+73DEWoZuhbodNKi
	 8faLuv9LJk7kp6JW3WVmwMGzz68rkKCIOBEY7CBZhe0eqDHzyUgRwNra/GY4A13Vp5jEH
	 A3wE1RcVMIwU4ana1Baqql/Cah8XkVe/G21VuTJ4iE++mhQ2J9JZICFPdSXq070dHQE1z
	 saDyp0u2ZgI1Zyyq/GbDpiQAJDuHbeFso79qv0xNv0t7X7ePrAdAGRBO7vS9ePUr/sDsx
	 ydjaZj1u8yRXoYtZlawPCP2Fq7VzbZ48XeIj1OqUc9pCnof1PALLW8f3YFLQkEBMrjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UArPrOru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AC4606A326;
	Thu, 26 Nov 2026 14:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UArPrOru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BDE1F000C4;
	Thu, 26 Nov 2026 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704287;
	bh=RxWITzqLCRJWxq+43B2iYN64lcek3AFCY1ByDKixwNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UArPrOrur3L87TwgvwDatGDi/ZZirxOSaXHqXD9sExbW9oLBoXTS6Gffb3LaGQpw4
	 kMBlaqLv1D3w/079XK5MkG96HBqcgVjUi4putk62OGHtG5AAmMwKsyEnZbnD1LOwun
	 uLKPca9qoCJvs4AMkqpIJZWb+tb7s8FHwqbisrIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/265] nvme: fix various comment typos
Date: Thu, 26 Nov 2026 15:36:41 +0100
Message-ID: <20261126143610.048203343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 367c240b0a99c7ada700a44345dd3144a02b6164 ]

Fix typos in comments.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: a4387799d422 ("nvmet-rdma: disconnect a queue on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c     | 4 ++--
 drivers/nvme/host/tcp.c    | 2 +-
 drivers/nvme/target/fc.c   | 6 +++---
 drivers/nvme/target/rdma.c | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 29171d4ca2a69..3d6546edc89fb 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1404,7 +1404,7 @@ nvme_fc_disconnect_assoc_done(struct nvmefc_ls_req *lsreq, int status)
  * down, and the related FC-NVME Association ID and Connection IDs
  * become invalid.
  *
- * The behavior of the fc-nvme initiator is such that it's
+ * The behavior of the fc-nvme initiator is such that its
  * understanding of the association and connections will implicitly
  * be torn down. The action is implicit as it may be due to a loss of
  * connectivity with the fc-nvme target, so you may never get a
@@ -2794,7 +2794,7 @@ nvme_fc_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * as WRITE ZEROES will return a non-zero rq payload_bytes yet
 	 * there is no actual payload to be transferred.
 	 * To get it right, key data transmission on there being 1 or
-	 * more physical segments in the sg list. If there is no
+	 * more physical segments in the sg list. If there are no
 	 * physical segments, there is no payload.
 	 */
 	if (blk_rq_nr_phys_segments(rq)) {
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index e6850d4907aab..9cee068a3c3d0 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1941,7 +1941,7 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 
 	/*
 	 * Only start IO queues for which we have allocated the tagset
-	 * and limitted it to the available queues. On reconnects, the
+	 * and limited it to the available queues. On reconnects, the
 	 * queue number might have changed.
 	 */
 	nr_queues = min(ctrl->tagset->nr_hw_queues + 1, ctrl->queue_count);
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 57ad6031cde91..aaa5d5c0ca8c3 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -449,7 +449,7 @@ nvmet_fc_disconnect_assoc_done(struct nvmefc_ls_req *lsreq, int status)
  * down, and the related FC-NVME Association ID and Connection IDs
  * become invalid.
  *
- * The behavior of the fc-nvme target is such that it's
+ * The behavior of the fc-nvme target is such that its
  * understanding of the association and connections will implicitly
  * be torn down. The action is implicit as it may be due to a loss of
  * connectivity with the fc-nvme host, so the target may never get a
@@ -2274,7 +2274,7 @@ nvmet_fc_transfer_fcp_data(struct nvmet_fc_tgtport *tgtport,
 	ret = tgtport->ops->fcp_op(&tgtport->fc_target_port, fod->fcpreq);
 	if (ret) {
 		/*
-		 * should be ok to set w/o lock as its in the thread of
+		 * should be ok to set w/o lock as it's in the thread of
 		 * execution (not an async timer routine) and doesn't
 		 * contend with any clearing action
 		 */
@@ -2592,7 +2592,7 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
  * and the api of the FC LLDD which may issue a hw command to send the
  * response, but the LLDD may not get the hw completion for that command
  * and upcall the nvmet_fc layer before a new command may be
- * asynchronously received - its possible for a command to be received
+ * asynchronously received - it's possible for a command to be received
  * before the LLDD and nvmet_fc have recycled the job structure. It gives
  * the appearance of more commands received than fits in the sq.
  * To alleviate this scenario, a temporary queue is maintained in the
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 7292eb1f4262f..04496a4db7c41 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1741,7 +1741,7 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
  * We registered an ib_client to handle device removal for queues,
  * so we only need to handle the listening port cm_ids. In this case
  * we nullify the priv to prevent double cm_id destruction and destroying
- * the cm_id implicitely by returning a non-zero rc to the callout.
+ * the cm_id implicitly by returning a non-zero rc to the callout.
  */
 static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 		struct nvmet_rdma_queue *queue)
@@ -1752,7 +1752,7 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 		/*
 		 * This is a queue cm_id. we have registered
 		 * an ib_client to handle queues removal
-		 * so don't interfear and just return.
+		 * so don't interfere and just return.
 		 */
 		return 0;
 	}
@@ -1770,7 +1770,7 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 
 	/*
 	 * We need to return 1 so that the core will destroy
-	 * it's own ID.  What a great API design..
+	 * its own ID.  What a great API design..
 	 */
 	return 1;
 }
-- 
2.53.0



