Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032587;
	b=uF+ugOzzeSTpksrXO4LzcKRhWBJQX2TEBehTZ97rG3WXQIT4zjN1JoLVi69y6R/QBf0V
	 756xlx1wphpdiKlkCo0Q2EjioyBf/hFyT/+LRYMd5yJqL+x3NmWiAxbLYkmkPWhwa/zka
	 CdP7nwUAob/LzPv+8Qq+hx8HBv2ZUHFNtoy1Ht0jhFhi2hE1VpC0tlEpkUP1ltjq0X9i1
	 JEdKQKTT1TL1qmK+moL7x15k1pxUaXt8etU8/H1ySSGu5T2aoD0ocdB3kRlQswPjjXqEd
	 ChRoqhk1H/MevhArPmKFuB9cCRJxo5w0JAiELse3Hdc78ruHYeAFROh7rTrXvPrVvoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zvr/t0yrwQGfPS9PhflFK0YZ0ydQrh92rvl+xCo17Ec=;
	b=jNDHP6e+A1/7l7gfIqV0YGNCKvqwEPSv9ZIUapoH+ycWxZQ/PslsOU6WrG0jbnMppjBn
	 03WxmAwvJn7AtPuAsZ7heY2j+1MJsnfSdIhbgEKG6mJrrZyMmuYhoC0hx2G7SqoYt88IR
	 zxzgy2bCNUC7Z559jDNbonjoKmd61FVKKSFiDJmM18iHkI9k0ZuzNvdNCIDrGQYPKJVRc
	 ntIwBLyKiXG9b8GuT2ucGNbBek0VakILqHymNXfU3oLVsvPdOYXs0+0GMSkuAdN4PpVMl
	 tioI1h+eAxNO4eL6Y9OKzLDHtt+YE4YVVw8Vkg/6li1iBgRWI91ixJ3wxuhJlezpQpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEaywA9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDE1606A31C;
	Wed, 18 Nov 2026 20:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEaywA9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D191B1F000C4;
	Wed, 18 Nov 2026 20:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032587;
	bh=zvr/t0yrwQGfPS9PhflFK0YZ0ydQrh92rvl+xCo17Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEaywA9iF5ctTviDU5/6c+L2Flsx0OJHLqxtE/rA6HAoRagx6pA9liKGyfN4ptoCw
	 XosR6rupAV0ZTDFAYXaQDWuYp084OEVm4vtavIpwicCrBZ/sV0PNv7oRpZNxOE+YGN
	 GJW6jGzEag3RvupvwohVpbMYpdYhMhuJbgPlbZUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1419/1756] block, bfq: initialize active lists for all actuators
Date: Wed, 18 Nov 2026 15:59:06 +0100
Message-ID: <20261118150105.665007430@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 00c2c34ead7e84d6594e20fa37a3c503823f5756 ]

Commit 2d31c684a053 ("block, bfq: inject I/O to underutilized
actuators") extended bfqd->active_list from a single list_head to an
array indexed by actuator, but bfq_init_queue() still only initialized
the first two entries:

        INIT_LIST_HEAD(&bfqd->active_list[0]);
        INIT_LIST_HEAD(&bfqd->active_list[1]);

For devices with more than two independent access ranges, the remaining
list heads stay zeroed by kzalloc() and are never set up as empty lists.
When BFQ later adds a bfq_queue to one of those lists, list_add() writes
through head->next, which is NULL, corrupting the list or crashing the
kernel.

Initialize every actuator's active list using bfqd->num_actuators,
which is already set up earlier in bfq_init_queue().

Fixes: 2d31c684a053 ("block, bfq: inject I/O to underutilized actuators")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20261019051137.1715-1-lirongqing@baidu.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 68359e1b92e20..ce7f414e82112 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7321,8 +7321,8 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	bfqd->num_groups_with_pending_reqs = 0;
 #endif
 
-	INIT_LIST_HEAD(&bfqd->active_list[0]);
-	INIT_LIST_HEAD(&bfqd->active_list[1]);
+	for (i = 0; i < bfqd->num_actuators; i++)
+		INIT_LIST_HEAD(&bfqd->active_list[i]);
 	INIT_LIST_HEAD(&bfqd->idle_list);
 	INIT_HLIST_HEAD(&bfqd->burst_list);
 
-- 
2.53.0



