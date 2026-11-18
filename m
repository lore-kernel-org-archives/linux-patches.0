Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062146;
	b=fj6z5TSIL8bBZH5aB/ZLyLr4WXlFRFq+XKwjWcW1XQ+8JRVGtUhXb0wUBmBgCcYgA4Zk
	 Q7xj3zMc/oe6wTSY/M/MkCGGyPqgzUmlU15gZdNs6zEwe2cH3tlZf07A/WqOKPf+m2imh
	 WXXyG5YttFulAi0WeeynWo10CZ6IGAYW9IFzOLAfufEZ9PHjTBzVQzjbIzWbZBtszq1lZ
	 93dcT/UGkL1hpmjMqR3QVnwDjpXcovslfa478vmprLO1p4tu/+OigrSudCWnwmwvxrAH8
	 TaNAI7dmudaVPiT4OcUp0YYQ14/080NAi2W4ZKTgC97emRHKTWnjr0fqRU87nm4ilFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FDuHAE+uwATQsMZh/Rm6o/v8FyN6pi5Kgc1g7jpnE10=;
	b=RWqyZEcCvMHM9dzxdh1k+N4c1hUM6QheGBOI7S8jq8+7iZgQ1JNb6RlC+/LpwqoDJ+r4
	 mOJXu9/Z3L54pIKWEnKeTelVz2St5iz1OjvKPqLFMXFqBBv5I6BAoFS/krPA6IYsma1kJ
	 FmRe94XPLTnyVtegvh7o0ME7kQgvuviOA2/MPCZsSVXPSfzX3c2Ai2mtG7MeZxEfk0DSb
	 oRviZVcIJGXr59jyAeqRh1iH0O+//pvorMPk3mcr1YORWA16vRIYNbvdz2yCTkLK7A7nO
	 8K9oJ1WUFCilsyrPa4amaqCCyTrSg3h4eRfsO2vrsomHZ5SZT22l/krY0xloWkwnj9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPPS9Drf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF27E606A320;
	Thu, 19 Nov 2026 04:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPPS9Drf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2185B1F000C4;
	Thu, 19 Nov 2026 04:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062146;
	bh=FDuHAE+uwATQsMZh/Rm6o/v8FyN6pi5Kgc1g7jpnE10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPPS9DrflIliCI3Wsr8UXpKILNSIWoxFlKE28CheddPG/dgs3oBncoWr2TzBKt2rs
	 GDllEn205hDNzXBUhrkgIL6p+bP20utvzva9PlEpPkZHLhKZSkmGFRqAeNl1E3WVgB
	 PA42ZQy1vOZqSprq8XiObkIrt0JOL9OCQr+OdwDE=
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
Subject: [PATCH 5.10 1805/1848] nvme-loop: dont BUG() if a scan runs beside a reset
Date: Wed, 18 Nov 2026 16:04:03 +0100
Message-ID: <20261118150034.874604500@linuxfoundation.org>
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
index e17710e405a31..ae7d3c0c81096 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -219,8 +219,6 @@ static int nvme_loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 	struct nvme_loop_ctrl *ctrl = data;
 	struct nvme_loop_queue *queue = &ctrl->queues[hctx_idx + 1];
 
-	BUG_ON(hctx_idx >= ctrl->ctrl.queue_count);
-
 	/*
 	 * flush_end_io() can be called recursively for us, so use our own
 	 * lock class key for avoiding lockdep possible recursive locking,
-- 
2.53.0



