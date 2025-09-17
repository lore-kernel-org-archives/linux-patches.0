Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955A83161B5;
	Wed, 17 Sep 2025 13:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114179; cv=none; b=e80LCQ3x1Nz+8Az989Dcjs484mYpRvqa1u49urr0pLpWuUYAuLPzbrf38JRyded9PyetEUNRiwnIbf9swIZiAdabQCx+MZYGOzkVsFEvRDOLk+6WJq7PLHkIYpXWeV2Hwl4u1mh8P3QwUXgQQW3VTzC1eaTZB+Xj6RiX2paGyus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114179; c=relaxed/simple;
	bh=fdWKb6y1HKQzSYZFCM94Bi3ydXgtgv/1c8KJRtXuiws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G21e+hF849r0r+jVZkEtWfKB5Hd6QqdI1bWYMcEMCg52wT8rkhU0F4tBTzKRvTHlO/85JWQPVVQokEycc8kXUwqIIO3LmoBMtoH1asvlO+Nwy126e7tHnMud7g03xxm18QxH4lkKk0vX0u5gY8el1/TCx8Y706QKbUI6Rok23Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiF17HfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiF17HfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65BEC4CEF0;
	Wed, 17 Sep 2025 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114179;
	bh=fdWKb6y1HKQzSYZFCM94Bi3ydXgtgv/1c8KJRtXuiws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiF17HfTdGPaBB+D8vcoeyCdA/AXPTmNIxzEwTTI4GQUZ90kbg253gvOqDKtvZtPo
	 gjrEXXTbzndtDX6ckHrWVefAKHbDiLAEMQfT6xLLvR65UYcDWn8AXhCtweQDFgsgsd
	 sEAA8evWDnqkOib7jK6iWwDX3Nc1PMO3X/V3rwCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 68/78] hrtimer: Rename __hrtimer_hres_active() to hrtimer_hres_active()
Date: Wed, 17 Sep 2025 14:35:29 +0200
Message-ID: <20250917123331.237842376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit b7c8e1f8a7b4352c1d0b4310686385e3cf6c104a ]

The function hrtimer_hres_active() are defined in the hrtimer.c file, but
not called elsewhere, so rename __hrtimer_hres_active() to
hrtimer_hres_active() and remove the old hrtimer_hres_active() function.

kernel/time/hrtimer.c:653:19: warning: unused function 'hrtimer_hres_active'.

Fixes: 82ccdf062a64 ("hrtimer: Remove unused function")
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/r/20240418023000.130324-1-jiapeng.chong@linux.alibaba.com
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8778
Stable-dep-of: e895f8e29119 ("hrtimers: Unconditionally update target CPU base after offline timer migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 00eecd81ce3a6..8971014df5b51 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -669,17 +669,12 @@ static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
 /*
  * Is the high resolution mode active ?
  */
-static inline int __hrtimer_hres_active(struct hrtimer_cpu_base *cpu_base)
+static inline int hrtimer_hres_active(struct hrtimer_cpu_base *cpu_base)
 {
 	return IS_ENABLED(CONFIG_HIGH_RES_TIMERS) ?
 		cpu_base->hres_active : 0;
 }
 
-static inline int hrtimer_hres_active(void)
-{
-	return __hrtimer_hres_active(this_cpu_ptr(&hrtimer_bases));
-}
-
 static void __hrtimer_reprogram(struct hrtimer_cpu_base *cpu_base,
 				struct hrtimer *next_timer,
 				ktime_t expires_next)
@@ -703,7 +698,7 @@ static void __hrtimer_reprogram(struct hrtimer_cpu_base *cpu_base,
 	 * set. So we'd effectively block all timers until the T2 event
 	 * fires.
 	 */
-	if (!__hrtimer_hres_active(cpu_base) || cpu_base->hang_detected)
+	if (!hrtimer_hres_active(cpu_base) || cpu_base->hang_detected)
 		return;
 
 	tick_program_event(expires_next, 1);
@@ -812,12 +807,12 @@ static void retrigger_next_event(void *arg)
 	 * function call will take care of the reprogramming in case the
 	 * CPU was in a NOHZ idle sleep.
 	 */
-	if (!__hrtimer_hres_active(base) && !tick_nohz_active)
+	if (!hrtimer_hres_active(base) && !tick_nohz_active)
 		return;
 
 	raw_spin_lock(&base->lock);
 	hrtimer_update_base(base);
-	if (__hrtimer_hres_active(base))
+	if (hrtimer_hres_active(base))
 		hrtimer_force_reprogram(base, 0);
 	else
 		hrtimer_update_next_event(base);
@@ -974,7 +969,7 @@ void clock_was_set(unsigned int bases)
 	cpumask_var_t mask;
 	int cpu;
 
-	if (!__hrtimer_hres_active(cpu_base) && !tick_nohz_active)
+	if (!hrtimer_hres_active(cpu_base) && !tick_nohz_active)
 		goto out_timerfd;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
@@ -1551,7 +1546,7 @@ u64 hrtimer_get_next_event(void)
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (!__hrtimer_hres_active(cpu_base))
+	if (!hrtimer_hres_active(cpu_base))
 		expires = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_ALL);
 
 	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
@@ -1574,7 +1569,7 @@ u64 hrtimer_next_event_without(const struct hrtimer *exclude)
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (__hrtimer_hres_active(cpu_base)) {
+	if (hrtimer_hres_active(cpu_base)) {
 		unsigned int active;
 
 		if (!cpu_base->softirq_activated) {
@@ -1946,7 +1941,7 @@ void hrtimer_run_queues(void)
 	unsigned long flags;
 	ktime_t now;
 
-	if (__hrtimer_hres_active(cpu_base))
+	if (hrtimer_hres_active(cpu_base))
 		return;
 
 	/*
-- 
2.51.0



