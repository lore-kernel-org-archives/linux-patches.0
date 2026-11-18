Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056914;
	b=dEb91T+0lxeZLmLfCXw1P20WF+ATrVTt3SZ9QmSaVowaFAyauxBlBIOnTUnOtDDortZG
	 JYZ8de2BcOQp5KEJF8Xr74/Vt87Gd6UT4h0b+NYmR+UCNAz0OpKEzvH8VxBCbBQLsF3Xk
	 2vFqRCxApyWgKzSqC6LSl7RL4ycogGTTq27c65uHJQoKeGCkKLYAmrcb30uqk1ogF6sq4
	 GnWFFAiMq9UBt9WPQC40O1p7ctkXASqG4c3zg+RLmWW7e5ZPy2WDpfVQtFOjTztqh4/RB
	 Ci3xhClmekfXffY+N7ajnDbYqYmqAfiXNUitQ7BXnRb773srMRBBJW3Vg9jtURQCs9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GSWSV6Of0TYxiI7Jf4pfN8tv33po6QPWjMt8ggpGRi4=;
	b=T7IkAbgQ14PCmzIbsheCxUp/bvAcGui5fQ8+MO/VRZoCOq7/S7Jk/Ga2+PpYBR+zCSgd
	 hcRBiloQVRDd1UirexbEvUrzWdAgGZ/qRDYn6LkE+ayYEe9rj709Ji43K75cTPCw2Fhl/
	 CPb8gSEt9XbLOfqcnq1w7Sz4TjUVbuYPHUcZr3A43wKc0fhQEO3S7+MbukwxX/bwdbtHz
	 zUGg0za2K8juuLvQfmrbWxytjXopql0JAR534dKegsLolTXj+QtTZuxBGBfJhDeg5aJpa
	 BBNLksoZu2g+ez/ZcOO6vZPva7lNcfCJMcBI9OJXGIdIGaqDe82vhs30JXkWgu39UNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKPEZY0p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F699606A31C;
	Thu, 19 Nov 2026 02:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKPEZY0p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D0B1F000C4;
	Thu, 19 Nov 2026 02:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056913;
	bh=GSWSV6Of0TYxiI7Jf4pfN8tv33po6QPWjMt8ggpGRi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKPEZY0pimEoSt/olQVt7OP2Mmh4nXaSxbnRrTCQRsFwhu8mpvldLVsQarBcRWPKT
	 a74uS/RNTXEwzwh33QrgLbSzlIJEa8vyPxb9QjMBd9LdJR8JK/8NfMLWeRf364+8Vk
	 0rL3wtTtQNvjfMCupbhQRhWPhC3tG8wRZJRlt7yE=
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
Subject: [PATCH 5.15 2156/2214] nvmet-tcp: dont read a removed port at Connect time
Date: Wed, 18 Nov 2026 16:03:52 +0100
Message-ID: <20261118150136.708177849@linuxfoundation.org>
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
index 458f679b10532..76f9dae1086fe 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -104,6 +104,7 @@ enum nvmet_tcp_queue_state {
 struct nvmet_tcp_queue {
 	struct socket		*sock;
 	struct nvmet_tcp_port	*port;
+	struct nvmet_port	*nport;
 	struct work_struct	io_work;
 	struct nvmet_cq		nvme_cq;
 	struct nvmet_sq		nvme_sq;
@@ -1400,7 +1401,7 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	u8 hdgst = nvmet_tcp_hdgst_len(queue);
 
 	c->queue = queue;
-	c->req.port = queue->port->nport;
+	c->req.port = queue->nport;
 
 	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
@@ -1679,6 +1680,8 @@ static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	INIT_WORK(&queue->io_work, nvmet_tcp_io_work);
 	queue->sock = newsock;
 	queue->port = port;
+	/* The port may be gone when the commands are allocated */
+	queue->nport = port->nport;
 	queue->nr_cmds = 0;
 	spin_lock_init(&queue->state_lock);
 	queue->state = NVMET_TCP_Q_CONNECTING;
-- 
2.53.0



