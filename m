Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059761;
	b=dhCUHs03KM+TOvuVO3hxwegvtCxB5virihB2ysicHvYgzUoGIJZ1LsIQlypEBN/tNHj/
	 zy1eN8K2rUMnIPC13pokrvfaRaTjfGI+yGN3sMuYqfLvdX+yDgH1/kxDfs6p+CyvGIY2E
	 2VeLrlvlru4dixoavpuXLR1Sd7N26IWB2fiBVjYK/GTuXXqRlXSdvPNkSuRwgRqb57Jwf
	 IrjBw0M5mgY/TcJ6kMrJtREppGUGhMrUAgrZCBy/11XJWeGKa/QBkIEZ8Ps46sGJP+kOJ
	 V7qW64I/CYXY83rs8BQS8vCAzEHfqQd/jHK4Z6iqbFDaU5MuuMVIASqafwhmIok6JyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W0fq9hL/fdnQtrMNlbrPMyjHjX35QqHeIeiO+ma47mI=;
	b=tBz/sHmC976JDE6eLpSfN/OO2ncpySQyuwSpv/ZqPeUOMVALxZKjuae5vAFLzWSRcwi9
	 8iLlFcyGHX0BcR8gNQMDaDuqr3REzcTc83czwDsr0euBpTWgjxGUOx02lFlT7dVlYAkp8
	 gNQZWadZHOGNQKSa7T0ST/VntagekHgRPookVUMNKPD/O/Azqa7dsy1HoCceiKpZI/z1W
	 ybevMyUjKJQAb2uQLhJkvgnObotaqwX42PM72ThRUQFDBLBUhEHDIMrfvypNbjVCzg0aq
	 qY7ghVoNV6czGteG/w+L8KoPAwtJzV1cv3sSeQXsRw20dtDtYU/UL0zBxWM8HMB+XfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McAEUQ7j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A755606A320;
	Thu, 19 Nov 2026 03:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McAEUQ7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2714E1F000C4;
	Thu, 19 Nov 2026 03:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059760;
	bh=W0fq9hL/fdnQtrMNlbrPMyjHjX35QqHeIeiO+ma47mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McAEUQ7jZP0XrEFT0sygIaBaUj88HmrLYN0E/kCOXwPwvWWIuGJUEmqYzw9f/2uDc
	 3p8b38CeyBNa9B+RnPm1+Ok2NkyaHuKHWSam6jM9oCWPgIZqstSeU0jn8rrdqVyTaA
	 9TELqu7cPN/CX/Mk3otNmgtpmCpjn6zRJo1BFA/0=
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
Subject: [PATCH 5.10 0957/1848] mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Wed, 18 Nov 2026 15:49:55 +0100
Message-ID: <20261118145957.070068841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted loop context from folio batches to existing page vectors with explicit index advancement ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5f8d8899bd0e7..6f2e267aa092f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -957,7 +957,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		}
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 		index++;
 	}
 
@@ -991,7 +991,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		pvec.nr = find_get_entries(mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
-- 
2.53.0



