Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033062;
	b=LD3H+38cA/4xX9oXmsnKlParIIk6s8AAdfnD+Bdao0MjQXU4rqARx1eIGOkYM7caWm7a
	 HrhwBrc4QLrk2fs5dLstBQUd4/HSz0XTm41kv7HGdPg4nn7D9g+W5S06Hv+a0KmFOH9iO
	 1gfCyaYvsU6IgigwGHD2nCgFm44UuMUbccxqv8/vtD7DBwicejtEyM5HUtSB/RDIpsHOw
	 0I1Wq3w62NZEh5yWVWA8XvNW9FXE7cTJCpRKhLUQOzVI9qaPSddg3mZfZIqS36UNkAeBH
	 WF/8emN9nNUPnA5kjL7o0GjGN3b0LjdrH2r51dUE6JGdCjT+0T/P8LME/I18aVIbsLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bk7lV4+SdpAqZepVeIRghX32bCuiy+9aexo3GswzxO4=;
	b=NWOSGQKNpd7ugpxsDkRjOG923MGAzR89BXwuRBqascy2NsMaYVzBivIitmiK8FiAAsg2
	 ahEHe5mnIYe4V/z237WyGug+bQU8qJdIJePlBozsVI7KGVIW3hF/ROhCkCmZ/cdxPvxLV
	 yr6cZQyrrPdbUZQXRgZglBLwCvmqQeIcg+gGRt0WB52TIpsjYLvBZ/u92D/qoUlBQm/Tl
	 ihgnPGjqv8+1UEHzklDiTx2fIv+eGB7MDKRhu8zKS5rglfnHgXsbrOsN1ib6nonF4LmTE
	 tPAt3IZDMF/wcAZjT6s9R6fDKHhchgLMj8M4TP78HEqlURSYJpZzmzrP6xgi+a015lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNGR00dv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9008606A31C;
	Wed, 18 Nov 2026 20:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNGR00dv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50301F000C4;
	Wed, 18 Nov 2026 20:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033062;
	bh=Bk7lV4+SdpAqZepVeIRghX32bCuiy+9aexo3GswzxO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNGR00dvTO20TAYZOImakEGxZUuLqsZAdzPf2QTV6oyssEq4PwWf0JA8sJ2IMTFTM
	 TXwxmdcVkBdtOfinj2aVcIOO+GxL42ijY2F3vV5CMVWgKAb3sRcsMILH82OxBkZIXP
	 ojWyHQtVhMk7TH4ETSV5Ozcm9+tcaIc37kofC0mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1633/1756] nvmet-tcp: dont read a removed port at Connect time
Date: Wed, 18 Nov 2026 16:02:40 +0100
Message-ID: <20261118150114.797434380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3f98ce65a87979e881343dcf082c9595ec90ddc7 ]

nvmet_tcp_alloc_cmd() takes the nvmet port of a command from
queue->port, and the commands of a queue are allocated from the io work
when the Connect arrives. nvmet_tcp_remove_port() shuts down the queues
that have no controller yet and frees the port without waiting for
them, they're released later from a work. An io work handling a Connect
at that moment reads the freed port for every command of the queue and
hands the result to the core.

Note the nvmet port in the queue at allocation. It outlives the
transport port.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 3c38646d97e44..afcc55d5af661 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -150,6 +150,7 @@ enum nvmet_tcp_queue_state {
 struct nvmet_tcp_queue {
 	struct socket		*sock;
 	struct nvmet_tcp_port	*port;
+	struct nvmet_port	*nport;
 	struct work_struct	io_work;
 	struct nvmet_cq		nvme_cq;
 	struct nvmet_sq		nvme_sq;
@@ -1557,7 +1558,7 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	u8 hdgst = nvmet_tcp_hdgst_len(queue);
 
 	c->queue = queue;
-	c->req.port = queue->port->nport;
+	c->req.port = queue->nport;
 
 	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
@@ -1988,6 +1989,8 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	kref_init(&queue->kref);
 	queue->sock = newsock;
 	queue->port = port;
+	/* The port may be gone when the commands are allocated */
+	queue->nport = port->nport;
 	queue->nr_cmds = 0;
 	spin_lock_init(&queue->state_lock);
 	if (queue->port->nport->disc_addr.tsas.tcp.sectype ==
-- 
2.53.0



