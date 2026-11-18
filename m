Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050630;
	b=Qe8eIxsTc8qpCUpuRYh3Od53+j8FZ7mMkAQNTeI4aVKvwTby7Trbm8OApb94PakPDCJl
	 cqOhI0pO/ok0OTsHLJROHhKiZyY+7lLNA6ZN4/DuGK3Oua6LXO2GZCnBHFW/F6Mo2Ek84
	 KPO/8sEJx5ID1bYa23tsqjdIRFB8sq4PVQonE7Al/94B0yYmB+nwXg5bAIXJaAmhW5Kbg
	 XVpeTOOOblvoO9l8CNpBAr3ojt/QSnC/Ef3AiI7HtB2Xu4+gxCMkTTPRPaf/sVUPVVox7
	 2svwokE4DRLrhqLz+JFdAgRgb6OcJnT1EDTsi3DVwAAuz7GXXAhMjKmEdIpkSb9PoIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SVyFYux0cRWY5XrQK62v3Wk62oYNGJy3jikymj1MSao=;
	b=dnNOGa+HXZL6/pUReJ3ljvjnlYG5vf3pqdN6Wlza4BYfE5nsFPlrcAbBWjnKvmq+I3O8
	 doABXP4WTgof5nyQJBzCT/O4RJ+wYyyaWT5sOLdRE+3IzTW1cR9mV50F3bb3r1c58yuSg
	 WsIwMcNzqDgi2Ku09G8RQ/aubRynWGoFe38PSiDP1VYhpjHjQYLYsj1AG0/QH/YGu7XfY
	 fMITxNN5HrxrlCP1SdaBpwPzQhNi9j3cXSJ/mNHk75sMhlVBzvzV+VCo+bk8zpOPVm9Ul
	 6OGtAu0QbuMdJdVXScIdx43p4X2cRonSHkSp54vZZZH6juWRnCaWeCv8aU8FaSKfMGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fc5/l5AN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD2C606A320;
	Thu, 19 Nov 2026 01:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fc5/l5AN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C531F000C4;
	Thu, 19 Nov 2026 01:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050629;
	bh=SVyFYux0cRWY5XrQK62v3Wk62oYNGJy3jikymj1MSao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fc5/l5ANbzb0uY/WvARy7Qja+2G8mjQzokLo0X3lpMiIOFMx444MSIHzP8SvLASZV
	 7pS+Wdc9PvVHhkjYYx46nB2gnJHDmB6qXYmHgOmygPtgDgoJ8EP0m0lZuHLY/GUCU9
	 iGcb8H2w/L8MHMpIZxIEQgqoN5zqs2XK/OZBoYo4=
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
Subject: [PATCH 6.1 2776/2857] nvme-loop: dont BUG() if a scan runs beside a reset
Date: Wed, 18 Nov 2026 16:03:30 +0100
Message-ID: <20261118150341.551667523@linuxfoundation.org>
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
index 0669b6c8abab9..0092ea58e6444 100644
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



