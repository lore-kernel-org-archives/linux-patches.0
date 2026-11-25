Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623891;
	b=URN0+RQ1GZ9RNbU9URTSCtCumz80YpbS5coYrvUnvEtZVS4shLcdzX7jREXSmmJCRmvm
	 SiLi92+9EDCE4O+90XG5qxNnJLeG35lGXhyYq4Bk+1fZlyz54IxN8YYsG6WvLFYZdKkLJ
	 9e8mwMplEWSeOtT2jdQo5YZ8rLRVnBTrvYMBv86O9HRLVT+UgBtpBK2C2ScEkGeM3h0lI
	 kKvNQGSDCQ97+QrVdQhWIa6Bl/HI2mVTLw1To9HRQAcYR7zEahtf2E4RpYINOUi2iXTsI
	 PRtQXsksNobg0uRMC/vr5IE4F+bhLF2Z/HnWlrSMYVhlTrLH1V4cNNr65GsElAR5e/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ma4mzjWhpShyDpQPNe0brUgZT5jpL3fvyQdIJKmPY9c=;
	b=D7J71Zy06cR0bkSFA3/8afqPVza8EszJH0DZ7RHtN43O4ZckSfOLKHSTptlhX3tajaKi
	 eLHjTPw1DiU/E9Y7/8AxtMFJY+pIxdxr7YSW7MpYLUMULihwQssiCj1mobi0fIMa6Xfet
	 w2ueUTGiR6Y/6RmQQfM7xJXeAiKVr0fsogDGFqFPnZnD9Jia8CpJdUMje+AvQb8sqTgZc
	 UGG7XrwKAKaSlRVne+p+Aek5FBAyX0ISnWvZ5lNVfPPYZPI8q11LO2vsKI8sFVro0Hyxb
	 yC7FUoSCbNLskV8OOwGAhnK3cq1cVdFqiprdzkBd8GoKr1UHFmWVU/2N0PoKJ5WbpcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIxGMZLf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1360606A323;
	Wed, 25 Nov 2026 16:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIxGMZLf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176A21F000CF;
	Wed, 25 Nov 2026 16:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623890;
	bh=ma4mzjWhpShyDpQPNe0brUgZT5jpL3fvyQdIJKmPY9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIxGMZLfKna3QquO0SBtIfOLZxpTlpC9nVo6bjmz3mv4syNofWAsCnpVujCNDV2qP
	 7gc7xyzgJQ6MvBGb4/Z+AxPHXMeNYaf88F+Up98mKPsIHOJa0/kukBQZ437b9w9gyN
	 9kDGocVNcKG7Xdh5Tb2mEV2ntOIWrDlmx5UoYcJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Florent Carli <fcarli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/816] sched: Provide idle_rq() helper
Date: Wed, 25 Nov 2026 15:26:06 +0100
Message-ID: <20261125143849.638065032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 1e0a2ba7afb1b60f02599093d84b72ce62ad11c0 upstream.

A fix for the dl_server 'requires' idle_cpu() usage, which made me
note that it and available_idle_cpu() are extern function calls.

And while idle_cpu() is used outside of kernel/sched/,
available_idle_cpu() is not.

This makes it hard to make idle_cpu() an inline helper, so provide
idle_rq() and implement idle_cpu() and available_idle_cpu() using
that.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
[ Florent: rq->ttwu_pending only exists with CONFIG_SMP in 6.12 ]
Signed-off-by: Florent Carli <fcarli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h   |  1 -
 kernel/sched/sched.h    | 28 ++++++++++++++++++++++++++++
 kernel/sched/syscalls.c | 32 +-------------------------------
 3 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7f0fb62df348e..efee6139c6af6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1895,7 +1895,6 @@ static inline int task_nice(const struct task_struct *p)
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
-extern int available_idle_cpu(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int, const struct sched_param *);
 extern void sched_set_fifo(struct task_struct *p);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 598dd26fe5a69..27de9290235e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1390,6 +1390,34 @@ static inline u32 sched_rng(void)
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
 
+static inline bool idle_rq(struct rq *rq)
+{
+	if (rq->curr != rq->idle || rq->nr_running)
+		return false;
+#ifdef CONFIG_SMP
+	if (rq->ttwu_pending)
+		return false;
+#endif
+	return true;
+}
+
+/**
+ * available_idle_cpu - is a given CPU idle for enqueuing work.
+ * @cpu: the CPU in question.
+ *
+ * Return: 1 if the CPU is currently idle. 0 otherwise.
+ */
+static inline bool available_idle_cpu(int cpu)
+{
+	if (!idle_rq(cpu_rq(cpu)))
+		return 0;
+
+	if (vcpu_is_preempted(cpu))
+		return 0;
+
+	return 1;
+}
+
 #ifdef CONFIG_SCHED_CORE
 static inline struct cpumask *sched_group_span(struct sched_group *sg);
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b51b39a109e01..f31fcdcfe6734 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -201,37 +201,7 @@ int task_prio(const struct task_struct *p)
  */
 int idle_cpu(int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
-
-	if (rq->curr != rq->idle)
-		return 0;
-
-	if (rq->nr_running)
-		return 0;
-
-#ifdef CONFIG_SMP
-	if (rq->ttwu_pending)
-		return 0;
-#endif
-
-	return 1;
-}
-
-/**
- * available_idle_cpu - is a given CPU idle for enqueuing work.
- * @cpu: the CPU in question.
- *
- * Return: 1 if the CPU is currently idle. 0 otherwise.
- */
-int available_idle_cpu(int cpu)
-{
-	if (!idle_cpu(cpu))
-		return 0;
-
-	if (vcpu_is_preempted(cpu))
-		return 0;
-
-	return 1;
+	return idle_rq(cpu_rq(cpu));
 }
 
 /**
-- 
2.53.0



