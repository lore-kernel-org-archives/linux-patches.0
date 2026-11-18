Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042577;
	b=xcMyFz70EyyRwf9/l/9iwLzABEgh6Du6aJDpRj6LyA0fJyYYjuB4RbgJzs09gE55whEh
	 yEAa0LSXqsBgDLWCTOKVFVp6VqWzDo1zetU7pfsWpFsUZdwsse1ONaPuIGVs87b7/bmGp
	 fKp8WdguTsXZoLyIucRES1R5EwZzPeYoY8Ekja7liqG9pGvHYEO3N044S22AQEdrbl8KI
	 T5ukO96wyJS2DAkxbB2jEfGRvX/rt0N2hqucDdm1alj+ccWFPOsD2ILZf9oWqYjBcL8E+
	 AQKNzRsSROZaS/Kgj8z0iymCxSXaYxetC7ugzrbkJrxQ6Gm4bduYPIXi3GrDEsR6ScA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AoOKrSIV3fX8/ClgJ3GI50rCzliGMFX7hfykV2c+wHs=;
	b=yOzjEOAHQOi3cW/MhNTUdXJkFpp4Zbz18HHauHcTaluEaQaZBzzlllPzZIXuEdhzqe1x
	 ir+F44HN0J4i6Wk5dlr10vFw50VxOuyiMUt5tECFTSnDo5EUlwWoH4CjPReQ7QRjZ9weQ
	 x/IOXy/41Tj5rMUw8Mzr1WYJBPOfSCyJnwrUmAjvC8NRHEelsmqIMTe/Y8GuzycOFafpS
	 2WXf7ZBKTPoOwjAoG5OBx9lh6haR3Fc+aa1zEqXPd6azfoMZpW1CkrlVrTPA8tlIVaxce
	 551R4yB9mRX57InPj9DaO/jw3DrAH6B6VeA2zsqhOV6iLj0RbYpny04cBlgFsePMo4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HEN7dw3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D22606A320;
	Wed, 18 Nov 2026 22:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEN7dw3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818B91F000C4;
	Wed, 18 Nov 2026 22:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042577;
	bh=AoOKrSIV3fX8/ClgJ3GI50rCzliGMFX7hfykV2c+wHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEN7dw3/Y13y9IRFazxCJAzvIVoHnj00ldIZPZV2xKYg3ZII5QYLlaAjRVz6UO69L
	 u6UksqofZY+1OiVeYbVNMvw2e4UdYZrhuVBXXimEucjXAN+ahR2icDiAGr+ynBL2oQ
	 DvNVvGmfHMGcKDa7bDL5gun7UkggtfZm2xREnA40=
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
Subject: [PATCH 6.6 3220/3318] nvme-loop: dont BUG() if a scan runs beside a reset
Date: Wed, 18 Nov 2026 16:04:02 +0100
Message-ID: <20261118150456.328954807@linuxfoundation.org>
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
index bd61a1b82c4cd..16e6d76e26686 100644
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



