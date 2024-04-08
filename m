Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2637BB11;
	Mon,  8 Apr 2024 13:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581303; cv=none; b=kvkqcU9gxEQVw5RN4WJ+FYbNU8L8v6iUECj0xhojMY5iD3eSrEUNjh/5m9w5z+LyTSlGDS2iDKkNUunqrjSHbEUc41QCCN4ua5yKptCC1nmSbaKstVl1ELojI7LBHENZn09kfj9ku3Anb7zXM1CHvFBGsI5UnK93jN4Z64JijqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581303; c=relaxed/simple;
	bh=qzTSAhYxHiDmq5aaB3w3UQRSHGi9YWNvQT5ERc7DJWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa5waGMVo3O/MrSZ5zypO95y1496uh1grklDHOWZ+M6V+yQE+WleTTyIr7tkiXX1uQXD0nNB+zrji20vsSK1stnAqTC7f9HZJrF1cmpQzFIhUZoCUNRD9/4IviQKu8QZwz15e0uF1+S0/aoI/k+XUrCk77UAyb69V/5iXgzZayY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOOnxDP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOOnxDP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C7DC433F1;
	Mon,  8 Apr 2024 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581302;
	bh=qzTSAhYxHiDmq5aaB3w3UQRSHGi9YWNvQT5ERc7DJWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOOnxDP7K94BRngSFfYEQ9K1uwyXSZZgBQwGbBXYoMOwg/LCqw24lrerBcmyho8Cb
	 IkCKTmc3S5f2r9TRZ2zP+QxaFaEjvwjSYbxTl/2MUmNcqts9dK/rBaMTWnbws7r3tf
	 PfYRlP7xO40uy0jRPWxOc7HHweV72r55PZRyYTLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/690] timers: Rename del_timer_sync() to timer_delete_sync()
Date: Mon,  8 Apr 2024 14:47:55 +0200
Message-ID: <20240408125359.884268099@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 9b13df3fb64ee95e2397585404e442afee2c7d4f ]

The timer related functions do not have a strict timer_ prefixed namespace
which is really annoying.

Rename del_timer_sync() to timer_delete_sync() and provide del_timer_sync()
as a wrapper. Document that del_timer_sync() is not for new code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/r/20221123201624.954785441@linutronix.de
Stable-dep-of: 0f7352557a35 ("wifi: brcmfmac: Fix use-after-free bug in brcmf_cfg80211_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/timer.h | 15 ++++++++++++++-
 kernel/time/timer.c   | 18 +++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 2e6f50b342662..e78521bce565a 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -183,7 +183,20 @@ extern int timer_reduce(struct timer_list *timer, unsigned long expires);
 extern void add_timer(struct timer_list *timer);
 
 extern int try_to_del_timer_sync(struct timer_list *timer);
-extern int del_timer_sync(struct timer_list *timer);
+extern int timer_delete_sync(struct timer_list *timer);
+
+/**
+ * del_timer_sync - Delete a pending timer and wait for a running callback
+ * @timer:	The timer to be deleted
+ *
+ * See timer_delete_sync() for detailed explanation.
+ *
+ * Do not use in new code. Use timer_delete_sync() instead.
+ */
+static inline int del_timer_sync(struct timer_list *timer)
+{
+	return timer_delete_sync(timer);
+}
 
 #define del_singleshot_timer_sync(t) del_timer_sync(t)
 
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 2c0e26718c7a9..d4ce3ebe2c8cf 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1030,7 +1030,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires, unsigned int option
 		/*
 		 * We are trying to schedule the timer on the new base.
 		 * However we can't change timer's base while it is running,
-		 * otherwise del_timer_sync() can't detect that the timer's
+		 * otherwise timer_delete_sync() can't detect that the timer's
 		 * handler yet has not finished. This also guarantees that the
 		 * timer is serialized wrt itself.
 		 */
@@ -1206,7 +1206,7 @@ EXPORT_SYMBOL_GPL(add_timer_on);
  * @timer:	The timer to be deactivated
  *
  * The function only deactivates a pending timer, but contrary to
- * del_timer_sync() it does not take into account whether the timer's
+ * timer_delete_sync() it does not take into account whether the timer's
  * callback function is concurrently executed on a different CPU or not.
  * It neither prevents rearming of the timer. If @timer can be rearmed
  * concurrently then the return value of this function is meaningless.
@@ -1342,7 +1342,7 @@ static inline void del_timer_wait_running(struct timer_list *timer) { }
 #endif
 
 /**
- * del_timer_sync - Deactivate a timer and wait for the handler to finish.
+ * timer_delete_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
@@ -1364,10 +1364,10 @@ static inline void del_timer_wait_running(struct timer_list *timer) { }
  *    spin_lock_irq(somelock);
  *                                     <IRQ>
  *                                        spin_lock(somelock);
- *    del_timer_sync(mytimer);
+ *    timer_delete_sync(mytimer);
  *    while (base->running_timer == mytimer);
  *
- * Now del_timer_sync() will never return and never release somelock.
+ * Now timer_delete_sync() will never return and never release somelock.
  * The interrupt on the other CPU is waiting to grab somelock but it has
  * interrupted the softirq that CPU0 is waiting to finish.
  *
@@ -1380,7 +1380,7 @@ static inline void del_timer_wait_running(struct timer_list *timer) { }
  * * %0	- The timer was not pending
  * * %1	- The timer was pending and deactivated
  */
-int del_timer_sync(struct timer_list *timer)
+int timer_delete_sync(struct timer_list *timer)
 {
 	int ret;
 
@@ -1420,7 +1420,7 @@ int del_timer_sync(struct timer_list *timer)
 
 	return ret;
 }
-EXPORT_SYMBOL(del_timer_sync);
+EXPORT_SYMBOL(timer_delete_sync);
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
@@ -1442,8 +1442,8 @@ static void call_timer_fn(struct timer_list *timer,
 #endif
 	/*
 	 * Couple the lock chain with the lock chain at
-	 * del_timer_sync() by acquiring the lock_map around the fn()
-	 * call here and in del_timer_sync().
+	 * timer_delete_sync() by acquiring the lock_map around the fn()
+	 * call here and in timer_delete_sync().
 	 */
 	lock_map_acquire(&lockdep_map);
 
-- 
2.43.0



