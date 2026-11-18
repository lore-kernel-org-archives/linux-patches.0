Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056916;
	b=BE2wcArWkjMClA8h0P/INs63PbtpsdoMmTRUh4LtNcJd+sfgzkOVB8HNODlYldWxkVmQ
	 ZR60Zigb2+jNzzNSot9Rm8kiyBBksLsI8+IvhVaI9dMpcSzWs2lJdzmL4hkDjpI7dsbpl
	 +YbpT6bJVDM3Qlw1R23BSCjfRwhtoMnItUzCS2ffM7L+WAt9omBve4WqxFfhOHEATWQU0
	 /7cy7a4IKNfCyJQHSf4XoouwnZLB20Ia31WQcN6gUvSYa1rwbxjNZiT9buE5gDlrqJH2h
	 QLgqseuzfqrlGM0qVlLXP1/Z13QZ4pgaWWFRB4Sllspj/+5KkbUizghgCGj948d+bOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pgZF5OMDucR96+IBS1Kpn7vxFTj5TynhIp6rgVlZt8=;
	b=peJhZ+g2/K94ejFI8rjbqs+9MdjlpePAG/cpwlvRpy69tIKt4ZDg1KOIo36hGIIby6wH
	 1wgbukShJRh3NaWzY1KMYBvD4h0CgCbOnwWGVI3I2Xoks3/62L+pDJR/iWAb4VCfBQtUr
	 DrPyb3ZDCRuuo1mXB1C2W8UGlP/D6hGH/Z7jzJUBEag5T4iEsYLA6fG3AfK7toIY1TTxz
	 m1vfjch+AiYKcBcwJYZSAJZ+KfWhemqEhcVMVTW/4PmZPGidNABIk4phxo4bt4tlNLyM6
	 v1katLREziN2Hwk1eBJuX4MM+zQYBvBV7hir0pDwhLuyfAi/lDwp4aXi3j1wLLvopcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6GC6po8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA10606A32C;
	Thu, 19 Nov 2026 02:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6GC6po8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E406A1F000C4;
	Thu, 19 Nov 2026 02:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056916;
	bh=7pgZF5OMDucR96+IBS1Kpn7vxFTj5TynhIp6rgVlZt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6GC6po8yW7mE0ax9c8p3mda69Msxgxm41lL7ja7Fp4X9yhfhIIwwjhJOuPWmm/tW
	 +/ZjAbIh4fPigwykaSibrrmEWjwz56mpssRXgmEUslCtetin7cWLoWRys9I0tNAwnf
	 CBY65Qe7580WC3vZJVR+2gV73lMl7c45bo4ftmfQ=
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
Subject: [PATCH 5.15 2157/2214] nvme-loop: dont BUG() if a scan runs beside a reset
Date: Wed, 18 Nov 2026 16:03:53 +0100
Message-ID: <20261118150136.743506841@linuxfoundation.org>
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
index 2553f487c9f24..d7d2aee1971be 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -221,8 +221,6 @@ static int nvme_loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 	struct nvme_loop_ctrl *ctrl = data;
 	struct nvme_loop_queue *queue = &ctrl->queues[hctx_idx + 1];
 
-	BUG_ON(hctx_idx >= ctrl->ctrl.queue_count);
-
 	/*
 	 * flush_end_io() can be called recursively for us, so use our own
 	 * lock class key for avoiding lockdep possible recursive locking,
-- 
2.53.0



