Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624455;
	b=wXPofI8uLCSug53r/Pp5YaMdZV8+1s8wGrzvUHBpCvE5MmRQs2zqlwvqat4gyQsBK8NO
	 pUwesJsfO93arEOfaF568Ch4WHqOUoxQPKOva2c5nyXhPDNL88eyXElNQeWwD6FWuoLlc
	 nekcU9POWn75Ccurzsb2mhfquEp55yb3f28fpa+g3Bb0QZwvqLMxncIYxybJL0NGqdR6Y
	 D8+pp2zc6BWTtoVOpRy+fHu6w9U4B9wQlgUu9SNwX01UOC1Holif8ESsfldr1hNeDakz0
	 GRaqg06SEecA9QDb6ueEiRPjy6BkF9W6CSTz4Hn7ahwAVN1hfFt3ozQbbvp3Y7ccMnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2q2jgUFJWhx9SZCsHr1W7JXtoKJH7qAVL9dkhCquemw=;
	b=ET+1ENBZUKhwRbjJIfVP5uJ39yiAQnbKjmQU2XcNjUNlQ+hhOs3YYjWVQwwdhLxkUkp2
	 NabmkDa+RLSYqLHGbShLwxDR9lbDtweBdUYW4kUDH7F0WZjUfSxbEjpiFaSRlwHNaBL6Z
	 ff3/J9738yrtuP2/mY1lTGqwMoxWoS4AmKoe3a1szqmHckRdpgExNYVhd04q9jspk349w
	 8nDrwI4GZTMwfK/axDalPCNBeMlIwUwl8Y5dDI4qBNanDtsLsv6S+ZkQ5MUWSvi78KiXl
	 /z8b3LU34kJI4MvWOrmF5JFVuE+S+6muNryW9I9kZo8UE0C9+/nw7WQmRZ+5Hr28H3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKeFRkSZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB00606A33D;
	Wed, 25 Nov 2026 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKeFRkSZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9401F000C0;
	Wed, 25 Nov 2026 16:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624455;
	bh=2q2jgUFJWhx9SZCsHr1W7JXtoKJH7qAVL9dkhCquemw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKeFRkSZHsMINQX8NdJvIOXnpTQDchRjSq64UQ/DkXjJQMI5ihJ4W1BxredvTdGxa
	 BXHUZlkGJYRSu6cJY7ZszBGPx94TFsc7C10aFQtWkfW9noeJYTeZ8rKvfiOVK8lu8T
	 b0IaOAZuaIep95BpVNpibLxoHEHxJVW47MAnFMcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/816] nvme: fix various comment typos
Date: Wed, 25 Nov 2026 15:29:06 +0100
Message-ID: <20261125143853.776127070@linuxfoundation.org>
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
index 7eb566c6fc557..1cd4bc001f1e6 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1364,7 +1364,7 @@ nvme_fc_disconnect_assoc_done(struct nvmefc_ls_req *lsreq, int status)
  * down, and the related FC-NVME Association ID and Connection IDs
  * become invalid.
  *
- * The behavior of the fc-nvme initiator is such that it's
+ * The behavior of the fc-nvme initiator is such that its
  * understanding of the association and connections will implicitly
  * be torn down. The action is implicit as it may be due to a loss of
  * connectivity with the fc-nvme target, so you may never get a
@@ -2779,7 +2779,7 @@ nvme_fc_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * as WRITE ZEROES will return a non-zero rq payload_bytes yet
 	 * there is no actual payload to be transferred.
 	 * To get it right, key data transmission on there being 1 or
-	 * more physical segments in the sg list. If there is no
+	 * more physical segments in the sg list. If there are no
 	 * physical segments, there is no payload.
 	 */
 	if (blk_rq_nr_phys_segments(rq)) {
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index c5b0e688fd9af..f6bc2a90592cf 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2438,7 +2438,7 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 
 	/*
 	 * Only start IO queues for which we have allocated the tagset
-	 * and limitted it to the available queues. On reconnects, the
+	 * and limited it to the available queues. On reconnects, the
 	 * queue number might have changed.
 	 */
 	nr_queues = min(ctrl->tagset->nr_hw_queues + 1, ctrl->queue_count);
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index bd2a7f4accfa7..4d77615b55e4a 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -459,7 +459,7 @@ nvmet_fc_disconnect_assoc_done(struct nvmefc_ls_req *lsreq, int status)
  * down, and the related FC-NVME Association ID and Connection IDs
  * become invalid.
  *
- * The behavior of the fc-nvme target is such that it's
+ * The behavior of the fc-nvme target is such that its
  * understanding of the association and connections will implicitly
  * be torn down. The action is implicit as it may be due to a loss of
  * connectivity with the fc-nvme host, so the target may never get a
@@ -2294,7 +2294,7 @@ nvmet_fc_transfer_fcp_data(struct nvmet_fc_tgtport *tgtport,
 	ret = tgtport->ops->fcp_op(&tgtport->fc_target_port, fod->fcpreq);
 	if (ret) {
 		/*
-		 * should be ok to set w/o lock as its in the thread of
+		 * should be ok to set w/o lock as it's in the thread of
 		 * execution (not an async timer routine) and doesn't
 		 * contend with any clearing action
 		 */
@@ -2612,7 +2612,7 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
  * and the api of the FC LLDD which may issue a hw command to send the
  * response, but the LLDD may not get the hw completion for that command
  * and upcall the nvmet_fc layer before a new command may be
- * asynchronously received - its possible for a command to be received
+ * asynchronously received - it's possible for a command to be received
  * before the LLDD and nvmet_fc have recycled the job structure. It gives
  * the appearance of more commands received than fits in the sq.
  * To alleviate this scenario, a temporary queue is maintained in the
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 78b541a6fb089..970452397b5d5 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1780,7 +1780,7 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
  * We registered an ib_client to handle device removal for queues,
  * so we only need to handle the listening port cm_ids. In this case
  * we nullify the priv to prevent double cm_id destruction and destroying
- * the cm_id implicitely by returning a non-zero rc to the callout.
+ * the cm_id implicitly by returning a non-zero rc to the callout.
  */
 static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 		struct nvmet_rdma_queue *queue)
@@ -1791,7 +1791,7 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 		/*
 		 * This is a queue cm_id. we have registered
 		 * an ib_client to handle queues removal
-		 * so don't interfear and just return.
+		 * so don't interfere and just return.
 		 */
 		return 0;
 	}
@@ -1809,7 +1809,7 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 
 	/*
 	 * We need to return 1 so that the core will destroy
-	 * it's own ID.  What a great API design..
+	 * its own ID.  What a great API design..
 	 */
 	return 1;
 }
-- 
2.53.0



