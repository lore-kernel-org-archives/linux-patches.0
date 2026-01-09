Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D95A15ADB4;
	Fri,  9 Jan 2026 12:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961403; cv=none; b=eY3/OaJDDFmhnT7kXElpCIUxh4D3K2DZRHekBf+chS5XnCh/1l5QR8C17nkpDuBJcosC8+APOsROJaaJ7A0WqRMgfhMckUs+3FVoANA8sErf0ey7EHkWCvlzqNRsP5ceyt8TrRu0eu2UQrbVc+B8x38YLbxNNwFPf2Y9Ael+ryc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961403; c=relaxed/simple;
	bh=9sdQHAYfSiBbRsaKSk/5OmtPI43dKX/1MA3gb71nrU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxVN8/J6B2cwPRE4/U09axDErFgS2jLABGvR160BxRjMD001MQzFjTTXb5jZgIXCeJMQeXYjvGhwV6y+ED4NbEhv03LthKoXy9ZLpN7I8XNdX4w4OmaPjdXnhlNK5NF7wJj3aj+Uczx14eJfK577rIfk+yMdPjRReKIt3waxtsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUNdu8f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUNdu8f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1386CC4CEF1;
	Fri,  9 Jan 2026 12:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961403;
	bh=9sdQHAYfSiBbRsaKSk/5OmtPI43dKX/1MA3gb71nrU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUNdu8f9Drafc6gPC0Sh85/GMMPrLWgAgvyYkMN9KF5C3bhvvDWjIj4CBCv0tSK3I
	 qklusRqVMO3/DFDd3doOhzelckcU9IHy6V+agA7wNm8zLRXTcE+nHO6yHB5Lky3AxN
	 ak11z2YllcY+jSF+/5EiY0WFB+D8D0fLT/fUCQik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, yin.ding@broadcom.com, tapas.kundu@broadcom.com, Chris Mason" <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 6.6 710/737] sched/fair: Small cleanup to update_newidle_cost()
Date: Fri,  9 Jan 2026 12:44:09 +0100
Message-ID: <20260109112200.781343241@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 08d473dd8718e4a4d698b1113a14a40ad64a909b upstream.

Simplify code by adding a few variables.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.655208666@infradead.org
[ Ajay: Modified to apply on v6.6 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11718,22 +11718,25 @@ void update_max_interval(void)
 
 static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
 {
+	unsigned long next_decay = sd->last_decay_max_lb_cost + HZ;
+	unsigned long now = jiffies;
+
 	if (cost > sd->max_newidle_lb_cost) {
 		/*
 		 * Track max cost of a domain to make sure to not delay the
 		 * next wakeup on the CPU.
 		 */
 		sd->max_newidle_lb_cost = cost;
-		sd->last_decay_max_lb_cost = jiffies;
-	} else if (time_after(jiffies, sd->last_decay_max_lb_cost + HZ)) {
+		sd->last_decay_max_lb_cost = now;
+
+	} else if (time_after(now, next_decay)) {
 		/*
 		 * Decay the newidle max times by ~1% per second to ensure that
 		 * it is not outdated and the current max cost is actually
 		 * shorter.
 		 */
 		sd->max_newidle_lb_cost = (sd->max_newidle_lb_cost * 253) / 256;
-		sd->last_decay_max_lb_cost = jiffies;
-
+		sd->last_decay_max_lb_cost = now;
 		return true;
 	}
 


