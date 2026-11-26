Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704291;
	b=LvVXBxvLDn0MMAk9GEjwbfokIPCxFVE0jLTZ1EhNFnHhNVqMcEU1Dflly4JptINocADN
	 xs3MUWWaTniSKAkA85cVZiNvyQ6udTt31wY/7SFIhnJJsTsEUxThoNGRrxJg68DkE6rTZ
	 aXhxLnqvCYEr+BlfxOWidnZe0HsKU4PW+T/Yk7FoQUCXwtFiYC1EZa1UJHLw7ABPsGBoJ
	 OfwO75m2ZT8o6x2D7olrEMrHpkfZJxhf0zpjdM9d9ReFaM1IejI5UnOB+9Xh7QMGuoinI
	 T3mdfGMMknxSCuvJla5nqqvwuA0cyyMdv/4HD93U/eBLRxgCtpJObpKW3EOvCUAuIwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XpPmdfFMToHoHwM4HIXJxbB6RC7e9K0ezEGYz+rsl+M=;
	b=Pds0QK7rmDzThbG5bVcTqbC/9fJluWqFxR4XNvCyOKnKA92eezVGNPvz7EKt0FwHUJEq
	 EM3eSifzNaTstugvuYs001ubb+wH+RDdMSjTUI7ITy6XwFjcHj7atntonTxXmyA6DlXww
	 hsqWbOVpSJFLe3uq6LbNG3UL5nFd35YzMdIGZJMqMw9MxUlNkSlPP61sNi+0VuqDG7kqT
	 j6JLr+nUniMccCGYi+Xk8cAKBHmRi6W/4cv0UQGe4Wyh3JB/ZJgeUM+1+Zk/Hnu+KMFsw
	 MWlQiXJHQoN03QLpgwoeFK6+FiFbWYhIKuo5pQ0zwlVDCkNZ7Xs2waMaLi4ht5aqoZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xq+i7OdQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDFF606A31E;
	Thu, 26 Nov 2026 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xq+i7OdQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573251F000C4;
	Thu, 26 Nov 2026 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704290;
	bh=XpPmdfFMToHoHwM4HIXJxbB6RC7e9K0ezEGYz+rsl+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xq+i7OdQJoXUxHYxPC39Sfe8fmulg4nTO5Rq9KXsCezMcgya3INfPC4CuH4unQeC4
	 ON7gX8C9PqioqJyT9WTb49RW55/4uKQpv9ue7wHID8z1itlpumrZ9kbmr8irOzp4Ke
	 KE/bElBY4fyI9mWQ6MdRZADmBCIO2t4rMXjvuS0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/265] nvmet-rdma: disconnect a queue on device removal
Date: Thu, 26 Nov 2026 15:36:42 +0100
Message-ID: <20261126143610.104295670@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit a4387799d4228866dc1746b466cd17e1c638d050 ]

cma_remove_one() sends DEVICE_REMOVAL to the owner of every cm_id on
the device and then waits, without timeout, until they're all
destroyed. nvmet_rdma_device_removal() does nothing for a queue cm_id
and leaves the queues to nvmet_rdma_remove_one(), which only works if
that runs first. As a module it does, nvmet-rdma registers after
rdma_cm. Built in, both register at the same initcall level and
drivers/Makefile lists nvme/ ahead of infiniband/, so cma_remove_one()
runs first and waits for cm_ids that only the later callback would
destroy. Since the RDMA CM drops all later events for a cm_id once it
has sent DEVICE_REMOVAL, a peer closing its connection doesn't help
either. One connection from anyone who can reach the port hangs "rdma
link delete" until something else ends the queue.

Call nvmet_rdma_queue_disconnect() for the queue. It unlists the queue
and queues the release work, which destroys the cm_id. Don't wait for
it, rdma_destroy_id() waits for the handler to return, which was the
deadlock before commit f1d4ef7d8883.

Fixes: f1d4ef7d8883 ("nvmet-rdma: register ib_client to not deadlock in device removal")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 04496a4db7c41..e6269e3391d98 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1738,10 +1738,13 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
  * queue cm_id and/or a device bound listener cm_id (where in this
  * case queue will be null).
  *
- * We registered an ib_client to handle device removal for queues,
- * so we only need to handle the listening port cm_ids. In this case
- * we nullify the priv to prevent double cm_id destruction and destroying
- * the cm_id implicitly by returning a non-zero rc to the callout.
+ * The RDMA CM waits until each cm_id of the device is destroyed, so a queue
+ * has to go now. Our ib_client also removes the queues, but it cannot be
+ * relied on here: built in, it is called after the RDMA CM's client.
+ *
+ * For a listening port cm_id we nullify the priv to prevent double cm_id
+ * destruction and destroying the cm_id implicitly by returning a non-zero
+ * rc to the callout.
  */
 static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 		struct nvmet_rdma_queue *queue)
@@ -1749,11 +1752,7 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
 	struct nvmet_rdma_port *port;
 
 	if (queue) {
-		/*
-		 * This is a queue cm_id. we have registered
-		 * an ib_client to handle queues removal
-		 * so don't interfere and just return.
-		 */
+		nvmet_rdma_queue_disconnect(queue);
 		return 0;
 	}
 
-- 
2.53.0



