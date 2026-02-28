Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934D233FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300947; cv=none; b=dUBoUreGeqTBmsU82ndEoMTZwm3oO/WS850nCIX3NQN08RV0Q750Fyz+Ye/lCepck2zF8+darsunK2ZxUw3IcGX82rExDgbK0UBbDSMG0sEGGHpcbNnUJcgUAu527pI0n+/DGIL4OVNg0JlDQTB9g9pWiGYZ8TkeiccQG8ugAZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300947; c=relaxed/simple;
	bh=NJLBrRX2j4NQXdAxOknzdGN5sq8YYJbadoVPGouiUgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFShFtu0Dl0b2pUGp3AafozsrrdbTmngqFAFqK6M/hxWSl5qe5f5GGMm0lNW7qyX5EGCp8fYJpiweQgXQejQUWp7YhNzFMwsKwraE6TB2/jVKCoh7VImmhJx3NPWm2Po5KEYHSfkwda8r0rv4zDaNVo9s+Ai41SdkF1kPrh+kY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSeASXb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSeASXb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FB1C19424;
	Sat, 28 Feb 2026 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300947;
	bh=NJLBrRX2j4NQXdAxOknzdGN5sq8YYJbadoVPGouiUgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSeASXb94NRDivm8BUCnRNckTuy1P8q3FJ8J/nWrPMFbzogTVw+iAB4KLM4bbV+i/
	 TI4P/gzQN35x8lQTc4enfNMRdI/SUlc1s2Ffn+qsVW3ZDrpKuJAxQXrbLEpvskjYCY
	 Edxf8W81uKbPcouFsR+6/Y8Xr0HUOaF+sSyhiQhngvG8gCtC4X6aTHOCAeQK1pKZ9n
	 aapzXLuPiQwpzMvFnLqragQWFoOibWEclfjLIRv7icGW60zVbqVr1TCgcwCrZxHtNX
	 c1tc3AqSzPD9Kgk/O4+xbpmnJsNTtTzW23Etf8wy+CI7Hr+Gwf832Zi03HvZ7ee7Gr
	 j5W5fJ8g63W1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yu Kuai <yukuai@fnnas.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/752] blk-mq-debugfs: add missing debugfs_mutex in blk_mq_debugfs_register_hctxs()
Date: Sat, 28 Feb 2026 12:36:21 -0500
Message-ID: <20260228174750.1542406-70-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 9d20fd6ce1ba9733cd5ac96fcab32faa9fc404dd ]

In blk_mq_update_nr_hw_queues(), debugfs_mutex is not held while
creating debugfs entries for hctxs. Hence add debugfs_mutex there,
it's safe because queue is not frozen.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 4896525b1c054..553d93b88e194 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -686,8 +686,10 @@ void blk_mq_debugfs_register_hctxs(struct request_queue *q)
 	struct blk_mq_hw_ctx *hctx;
 	unsigned long i;
 
+	mutex_lock(&q->debugfs_mutex);
 	queue_for_each_hw_ctx(q, hctx, i)
 		blk_mq_debugfs_register_hctx(q, hctx);
+	mutex_unlock(&q->debugfs_mutex);
 }
 
 void blk_mq_debugfs_unregister_hctxs(struct request_queue *q)
-- 
2.51.0

