Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062144;
	b=jYcy9CmnewxCIjwru122jBAD3h//xlLX9QKEEm3Ze0zn7wa7MPRsgDvwQsKt4lqJxlRr
	 mceKfLQvqm1P8uQDOxDhLc2fEqPP0EtRKGTbP0py+OOlL3M0zHUWn20kHEpzTLqYiKY5s
	 rYMBRjf00AhYrx4TTNGfyvLcBTZ5bem/qkLwnaHqheFR+Uwg3Qvm1FJYrmk2/l0lB76Zy
	 pipdWax7e1pf/YirC5vJ/VxOEzjAWL1AkCb1RWBzZf4YI99b2BoNynv+Gcg/bPXRYaNg5
	 bdrTJ+2oUDmi2LnR7il43rd/1HmmHliVLI3MCbNiZZLkqhOEQ2Z/ykHQlVG9B9dJB7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RnCMIDVbgaABWQtxWmb3xMD+jCVmvqw6BEr/1HB9qk8=;
	b=OBcWAusW+VqeOOmOZko3xSLqn0D6+/JIBF8LjaPquo8qE2YJN0fH0M7S7tO9v2V3deJl
	 LnCGft5b3sbTHfW9NC6bwCpBW6rBFKgakWJ8n2hQ9wk0kMJyVR5wVedrQPETZG9hwG1Jg
	 h19ldGltOCnK/lT+2xLEniwnOEN0B95tgNPbyAjjY6Xw1bfYNXV2ZOtXYP5cZ2lM+QNJ0
	 Wsneb7PmTRk+epboPP/S0WNFyfzumKdBfCcPNr2b3hpiTYbWHpH4s9+enjFyiuqOp9f69
	 5I/09Oyj7luC+YTrvypTGT2Nz2l3PsGqk3tezoTBKa/9Ml7Eqp95HqwpHelbXm2T9wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXOH6G3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F0D606A320;
	Thu, 19 Nov 2026 04:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXOH6G3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493911F000C4;
	Thu, 19 Nov 2026 04:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062143;
	bh=RnCMIDVbgaABWQtxWmb3xMD+jCVmvqw6BEr/1HB9qk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXOH6G3RfKy6q+bhpeSRRybauVQeNl4w4p+oxekAd/uSEIJZWQOarD48DMXuv+N2z
	 tC8rkCmrYZVTgq+CHlxyw6ltzIjV0OiQosf5KNO6qMT1drA5JB1Sz99a7Y2mRl6q6l
	 cEXlW1ftYhHooT9OmWyzI05dkwkvKRGcnAxaVPTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Qian Cai <cai@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	John Garry <john.garry@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1804/1848] nvme-loop: use blk_mq_hctx_set_fq_lock_class to set loops lock class
Date: Wed, 18 Nov 2026 16:04:02 +0100
Message-ID: <20261118150034.826127681@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 88c9979334aa5ff8c814ddf578f3113ed6c5ce8e ]

Set nvme-loop's lock class via blk_mq_hctx_set_fq_lock_class for avoiding
lockdep possible recursive locking, then we can remove the dynamically
allocated lock class for each flush queue, finally we can avoid horrible
SCSI probe delay.

This way may not address situation in which one nvme-loop is backed on
another nvme-loop. However, in reality, people seldom uses this way
for test. Even though someone played in this way, it is just one
recursive locking false positive, no real deadlock issue.

Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reported-by: Qian Cai <cai@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 64e21d782020 ("nvme-loop: don't BUG() if a scan runs beside a reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index ff3258c3eb8b6..e17710e405a31 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -211,6 +211,8 @@ static int nvme_loop_init_request(struct blk_mq_tag_set *set,
 			(set == &ctrl->tag_set) ? hctx_idx + 1 : 0);
 }
 
+static struct lock_class_key loop_hctx_fq_lock_key;
+
 static int nvme_loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 		unsigned int hctx_idx)
 {
@@ -219,6 +221,14 @@ static int nvme_loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 
 	BUG_ON(hctx_idx >= ctrl->ctrl.queue_count);
 
+	/*
+	 * flush_end_io() can be called recursively for us, so use our own
+	 * lock class key for avoiding lockdep possible recursive locking,
+	 * then we can remove the dynamically allocated lock class for each
+	 * flush queue, that way may cause horrible boot delay.
+	 */
+	blk_mq_hctx_set_fq_lock_class(hctx, &loop_hctx_fq_lock_key);
+
 	hctx->driver_data = queue;
 	return 0;
 }
-- 
2.53.0



