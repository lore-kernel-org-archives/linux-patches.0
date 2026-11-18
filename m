Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028123;
	b=fd/Vni79ZBNw/jxzN8ew5zk2eVqUHvjPMRJhnDbBlrjpd2QMQYsypMxCc+2HYHCdyBoW
	 5dDArQLY+yrrXb46wydjli77vfGUEAvvaC9nLw+3tcmgtSiMbTYE2Tz96TvtUxEqqv7tW
	 tfoNVbPfrh8GEnAtXrS6KVVTfHzDwhDO0frw5b3EIb+hgjxxtrwWxRjLOaETpd7dsqwwu
	 AKgY3DrFZpElJrVHqgW7yus8JJcuR/+/GFbzkdZkpNcfo81gNttmTqR33b/Eeniu7GIcT
	 wEa+j11YgwbDstWns3kgkx6K4lylrL1IGQ3TDgBIehw+FWtWNtnqP5yh4FxBVPXpMdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gopjbl7yMtH9G9eycVyMq0emozQW/U9J3y11NZpEVNg=;
	b=D2oogMkgZqEmRmMG6ZIo0W0rQslHTosik3JxvHQW8Os8mTZk3NCfEHAF37LBPOqG6jP6
	 CA823u8gGZeCK3RbnYHlydjvYSoP3tvoIzUxL77OWZCB1nAQDSqWxQjQFPIcWyGw6APN9
	 gvdqKt/lKvxYMRrjAe8UGtUhDluRRam5dOR8C2x+LHiESk5cJmsPdSxlRnp9zXk7eAYSf
	 kXZ0yTS3D5ZNgBsHJtQJOG0ggZj05COb0cqgwAdUA6ER24gPQrNeSW2aE0y2HjZO1CcD7
	 YlQclTAWpzDPcztbCimyO7y0A8VJqQuvh3MzmvThObFbvG/MJkSw2NUhiYTLZ2nTu1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8bZRwFh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35535606A333;
	Wed, 18 Nov 2026 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8bZRwFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5011F000C4;
	Wed, 18 Nov 2026 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028123;
	bh=Gopjbl7yMtH9G9eycVyMq0emozQW/U9J3y11NZpEVNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8bZRwFh0EqCOr98sQjgoBRNAgzTXQoONAKZJ0Pjjqe5eV4jZyRZhU2ZhMSqhyEVy
	 xf3SkaHbkYk67dlBlOEHkxc+Xx161zT+DpUieLUpyVSGBdoc+D8sLV7/eJqT1bUHDM
	 jzup4Fe2sV4m574ET+dtO2EPa/DmcOOLTqkupqsA=
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
Subject: [PATCH 6.18 2032/2151] nvmet-tcp: dont read a removed port at Connect time
Date: Wed, 18 Nov 2026 16:02:47 +0100
Message-ID: <20261118150235.757607619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 1e7e68e008c71..6f8d5c268a221 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -166,6 +166,7 @@ enum nvmet_tcp_queue_state {
 struct nvmet_tcp_queue {
 	struct socket		*sock;
 	struct nvmet_tcp_port	*port;
+	struct nvmet_port	*nport;
 	struct work_struct	io_work;
 	struct nvmet_cq		nvme_cq;
 	struct nvmet_sq		nvme_sq;
@@ -1535,7 +1536,7 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	u8 hdgst = nvmet_tcp_hdgst_len(queue);
 
 	c->queue = queue;
-	c->req.port = queue->port->nport;
+	c->req.port = queue->nport;
 
 	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
@@ -1991,6 +1992,8 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



