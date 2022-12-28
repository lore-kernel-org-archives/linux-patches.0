Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9E81863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAAFC433D2;
	Wed, 28 Dec 2022 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238950;
	bh=KW4nSEj+6YHvbq7HG7eXvlWAw63935c1hTZCBUj10rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVcz8m2mn8fWFiDjcmrxKM/fG3wBstI5WnlGx9z2iFn9eIcXNIZ4K5cH1/OLGsBwT
	 IKlEftjsHTT6M23ACECekqyfLfcZ8OYLVnZ2Yln/VB0Lk2dDLjAjE8mP2Ymid9qygo
	 v9fmjJg2UfLLQvPerB9HiHGeFSUNblNytvHrWS3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mel Gorman <mgorman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/731] sched/fair: Removed useless update of p->recent_used_cpu
Date: Wed, 28 Dec 2022 15:32:58 +0100
Message-Id: <20221228144258.609114431@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit a7ba894821b6ade7bb420455f87020b2838d6180 ]

Since commit 89aafd67f28c ("sched/fair: Use prev instead of new target as recent_used_cpu"),
p->recent_used_cpu is unconditionnaly set with prev.

Fixes: 89aafd67f28c ("sched/fair: Use prev instead of new target as recent_used_cpu")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Link: https://lkml.kernel.org/r/20210928103544.27489-1-vincent.guittot@linaro.org
Stable-dep-of: a2e7f03ed28f ("sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9e2c6e38342c..d706c1a8453a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6595,11 +6595,6 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	    (available_idle_cpu(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
 	    cpumask_test_cpu(p->recent_used_cpu, p->cpus_ptr) &&
 	    asym_fits_capacity(task_util, recent_used_cpu)) {
-		/*
-		 * Replace recent_used_cpu with prev as it is a potential
-		 * candidate for the next wake:
-		 */
-		p->recent_used_cpu = prev;
 		return recent_used_cpu;
 	}
 
-- 
2.35.1



