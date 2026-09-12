Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A223BD03;
	Sat, 12 Sep 2026 12:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215212; cv=none; b=gxV3AJUoe8IXze7C84ehB4kZ1dzfCRa7hqlN9/kf2t8YIDaWpGYD6XlgPsp3DeMRovsnXjvjqf+TNFynrhiaLnXX0GcXyfDYBf5B2bz5QNLbKFnCDKtUIM7Q6wYBQN1kDvL1SbzKyqrEZb0h1/9MHq21CoseROjxoz5cMjeIErg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215212; c=relaxed/simple;
	bh=8hbHK/rwvpWX3bEdNcWVjP3R+Uhc+XWFcGCfW7a0pa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OA5zReqxvcVwEIlx/mO1biSrAKHzCQrpAJ6p89MRUGJ+Fj7+kdXG3m2Ws7bTzPRDzZ5mznYn3tnaQ2IrUej5fitJhyGY8ri62z2X5JObmH52u9JfUgQKBBcgX+0yDxeZhO4vZthTwRBAUHU4zqTummp32Nq2KN4c774Jy/OCKDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlFiwxmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlFiwxmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4941F000FF;
	Sat, 12 Sep 2026 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215211;
	bh=haKNU1uvGecTES1pdrLT4tr9WCfydh6Qvon6Lmut5v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlFiwxmLlVHX8S+me/uGo95YXCZ4DCXFpBDM6tNkaqo3MY7BY3sI4Su2J4BU6iHjK
	 m1LtaT3cXikuYTMoj7bWhDDR6DIyIcw/uqgf6VAFmluz1JrGQ4B2WOlk1HAefaNQTI
	 /GMjBI0KK7prtTj9965RSzrR4gVEUXnqfokEDfvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Baoquan He <bhe@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Young <dyoung@redhat.com>,
	Doug Anderson <dianders@chromium.org>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Molnar <mingo@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	Joel Granados <joel.granados@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Kees Cook <kees@kernel.org>,
	Li Huafei <lihuafei1@huawei.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Nam Cao <namcao@linutronix.de>,
	oushixiong <oushixiong@kylinos.cn>,
	Petr Mladek <pmladek@suse.com>,
	Qianqiang Liu <qianqiang.liu@163.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Thomas Zimemrmann <tzimmermann@suse.de>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0468/1376] panic/printk: replace other_cpu_in_panic() with panic_on_other_cpu()
Date: Sat, 12 Sep 2026 08:48:14 +0200
Message-ID: <20260912065617.961968449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Jinchao Wang <wangjinchao600@gmail.com>

[ Upstream commit d4a36db5639db032a434aef968f9188a600139ec ]

The helper other_cpu_in_panic() duplicated logic already provided by
panic_on_other_cpu().

Remove other_cpu_in_panic() and update all users to call
panic_on_other_cpu() instead.

This removes redundant code and makes panic handling consistent.

Link: https://lkml.kernel.org/r/20250825022947.1596226-9-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Luo Gengkun <luogengkun@huaweicloud.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: oushixiong <oushixiong@kylinos.cn>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Qianqiang Liu <qianqiang.liu@163.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 36630cafbeed ("printk: Fix possible console use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/internal.h |  1 -
 kernel/printk/nbcon.c    |  8 ++++----
 kernel/printk/printk.c   | 19 ++++---------------
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index 2cc13c5597688..53c4b3438a1c6 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -328,7 +328,6 @@ struct printk_message {
 	unsigned long		dropped;
 };
 
-bool other_cpu_in_panic(void);
 bool printk_get_next_message(struct printk_message *pmsg, u64 seq,
 			     bool is_extended, bool may_supress);
 
diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index 68563ed55e203..7b4dcb09ce998 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -254,7 +254,7 @@ static int nbcon_context_try_acquire_direct(struct nbcon_context *ctxt,
 		 * opportunity to perform any necessary cleanup if they were
 		 * interrupted by the panic CPU while printing.
 		 */
-		if (other_cpu_in_panic() &&
+		if (panic_on_other_cpu() &&
 		    (!is_reacquire || cur->unsafe_takeover)) {
 			return -EPERM;
 		}
@@ -309,7 +309,7 @@ static bool nbcon_waiter_matches(struct nbcon_state *cur, int expected_prio)
 	 * Event #2 implies the new context is PANIC.
 	 * Event #3 occurs when panic() has flushed the console.
 	 * Event #4 occurs when a non-panic CPU reacquires.
-	 * Event #5 is not possible due to the other_cpu_in_panic() check
+	 * Event #5 is not possible due to the panic_on_other_cpu() check
 	 *          in nbcon_context_try_acquire_handover().
 	 */
 
@@ -348,7 +348,7 @@ static int nbcon_context_try_acquire_requested(struct nbcon_context *ctxt,
 	struct nbcon_state new;
 
 	/* Note that the caller must still remove the request! */
-	if (other_cpu_in_panic())
+	if (panic_on_other_cpu())
 		return -EPERM;
 
 	/*
@@ -446,7 +446,7 @@ static int nbcon_context_try_acquire_handover(struct nbcon_context *ctxt,
 	 * nbcon_waiter_matches(). In particular, the assumption that
 	 * lower priorities are ignored during panic.
 	 */
-	if (other_cpu_in_panic())
+	if (panic_on_other_cpu())
 		return -EPERM;
 
 	/* Handover is not possible on the same CPU. */
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a01a5683ecd92..9434460cff640 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -346,17 +346,6 @@ static void __up_console_sem(unsigned long ip)
 }
 #define up_console_sem() __up_console_sem(_RET_IP_)
 
-/*
- * Return true if a panic is in progress on a remote CPU.
- *
- * On true, the local CPU should immediately release any printing resources
- * that may be needed by the panic CPU.
- */
-bool other_cpu_in_panic(void)
-{
-	return (panic_in_progress() && !panic_on_this_cpu());
-}
-
 /*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
@@ -2366,7 +2355,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * non-panic CPUs are generating any messages, they will be
 	 * silently dropped.
 	 */
-	if (other_cpu_in_panic() &&
+	if (panic_on_other_cpu() &&
 	    !debug_non_panic_cpus &&
 	    !panic_triggering_all_cpu_backtrace)
 		return 0;
@@ -2802,7 +2791,7 @@ void console_lock(void)
 	might_sleep();
 
 	/* On panic, the console_lock must be left to the panic cpu. */
-	while (other_cpu_in_panic())
+	while (panic_on_other_cpu())
 		msleep(1000);
 
 	down_console_sem();
@@ -2822,7 +2811,7 @@ EXPORT_SYMBOL(console_lock);
 int console_trylock(void)
 {
 	/* On panic, the console_lock must be left to the panic cpu. */
-	if (other_cpu_in_panic())
+	if (panic_on_other_cpu())
 		return 0;
 	if (down_trylock_console_sem())
 		return 0;
@@ -3197,7 +3186,7 @@ static bool console_flush_all(bool do_cond_resched, u64 *next_seq, bool *handove
 			any_progress = true;
 
 			/* Allow panic_cpu to take over the consoles safely. */
-			if (other_cpu_in_panic())
+			if (panic_on_other_cpu())
 				goto abandon;
 
 			if (do_cond_resched)
-- 
2.53.0



