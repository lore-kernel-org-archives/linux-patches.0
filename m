Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033059;
	b=rNErYMZ8Yy7eRfJv/x0RW4JJO5Z4Ak9PWZpAZC1Frl7l1qfOkrb4jGucCmePzpm+Akz/
	 93JyECkk8WK1DHDb9JBU4xOCx8nGe5j2jpqXBFArSjraCE3SV4/2/srzGs6rp9H7QB20N
	 FLdnA92OWOLVtxT/W8tu46HLwoUA3xv+VeEmkbVe9lSO+zaWeLVUU0dmvmc4oULt8dirG
	 RrVm3tVmGOWkr9T6Wr2DQasiTSBXYcsLZAN+sIZYvTgthizYGJhyoZJKZpq31NwJYge3i
	 XYkt43AvScXnLThCoMLdrb3mvgNb8rCYUmYK/nntZBjSyVOLPlBP6doAGWz4KlMNmLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n0C6s33R+mdQPrsN2eJDj9el42pgDeFfCnETp+Gylvo=;
	b=Aflb8z2IEGA+qmUihn7WN2hiQKLIiG8aelOdXHy6607XSq6/A53/KvhFMegtfD8THuvT
	 CBMQKzxEVCkS0PiFb51p6ss03Zwl4gQUP6iTltiwZRnvP4Hh+Pgoqvccg5uT/Wi6codFh
	 ZvNS9wwqTYGY7B3xJjtzZaKXLQdjJvLGQYavy4KQv/EnHmmgJY0BqGvKuNQx3EjVXzqzl
	 aKy2AuPLI3OpSS/5qGApoVgB9RwpnefIVIg4woFpsgLAXWy1sRfkrqSDiI1TtjLsc3Yg2
	 VPdWIO83k7m8yV3w/1Y4KnWJgzFU3sVTSM5dL2GsBRoVD0gIjr1v+oU5LlCGAUUuAHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CV24S6WZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4237D60A263E;
	Wed, 18 Nov 2026 20:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CV24S6WZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9732C1F000C5;
	Wed, 18 Nov 2026 20:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033059;
	bh=n0C6s33R+mdQPrsN2eJDj9el42pgDeFfCnETp+Gylvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CV24S6WZC7f0mqg7jJWl5L8rcKIdZ9Ytkn4XJ88sYFge+/+XDnarRlaVffihtwkyS
	 5q2y7qrHmw1B1XLewYoGLhEXS92qV53mx0meuQOWjelJd6FR3b2Cebr46CyAoCeTdf
	 CjErMvp/sA9uedkRxCSAwofMauL5lRbRKmrAt/X8=
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
Subject: [PATCH 6.12 1632/1756] nvmet: fix NULL dereference in debugfs host_traddr
Date: Wed, 18 Nov 2026 16:02:39 +0100
Message-ID: <20261118150114.758598824@linuxfoundation.org>
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

[ Upstream commit 81ce4d9bbe8cf47d4b023e932ee29b22367545e6 ]

The host_traddr callbacks of tcp, rdma and fc take the host address from
the transport queue around ctrl->sqs[0], which nvmet_sq_destroy() clears
when the admin queue goes away while the controller lives on with its
I/O queues. A host that closes the admin connection and keeps an I/O
queue leaves such a controller behind, and reading its host_traddr in
debugfs dereferences a near-NULL pointer:

  BUG: kernel NULL pointer dereference, address: 00000000000002e0
  RIP: 0010:nvmet_tcp_host_port_addr+0x19/0x50 [nvmet_tcp]

Don't ask the transport if there's no admin queue. Nothing holds the
queue for debugfs, so a reader that's past the check when the queue
goes away is still on its own.

Fixes: 7e5c3de3f2f2 ("nvmet: add 'host_traddr' callback for debugfs")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 6fe67b3d708ec..3b90a88e1207b 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1597,6 +1597,9 @@ ssize_t nvmet_ctrl_host_traddr(struct nvmet_ctrl *ctrl,
 {
 	if (!ctrl->ops->host_traddr)
 		return -EOPNOTSUPP;
+	/* They all take the address from the admin queue */
+	if (!ctrl->sqs[0])
+		return -ENOTCONN;
 	return ctrl->ops->host_traddr(ctrl, traddr, traddr_len);
 }
 
-- 
2.53.0



