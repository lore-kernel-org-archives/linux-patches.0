Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8444233F8CA;
	Tue,  6 Jan 2026 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719690; cv=none; b=KmjtS05ENAbKVzY2KnE0JYJLc7ZI7lstaTg1FmNzf+fB/kuFa9JDkwW4d2xyBQt3tBKWM/C5wlUcLZdeqCYFHnPrFUoL/e/6M+BVHKQOZn6pDRDtw0nkM3sy3YFycLyx0MROOCBAOt3Ro4KX5v7eGKclNuMYqHFm+l81AOQ3yXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719690; c=relaxed/simple;
	bh=nTJLAlR6ZVst8dCKZqs2sXdxnws8K59nhHL347Dk6EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7M8Wk9RuL1qCkgWXdJj+ysMIpmI0aN9g8vAI03TAXlizvcBDJL20ct4PKdB3nBbR8UScBphOiwEbew7VGGea9EId1TxOUiH/KlPWK1UZv6np0bZUfmPWFP1a+vp9cm/uJGq+ryACaBIKgwaqpsKpTBNJrl6R6BgsYWgCiOh/9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoKIH8ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoKIH8ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A42C116C6;
	Tue,  6 Jan 2026 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719690;
	bh=nTJLAlR6ZVst8dCKZqs2sXdxnws8K59nhHL347Dk6EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoKIH8geT7JhbcPAQU4PDr7IcRy3fU1edIAm0yXoC7BGx7LNOH8nAlDC3AFpow/Mm
	 myFySUn1Wy1AFaQ6YGduA1ABm6y2QMWakP4hGvk5+5UK8pVCGPmPkTxXhMMKhQpmMr
	 8bFKzoWsunm2yCEA67NrJSMwmd8vM8RGpaSA5NY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Adam Li <adamli@os.amperecomputing.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chris Mason <clm@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/567] sched/fair: Revert max_newidle_lb_cost bump
Date: Tue,  6 Jan 2026 17:56:33 +0100
Message-ID: <20260106170451.760440023@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d206fbad9328ddb68ebabd7cf7413392acd38081 ]

Many people reported regressions on their database workloads due to:

  155213a2aed4 ("sched/fair: Bump sd->max_newidle_lb_cost when newidle balance fails")

For instance Adam Li reported a 6% regression on SpecJBB.

Conversely this will regress schbench again; on my machine from 2.22
Mrps/s down to 2.04 Mrps/s.

Reported-by: Joseph Salisbury <joseph.salisbury@oracle.com>
Reported-by: Adam Li <adamli@os.amperecomputing.com>
Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://lkml.kernel.org/r/20250626144017.1510594-2-clm@fb.com
Link: https://lkml.kernel.org/r/006c9df2-b691-47f1-82e6-e233c3f91faf@oracle.com
Link: https://patch.msgid.link/20251107161739.406147760@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 62b8c7e914ebc..3ceb7f69f8f7b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12238,14 +12238,8 @@ static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
 		/*
 		 * Track max cost of a domain to make sure to not delay the
 		 * next wakeup on the CPU.
-		 *
-		 * sched_balance_newidle() bumps the cost whenever newidle
-		 * balance fails, and we don't want things to grow out of
-		 * control.  Use the sysctl_sched_migration_cost as the upper
-		 * limit, plus a litle extra to avoid off by ones.
 		 */
-		sd->max_newidle_lb_cost =
-			min(cost, sysctl_sched_migration_cost + 200);
+		sd->max_newidle_lb_cost = cost;
 		sd->last_decay_max_lb_cost = jiffies;
 	} else if (time_after(jiffies, sd->last_decay_max_lb_cost + HZ)) {
 		/*
@@ -12950,17 +12944,10 @@ static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 
 			t1 = sched_clock_cpu(this_cpu);
 			domain_cost = t1 - t0;
+			update_newidle_cost(sd, domain_cost);
+
 			curr_cost += domain_cost;
 			t0 = t1;
-
-			/*
-			 * Failing newidle means it is not effective;
-			 * bump the cost so we end up doing less of it.
-			 */
-			if (!pulled_task)
-				domain_cost = (3 * sd->max_newidle_lb_cost) / 2;
-
-			update_newidle_cost(sd, domain_cost);
 		}
 
 		/*
-- 
2.51.0



