Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069FF33F59A;
	Sat, 12 Sep 2026 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215160; cv=none; b=EJdHsi3ndRTMDbTNE5l4NmRGhW1qmnxx9XgbZBj9ZhGP7BkDwM1eQKio/IbVBA5nHHCdjYa2XWWpJJmz2z4WJLOvcbXX3mVyE8PRWouyG0XvX/woOH/WT96s4tve9BWEa8Em4px37HMd1pNoCDEglPSUaW46mRi29gQYIrBZJuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215160; c=relaxed/simple;
	bh=cy0LTPxUss/NQBDP0HmrYd+mdrkw+3GiZeUJjX+udpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxAf8/H+JyGOV86COIdpQrli4/X9WmI30QumeNl0qZnRFbZ8rLELXJGYyQjYWl13e68xCCg3sBu7zPdKHzKEFvltNCafh86a9dObkNFoX+qn0HIfQjvAel22nmfv7GAznNuHjgnjZorQhjh/mgJHWiMOsW35aIt/RmjELQWKOrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+TSFnyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+TSFnyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE541F000FF;
	Sat, 12 Sep 2026 12:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215158;
	bh=NkE2ECTiVQBIhfRsbdNb/sVxW+89kPOvkihk80t4Ix0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+TSFnyxju6yzqM8zLF9nh6wPuVxvg5hO5j3LBO9LoofY+ra+kUA5C5f9pYhRJjJ9
	 dKm34Srk88G6FmPFHPDTThmyiB2MddMOpGcg8HyGe+fH+61Mjk4COLald9X/H3Ng7Y
	 y3ZHfPkGdyspHzASgj4VwguiX6mGvD31WbKWw5Fw=
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
Subject: [PATCH 6.12 0467/1376] panic/printk: replace this_cpu_in_panic() with panic_on_this_cpu()
Date: Sat, 12 Sep 2026 08:48:13 +0200
Message-ID: <20260912065617.938691060@linuxfoundation.org>
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

[ Upstream commit c6be36e2997662f423edfa3979a63935873ff648 ]

The helper this_cpu_in_panic() duplicated logic already provided by
panic_on_this_cpu().

Remove this_cpu_in_panic() and switch all users to panic_on_this_cpu().

This simplifies the code and avoids having two helpers for the same check.

Link: https://lkml.kernel.org/r/20250825022947.1596226-8-wangjinchao600@gmail.com
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
 include/linux/printk.h            |  2 --
 kernel/panic.c                    |  2 +-
 kernel/printk/nbcon.c             |  2 +-
 kernel/printk/printk.c            | 15 ++-------------
 kernel/printk/printk_ringbuffer.c |  2 +-
 lib/dump_stack.c                  |  2 +-
 6 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index a6c6fd107805b..c2ae39c85a203 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -312,8 +312,6 @@ static inline bool pr_flush(int timeout_ms, bool reset_on_progress)
 
 #endif
 
-bool this_cpu_in_panic(void);
-
 #ifdef CONFIG_SMP
 extern int __printk_cpu_sync_try_get(void);
 extern void __printk_cpu_sync_wait(void);
diff --git a/kernel/panic.c b/kernel/panic.c
index b4005d5d3343a..97c472164393b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -236,7 +236,7 @@ EXPORT_SYMBOL(panic_on_this_cpu);
  */
 bool panic_on_other_cpu(void)
 {
-	return (panic_in_progress() && !this_cpu_in_panic());
+	return (panic_in_progress() && !panic_on_this_cpu());
 }
 EXPORT_SYMBOL(panic_on_other_cpu);
 
diff --git a/kernel/printk/nbcon.c b/kernel/printk/nbcon.c
index e7a3af81b1739..68563ed55e203 100644
--- a/kernel/printk/nbcon.c
+++ b/kernel/printk/nbcon.c
@@ -1394,7 +1394,7 @@ enum nbcon_prio nbcon_get_default_prio(void)
 {
 	unsigned int *cpu_emergency_nesting;
 
-	if (this_cpu_in_panic())
+	if (panic_on_this_cpu())
 		return NBCON_PRIO_PANIC;
 
 	cpu_emergency_nesting = nbcon_get_cpu_emergency_nesting();
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7b7f0fd6adc7f..a01a5683ecd92 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -17,6 +17,7 @@
  *	01Mar01 Andrew Morton
  */
 
+#include "linux/panic.h"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
@@ -345,18 +346,6 @@ static void __up_console_sem(unsigned long ip)
 }
 #define up_console_sem() __up_console_sem(_RET_IP_)
 
-/* Return true if a panic is in progress on the current CPU. */
-bool this_cpu_in_panic(void)
-{
-	/*
-	 * We can use raw_smp_processor_id() here because it is impossible for
-	 * the task to be migrated to the panic_cpu, or away from it. If
-	 * panic_cpu has already been set, and we're not currently executing on
-	 * that CPU, then we never will be.
-	 */
-	return unlikely(atomic_read(&panic_cpu) == raw_smp_processor_id());
-}
-
 /*
  * Return true if a panic is in progress on a remote CPU.
  *
@@ -365,7 +354,7 @@ bool this_cpu_in_panic(void)
  */
 bool other_cpu_in_panic(void)
 {
-	return (panic_in_progress() && !this_cpu_in_panic());
+	return (panic_in_progress() && !panic_on_this_cpu());
 }
 
 /*
diff --git a/kernel/printk/printk_ringbuffer.c b/kernel/printk/printk_ringbuffer.c
index d9fb053cff67d..e2a1b2d34d2b7 100644
--- a/kernel/printk/printk_ringbuffer.c
+++ b/kernel/printk/printk_ringbuffer.c
@@ -2143,7 +2143,7 @@ static bool _prb_read_valid(struct printk_ringbuffer *rb, u64 *seq,
 			 * But it would have the sequence number returned
 			 * by "prb_next_reserve_seq() - 1".
 			 */
-			if (this_cpu_in_panic() &&
+			if (panic_on_this_cpu() &&
 			    (!debug_non_panic_cpus || legacy_allow_panic_sync) &&
 			    ((*seq + 1) < prb_next_reserve_seq(rb))) {
 				(*seq)++;
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index 388da1aea14a5..0b41b0a34323c 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -102,7 +102,7 @@ static void __dump_stack(const char *log_lvl)
  */
 asmlinkage __visible void dump_stack_lvl(const char *log_lvl)
 {
-	bool in_panic = this_cpu_in_panic();
+	bool in_panic = panic_on_this_cpu();
 	unsigned long flags;
 
 	/*
-- 
2.53.0



