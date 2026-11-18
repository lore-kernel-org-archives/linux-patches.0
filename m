Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021085;
	b=CE1rIv4weIAEMHSYYq23rKt7DLjCDtpqNMNXYN9Ohf5n3w8QrxkyMdMKk+EkgHHz5mTj
	 r+C1YYg9VkX6rff/8fIpfeiwOiRNiQrhZuwzF/dlLyxOJb1CsZwhT/tkeyM0CMf96k6uT
	 IrW51yuF4RefRgjMpd2tcIoj6/C8ga75HnO40Bn7O8Qm91ppsdrdbpl6kUQ5wJJFea7YI
	 luzTEnXmKBgUqGptfm22+q3X2JuS9Dx95n800vAfSahZnx9oyprUHlpzT0H6RJM4yjfwv
	 z5w86pZj58y7rFUG0SQfu8TfxiM3YoogI8wdpvZTh9uVobLz8ibOxgkttgbbbu6gH/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s+cJbegFywilJxpoNmNI3ASIvNHXL5ZQkCpbO1z5W9c=;
	b=5LTE0pmU2wGltozqDaXOmc9xzIOpGadVTH21AZLjHnDrr1iyp2lEcMtxnjcEoVFLQ8/F
	 9Sc38V57hcWz0RhkgCTmKrv0zQalsNtuSCpSJE9qGwRLaL3eHEQCF+3HoZFZT9+AzWP6p
	 UWhX1W3V/DPloB3uLGV+lub2kqoyzjaPGwW7oozyCk3fOX/TpS1S388/SsomvY5WyskhK
	 9uOiPvxhq3kTb8fN4C1xZBukvCbR4i/iXw18We56mPoMY47+YjRmO/9F/d7g0YfIc6Jf4
	 Q/BvfQ4g0Pu4mDz8LNA+VfvN+8ZOuR8wtemI5egfqsT8LyWtHqJ0RdlAGB3piGno5Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNoN7ci6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF98D606A32A;
	Wed, 18 Nov 2026 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNoN7ci6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8251F000C4;
	Wed, 18 Nov 2026 16:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021085;
	bh=s+cJbegFywilJxpoNmNI3ASIvNHXL5ZQkCpbO1z5W9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNoN7ci6CMe2Zw0pVkG1KGrai1KYSZx/tiZJNkFajLBdWPRw/ZsI/UdOmc0a1TSFA
	 JAEt/Mx/pIYFFgyYdl9sRRUpXOHmQqWM0StvXmok2nDMk8Ocztuvp1O0YxHtVLENr1
	 L9WW0SWAJc7SkyszuxZYpXK9GGImdIYkgtgo524k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2180/2651] block, bfq: initialize active lists for all actuators
Date: Wed, 18 Nov 2026 15:57:00 +0100
Message-ID: <20261118150404.263546915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 0f75301b3115f..b21ddba30df16 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7273,8 +7273,8 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
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



