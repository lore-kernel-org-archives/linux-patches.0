Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621483;
	b=WiX8OH75gePFYsK9GorkttxaVF2F1bIlZZzakjfI+xxJiLz/c40QBQ4CinmbifnQuQEQ
	 GcxBu2O2QDAPuvpwXeVIGVhhnZvXmm4Qdu8c5EV9k2y91J48mso2zdYStLuNnxwSO+v9N
	 kOKXOzIz5s0nR55g/VgOONTSYi+OQ7iPsqxB1yaOS6blW09M47gKEDtZ29oiLiecvly/F
	 zaj6yYnnyMq4qILZ/+I7jKOUv/NJHbgzbt/KNHTfqLnt1qmMTA1RencKxOgit5mxoo3Z2
	 Rf8YMTRBS96RpAIEoqQGmiwZKbtAEuPljfTrMBW5njoClavyZzhtVEmWnHen1ZBPhjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uC+Ah/QpYmIectYdKcLVrsBaTwhzIH1UICxu9VBpTX0=;
	b=wwrDSimXFijXUeOvsHF16KGOhHyticjRq0WXI/kh4DQp0gBRavYecM3sPBl/Is4dXgt0
	 t9fR+3PU83xDJRN0MI75SJxtFylXvXtznWLEc09/5Rf0CNVkMLaFFLVFwoRZ7BZ0McPkh
	 AmHrw+b27FXH/d1zYk24RlqW1OfLH+0tf30MhL5WPXqNASLrozl2ULNbwiIfwc17HfyZB
	 wd4oUSsWTtX03ge8qhAO94sVUkG3XGiqQarkxeUN5V4QrHAXfyr6WwFtGpSO1KnumwCyI
	 PVwBBqbGgEznP4rgc+TgVznhU828S9eiBHU3iCmWAXzCYu+elChs2e9UGw+IHeib6/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J7Yk7kiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B985606A326;
	Wed, 25 Nov 2026 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J7Yk7kiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998C71F000C0;
	Wed, 25 Nov 2026 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621483;
	bh=uC+Ah/QpYmIectYdKcLVrsBaTwhzIH1UICxu9VBpTX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7Yk7kiOxc0AG927WrhAJ5YX8Yd8RvNxdRPemeaZzyUctnF/ioKS+sW1DxIM8FBfY
	 MmwgdoEX8cERyQU/fux9PDgCkpIIFm1LVFoqrhX7AWBq1XVBs/Keg0bW9eDu3801QZ
	 eMydzhqa8fx/3qVIHpxWW3liXiFJO4VsB8Q6GFCA=
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
Subject: [PATCH 6.18 238/990] nvmet-rdma: disconnect only established queues
Date: Wed, 25 Nov 2026 15:26:45 +0100
Message-ID: <20261125143827.665951062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 20e574a4eac64..338933d15b38e 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1691,7 +1691,7 @@ static void nvmet_rdma_queue_established(struct nvmet_rdma_queue *queue)
 
 static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 {
-	bool disconnect = false;
+	bool disconnect = false, live = false;
 	unsigned long flags;
 
 	pr_debug("cm_id= %p queue->state= %d\n", queue->cm_id, queue->state);
@@ -1710,6 +1710,7 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 		}
 		fallthrough;
 	case NVMET_RDMA_Q_LIVE:
+		live = queue->state == NVMET_RDMA_Q_LIVE;
 		queue->state = NVMET_RDMA_Q_DISCONNECTING;
 		disconnect = true;
 		break;
@@ -1719,7 +1720,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
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



