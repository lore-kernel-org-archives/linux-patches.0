Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC46A35B159;
	Fri,  9 Jan 2026 12:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963156; cv=none; b=hANCa7Q8bEWQ6to5Fz2h0Qxy2yYg78Pw3EamXMQtxwZTXteuhpecncnKjeY81/M89Fo4uDuVSftQY0GUK8KyWFgObKsrmd/CIbSaxLumCDljTKL8awuWYXaZzo2qJ671/9Zo9Ayef01g5d/FF0cSIKOf4+7FSdsLKnbQfQdJOhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963156; c=relaxed/simple;
	bh=uUHj6ZudnI+33j8gaUCfWRh84Q7XiUP7QkhF5WRnFGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THLxw1R352FmppQimqK3nU4XIpq6vbn+JJG3Z7CCBv4fLR3wuxEpufJ0XB92NZCd+yKIkz5GWUHYQLuQGZwf5VzRAiQMLwAxkjvP9krTqT8UAw9saekWKC99mWb5UrgxSBLHN2lyzmJFQBtkA5piMOdnSbmK/ymaKSwTvZVSIfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNplrpG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNplrpG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA38C4CEF1;
	Fri,  9 Jan 2026 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963155;
	bh=uUHj6ZudnI+33j8gaUCfWRh84Q7XiUP7QkhF5WRnFGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNplrpG2wRGUYTfRACehTvQSrz9qUoA63LdMZpN6GadyYhz8kAcpaQG120R5Tb9XL
	 W8HT9pKu7PEAJfiNH9imIoIUbib+guS/jqZ8pVWE9TI7ByeXJ41/4n1yyJVN+px+K/
	 ZszTGlfBJzoIF1dKt8dkSKwUkOqhebOiI+nrLoDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, yin.ding@broadcom.com, tapas.kundu@broadcom.com, Chris Mason" <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 6.1 616/634] sched/fair: Small cleanup to update_newidle_cost()
Date: Fri,  9 Jan 2026 12:44:54 +0100
Message-ID: <20260109112140.815397574@linuxfoundation.org>
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

commit 08d473dd8718e4a4d698b1113a14a40ad64a909b upstream.

Simplify code by adding a few variables.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.655208666@infradead.org
[ Ajay: Modified to apply on v6.1 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10937,22 +10937,25 @@ void update_max_interval(void)
 
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
 


