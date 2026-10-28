Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216421;
	b=NRhUqqfaJAwLYKGgrMxW7lG6Eow4MFsrvh+fuxS2If8c0HttYrKTe8UBhymI+leJVO6B
	 qfcOr8dBDKDmk2B2g9FQQbOy33yf/Gph2HeSgkfRJA7npRKWv/BYXs40ZgjFeLhNPdhQJ
	 1OrchuDSrPQVVNbyHE3wnjezebz6zRhe6dRJLFTWgawXTs95+D4CmW9WcF2TEdy8+LJys
	 qROFOJw86wZVLejxIt/8n6SlQrrL+id6B8KM1tcyHoxTBhur7bzRfsX9Nkjeaez6NDjFe
	 R0kA61/5LJIZumHhX9IKizmogRK7nnY6su6iYRk9lEIBOiKhj25HvQ6d4CeX/QMJnNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WZipF4ssF223KqpJiCE8ivVoL1+UMRo7dji9b/viTT4=;
	b=CglY+lYi3TRbTd0SM5W6KLj3ON/eLhI/5PrjcI1kB0NAEGRdvEbbYchzBeK0juX94fBG
	 iuqaQr9+Dx9sFxihwmvjG26adxCZjPlsA073JXoW/9STlgkWnK3WwR3DVFMCZ/9JeDx6I
	 GyikVxHpYaj/fS/4axIEOhkU32H/CWewWidmtPXieiE4VLq+McuMRDCGAvc7D5XwB8k+B
	 OXkLkNtmEr0kZR8fkMOzsoVJi8lcuPS4HfqoZx51dpH5wZwBu2LbAe/qQcA6t1qtLGpJr
	 yVzdRf6pGDQLPhaIVLq7DYIrhnIsxG4CRRhWi9fQQ49+gl28tQ+PdAl2H7lxtOd4t4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y1HShpEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E27606A33F;
	Wed, 28 Oct 2026 19:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y1HShpEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D781F01825;
	Wed, 28 Oct 2026 19:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216420;
	bh=WZipF4ssF223KqpJiCE8ivVoL1+UMRo7dji9b/viTT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1HShpEZ9Umt/GRcFPutr1GAlimGU2/zJhRtVaCxKgNDBfB1fV8c35JBTyOkmOBH2
	 HI90dMzsRoOM3vD12zkfktIPIWSBfa0zYTJ3wHW/G7hQ8tq/tEWz8LswRpaQvdBCOr
	 bIld5VHG+4UEW0qaoDmg+v8QcHyi/vxuFgSUnw6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1548/1887] blk-iolatency: clear delay state when freeing policy data
Date: Wed, 28 Oct 2026 18:00:44 +0100
Message-ID: <20261028170534.694674494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit 8935bf22c0a0db517a7f72f7097300e05dd852f5 ]

io.latency can throttle a group which has no latency target of its own.
When a sibling misses its target, check_scale_change() scales down its
peers, and a peer that reaches queue depth one gets blkcg_use_delay()
called on it on every further scale-down, even with min_lat_nsec == 0.

iolatency_pd_offline() resets the target through
iolatency_set_min_lat_nsec(), which clears the delay only on a nonzero
to zero transition, so it never clears such a peer.  Freeing the policy
data then leaves blkg->use_delay set and blkcg->congestion_count
elevated with nothing left that can drop it.

blk_cgroup_congested() then returns true for every task in that cgroup
and its descendants for as long as the cgroup lives: page_cache_sync_ra()
cuts readahead to a single page, page_cache_async_ra() skips it
altogether, and __folio_throttle_swaprate() takes swap_avail_lock and
schedules a throttle on anonymous folio allocation.

Clear the delay in iolatency_pd_free().  By then bio-held blkg
references have drained, or the queue is frozen for policy
deactivation, so check_scale_change() cannot re-arm it.  The free
callback can also see policy data which was never attached to a blkg,
hence the pd->blkg check.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260814165712.510132-2-usama.arif@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 884be27f0dda5..10d0ffccc874d 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -1037,6 +1037,15 @@ static void iolat_release(struct rcu_head *rcu)
 
 static void iolatency_pd_free(struct blkg_policy_data *pd)
 {
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
+
+	/*
+	 * Groups throttled as collateral have min_lat_nsec == 0, so
+	 * iolatency_pd_offline() leaves their delay set.  Drop it here, where
+	 * no in-flight bio can re-arm it via check_scale_change().
+	 */
+	if (blkg)
+		blkcg_clear_delay(blkg);
 	call_rcu(&pd->rcu_head, iolat_release);
 }
 
-- 
2.53.0



