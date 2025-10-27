Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F56330324;
	Mon, 27 Oct 2025 18:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590811; cv=none; b=R1dZmQ5cBETLowVmbXLQGGfrycBBVtwCzBbND8CrDFsqwenp9CpinYUckPb/8ufVkx8/wgjYWj8aNHodnb0Jj22SszjbsZKFrLc3i5nN2SJ0neWKvCLp6LeD5vqui6PJvs3QR+NjBFRFd0bTvJXIvemIAgqYGhX8DLZM73kuHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590811; c=relaxed/simple;
	bh=tAdgH8Vtcf/xsGYfQ6/zGduMAWCoAYKJ9cFZgHzmEVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQOU8OPJAVNEQ3S1yBnAMP2hb6bmposxWEkbfGBhfK9ucpxPUbAq+/5wKsLYBFVOmlHpoDJv42tX8MsQaZdWi+HcyYftq2wj//uolE/TUg4iNcKNuzHftNIWq9BwUh9iDepIPdwk29BAKGhrrvquA7b4kNnbPDTfcPzMKZPv/qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f78lZS75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f78lZS75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4D1C4CEFD;
	Mon, 27 Oct 2025 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590810;
	bh=tAdgH8Vtcf/xsGYfQ6/zGduMAWCoAYKJ9cFZgHzmEVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f78lZS75jdhI7qbbMCoX+l02MfoknOdQsAvrDlJrDlg+yuxdB+L8d7ryiGBPV/MkI
	 DFg0i3fShUgExuYkR65/URnlnkdFXlPuhZbMV2Hilpe+LQuvcTfQZm2iW71SjNz17N
	 c5jhtdPSzNHL2/YQ59qJF8MmaG5L8JybtThTQPiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kbuild test robot <lkp@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/224] sched: Make newidle_balance() static again
Date: Mon, 27 Oct 2025 19:35:12 +0100
Message-ID: <20251027183513.357882035@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit d91cecc156620ec75d94c55369509c807c3d07e6 ]

After Commit 6e2df0581f56 ("sched: Fix pick_next_task() vs 'change'
pattern race"), there is no need to expose newidle_balance() as it
is only used within fair.c file. Change this function back to static again.

No functional change.

Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/83cd3030b031ca5d646cd5e225be10e7a0fdd8f5.1587464698.git.yu.c.chen@intel.com
Stable-dep-of: 17e3e88ed0b6 ("sched/fair: Fix pelt lost idle time detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c  | 6 ++++--
 kernel/sched/sched.h | 4 ----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2680216234ff2..db4a1da522e42 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3690,6 +3690,8 @@ static inline unsigned long cfs_rq_load_avg(struct cfs_rq *cfs_rq)
 	return cfs_rq->avg.load_avg;
 }
 
+static int newidle_balance(struct rq *this_rq, struct rq_flags *rf);
+
 static inline unsigned long task_util(struct task_struct *p)
 {
 	return READ_ONCE(p->se.avg.util_avg);
@@ -3849,7 +3851,7 @@ attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags
 static inline void
 detach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) {}
 
-static inline int idle_balance(struct rq *rq, struct rq_flags *rf)
+static inline int newidle_balance(struct rq *rq, struct rq_flags *rf)
 {
 	return 0;
 }
@@ -9898,7 +9900,7 @@ static inline void nohz_newidle_balance(struct rq *this_rq) { }
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
+static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
 {
 	unsigned long next_balance = jiffies + HZ;
 	int this_cpu = this_rq->cpu;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b8a3db59e3267..46e6f4e905dd6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1464,14 +1464,10 @@ static inline void unregister_sched_domain_sysctl(void)
 }
 #endif
 
-extern int newidle_balance(struct rq *this_rq, struct rq_flags *rf);
-
 #else
 
 static inline void sched_ttwu_pending(void) { }
 
-static inline int newidle_balance(struct rq *this_rq, struct rq_flags *rf) { return 0; }
-
 #endif /* CONFIG_SMP */
 
 #include "stats.h"
-- 
2.51.0



