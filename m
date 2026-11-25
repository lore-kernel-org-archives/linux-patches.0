Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624441;
	b=CObm1efdT2PY0MVcP2Z3+2u3yRRVj8x25OKoo4C1dkDT0UG+QBdBhd1yamno/4v9mI3z
	 UrGWD+EmHhpJa/ajIo9PZYcMTqXrPQ5Tr15e8Q0rGVXvP5I7ETZWze98luUov88pz5CbO
	 JYEr9SrGqRqn3C33sLno+1EEjCh0FlZxRKkq11+om4zUuOlm5Mh3KvXXAHG6fQeyut/fN
	 ArKNvDEQdpoLcRHFDcEu8ysSwLT/Poqz4gxmqmLZc8qkDHgbAYu1COCuMMzbW9MT0ZlqP
	 TS4+0C7MCTJnVvxsNGaJMWHVscR/RYAWKAbs1RMWs8RFe/AJOIOkBehMIcx5ztMv8wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aTP9zBKzhfJo/O0xzn0EbO4vGiWInjiYA+oblFOyxgM=;
	b=D7f8H2q0Q5MroNfRa7EdE5b3A7eM+I2V9Ro4TaO7JzknqnRPXp0Ib3Q19X9BNGBzrv/C
	 kOqiNT7H/jFQO1xboMgYJYEF4USQeYJdbPNsS0oEkj1DALBz+AIP8SCB9B3N8sb8Qm7it
	 T6rgNtFw9MWo6aTsUmWBsoXwZbha1m17EM0HrJONrauLN/UsDM7omIChYT2vHbn+PX6Yu
	 +kfzzUc+igRIUjE5Qt3hqRNJ7Pj81Oh/aiBRt7Ut0KUnxGhUQlRsNCEJN/rBOcgj9xMjL
	 zFtPuEVzKei42hZApGQNhbh2kIEx5f/BHdYcq7MwvIq4nmw3bbZtbKMbLGJCrg74EUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdvG2bLN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B8C606A32D;
	Wed, 25 Nov 2026 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdvG2bLN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A261F000C4;
	Wed, 25 Nov 2026 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624441;
	bh=aTP9zBKzhfJo/O0xzn0EbO4vGiWInjiYA+oblFOyxgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdvG2bLNNNAIrPmBy+6Zn0EtuqQe9vtRLS9ZIb+Edf4g80jcvjSh935fMVJiiG2xA
	 Ha1S+GhT9EOLVn9rOvz96ksULEn/BaYcQ2A3+oFjoZqJ4BOh9j0dgQCHH73++CsigF
	 V5l41HioV7Ik2cxk2dRLnMAE5AZ9wZDpp677miRg=
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
Subject: [PATCH 6.12 194/816] nvmet-rdma: disconnect only established queues
Date: Wed, 25 Nov 2026 15:29:02 +0100
Message-ID: <20261125143853.685449947@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 000a9f4492abad6008682b55571ddc31941963e3 ]

Over iWARP, rdma_disconnect() sleeps in iw_cm_disconnect() until the
ESTABLISHED event of the connection has been handled, and iw_cm handles
all events of all connections one at a time on iw_cm_wq.
nvmet_rdma_destroy_port_queues(), nvmet_rdma_remove_one() and
nvmet_rdma_delete_ctrl() walk the queue list with
nvmet_rdma_queue_mutex held and call rdma_disconnect() for each, while
nvmet_rdma_cm_handler() takes the same mutex. If the walk sleeps on a
queue whose ESTABLISHED is queued behind another queue's event, both
are stuck and iWARP connection handling is dead until reboot. A peer
sets that up by connecting in a loop, or over siw by asking for MPA
peer-to-peer mode and then staying silent, which delays ESTABLISHED
indefinitely.

Only call rdma_disconnect() for a queue in NVMET_RDMA_Q_LIVE, which the
handler sets when it gets ESTABLISHED. A queue that never got there is
left to the release work: ib_drain_qp() moves the QP to the error
state, which ends the connection, and rdma_destroy_id() tells the peer.
Over IB and RoCE the skipped call did nothing more than that.

Fixes: f1d4ef7d8883 ("nvmet-rdma: register ib_client to not deadlock in device removal")
Fixes: fcf73a804c7d ("nvmet-rdma: fix use-after-free when a port is removed")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 7e715d0436f8b..7db9812c4e16b 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1689,7 +1689,7 @@ static void nvmet_rdma_queue_established(struct nvmet_rdma_queue *queue)
 
 static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 {
-	bool disconnect = false;
+	bool disconnect = false, live = false;
 	unsigned long flags;
 
 	pr_debug("cm_id= %p queue->state= %d\n", queue->cm_id, queue->state);
@@ -1708,6 +1708,7 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 		}
 		fallthrough;
 	case NVMET_RDMA_Q_LIVE:
+		live = queue->state == NVMET_RDMA_Q_LIVE;
 		queue->state = NVMET_RDMA_Q_DISCONNECTING;
 		disconnect = true;
 		break;
@@ -1717,7 +1718,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 	spin_unlock_irqrestore(&queue->state_lock, flags);
 
 	if (disconnect) {
-		rdma_disconnect(queue->cm_id);
+		/*
+		 * Over iWARP rdma_disconnect() sleeps until the CM has handled
+		 * the ESTABLISHED event of this connection. The CM handles the
+		 * events of all connections one at a time, and our handler
+		 * takes nvmet_rdma_queue_mutex, which callers of this function
+		 * hold. So a queue that has not seen the event is left to the
+		 * release work: ib_drain_qp() moves the queue pair to the error
+		 * state, which ends the connection.
+		 */
+		if (live)
+			rdma_disconnect(queue->cm_id);
 		queue_work(nvmet_wq, &queue->release_work);
 	}
 }
-- 
2.53.0



