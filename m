Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022207;
	b=jRIScWUTxqAsSwUdZglghFvrBRN88avewhpw33ibhhuVm5vYlXSWOJXWevV6l0NA2eaQ
	 u4AYBaYv9WfiU4DZ+y/OQHxtci/6Oy2229mM7d6VJCXGZsSnXmh21/Z8I64on+v8bzyaO
	 F+suzH5r78j31saLa0xUtCCDtuejsXpVNdGSd5GpZ4QXNJv+hv+Ic26foBt0jGsbYL+Xj
	 PEwR/SrIjCN5rztEzOzrgUEshAwkTPQrKahT5wpF3psvt+Nqzwm2HZaRuVxmyN6Jwbrlz
	 WFmyalh9eMkWxniIHcg8diHneSNhXIGLv/vyX2MDTDSrQ+dcDJnbrjnvSWofgDN4wVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/bnUn83Wkn8RYMsgXe4rrEIZ8R0/4KeViigdlx4suyE=;
	b=l0kk3RQpEFluDqE7gb/K55cM1HW5JriZhMTpZMd9tGe4jqFidcDcogYYqIBtHL1iwAcC
	 DV57RxllYYFZbPG/MsN6SNTORZviSBTesQB8TA4vKGk8m9ZXwe39kozEfO3q6OojuenLT
	 IUOVDOkhUw5c4SAEw9S7FVm9gtjTE797Gzjv81+Z/+uqvxzKpbhGKqb7N/uZWpLYx7kc1
	 o7A+hBL7ZIZJwIU5X+eVoRWNYSOBT5qlp/6fELLjcICzzwRub4WkjjxkqZ4zHcMAQ2Qrk
	 w8PBu4BrPMWshoCFV34gXQS86Bt43b11xyh2/YOVtZfJkRkL1QbC7S2PbWNMYPrQhrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NH5gjEX1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D486606A31C;
	Wed, 18 Nov 2026 17:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NH5gjEX1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B671F000C5;
	Wed, 18 Nov 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022207;
	bh=/bnUn83Wkn8RYMsgXe4rrEIZ8R0/4KeViigdlx4suyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NH5gjEX1kRGQQ9TM+s7pPJdjhhNCHPPihBtPL0WSfmKNhkZdgLqXU1UfdvFf3QtO0
	 guaoL8TAiJ/BMxikzaunpIuo/F9UaLe6QVl7QaYhWPYheVOKQnKjGNEEOFHwCXdjMA
	 4FtkkedVQ/h8URlT0zWQ329m78jAFjsQGE7axH2g=
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
Subject: [PATCH 7.3 2539/2651] nvmet-tcp: dont read a removed port at Connect time
Date: Wed, 18 Nov 2026 16:02:59 +0100
Message-ID: <20261118150415.975145538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 84af7d1bc588b..85a10679d0a93 100644
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
@@ -1512,7 +1513,7 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	u8 hdgst = nvmet_tcp_hdgst_len(queue);
 
 	c->queue = queue;
-	c->req.port = queue->port->nport;
+	c->req.port = queue->nport;
 
 	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
@@ -1969,6 +1970,8 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



