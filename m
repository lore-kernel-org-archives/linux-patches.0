Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216418;
	b=tm00SqM16aEn3mN0ZsxQuMzQL0ZcxKpgF5dNb741VSeRtqmCWCwpYiMzZNfSqrbt0o0B
	 tFNcw5y8J/NWskE4RBNg7qDw0kf8c90ZItksF+uvnA0jDu0DkUssEUoOqa+qGsAeOWhWU
	 Ye8P0fpPt7c6VE1tI1u0/XmG2PlLGDNUwXQuYoEeeb7yHqMI087vhA9RmGwZWDlUnaq6t
	 6LISZod1uHI13gn0XZVT7HCxLd4muHtdqlPep5vaRRCQXpjiGgcmdv/dvlFcfSWpeCrXN
	 qeTyooFoSGUkQhTJsQYIGe/ycWAIFCY2qKvd/fcFG8zW45AtGEMgIkgl7eoFU1M7KtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v5wlOwOXwthGLZ2jPmFgnnMHWopnhCL0pnKJ1GFsv+c=;
	b=DxrNcJ25QkZPj1KpXZjZ6tSmHw3MOr3cgSqNmoETLO9pCQx1hM0f/KSRRUYBgfNK9rNy
	 RGg4QtfVSZhn9+L1qJ72gT+WdBi2q4ob/wXXhiFgqLtx0gZS0SGgP03ex0RycLaXppQO8
	 gswWR1WjIzVgnNhuIP8/Y8cAjuCxadbLxm7RmT+cro+VV7Br0RsZQ+gfj+ChcpwLF+eK9
	 VcHqqtKkYgxldyfxwFQmvUG6wMi7BzzABDpopgoY7b0xJ2r92BRZcduJLPYe1feyN0U/n
	 xnb9wueEVmSzjqXEZOZ8552MABF/8MO32eEXbgxTzAlVNognfH0K/isVVQCx8flL1xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkHoUl73;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEE60A2604;
	Wed, 28 Oct 2026 19:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkHoUl73
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BE21F031E0;
	Wed, 28 Oct 2026 19:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216418;
	bh=v5wlOwOXwthGLZ2jPmFgnnMHWopnhCL0pnKJ1GFsv+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkHoUl73WrGyB3lc4ywje639D/HEvrhsAeKttp39Y4KYHIkrwtPZIS+7Vv+VhOLQF
	 +vxFqBfp6TNVOJJbainCKD454SZvFKbQqSj3Si1THZUpGXwADKQqp/jdFREhsHZA0V
	 0zcwNRZvK99utzA8o53JvSByEDruzmwDnBIe2cLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1547/1887] blk-iocost: clear delay state when freeing policy data
Date: Wed, 28 Oct 2026 18:00:43 +0100
Message-ID: <20261028170534.671291880@linuxfoundation.org>
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

[ Upstream commit 97cb95d2148835ae86ff916b145aef332d40439d ]

iocg_kick_delay() turns sufficiently large debt into an explicit
block-cgroup delay with blkcg_set_delay(), setting blkg->use_delay to
-1 and incrementing blkcg->congestion_count.  Clearing it again depends
on iocg_kick_delay() running from the period timer, the waitq timer or
the issue path.

ioc_pd_free() removes the iocg from active_iocgs and cancels its waitq
timer, and no further bios can arrive, so once it has run nothing is
left which can reduce the debt and clear the delay.  The blkcg stays
marked congested for the rest of its life.

blk_cgroup_congested() then returns true for every task in that cgroup
and its descendants: page_cache_sync_ra() cuts readahead to a single
page, page_cache_async_ra() skips it altogether, and
__folio_throttle_swaprate() takes swap_avail_lock and schedules a
throttle on anonymous folio allocation.

Clear it explicitly, after the list removal and the synchronous
hrtimer_cancel() so that neither timer processing nor an I/O path can
re-arm it.  The free callback can also see policy data which was never
attached to a blkg, hence the pd->blkg check.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260814165712.510132-3-usama.arif@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index eeda41267bd43..814ad657cc56e 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3016,6 +3016,7 @@ static void iocg_release(struct rcu_head *rcu)
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
 
@@ -3038,6 +3039,12 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 		hrtimer_cancel(&iocg->waitq_timer);
 	}
 
+	/* off ->active_iocgs and timer gone, so nothing can re-arm the delay */
+	iocg->delay = 0;
+	iocg->indelay_since = 0;
+	if (blkg)
+		blkcg_clear_delay(blkg);
+
 	call_rcu(&pd->rcu_head, iocg_release);
 }
 
-- 
2.53.0



