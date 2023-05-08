Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A007C171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F65C433A4;
	Mon,  8 May 2023 11:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546211;
	bh=BF0II4A0ry5/qNylK3e3ADVEGuTPlHMXERqjd/pfHBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9aiHZXNtjrI1GiMgQA+kg3ujQd0ZzLtUhRFXOWkTGx8gEI7Vy6XsS8kYn3nCeJX/
	 k8feGbdgCfoBzqMdOeeqFeQNjMXUPiceMuiIahBvvKuSXbo5tbCZi17e5rgtOgn7iG
	 TtkOm9VFlIs7/4vBZKUyT9vTMfH2HRYqtX829k6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mel Gorman <mgorman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/371] sched/fair: Use __schedstat_set() in set_next_entity()
Date: Mon,  8 May 2023 11:48:07 +0200
Message-Id: <20230508094823.366478047@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit a2dcb276ff9287fcea103ca1a2436383e8583751 ]

schedstat_enabled() has been already checked, so we can use
__schedstat_set() directly.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Link: https://lore.kernel.org/r/20210905143547.4668-2-laoar.shao@gmail.com
Stable-dep-of: 39afe5d6fc59 ("sched/fair: Fix inaccurate tally of ttwu_move_affine")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 591fdc81378e0..70f7a3896a90c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4691,9 +4691,9 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	 */
 	if (schedstat_enabled() &&
 	    rq_of(cfs_rq)->cfs.load.weight >= 2*se->load.weight) {
-		schedstat_set(se->statistics.slice_max,
-			max((u64)schedstat_val(se->statistics.slice_max),
-			    se->sum_exec_runtime - se->prev_sum_exec_runtime));
+		__schedstat_set(se->statistics.slice_max,
+				max((u64)se->statistics.slice_max,
+				    se->sum_exec_runtime - se->prev_sum_exec_runtime));
 	}
 
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
-- 
2.39.2



