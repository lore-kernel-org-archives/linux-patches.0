Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027431;
	b=Q5olAL/lACYh/snOAwRDunJ/Idf5/duIacTDG0RZQAS3TCWim/WENyU8SZocOWYNN9/F
	 G2ovwgij5DAq4dOKIgZ49l/YqKw7WsAMuk7KeXeTRpgtJ/pP8BbOjj74zkFded78H6nj/
	 GuVPJ/p86uKJtyx862GQXZT8Tw6fKjyAP3FhyOLzbKfh+lEYL7sRnF4stz5r277MfSYE6
	 aqc6iVuYQ/yW8pTJiqZxBS6hu5SOLq5lBi9UcT5NiSBQLMoQKrNBrietLvrHEdpbOqTqG
	 7zNsg9XMdPbGqakeLaZ/Sa4V6koIOm5U9YH8S3u5bGnlpq+TafFdQI7mHG9ytsaHYtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3JeLerdd8xJbC3kZkK+eU/dn1utwXpfHPvIA5N1f8Qk=;
	b=pmdxAp2YNDdCMrSfjX1NxI+HA7wbTn5WLhwsLg6cE/N+G0dtycKENcq5ECm/+FXOeact
	 LWjnH5lJc2e5i3hACuJEq1sUFn+qjYK6votmaVDBxd6CbxK3He5AFWp73Xzzfy7895RH7
	 C5+Lc7RfNgwWBB3NeKmt8+MwlzyJw7CdS+Tuysrfx63/PF/l4efVy6/Lo5/Ky+GYPI5+3
	 LXOwy+ct8njD3VQZXshP91E4am0GsKyR+lWnJF1FAFWzYmMGY5LTdHCdIEDF23EMvk5+k
	 3mLYQXbUDoYdnvJ4Hya1rySzxUCecTWtD9kCUW48CaplXTyLauWof0b1yFILNnxm7aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JfaPpa+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C6560A261B;
	Wed, 18 Nov 2026 18:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JfaPpa+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7AC1F000C4;
	Wed, 18 Nov 2026 18:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027431;
	bh=3JeLerdd8xJbC3kZkK+eU/dn1utwXpfHPvIA5N1f8Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JfaPpa+eXbLy6Yag/0ZH6xtUXzx9C5Mb8x2/dTK5mj+vhLTbMUnoo8WsxKLVY99o
	 OW28ZHrg6uXhwXkCUPbWyFgLfk70M13lIJLmNZCoJzYFQHYsRKYHE/jWc2FnRKF1h5
	 UT1hH27BWuQ0MCUWfxFQXjICY8jkKMGFBTHuhYN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1788/2151] block, bfq: initialize active lists for all actuators
Date: Wed, 18 Nov 2026 15:58:43 +0100
Message-ID: <20261118150226.951925378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9e9d081e86bb2..5f0517fc27229 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7287,8 +7287,8 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
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



