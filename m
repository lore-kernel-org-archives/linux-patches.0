Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D858A3D4129;
	Wed,  8 Apr 2026 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672408; cv=none; b=cs5hlUWO/mEntyDtkAfgTzMCF6bNS1vQbS+3m3/GyYfMn3dG8/9y7Kxk2vNN7USk0Yx3QEkEASmw0/PZ1kbOwFnUxZ9lz79hTIYh04O/kqoE+i3wVtwM0PKfR/ZseCR4Hqs+mpyRJoV7UptyK99n55qSmkr3YfDdt3G4PGo3UYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672408; c=relaxed/simple;
	bh=MVKRdno0jnY7CzdP+oiCXWw6iCQFOPA6iGB0Sy8Me1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgguqQ3FPusRxbKcySlWCE0XyTlbfHs5LnmHFJc81YkkcnDn0k5d54+lQpmzzuIkolPQxkFeloDue+CG/PdLv2Ud3a/lJt7+DOcWokX4soHYf/QGfmFGcYVmOO1ZdM1gPaHhJzeyfiwBnVwHb5p6gAz0ewoEkdccURSoJY/Lzio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+0RDUti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+0RDUti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F598C19421;
	Wed,  8 Apr 2026 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672408;
	bh=MVKRdno0jnY7CzdP+oiCXWw6iCQFOPA6iGB0Sy8Me1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+0RDUtiZxo4qyl+BmVNlthF3OZQzA/HOKgpPzCAMwLrJnl2HutbO59UMjIE4hFzZ
	 +skWcKARUSukNBtOUQESGNseUiFv/4VYJQx/WR01ivI9wHyPeue9SB5R4XH+JI8LTt
	 lvRVJKkCopfH1PpafoY25KFGOorjB9jOi8Geixu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 309/312] block: Fix the blk_mq_destroy_queue() documentation
Date: Wed,  8 Apr 2026 20:03:46 +0200
Message-ID: <20260408175945.316627921@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 81ea42b9c3d61ea34d82d900ed93f4b4851f13b0 upstream.

Commit 2b3f056f72e5 moved a blk_put_queue() call from
blk_mq_destroy_queue() into its callers. Reflect this change in the
documentation block above blk_mq_destroy_queue().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Keith Busch <kbusch@kernel.org>
Fixes: 2b3f056f72e5 ("blk-mq: move the call to blk_put_queue out of blk_mq_destroy_queue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230130211233.831613-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4175,8 +4175,9 @@ EXPORT_SYMBOL(blk_mq_init_queue);
  * blk_mq_destroy_queue - shutdown a request queue
  * @q: request queue to shutdown
  *
- * This shuts down a request queue allocated by blk_mq_init_queue() and drops
- * the initial reference.  All future requests will failed with -ENODEV.
+ * This shuts down a request queue allocated by blk_mq_init_queue(). All future
+ * requests will be failed with -ENODEV. The caller is responsible for dropping
+ * the reference from blk_mq_init_queue() by calling blk_put_queue().
  *
  * Context: can sleep
  */


