Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEA235BDB6;
	Fri,  9 Jan 2026 12:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963153; cv=none; b=DT5vMttPS30QQyEZu0PR4YGKov2TpXe0HYHSAhivubJu25Z4bYjShdgt9ONsaOHCyQ8Mj6AXrojEzFaJ3S9cXHtFiY++wnCCRfbTkyAKkQSNxtro1Bo5Pn2iflsNRBX8VococDbvs+8I/OTzWVF+j9LEF9wO6aR5yA0qgZh9Fcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963153; c=relaxed/simple;
	bh=CiPbIIAyf0/NIpEzGbGU1Scp6qcBPJ8KcsOtx93BnuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpuKooSyJwJmuOfZBEgNKy1r/HhXaHsJ+MZSvK1Yhz27P42WCZMp+7XoyX6262DcOYcWUPlw9++XKu0urKfp2Ix2+mjTPRPFuJOTzdjQslYQQp9fa8vzG1Ua0aZMsQdOqlGFdu78Cl+QHr7aWvmiVQIHWgwIVQTmJzAmQOKM8aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6NvnJhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6NvnJhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8EFC4CEF1;
	Fri,  9 Jan 2026 12:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963152;
	bh=CiPbIIAyf0/NIpEzGbGU1Scp6qcBPJ8KcsOtx93BnuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6NvnJhdhuKe1l2cbLrrgCwlxWOKHN0bBCovNiDhwqN1mUqc48BNbB8BRL2BXsThg
	 iWxrCJLIocZHZO1dRPH0tF1eshmBFujc97WHAVCK+mHxZR3Uj/ta4S/EGVLL9P3Yso
	 2t5CkcSrcFP+DuHxhFBfwVgzvbYAcZlRZdSPBfwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, yin.ding@broadcom.com, tapas.kundu@broadcom.com, Chris Mason" <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 6.1 615/634] sched/fair: Small cleanup to sched_balance_newidle()
Date: Fri,  9 Jan 2026 12:44:53 +0100
Message-ID: <20260109112140.778372254@linuxfoundation.org>
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

commit e78e70dbf603c1425f15f32b455ca148c932f6c1 upstream.

Pull out the !sd check to simplify code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.525916173@infradead.org
[ Ajay: Modified to apply on v6.1 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11589,14 +11589,15 @@ static int sched_balance_newidle(struct
 
 	rcu_read_lock();
 	sd = rcu_dereference_check_sched_domain(this_rq->sd);
+	if (!sd) {
+		rcu_read_unlock();
+		goto out;
+	}
 
 	if (!READ_ONCE(this_rq->rd->overload) ||
-	    (sd && this_rq->avg_idle < sd->max_newidle_lb_cost)) {
-
-		if (sd)
-			update_next_balance(sd, &next_balance);
+	    this_rq->avg_idle < sd->max_newidle_lb_cost) {
+		update_next_balance(sd, &next_balance);
 		rcu_read_unlock();
-
 		goto out;
 	}
 	rcu_read_unlock();


