Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042574;
	b=y54ZHsxvIUDahLZev98YclVsLfDhi3EYUU3Iy3zqLeTxthAvJ40ihc/1NUc0KaTCigwZ
	 UFMqQU5+xIQWo9eZJA0NWy5GdsgrYCm81uRvfQ6m9a7fN/hel5thvqw6yiSxrN8fBrn0F
	 GZYS4HpZVffCe+cTZ0yDMRZb9+VuVHD5Jom+6xtOZOgpCPLozq6u9BewZUKBOgDhdl8+z
	 JrKF+SVbgvJjlFlrbo+LOtVlPT2Brgh6Qtb+YsotbmZvDqSRUdg+qxddLwmzTwESrqMiq
	 ospRZKZR5LC8ztNGDha0SUxQinI4iGd8Xf63e332coDddHDkkMV5gPSKNkdCqMPrLxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EXXjO7WtNC+DRfT0R1WkgZqNVb2a1+cxNgzgzHa502E=;
	b=gUllSqn/nevoeQDh9+bSuc8Cfegf4ipLGDRgcbXguiXy87fF9B77uCfY9lQYt28UIU6Y
	 sGsgEiheqRLm1geU7/WINhXx/OFXHAcwHxo4u0Y682d2cMHE3Z44XS+nwhGWQD3EUjXoF
	 8BMzCAoYbfE5QsLYcLPqBawZh8EKQcFCM/TRStrJQ/IjSiCRjaifQCY9fFC/I1kNfKjQu
	 nRe4a+dPki/WctwLWBZ/y8vvmklEXk8sDYHP145Y2KNsPn1uyjs2KhK7MgVJbsGuQ5w2I
	 VNve5M4H3dgugiOIwVBhESwOxkZ78vmDR49LMOL1ywxcv9C4zE2cJrzSejJCfj/sxAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFUIQVcV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B529606A320;
	Wed, 18 Nov 2026 22:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFUIQVcV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C221F000C4;
	Wed, 18 Nov 2026 22:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042574;
	bh=EXXjO7WtNC+DRfT0R1WkgZqNVb2a1+cxNgzgzHa502E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFUIQVcV4RfSRcgcO5Ioy6AUHu9zp3poSJLFgLqicwW48kAHLnCmss+7tG4VhI9po
	 zOwm0TUxzz6oIezU4fgatecJ3wRYPw+QkOHsPsZh1xTGZt0h69KHkNUtETKu4qYKEE
	 NH+0hRO+zRA7nD/EaVeNMwwc2hRqdHN6eUdly+Xw=
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
Subject: [PATCH 6.6 3219/3318] nvmet-tcp: dont read a removed port at Connect time
Date: Wed, 18 Nov 2026 16:04:01 +0100
Message-ID: <20261118150456.302997193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8421768dbccc4..7134c54592dcd 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -131,6 +131,7 @@ enum nvmet_tcp_queue_state {
 struct nvmet_tcp_queue {
 	struct socket		*sock;
 	struct nvmet_tcp_port	*port;
+	struct nvmet_port	*nport;
 	struct work_struct	io_work;
 	struct nvmet_cq		nvme_cq;
 	struct nvmet_sq		nvme_sq;
@@ -1458,7 +1459,7 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_queue *queue,
 	u8 hdgst = nvmet_tcp_hdgst_len(queue);
 
 	c->queue = queue;
-	c->req.port = queue->port->nport;
+	c->req.port = queue->nport;
 
 	c->cmd_pdu = page_frag_alloc(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
@@ -1745,6 +1746,8 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



