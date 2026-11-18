Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022209;
	b=1g36uyW9ZYE9mCfB2fjkSKFwSfR1VEEuIPEqQ0CDdIuFhuNdAV0Z7fzf/x860HE4N521
	 oOJpArlSazRuh3w4ueIuHilvp/dGpliAXgQW030nxVZE8XDDqL78HVGD1CUAjbG+LBt6S
	 6W80TAiawIlzBy1gePvbPyGZHt3E8HW2T3VrjySk4QSkQAD+OpY3ZA77I/Ek9aXEvT7Yv
	 slQ/c269kntBlA/zODgWl8vPoMg9K7tfoU6x9tGTNvSCgSr7nqEddR0D6DFzvtBvsHUD7
	 Blt+Z0vOyCeqsRP4LJylYHcpAsyqiiEmD93oyIxZJRC1iaZix/IKBM3LUCiC9THF8Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qD/1+4ZYmP/s4bmLmI2OSCnRnR7hMsqhx7H2SOpm2go=;
	b=nXiuWN77xlXgQRfLAnepegiMRmwVphuDB29AJNBjuejcOvaGCxDn7L8AGo/oGzUoKpji
	 pNkDi7mNzlDsy8oQITPwtYf5eguLTy06jpM/1M2SEEYjLzMufGKK4fDns/zY6yAmBPOae
	 suxm/d6+NbtmYUF6IeVTNI4k6ZXGIx6EuHzcL6hpf4JPPaCYGGufiaI2jGM2Of432FChr
	 mhqbEOShBrk2gmDTukYqPWBoYoCf6hVFwd6/RGU+LnhnJickvysS0y+iJyoIPWT6x4lEg
	 +h+jxDZvQ6LqG3CXoUVcGkXIPeTZi4H0upXeDsqvGJ5asmTbkJ9G6bv7K2hq7Ms5Rmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqYLAg0E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCF2606A325;
	Wed, 18 Nov 2026 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqYLAg0E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459D61F000C5;
	Wed, 18 Nov 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022209;
	bh=qD/1+4ZYmP/s4bmLmI2OSCnRnR7hMsqhx7H2SOpm2go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqYLAg0EDA3iME3M64ZKyRzCcWN67XdddIWs3gzReyghCeOOKUUEBHvKtDKOCf4NS
	 hZ3iMFoNecCDhxMN2n+duNQzQSATaFmrONULvFXtS/iwv/OZdJW0m1QuwujIC5wb/B
	 qweAZO8CRnH0L1ZbJIc+JjPHJVLdslJVrdAqQN6I=
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
Subject: [PATCH 7.3 2540/2651] nvme-loop: dont BUG() if a scan runs beside a reset
Date: Wed, 18 Nov 2026 16:03:00 +0100
Message-ID: <20261118150416.004739943@linuxfoundation.org>
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

[ Upstream commit 64e21d782020e267ca57765a30216c38b34f296d ]

A reset sets queue_count to 1 while it destroys the I/O queues and
counts it back up when the new ones are made, and it doesn't stop the
scan work. A new namespace found in that window trips the check in
nvme_loop_init_hctx() for every hctx but the first:

  kernel BUG at drivers/nvme/target/loop.c:224!
   nvme_loop_init_hctx+0x7d/0x80
   __blk_mq_realloc_hw_ctxs+0x3af/0xa80
   nvme_alloc_ns+0x1a2/0x22f0

The check protects nothing. ctrl->queues has nr_io_queues + 1 entries
for the life of the controller, the tag set never has more hardware
queues than that, and nvme_loop_queue_rq() rejects requests until the
controller is live again.

Remove it.

Fixes: 3a85a5de29ea ("nvme-loop: add a NVMe loopback host driver")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index fcb1f8186fdd0..e579a307798b9 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -221,8 +221,6 @@ static int nvme_loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 	struct nvme_loop_ctrl *ctrl = to_loop_ctrl(data);
 	struct nvme_loop_queue *queue = &ctrl->queues[hctx_idx + 1];
 
-	BUG_ON(hctx_idx >= ctrl->ctrl.queue_count);
-
 	/*
 	 * flush_end_io() can be called recursively for us, so use our own
 	 * lock class key for avoiding lockdep possible recursive locking,
-- 
2.53.0



