Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036480;
	b=HP+R0tVUkydmB2y//OaBOMrrwNr9TVe+nirs/c5N2tWU8ou5w0imB55zkNjf/VpGssSV
	 rZH1xwFKpF+d+I/8AkTSUbkLcLm9afrdgXKPSMoovViJD759ZsvOANwLHntFE8u0+fmYh
	 kAty7j0dAP/jUluFI9CVL7wsA2dD8ZZjgH69Es969htN4NRRbDDL47WrQXwEGmHYcLWya
	 NFrJyKSLtzX8SYZtJz/s4+FlVCanN157jQDh+zJp7JRAcg+UacAreacVCPbqlJm2GnzFz
	 qdQ50NYO5gif1YBo5zo0rSIUPhIIOyS2skv+OguLBu+aYu20jdQOdWuQiOWo9IQ6NIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+js5raqhdw8201E2UTBKs+TPTX0xfNjmu5I6lXthCF4=;
	b=RtUJG1c1Dpw4yGWzY8m0RPMI0mK7nzQ/CMdrVUvWEmicrhddGOVaTMHyEDuRjPV8YPvh
	 v6m/RaAQd8U8IqHhzv9JFjdZiAP0+OgvKUpqSZsxRtKL+y/RfEB8yppTN/OnHd6KD65xj
	 ynYcsrKuqa0h2UD224YQJ+PNf8GJEz0bC41Ncc3XRvYHD9weQ5m1NkKdzL6G60PSqHWln
	 qG1SNFIAuexWgbVcrnXfgsfre2YKcxdF4MsVJhelvD10p0XQ4ZhE34Jp/xXMco9dW72WH
	 bhEO060z6zQsPtjLYIirs6800K8Qlukx8NYEnywihRxXFzInLO6g7V5GpH0uSpFxIKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYrLpf9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE71C606A320;
	Wed, 18 Nov 2026 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYrLpf9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395621F000C4;
	Wed, 18 Nov 2026 21:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036480;
	bh=+js5raqhdw8201E2UTBKs+TPTX0xfNjmu5I6lXthCF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYrLpf9i/rg4MnnDkhjb9NzKQmxWo852vk4SSj58zqF2lt1GgpLYLGTcDtHJ7vGJt
	 jcGqYNsvHDIQXjz+q3ZNLgkiOzB0gtjic5xRxjLKvzsuAtX+nUWX3XmAshFLWgvE0q
	 1n09AUzAHztgsP7Vk3AkBBN4hVJbYC7VDNS51rcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SJ Park <sj@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1076/3318] mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Wed, 18 Nov 2026 15:28:18 +0100
Message-ID: <20261118150352.247877465@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ebd1a08c192109c83a87ddf42793ed6283180faf ]

This shows up in the Meta fleet on ftruncate() of large tmpfs files:

  INFO: rcu_tasks detected stalls on tasks:
  00000000752fd185: .. nvcsw: 59455/59455 holdout: 1 idle_cpu: -1/0
  task:rocksdb:bottom  state:R  running task
    __folio_split
    find_get_entry
    find_get_entries
    truncate_inode_partial_folio
    shmem_undo_range
    shmem_setattr
    notify_change
    do_ftruncate
    __x64_sys_ftruncate
    do_syscall_64

shmem_undo_range() walks the whole of the requested range in folio_batch
sized steps, twice, and its two cond_resched() calls are the only
reschedule points in that walk.

cond_resched() is not an RCU-tasks quiescent state.  Use
cond_resched_tasks_rcu_qs() at both points so the walk reports an
RCU-tasks quiescent state as it proceeds.

Link: https://lore.kernel.org/20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org
Fixes: 8315f42295d2 ("rcu: Add call_rcu_tasks()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f31f6ffa28763..448fc9932684b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1024,7 +1024,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	/*
@@ -1065,7 +1065,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
-- 
2.53.0



