Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425851E8836;
	Fri,  9 Jan 2026 12:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962055; cv=none; b=FXxKNs/a15y3Fg+4wPcZXpnY690QAX1fl9xUdYeK9PhavVH6H8h0s2GrUajkTLDBv1nE9U/DWPktiAUqvZMzzhkNoiZmy28RHiDvyZLd+qiOu6fZWDMtiJsqrLwNGSEGx+1jFe1khWnL9n94+xcshjwFAf/xTcpPuu2aFI45xkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962055; c=relaxed/simple;
	bh=LW1nX3JxkVLZTlU/OxNVNiEVEYtWynqnZwibRO6PAss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjPI9TJ7uExO520Ffajn6eRNyZ9Q6vL89Ml0lbbSkc1ENh2b0oo5lvL+yVXZ78PpGHqJ1cNOc0n3PqqZ2KboCgYnLeZFrqNA3ii5dBq3yYgV1TfBdHtF/m/Zr04fzVC1B4D6RurlNmQyAqkfJb2u8cgo1UCB5gCBviGjSFWdRF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSQviE1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSQviE1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92128C4CEF1;
	Fri,  9 Jan 2026 12:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962054;
	bh=LW1nX3JxkVLZTlU/OxNVNiEVEYtWynqnZwibRO6PAss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSQviE1Hq7U8PAmF31vlVNv0gqg8DtSEcBE0pOdA3Ua0uQJxEM1tLu2XXgBx7oq3L
	 l/QkY2sCdS1GkWOWmvftoycYw9i9YjzQol72fpEF2tYuMG4nscPq8E4pIAYto+UFEl
	 yIEHPwdmodlmucmJNEqGv3NIHnDU8cHb9r02hwkY=
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
Subject: [PATCH 6.1 230/634] sched/fair: Revert max_newidle_lb_cost bump
Date: Fri,  9 Jan 2026 12:38:28 +0100
Message-ID: <20260109112126.084033555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b6795bf15211c..f5a041bc3364f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10941,14 +10941,8 @@ static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
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
@@ -11630,17 +11624,10 @@ static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 
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



