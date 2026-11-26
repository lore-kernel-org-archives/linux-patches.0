Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705219;
	b=nyJt4R68QqpkR/E1+dBtvXSiDZRjjuYIALfb83INadFlqxIXjUC2dLFPsbIsBjV2kIjw
	 CtubHRNwIikhgAKGdeuuSure91Q8oFzTgJ/iBlzXI5lY8UpXZGvz49vp4x4CppP9gGvxh
	 SDdrOCadg4gamXuOhDE4ky8VnFAPAAkklxUKDrnkaf2hDXV9z7YW1W0lg6Jc8Pt1BC/qT
	 i1cmQolVRzJs+DiIqWOlUCJS/dL7eV5bXjp1x+xeimtU6ypRwwZmHRlWIpJ7BSGaGx57j
	 20AmGwminWYqpUS3EMJR4BbC/bcYglTwl2K5FQzlw1KYqRdua2KGHYLQ52WFwfo7/9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6toGyUI6XAt21t5mnAKkunhr7+KLlOJY6Oi4MGwbiZk=;
	b=XKCSnhsjqNandJm01eqHTNBT7AsAuhGM60qhu8D6Rr9+wA5NHffTb8IVcJ7z/2yR7P92
	 FTWNh6qe/SyGfUaw3g631cGZKQj1Rp1+XQGB75UDWuGk/n+vRiMS4nVivbrOFEeJah9Z0
	 XDaxRmjHTuI2jQZeim5EhsNvtgV3CYKMnpaGyJJj0vsvcMQfR712LhxBzgxfu4s+3WZFB
	 fOt3qgF2dxS9NOt4L8SBT769qkw8WJBnZ1TcHbDH81XEnPgxj7dG2YI4guGn7MS+n7a+6
	 m2/aGoFHmElkPGSURnp9U7aBaiKHxWRcvJmf7jqyWucx7ApiVUIrZopfDjbSoN6nCGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aw8Wh4uN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B057606A321;
	Thu, 26 Nov 2026 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aw8Wh4uN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E73A1F000C0;
	Thu, 26 Nov 2026 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705218;
	bh=6toGyUI6XAt21t5mnAKkunhr7+KLlOJY6Oi4MGwbiZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aw8Wh4uN8J0qd9KH+bC/WXk1urbnbIo1JMyNQ24IwwSdsXGKJbPksTpRm7tDtMXa8
	 nYt7t2ORC7UQxmPaRQ8guAQvf8QW0QD1uk/iKv3e4egsYO2+62tuq0rA5nDq1JUUHr
	 aqsaa6SF0HBq5uE0yJhbhjZVNpSaybmg9jiPuhvo=
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
Subject: [PATCH 5.15 079/319] nvmet-rdma: disconnect only established queues
Date: Thu, 26 Nov 2026 15:37:27 +0100
Message-ID: <20261126144008.524062376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index f4819e2976a81..d9ca9510dac5f 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1690,7 +1690,7 @@ static void nvmet_rdma_queue_established(struct nvmet_rdma_queue *queue)
 
 static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 {
-	bool disconnect = false;
+	bool disconnect = false, live = false;
 	unsigned long flags;
 
 	pr_debug("cm_id= %p queue->state= %d\n", queue->cm_id, queue->state);
@@ -1709,6 +1709,7 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 		}
 		fallthrough;
 	case NVMET_RDMA_Q_LIVE:
+		live = queue->state == NVMET_RDMA_Q_LIVE;
 		queue->state = NVMET_RDMA_Q_DISCONNECTING;
 		disconnect = true;
 		break;
@@ -1718,7 +1719,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
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



