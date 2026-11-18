Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042116;
	b=eCe8EgFcu1qnptPoBjyeVrNWH8oJBNKs3T18tdoGj10X6SIlAPE8bf5voSqYqtnoeKQj
	 duWq5zxeprgJsJ2ENu/LlgKTQXHv2rB6onbChbUkAHP1smM1gguq+zCbHLbQaR+CuP3Vn
	 hwotxTzZb8i6IDrBpFTxWNevOkc+iHX2TYriXRb3zDLJIe3dkkyg+HqRWd9hN/y05b92s
	 7tlCrTRPYbrY5LqsqAnvbFWYNxKVFqpJz0slrs5dz1S6lWkOlvVSfVJeYaYybR/F6AGJM
	 OIKZVYRDzXl3dwDq1lK1Q3/y0444O/5L9gkrppMVLKAYR/CjoVnoViHtfIYPGTruTWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j8UYHdBpqNiif9RHpCz3OSaYm4rOiUwe9xu6kNzs8kA=;
	b=j/aZwKcpWFDwegYp3JhzzGuIo/MVEQ9KkcR4Z69bV6xkBj+pGnddzcO6gaWIsKxYG1Jr
	 nHZVg49jyZkKh3i1ooY20nVEyY7hXxPgLzg2FSjzI7sgAEAgtnzMwPklqm2Unto6GXvdd
	 Gmv46D9j6H6Ux1fpCVaCc+7P0phKB379NzhkvLDJPEBUxKuaRtE+poDNRUxyY5pigbPTc
	 KqY/tTiQKpCdHh3fDXCubRbuakIcEjU6ZZMjEDCbJ4msxtPFoEVGOptcOoR2DH0jyzkXT
	 ZUt5Zs57Zck+ZvLMZOrpmzUlDlegTFJvCNN8KeqJVGASK0DTVR0MWlph7gn7HDp1DZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OR16L1Ly;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F95606A31C;
	Wed, 18 Nov 2026 22:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OR16L1Ly
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FBE1F000C4;
	Wed, 18 Nov 2026 22:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042115;
	bh=j8UYHdBpqNiif9RHpCz3OSaYm4rOiUwe9xu6kNzs8kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR16L1LyOvH4TWrAnOXtD0YG1dGZR9JpjMmz8FUpr+4v6S+DYE/QaQWuh/OhGaXf0
	 P6x09tgsabwpUnlt/gGMXehqrYbzTau0jjdhyUWgdVMxBbUlwliY3n8WCWSCFd+MnT
	 HSmpC4T2HRukWrTiRRtMG04xQVI4wCVT3rZKWnRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3054/3318] block, bfq: initialize active lists for all actuators
Date: Wed, 18 Nov 2026 16:01:16 +0100
Message-ID: <20261118150451.767670263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 617d6802b8a0c..bcaa55b52e9e9 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7327,8 +7327,8 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
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



