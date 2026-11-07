Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064663;
	b=Ldw3MfuHEjxLacY5pl4KZe+ImXpur5CNCSGH5d4QE46kX4OYKwzs/huePS9+FOx8L721
	 6hKnmxTSshry1GzadmGRq645Qf4C4Nf7gSiwNyN9aH2h2hRGDvzA6Ew3T4vwiekfE0aMI
	 vEYiX+s2bfi4iAYdCp3GzXjNYokhJiVJIpAXPF78PGcB98gf0MffCZlgXM2+ugRfrqTFd
	 /A5smCwDQfAE3HH4UWggp7A/qVhyUCiGfrN5z7UNUtg9TcznOMWgQVWFyjdwRUW5H9iPV
	 UIt6gPx6ph9TXTvD40aWt8ZzFxLW75+lm79b8XMUd+oDEgn0oD85ysnvEOYq/JA00FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hsn0KGLZ5xvlYlAudtLBQX6JYxIHoJkuwOB/sPjRqdY=;
	b=UqhbCvmoTBN6oiF1ILc/Fc0iZRLD3Nmbd3/11UY+F7Vzn83UZM2dwGVgoh66s6M5tUZn
	 f2AfBz+rzHbkVP/Z9dtNybxtifgbeQ3rqoLbiXLilrwPAvYz/ZY6DiRtNj16NsIRpOJ8J
	 S9469HyXxgSWofNpbH3FnR2LFbyJrUlx4HNXNu/DpA1m5+zRu+toaN04WiOdRkb66nT+/
	 WmxqgS4kC7NbECM3x79LU+2KUXnnJo/Kd92EoUe1nzk0PRVXm7t0Yh6YmDNFoyFCYb0Vv
	 dCCkmARWRWcFQLr7RlRxxYqwYO0YteGnnHM9NKMwLqEbBIO+P/gAPQIpM5nvSinI6/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQjDm748;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C256082BE6;
	Sat,  7 Nov 2026 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQjDm748
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BFA1F008A7;
	Sat,  7 Nov 2026 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064663;
	bh=hsn0KGLZ5xvlYlAudtLBQX6JYxIHoJkuwOB/sPjRqdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQjDm748igoldyUGY3U/PBAt2qf56RcFxt1rTUrodnj41AnO+g1Zzdf1aabXOh44x
	 NiRCRIoHIk63qM6QS3NWi1L1lrm01BRqo2Hhpvy+hLLn1hQO4Cm4G2e1bPKNk8CFAJ
	 unEZ6d0+mGk76ycHEWNYdMIMIHWSkrNubbH3hmfY=
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
Subject: [PATCH 7.3 0662/1257] mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Sat,  7 Nov 2026 08:49:18 -0500
Message-ID: <20261107134957.539632394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 848316eaa7f4f..af531eea77b93 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1159,7 +1159,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	/*
@@ -1200,7 +1200,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
-- 
2.53.0



