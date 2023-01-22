Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFDA2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C5AC4339B;
	Sun, 22 Jan 2023 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401332;
	bh=qZIR3+DMn+9u6CQsOyR1bKe1uDm90hSrUoRzC2mA2iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrfydrRf+7E+/1PFcbwOdWdKrbatiPQL3TvKQs5vGWWto1DimBbGCirUp+60feRia
	 azqb4E6Dkkmg5Sqi3oGosrhnC/M8zc2AMjZlt70c8vXg2EGZPRKrUSCQiHlpNS62mD
	 GBgbd/UrjgZqPnBA8m6ODecK6hd+ndKwCO03csx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 191/193] block: mq-deadline: Rename deadline_is_seq_writes()
Date: Sun, 22 Jan 2023 16:05:20 +0100
Message-Id: <20230122150255.149769924@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 3692fec8bb476e8583e559ff5783a6adef306cf2 upstream.

Rename deadline_is_seq_writes() to deadline_is_seq_write() (remove the
"s" plural) to more correctly reflect the fact that this function tests
a single request, not multiple requests.

Fixes: 015d02f48537 ("block: mq-deadline: Do not break sequential write streams to zoned HDDs")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20221126025550.967914-2-damien.lemoal@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -294,7 +294,7 @@ static inline int deadline_check_fifo(st
 /*
  * Check if rq has a sequential request preceding it.
  */
-static bool deadline_is_seq_writes(struct deadline_data *dd, struct request *rq)
+static bool deadline_is_seq_write(struct deadline_data *dd, struct request *rq)
 {
 	struct request *prev = deadline_earlier_request(rq);
 
@@ -353,7 +353,7 @@ deadline_fifo_request(struct deadline_da
 	list_for_each_entry(rq, &per_prio->fifo_list[DD_WRITE], queuelist) {
 		if (blk_req_can_dispatch_to_zone(rq) &&
 		    (blk_queue_nonrot(rq->q) ||
-		     !deadline_is_seq_writes(dd, rq)))
+		     !deadline_is_seq_write(dd, rq)))
 			goto out;
 	}
 	rq = NULL;


