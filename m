Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062135;
	b=ezTCr6DzY+iQq0sLcTyIo1yctPWpZSi4wyIpB8GoPw/pa3Mbrrlpn9xf4AKCe/COZAm4
	 vYve7J/qBpwMIubB0vd6pJ9eoisAvGc0WUm0dbRzGmZWLKEqWxX63ZoepUzc5mkfOfSwG
	 IGRp5NqTav9wp5zK2NTVS3S0TZ1MEDRBCWmxDBlehl9fVDdCH0yQcrn/mbdcOZtXNPTWs
	 DaBhOvthru20/JwBd3GD5zbdJ4+LCRImuCYXsy3uNPHJB5K1COXiO6QQFdUaMSx/iyD/c
	 vjUNSIBkblpDT4K7oSvETsWRF33NULzIyh6N846xuC6KFqmxtaXkFba1bxxgURhlObw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y/6Qjkqi7r0Ki0sgdp+znPYJYvY4G3fzO7FKQeN+bGU=;
	b=ruaVkUfHoLbTofj94tUL8RLfk2S1r1As7aFhhIjeuc0j8dDX7ZyZ3xv6pkvFik1oFWEK
	 xXIBn0qTJBlX/6KjRfevbGChJyRjwRpQz+a3Z6npvufUVmlgpmKsuK1UhT9doSgJFySN1
	 +MGXFdDrtgwhMIzEaaU/jywF7LwagU/2Te3AGDOC3ixjXzCJIvRSjA1JAtv7W1kfVOyJu
	 vR33bVpbM2szyw+duOnaPToWqf+Rdk/B6sZ6Jb45pwX9e+6Mp9LMY0A37iM8q424bfP+x
	 4n38niAgKnQX9bfgYqHu87TFe/EawVTUOtuCQLrEEqUT2oI35XoRIVYhGn+774c5P/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pV67ft9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A690B606A320;
	Thu, 19 Nov 2026 04:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pV67ft9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1101F000C4;
	Thu, 19 Nov 2026 04:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062135;
	bh=Y/6Qjkqi7r0Ki0sgdp+znPYJYvY4G3fzO7FKQeN+bGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pV67ft9G9y8ueWOCp1yzX9y1v1vyqHvAZIOEUJ1SHDWxr0Saslwg3X/g17APIgpdB
	 Xfrxlc0vumNI++VJA+yGkUhjIhruZG/Gp32ahrJy7G6up/EHmBQEIPjuFLw+DXEEvN
	 YfqGfOx/p5YNVcZmmSHN30ZvqSoSmyBDrgFdb4+E=
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
Subject: [PATCH 5.10 1802/1848] nvmet-tcp: dont read a removed port at Connect time
Date: Wed, 18 Nov 2026 16:04:00 +0100
Message-ID: <20261118150034.754130489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 05a599f6c8d59..46547a1fcf872 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -94,6 +94,7 @@ enum nvmet_tcp_queue_state {
 struct nvmet_tcp_queue {
 	struct socket		*sock;
 	struct nvmet_tcp_port	*port;
+	struct nvmet_port	*nport;
 	struct work_struct	io_work;
 	struct nvmet_cq		nvme_cq;
 	struct nvmet_sq		nvme_sq;
@@ -1370,7 +1371,7 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	u8 hdgst = nvmet_tcp_hdgst_len(queue);
 
 	c->queue = queue;
-	c->req.port = queue->port->nport;
+	c->req.port = queue->nport;
 
 	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
@@ -1647,6 +1648,8 @@ static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



