Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047301;
	b=rzjwPUBkDn7ib43GJLRygOVja4UZtialN1+w7trFZbupWyBVxCnh/XyTHRcgk+I85phv
	 uUsR3WlMc1JaP58mqAlp9CBqyagD9sp2unW/d4/NMMKf8ctv3ZhmeMMC0YtZ+W1g45U9n
	 7A1jJ2/S4Fb3h0MsAeA8IhfTQt42Menq2seAtuMlcOH1997bFWUoDD7anp+Qd8dQbnKG4
	 UqlNrzzCBnuz4tdcBPB3foJ5e+SmRQZf0ifJDdvSwT/HNdFUbav+BnYKSrPb5Nph+vdJr
	 +yoNgU/HRmJxLm+28gc6Mt+O50HH2D+JS30Qa9D5ffIQfI7zoG/O0g/HDdY12UO5ngQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=doiaFPLkBW2io+KVRC7WiOq/QXANIGtce1F6nvGo6/8=;
	b=cZ09vNKNqUY08fsDoxM+JicoHFDVtIsDn3Au8ag0PA//kbsD/RTC9ROz2BynQ8aC8WbS
	 DucHJ79bEJVazbC0tKpzR1vDTM4uwpBGdTiENS9ksFpsJxcp025NiLz5xbaWyF9YjTPl+
	 JdeRInPV6akEOOQf8ZWuENKbaaVYIHV6utO9COHaqcJGtWfc5bpq9OR639EKCPShjG7pB
	 ImLaDAGaaVqFO4H/EZs/fTRBvLb8tkzTDEQlHgXRqJ7apekvcpOOSUnZL0g5wN1Fwe+lQ
	 X4RgOEHptf6lpXoqzG9bwmABoEwW13j5DwWqShxSZKAt+tfBekq2Go0U96ooRvCYbLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RdBP2OFf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8B8606A320;
	Thu, 19 Nov 2026 00:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RdBP2OFf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221611F000C4;
	Thu, 19 Nov 2026 00:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047300;
	bh=doiaFPLkBW2io+KVRC7WiOq/QXANIGtce1F6nvGo6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdBP2OFfyxZuiEgO0wnc4vePNATLNwc2J23/rB4gX2NGWzJl1N/Xr/1jadKsaUgGF
	 idloIPhNuBZbKOxVSU24lxNAOf/y/tspI4zRa8mVZ4Eu6dAf8boudUDIsbkLiZMeY/
	 3y/eaZaCJnKM2p2ze8xk1Doxg5wfRxF2OGQK0u3o=
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
Subject: [PATCH 6.1 1553/2857] mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Wed, 18 Nov 2026 15:43:07 +0100
Message-ID: <20261118150257.297277096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 420d4e3b79e35..9db6a2488f456 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -950,7 +950,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	/*
@@ -991,7 +991,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (!find_get_entries(mapping, index, end - 1, &fbatch,
 				indices)) {
-- 
2.53.0



