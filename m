Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054516;
	b=1hR1wiEXpgVY6KHkoilU72UXtW/ianxgED06YFdiBmAxQ2p7fDW7CQI+/0i7y68JXoQF
	 bDD2eQjvIY7MLY67b5c/sX9pBlrMt08mnGCtgEgT9HdUFGxfRW+T/0RAqOgTjcD09zbnx
	 AEKrJPn9AY1CSWzLcrHyBdSanO+hzTawpWZYtqYDXB4B04kLq8SjQqKvPJC72IHTao+0w
	 1kqvWa9AFWlYOhpfvWkztfUEvUD6HKaO+MCxpMtoRJwFbIy6eSz3EJqyMXw0NW4pr6pn8
	 j9HU0JYK3GzUmJONWq+xnRj/29CF14XHOzi5n/Gc+9rMerjMmoAWmsqzPiTxjeaPhKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SBSGyYg6lMQOcPDV+sl53ySPtEcfFXlNJvrJlH949vI=;
	b=cphMc0MfSopMSbjYefnSrFMZONV1wZTAbv0K2xgRwg2G3FcCmEIYDnxFRXck4iq7Usip
	 DFVeFE22fesm6uPVU8XTXNBxovAFYJxpfznF7P82CKgXWE56f4wzoKpfwB7z2st8Xs9wO
	 cJ5oAcqLvnPDWZgWLUF8s5hpGOjXIyKzU+hksahU81OetJEnI8XFp59g3TD3kYN8wJyDa
	 Qz+gvKX1sJHKB16+KGV7LmOPMyl4X2PSyzfuTjDP/we8ibCyHA2xrZWrfo09chLYBEvhy
	 T8fVCsmYkoibkh0UNhwpzPnGJrONc1gO+JGHlKwzPqLDInouUaUViepZO11WE03CCzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7jtsUxB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7602606A31C;
	Thu, 19 Nov 2026 02:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7jtsUxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176071F000C4;
	Thu, 19 Nov 2026 02:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054516;
	bh=SBSGyYg6lMQOcPDV+sl53ySPtEcfFXlNJvrJlH949vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7jtsUxBe8n3yGyR7Ef+lgMI61R86erebl6GupVpyBLnc7nULpVPNuBBX6MSlLYaR
	 yHi1zGaUn25ddv8u7v/LhBSE/NdbzqfiNT08GvfsMpCVTbD5lJR1ghCVbssnc33Ubu
	 BuKwBafGwFl5CWHgdjIsokwyidRW2y8gkeVlqSFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1303/2214] blk-iocost: Simplify ioc_rqos_done()
Date: Wed, 18 Nov 2026 15:49:39 +0100
Message-ID: <20261118150103.635999845@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 62c159a03da92121b1b909fd8039028de97885fc ]

Leave out the superfluous "& REQ_OP_MASK" code. The definition of req_op()
shows that that code is superfluous:

 #define req_op(req) ((req)->cmd_flags & REQ_OP_MASK)

Compile-tested only.

Cc: Tejun Heo <tj@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20220615225549.1054905-2-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e9804489e27d ("blk-iocost: account flush sequence latency only once")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 496aa2d4c435a..2c3047d2c80e1 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2808,7 +2808,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 	if (!ioc->enabled || !rq->alloc_time_ns || !rq->start_time_ns)
 		return;
 
-	switch (req_op(rq) & REQ_OP_MASK) {
+	switch (req_op(rq)) {
 	case REQ_OP_READ:
 		pidx = QOS_RLAT;
 		rw = READ;
-- 
2.53.0



