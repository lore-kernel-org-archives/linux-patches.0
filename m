Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABFE35971B;
	Fri,  9 Jan 2026 12:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961401; cv=none; b=bSnslXMBhlv+BE7J9vUXrpYUGof4odaQ86c3rFDRzrhFUwqMfcRZV5oogXe3QoNtW+Sqb+EO5clPh/H6gAI5mPg5IGHjsQeEE9TABlLltKpk067DSySa098fuMbcRri42erGbV4kY1H59buanIyqaIfHsG/FsmwmXbr029KhOMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961401; c=relaxed/simple;
	bh=BwyG9s1E8OvDoPbozBNwizyMPdsDDseg4SbJsaNVBR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXgn8qwVXmD8ZYgwgbNdGNaTA+dMK0/rw1nQPqQLyCN5lAk8O+mv7lNU/FP+ZJBe4Axg3n5x5xiVd7zsiYqvqxFJJjyQFoDQG9qaX4qeGlV6HLMyXBW5WDRI79TN03d61/pjxq5QZNODBlV+raUg/ZvRYyOE3yrCesDDs4jiMwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8SaDoAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8SaDoAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489E2C4CEF1;
	Fri,  9 Jan 2026 12:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961400;
	bh=BwyG9s1E8OvDoPbozBNwizyMPdsDDseg4SbJsaNVBR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8SaDoAoe6oHLA9hxwYVA9UjevX+lwWBLj3P7MS7thCnMK5Rdk/WNyJpbXOUVTods
	 HRLwwAq2C71Is3zmS484SYSF2JCg+KRe98NnKZCOHqw5AFxU33QSB+KCShpmtOFN1n
	 eWYi/G/eTI21AqPakFCLC/czeycc3v2H6qpxvxQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, yin.ding@broadcom.com, tapas.kundu@broadcom.com, Chris Mason" <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 6.6 709/737] sched/fair: Small cleanup to sched_balance_newidle()
Date: Fri,  9 Jan 2026 12:44:08 +0100
Message-ID: <20260109112200.743794654@linuxfoundation.org>
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

commit e78e70dbf603c1425f15f32b455ca148c932f6c1 upstream.

Pull out the !sd check to simplify code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.525916173@infradead.org
[ Ajay: Modified to apply on v6.6 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12374,14 +12374,15 @@ static int sched_balance_newidle(struct
 
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


