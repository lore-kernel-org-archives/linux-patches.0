Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054094;
	b=Xb2zCFyYcs9WJASuGStBGFDhiJzNw2T8fAInAjOv7H7p75AUcv9eJpTMCypWE+zjDls6
	 LMrca/QkTQyXIA8Riq629SoDx5I/9RCiZytDS8OTFYDemIBNSHezvVAcjoHHQwD0rak8b
	 lesmPk3QhreDQ1ESIJgEMxA/32tBmFvJSTiEJP2jTKlkSLQMxPEQXplCVbd1tVOaoAHU0
	 Hbi0bg5bcu7G8FudzW/auqU+wuuKZU15QpSjiUIhkvcOgtqYzd/t7i7yZ9HtUcbJD2XWw
	 PNgLxFjcX4dkfSoa/jclyzksMrilDyf+vLDGBdE5uPpXKQT8UQYAZ1I2++zujrXovpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kZAWKx/NtcQqLfCvmV0aEp8s7y10jd1P83aR+TMF86I=;
	b=UpzoEJpWFFB180vsNXTvV1j1fgCsPWde4Ie8Npw8bBZsvSUQ8pUqx/M0dMGTaFIKUHXb
	 7rt6/tRyR1YCKxlCnsohbVXw4xtCeh0nThSptK6mGUINzebn85miTEI1+0jw7T2jNttNc
	 PsHOZIFZPdjR9YnNwAMxt1G/SC01r9I7akb7IzG9FheAir8NYVWckmYMlFu5QOn3EMkDi
	 16ppOxmxtlrmDnmR8bnBUAs2GXdwm3xoKuwZjzvIeZiHG3B1/hm/SzzfJcono2/GVYfzW
	 R8dfVglU4v8DbAq5jx0MpvK9pv/B42NSDhviO+c4Kk3APb+Hl8ysqlz7MqmVEZzDzwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiuzeFOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE8D606A31C;
	Thu, 19 Nov 2026 02:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiuzeFOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8461F000C4;
	Thu, 19 Nov 2026 02:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054094;
	bh=kZAWKx/NtcQqLfCvmV0aEp8s7y10jd1P83aR+TMF86I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiuzeFODwrd0N2BS392aPbTh7bm7/g5gt4CqWT3IeGPfHKWZ9+y6jcFMHzAdcHfY/
	 kjbfO3ZuaEayZCqM/oQ8pW/NvZ7qsLzbrEuSTxXO6ysZmx+2ZENEQjGsCtg6pdwrZl
	 HITYcW1drNzzWN7m/7PU97roNl5oWeu3HoeCGTz8=
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
Subject: [PATCH 5.15 1150/2214] mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Wed, 18 Nov 2026 15:47:06 +0100
Message-ID: <20261118150057.999723800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for pagevec traversal instead of folio_batch, preserving explicit index advancement ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 06ed84ebdf3b7..cc5b08d9802cf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -962,7 +962,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		}
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 		index++;
 	}
 
@@ -996,7 +996,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (!find_get_entries(mapping, index, end - 1, &pvec,
 				indices)) {
-- 
2.53.0



