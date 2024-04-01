Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18CD481DA;
	Mon,  1 Apr 2024 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989877; cv=none; b=UR2St9CpBS69bZKes1KxTjdZKQmQ+nSPr16ffze6gXQM54shKDsz85PltyRRg+WjizaVFeohJIxTW0pcikKJTojW8lLEqwp6tS7bOsku0e85vmLGwEGQM9fapmUXjjmUJkn/M+3jGbbjfcCj9KdGNtIn93rSYGGda/v8lyR4hys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989877; c=relaxed/simple;
	bh=bni2oreh2FKEObmaTucp12nLPfvOLx66qrWYUZaiTMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVj824QtwcYl4Io6J9vz7/dSp3VRFrNTQEZzCQFV7udiuOhY1mO0MYXsfdqDbHkTnbqaeXWHoeayNqSbcQLad+bxca4bSIRGuZcKkNnkwEfCJsdaysZSdFqtjvWuPmzdl9j801W3y2p5RShGx96vD748RKWbpeQOFuJyQnh2YcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzE3P7Iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzE3P7Iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E79FC433C7;
	Mon,  1 Apr 2024 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989876;
	bh=bni2oreh2FKEObmaTucp12nLPfvOLx66qrWYUZaiTMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzE3P7Iz+0KUBW5Yd4rHCPm1LF9JJrYhA9SSWqRP0tQUjlPeElRwbuJqsXbXs9ee5
	 xKDr8RUfCunsY0AX3N2IHuL7Ic5z4gJI4nuRFJhiWVnvGKYl5xYeEqzji2VQ8xwiB7
	 1aUxb9W8p7qfhIOT+caHV2KM/u7PNamQNIGwMat4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Zhiguo Niu <Zhiguo.Niu@unisoc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/396] Revert "block/mq-deadline: use correct way to throttling write requests"
Date: Mon,  1 Apr 2024 17:43:20 +0200
Message-ID: <20240401152552.447025364@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 256aab46e31683d76d45ccbedc287b4d3f3e322b ]

The code "max(1U, 3 * (1U << shift)  / 4)" comes from the Kyber I/O
scheduler. The Kyber I/O scheduler maintains one internal queue per hwq
and hence derives its async_depth from the number of hwq tags. Using
this approach for the mq-deadline scheduler is wrong since the
mq-deadline scheduler maintains one internal queue for all hwqs
combined. Hence this revert.

Cc: stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Zhiguo Niu <Zhiguo.Niu@unisoc.com>
Fixes: d47f9717e5cf ("block/mq-deadline: use correct way to throttling write requests")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240313214218.1736147-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8b..02a916ba62ee7 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -646,9 +646,8 @@ static void dd_depth_updated(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct deadline_data *dd = q->elevator->elevator_data;
 	struct blk_mq_tags *tags = hctx->sched_tags;
-	unsigned int shift = tags->bitmap_tags.sb.shift;
 
-	dd->async_depth = max(1U, 3 * (1U << shift)  / 4);
+	dd->async_depth = max(1UL, 3 * q->nr_requests / 4);
 
 	sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, dd->async_depth);
 }
-- 
2.43.0



