Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022193;
	b=gsCm7TRh6gfLcll+6kG+e/Xvo1fbtHxz7g+b8bXe1Bs2pmsLGJcAPW//BxW0W9CKlWcZ
	 H9/oRXRvBxVEFWYhapwIQ+8Fm4+I5dswfTRpaUJNACmbL5HjV8QiDZ8ee9fk2lOkn2UTn
	 B9J+KrKD5KMtLakXI0oaSVrUBQCGDabLuvRAYMUeAyFBwpIZ+I5m6UcYv9oqj0ksgiRUh
	 Qf+9sSgwG7AC7oWaHnb+GmKBNWvsyGGq3K4jC5wi1gHeRC31i3U7egEgafqESiXc+QFjU
	 KScBywQKLF2fW0Xc0SfSDXDGjlHUH7o0knnKHs3R9Uylm1ToZfPthNXKV1Jz+TIOB6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CDTlZSxrPawjJv+yARfL5taqmRBffgdt/rsmQw0K8+k=;
	b=xBfrJeWd4GmdkByIXXxwV4a569cTGc92btn7UyqhEh/IIgJ5MDdBz+c2vCmGbfonAUPs
	 WpD0wMEJO+ulbtXkcbq7k+FNoH+9A9PCzvpdsd3ngU/8GxLozxmMFFNue+XKb6wppaXhY
	 lFqh4GgL4LxMhYN3QHNXdL9JADqgzigVxCaD2gaJ1EkIPVZX9kbwueGR4DQkbD6WLfa6/
	 cyPxkBAcu3tA/MMIC0s/DG6K1ENOrqCjmlxINU3yNHJ23q5kv3g28y/dK8u4NcxE6r9d0
	 n91UxnSQWIq5c6rT1bxxUh+LoX55oxRx4V+JapgUiITYg45EbTWRMTopqF5aqBEw+Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sRgnS9uu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355E60A2606;
	Wed, 18 Nov 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sRgnS9uu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C207F1F000C4;
	Wed, 18 Nov 2026 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022193;
	bh=CDTlZSxrPawjJv+yARfL5taqmRBffgdt/rsmQw0K8+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRgnS9uui9JwqpctzZYqLTZ0pGZSwSBWfKa4etTYTbztecAiNzYrcKcCsdz41PYoc
	 9aSvNiqP0rmWdo8IxBpIMyS6ReF68jHdHPfKyqp3D0kNQBSxr7hAfV65HPMKsVpQ+3
	 ZxKyD2xxYLpcZNxB1Z0GO3hsx2/hZeY5sixyHjxg=
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
Subject: [PATCH 7.3 2538/2651] nvmet: fix NULL dereference in debugfs host_traddr
Date: Wed, 18 Nov 2026 16:02:58 +0100
Message-ID: <20261118150415.945186747@linuxfoundation.org>
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
index c3c94bb7fb846..9bda7089b91b3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1822,6 +1822,9 @@ ssize_t nvmet_ctrl_host_traddr(struct nvmet_ctrl *ctrl,
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



