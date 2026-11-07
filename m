Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064928;
	b=iVGuogEMAVng++if4ezMntAD51LN3HMog/HMylx0L1j6VBkIOKibC/FpoOqpQKLXUPV7
	 8dZIwHrV8D8JH3qw8Q8Rh0nzPVBRroGiCThm2UTe/E3QzVqcqO2WudGkjd+Oqm8795ORK
	 pwAMCTdQ07Y5phBOu0WqD4sqcVh0txzacJDlo9iHzVvkDkIWfkjX+jjly3Jc5QI8j3fUD
	 doCShxDLZITSunu8XPqvtHzpItt/4niRvq+R78Uck1mTICDpFPV5vsQAPnit4pas3ufGx
	 cgUF6lFXlxm2kZ8lKACtWxrlTP0aX9YqPK5X1uyg1vYc6vbwUEdnEqOvhK9DgV5oOuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GAcmS0Gj72syrvC4EMh7qIxa5KGzoM+1SVB/Vmvphkw=;
	b=FtS3aJdYJhvBhpG1fwskIk28925iwMeiCr9kUuE7jfLd+ocXIQFE2jrNU3NQadpXBadA
	 iXhkrl9kEywvHrKvgeSE6iBj06R4Cbdqf+m8l17HmO+0TThlkzg90WOB1OARSxoOjxtnN
	 qzztUA00Ix0yLjExw1lBKDeL7bhpreLZP0HQlFQ3lVTOisDiP08Vdb/EwJbJpv5Hkb8JK
	 HLB42oco+HH7GaGRkmvngBp3Jd2ud/heTCcGFdgUQLFaWRXPTulRYKzEXsGxGkb6ob+vO
	 n/3+wNvwtTUGOTig4iW45B+7zKEWElqfT+wQeg7KIqB+7AFbsmGxBrMAxmmU3mfPbzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pvttwzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF8606B88B;
	Sat,  7 Nov 2026 15:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pvttwzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579BC1F0089F;
	Sat,  7 Nov 2026 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064927;
	bh=GAcmS0Gj72syrvC4EMh7qIxa5KGzoM+1SVB/Vmvphkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pvttwzRQHu245sKXu73lqzus5hJ/+fBzE88P/Cq96tzXo4EhnaWr13A/1tf+zfKn
	 btGbGIZl4ii1Ev4V+1g/iPf+bTKMP22c95VIcfQVL0CguLFo5NMf2iMoNzor3SVMyD
	 LhcHNx5v/ScIrJPN7eOBUIbKdVo92g2VqiuYSDac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0822/1257] ublk: mark the batch fetch command cancelable before linking it
Date: Sat,  7 Nov 2026 08:51:58 -0500
Message-ID: <20261107135002.043209225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit b59e96011d22e322fbf4d5d1d1124de538c278ed ]

UBLK_U_IO_FETCH_IO_CMDS has the same order problem as the per-io
commands: ublk_batch_attach() links the fetch command into fcmd_head
and marks it cancelable only after dropping evts_lock. A cancel from
the control path (ublk_batch_cancel_queue()) can take it in between and
complete it, and the later mark puts a completed request on io_uring's
cancelable list.

Mark it before linking it. evts_lock orders the mark before the link,
which is where the cancel finds it.

Batch commands are not bounced to task work, so they can run from io-wq
without uring_lock, and io_uring's cancel walk can now find a fetch
command before it is linked. Two things make that safe:

 - initialize fcmd->node: it came from kzalloc(), so list_empty() saw a
   linked node and ublk_batch_cancel_cmd() would list_del_init() NULL
   pointers
 - on the -ENODEV path, complete the command with io_uring_cmd_done()
   before freeing fcmd: that removes it from the cancelable list under
   uring_lock, after which nothing can see fcmd

Also use data->cmd instead of fcmd->cmd after dropping evts_lock: once
fcmd is linked and not the active one, a control-path cancel may
complete and free it.

Fixes: a4d883755399 ("ublk: add UBLK_U_IO_FETCH_IO_CMDS for batch I/O processing")
Cc: stable@vger.kernel.org # v7.0+
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-4-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6015fb2fb925f..5e37b8e9d9acb 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -815,6 +815,8 @@ ublk_batch_alloc_fcmd(struct io_uring_cmd *cmd)
 	if (fcmd) {
 		fcmd->cmd = cmd;
 		fcmd->buf_group = READ_ONCE(cmd->sqe->buf_index);
+		/* a cancel may look at it before it is linked */
+		INIT_LIST_HEAD(&fcmd->node);
 	}
 	return fcmd;
 }
@@ -3915,6 +3917,15 @@ static int ublk_batch_attach(struct ublk_queue *ubq,
 	bool free = false;
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(data->cmd);
 
+	/*
+	 * Mark it cancelable before linking it into fcmd_head, where a cancel
+	 * from the control path can take and complete it: see
+	 * ublk_prep_cancel(). evts_lock orders the mark before the link.
+	 */
+	pdu->ubq = ubq;
+	pdu->fcmd = fcmd;
+	io_uring_cmd_mark_cancelable(fcmd->cmd, data->issue_flags);
+
 	spin_lock(&ubq->evts_lock);
 	if (unlikely(ubq->force_abort || ubq->canceling)) {
 		free = true;
@@ -3925,14 +3936,12 @@ static int ublk_batch_attach(struct ublk_queue *ubq,
 	spin_unlock(&ubq->evts_lock);
 
 	if (unlikely(free)) {
+		/* off the cancelable list first, then nothing can see fcmd */
+		io_uring_cmd_done(data->cmd, -ENODEV, data->issue_flags);
 		ublk_batch_free_fcmd(fcmd);
-		return -ENODEV;
+		return -EIOCBQUEUED;
 	}
 
-	pdu->ubq = ubq;
-	pdu->fcmd = fcmd;
-	io_uring_cmd_mark_cancelable(fcmd->cmd, data->issue_flags);
-
 	if (!new_fcmd)
 		goto out;
 
@@ -3940,9 +3949,12 @@ static int ublk_batch_attach(struct ublk_queue *ubq,
 	 * If the two fetch commands are originated from same io_ring_ctx,
 	 * run batch dispatch directly. Otherwise, schedule task work for
 	 * doing it.
+	 *
+	 * Use data->cmd, not fcmd->cmd: once fcmd is linked and not active,
+	 * a cancel from the control path may complete and free it.
 	 */
 	if (io_uring_cmd_ctx_handle(new_fcmd->cmd) ==
-			io_uring_cmd_ctx_handle(fcmd->cmd)) {
+			io_uring_cmd_ctx_handle(data->cmd)) {
 		data->cmd = new_fcmd->cmd;
 		ublk_batch_dispatch(ubq, data, new_fcmd);
 	} else {
-- 
2.53.0



