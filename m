Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033066;
	b=sqVG9X5IC7aQJa+SK4+tUbpAuoyaYMxJrvzzbGLJM87ZCb67owom3kc9HZcCW1vV1FEC
	 PyCJuqtc4RfHewpfqeztFBfiwgLUHcaeteJquZR8c2eDKVN3x8BCsPXDPhk2spJaUGtC+
	 Wc3KD1d2XcEuKGRnjhYaTqe3+vNCdndIAijw+PTm5uRIP/cD99tev/bkRp7tFY6k+We1i
	 1bTxqapGaENlPMR9IfTy6opVNaceMa1PGwe7EhpWIyXSBrsLGpM84vt/jyvHMR9tGPNAX
	 tJnd2jes6HkC6Px6ViqLhxuiw60EvrYnO3RhA51tSSJA3EZeaLnZts4lBNUctGXWQDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wbYsGx345UVAF4RAsWTxFi3GeVUT5NdgpR6Zoy0JDBA=;
	b=J2uy2tW1/j2SuPYvoMMIJlWX5vbys0fKIh5/yXXNApAwxWhsGdr0oClcYdNr6e/o80EY
	 I0VX0+vMFeG93zjUeF8mkUqamI/s+mORMpAtzTy0kImUHypqcZFSgxFLCrTVFykyfYsif
	 VUBuom9cZJlLBaPC28BOYc0Ha1pQqnf1OAn5V0MuPyRusKzs/dca3Y5qkIscb+FOdg34b
	 lWVNRz27eb98q2TtdDKzK9cWWlMS6jjdcZSkD66cXrfsNuWhxlp6KE5ozh1ebL2IwN1Lz
	 enNjQFcrPENTFlb180eAGzlHbigPdHek3t78SbfjOF8MrqjTkbUIgARzTidvQ82Fh1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOxmjw5S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A560A2607;
	Wed, 18 Nov 2026 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOxmjw5S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3631F000C4;
	Wed, 18 Nov 2026 20:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033066;
	bh=wbYsGx345UVAF4RAsWTxFi3GeVUT5NdgpR6Zoy0JDBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOxmjw5S15NBJ9hqN/uPaeumcO/NU8kyIxbs4B5hnWokL9jYek6CJ/ZgYSjEucm3l
	 F7+67kv5fatstX9eFuAkZXZEpwTiWGuGj4SWeGXb2Nyn5y2Atvwx9tyLqneqxHUVXj
	 I7dG7gjZ9Fh2mu1SeMT/IT1Tk03hnD2PliQy/uhc=
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
Subject: [PATCH 6.12 1634/1756] nvme-loop: dont BUG() if a scan runs beside a reset
Date: Wed, 18 Nov 2026 16:02:41 +0100
Message-ID: <20261118150114.833146933@linuxfoundation.org>
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
index a9d112d34d4f4..8bb3e01d9ba00 100644
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



