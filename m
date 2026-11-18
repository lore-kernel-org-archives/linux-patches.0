Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050627;
	b=idNmmWqsAvci6Pdql9padDs8zjOgibTWQK9sMo9TQClAxzeH1ucGP6IHJ/ozRms0rrC7
	 RRokyKSHbT2XAOQkgZmeTRewGbBBIsGDDQjYVnH0HSQAMuqoBJC20FcY1j3JSZ874R/kB
	 7vl98JENUHChVmZpc7eKy74fRu7Vel/MhaDA3ElCnlrYCHnMAfAEZhsiCo8S9EGIQt0Xq
	 IrBoYjbB2N9lsmNAGGpkTmywHX35G9gRL0QHtbFtMWXzDer9dCOKDnZwkoyj2+oq8NZu5
	 zWdKO+IDT30GHOaQWuZRfZ8q7ReTfj5r4LUI/9eA7XorXWYhxDNzM8OyCRTqUZUHH/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rg6b/VlI5RVD+HnozSZI6eRZBUdWmkM1cJRyhhmaXA4=;
	b=apFHwldKCUhgpw/U0rjC2cWBXb/n+uRcG19VjyPsJdvvVKhlBWTtsInzausfUuw2Vz/Z
	 XNyRLIjKL9ZkgJEOj5kdfUicOyubAMGrJqWJODt8Iw/wLDzHcTtk745Kd5tmjKXD+cT+U
	 ySeiW7DpLTnyMUTBp7UsANXVA/3H3Co1b6oqWRMJp3oxxS/cDGiT22VGELvFn3tftqq6J
	 /mELFy7P2ALkpKouxX9qGwqZUFGEQeDXGHUKe+PsHJ8ozBTP4CfaIq6ztgZY6H9LcRZkC
	 D1rVa62ik0t1oAwMHhMl0yVzn7N1HJNQIkJUwjTSCkeNxNh4rIFgZ1FwpBiZ/v4jSzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJ336q0z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E21606A320;
	Thu, 19 Nov 2026 01:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJ336q0z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854C11F000C4;
	Thu, 19 Nov 2026 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050627;
	bh=Rg6b/VlI5RVD+HnozSZI6eRZBUdWmkM1cJRyhhmaXA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJ336q0zwSrlmtBUr/iJ5Z2zCAB20BJ/sX3FVWwTnd8xpdmGcRPeihfImJh2EAZp5
	 Ra+HeRaL3Rqn5syP9N0XIoaGgEPrxGPbisEj7QAT0Cq+gZRuUQHPVuV/li6RITiZXM
	 zacUzSJ8DzE1FQRLPjh19RLTmYDpLgRsrIPpgAfY=
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
Subject: [PATCH 6.1 2775/2857] nvmet-tcp: dont read a removed port at Connect time
Date: Wed, 18 Nov 2026 16:03:29 +0100
Message-ID: <20261118150341.516445824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ae654bccfbd11..608464d2f308b 100644
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
@@ -1419,7 +1420,7 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	u8 hdgst = nvmet_tcp_hdgst_len(queue);
 
 	c->queue = queue;
-	c->req.port = queue->port->nport;
+	c->req.port = queue->nport;
 
 	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
@@ -1703,6 +1704,8 @@ static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



