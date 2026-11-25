Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618435;
	b=jiol5Gf6ULF9uXn9N5BfhVz3h9dTUI1vVYOD+vpA31wKLRP3AjOI1X0X7bdVjoSMndNW
	 5jepOmvdasoS+8V8GGBcSj1sLug48kjZ5Ld+szsOWeVSMdgaTJT4jl4BBCIQEv/Sy75T7
	 4F8UBfot3ji7xKDKq6HbTBOOcse+ZGrAMGD+VSuH1NpCX5Dyd+Iw7N3uDGOYDj7EAZ/EJ
	 nQOKwkJbm85sOM80J9zj+mCozRFT1kaHEsgP+2PUOGE2GMuzaxDWTvOGi1EuiuQBEojv7
	 UGz+UWQtkd02TqA821+GaK9K0MDxY6em98Lc54mChzteJO6KgHpSiolBU3WDBGA02bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3cKYyGdNuYgCgfoDfU+MOXGZagkQuC6K5g/212i+F00=;
	b=k1Yo1xV5puy3H7Q/crLJdYBrz+Eq6L+mIcb1Gop8NCT8YBHxlzzJP4034i+lq7El9dN2
	 +OSjtaX4vKeeofv19GspVDZc2LNQsje6dxi8BWH6+7TsMXWeDURnOFTXzyMr/OlDBiCxV
	 xVhbCjEzw4hcq4gKLSHdMQ2BVp0ezZOeeSfFY0ywSKmsvzj5vm1Pjhd08moeeTk1WsbyY
	 qb46GpYW1GQCmika96hP3oSmmf/kTCwa2sHjsEl+Bj8AqI/wG0w7AYqFUK8BdE+sksRoq
	 82TWmx0mGxFE1OZCDnq0ufRevwQ7oWGA469Q3cvXnk5b2DySEFrGAMhm4T+LB+JNOoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EGPN0SUg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA37606A321;
	Wed, 25 Nov 2026 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EGPN0SUg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29FE1F000C6;
	Wed, 25 Nov 2026 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618435;
	bh=3cKYyGdNuYgCgfoDfU+MOXGZagkQuC6K5g/212i+F00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGPN0SUg4sH4t11x1SSD1LmD3k4Wui6JHauMnl9/ToibbPfcsDONzu+Eoj+0GCLZe
	 HTnXH4530Bx4+Os/XyPsZe6T8b8Mc5HbPRlM17eK5z7heG7dF/3zij5IaGC2njxUPM
	 GWp2qbv6E/AIKQdA8Hj5SeqK15jCtuXHj9KkzB2E=
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
Subject: [PATCH 7.3 0262/1005] nvmet-rdma: disconnect a queue on device removal
Date: Wed, 25 Nov 2026 15:26:40 +0100
Message-ID: <20261125143827.875732809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index e7dbfa383c57d..ff387fc47885d 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1782,10 +1782,13 @@ static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
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
@@ -1793,11 +1796,7 @@ static int nvmet_rdma_device_removal(struct rdma_cm_id *cm_id,
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



