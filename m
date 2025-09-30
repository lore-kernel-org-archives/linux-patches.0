Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6B92F5301;
	Tue, 30 Sep 2025 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245170; cv=none; b=j4yueK0q1d1hNN0s/am/tMbgUv5TjHUqqOFgVOp3fwi+uwFUhwI53Q6VdYLZKNSiWIzs9fmvrSF5oB3m5QVtwFjuJzxMl7/kFoMsrDzYaEToondiwP+q8/nuoq8VQIbqNx/n8UHo/wJcyLeBuud6kx05PFoyRRsFNuBKYs9sJjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245170; c=relaxed/simple;
	bh=UyIYAgSCNyB4gwnA4MkhFyXskrjJpffaJTV/gR6oe8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV1edFa9wwZCQ7W/23RBLIJfbXdd7EkzXGMuv0O2Ev5oQBkeO+o8n95Zv9fa+N4xBtUOFDHXF0mT8+4oQDQ3creheXZmZilzpehDxDF4uibMtj336vfKuvOyW3BcdoGZkIioX4E4h6xgUK74gjQz3LUZ56XJkOagwqgMtZS78og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uv7dwRoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uv7dwRoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EDBC113D0;
	Tue, 30 Sep 2025 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245170;
	bh=UyIYAgSCNyB4gwnA4MkhFyXskrjJpffaJTV/gR6oe8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uv7dwRoIECHzCggWUHvKnx3zvHyH2pXRgFJmmccPCJlj8Os3n7y9ZGKCNyZ2dthBz
	 v1lYA0tYZCXKxDB3yX7882PBxsUyJ4pJSMzktcTJlFCyC1HqQgsqrIme2Am5WK4M/k
	 YogXLzFuS463lFf35QA6t+PlCthbZFf9wI7Jx64w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/151] hrtimer: Rename __hrtimer_hres_active() to hrtimer_hres_active()
Date: Tue, 30 Sep 2025 16:46:25 +0200
Message-ID: <20250930143829.796268920@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a8fbf4b1ea197..74a71b3a064dc 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -631,17 +631,12 @@ static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
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
@@ -665,7 +660,7 @@ static void __hrtimer_reprogram(struct hrtimer_cpu_base *cpu_base,
 	 * set. So we'd effectively block all timers until the T2 event
 	 * fires.
 	 */
-	if (!__hrtimer_hres_active(cpu_base) || cpu_base->hang_detected)
+	if (!hrtimer_hres_active(cpu_base) || cpu_base->hang_detected)
 		return;
 
 	tick_program_event(expires_next, 1);
@@ -776,12 +771,12 @@ static void retrigger_next_event(void *arg)
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
@@ -938,7 +933,7 @@ void clock_was_set(unsigned int bases)
 	cpumask_var_t mask;
 	int cpu;
 
-	if (!__hrtimer_hres_active(cpu_base) && !tick_nohz_active)
+	if (!hrtimer_hres_active(cpu_base) && !tick_nohz_active)
 		goto out_timerfd;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
@@ -1489,7 +1484,7 @@ u64 hrtimer_get_next_event(void)
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (!__hrtimer_hres_active(cpu_base))
+	if (!hrtimer_hres_active(cpu_base))
 		expires = __hrtimer_get_next_event(cpu_base, HRTIMER_ACTIVE_ALL);
 
 	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
@@ -1512,7 +1507,7 @@ u64 hrtimer_next_event_without(const struct hrtimer *exclude)
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (__hrtimer_hres_active(cpu_base)) {
+	if (hrtimer_hres_active(cpu_base)) {
 		unsigned int active;
 
 		if (!cpu_base->softirq_activated) {
@@ -1884,7 +1879,7 @@ void hrtimer_run_queues(void)
 	unsigned long flags;
 	ktime_t now;
 
-	if (__hrtimer_hres_active(cpu_base))
+	if (hrtimer_hres_active(cpu_base))
 		return;
 
 	/*
-- 
2.51.0



