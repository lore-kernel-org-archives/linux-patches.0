Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062354;
	b=a7mf411CsDLgfLpxzNBLCI5kfyc5gJzlKu5kbp15lY7RcyCLzikClTp8CpnvY9W7qUO7
	 VTBjATIPzIUHDpOdM929BY3UO11y2mayfYb/+RiqodAe6cXuKVD+GUcWj2oS3hFxe66tV
	 71AOjDgYbURWozwQwU3jGX2u2tad+eER2HyeZ6f/lC7G9bc6QHzJ7qOLdsPe2nGN4YABv
	 fuibzW0lryMdKsy+AGlv75EO6l5zjkAEjTF7Lw0DYCm/oy9dUycZ2c3QFSLUorbwYCGq2
	 Z/flsAMptKY5Zoo/NQcqV6TwjTxrPaKqF8gQQ1hbepw0r3pDC8HKMLE2bVv7Herrzzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0yoXhaKUitJpeSnibqHdSWGseHg96amtBaluQIoyS14=;
	b=uo/3lfnUQjMvXc6YTQc4CdQC4Gamz2eFfvuxSXbKe+VhNnBBq/nHUdFCsApzanImGvXZ
	 KBfza612C6niBpIaFGN3PcyeV9M0s5FXr3JnqdlDJa0bd+HSwzp0vEQ7XwNYnJvR9nfvf
	 x3o3HBQjB/8kJJ39fFqaXspoRVwT7ftGVtorp7rT7OU5SQzqjJJCdb9QZG2WFvPDcbT8x
	 y+b0VwEqYP4oGMFHyKcRKDGKou9/WxBK561Ppc4ebdgiLRwUjjnqnUOSUYswxva0Q5sC2
	 8CIPPOM2B7itJOpatzNLsPmMzplbvyyHqxtfVvCMZJZ7jlSFOgEGfYFd0bdv4hoMX2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vlm/JCJB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934B6606A330;
	Sat,  7 Nov 2026 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlm/JCJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452961F0089F;
	Sat,  7 Nov 2026 14:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062354;
	bh=0yoXhaKUitJpeSnibqHdSWGseHg96amtBaluQIoyS14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlm/JCJBXbn6R0bjLUAhihUjtKHyKS5+BBZLOVyt/voZb0xinrcx+suVs2jPHtUuD
	 bXAsiBi6/bvBE9umpxeHwu90htWlkkTP563YDjad58BXmy8zQ+ATrurqe1GeksagsR
	 i6ab0dF8Y/3o2Xiv9BmChzo3+jRROzVvv3MvbhZI=
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
Subject: [PATCH 6.12 1243/1536] mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Sat,  7 Nov 2026 08:54:19 -0500
Message-ID: <20261107135032.672916601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 9166d9c455abd..4d01fc877e768 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1057,7 +1057,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	/*
@@ -1098,7 +1098,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
-- 
2.53.0



