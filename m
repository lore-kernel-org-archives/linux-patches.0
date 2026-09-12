Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB812357CFC;
	Sat, 12 Sep 2026 12:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215377; cv=none; b=T0SE2KgMiyLzvWzg47XdVFfaySwb8V5l0wXpmvh0l6VVe3TfW8ONjqmq4UedDeGhHFB8mjt6PjJcYZbeew8iH90Kx5Qt/wg5sryLRGytzh/v68wO69iCz+Pkb8403mFdd/m525mrdbmBaXJHT3hFtlhHB/WvkVXDdfcaRIdVadM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215377; c=relaxed/simple;
	bh=sGzj36QfvG++wCmoDa9TCquHmwlYfojxlN4u5C6/HJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJJysimVMdSWvlLw7S6xy8uQvtYliCmd4Dx9IFp2LsLYjnOmkEu2PQIyHn+v86FKoSYpGrwyuIn4t00ExptYEMgEnOvWC29yMgMM/1EM8bjlWlWgF92pD8Rp9Z5Wa4qZbSEKf7T+Af1fMzPicZ2kkl7A1v1A5bmYIAYhpCsG5fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RThasUZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RThasUZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A4B1F000FF;
	Sat, 12 Sep 2026 12:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215375;
	bh=FX2L/mnHmlJMLbYRVOxiZRUokQ0q4Xcbh4ZFypZ5CZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RThasUZsEyKgwysHSemRlgCBfLfBPfQC0uy4n+AetiEYc4cFZqF/PuViL5LVZQNv4
	 Sz+dKPHDSilpaBKFRa3b9sUOM046QjSw9jGbm5FyhMrhQzG/mcs0Cy7F6JWVn58eRE
	 GfhB3trYub7KVRacwths6vmyvOfr2KqJ97MPGAj0=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: [PATCH 6.12 0466/1376] panic: introduce helper functions for panic state
Date: Sat, 12 Sep 2026 08:48:12 +0200
Message-ID: <20260912065617.915208554@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinchao Wang <wangjinchao600@gmail.com>

[ Upstream commit d0d9c7235548f1d772f1e48c9d5742c65d81c705 ]

Patch series "panic: introduce panic status function family", v2.

This series introduces a family of helper functions to manage panic state
and updates existing code to use them.

Before this series, panic state helpers were scattered and inconsistent.
For example, panic_in_progress() was defined in printk/printk.c, not in
panic.c or panic.h.  As a result, developers had to look in unexpected
places to understand or re-use panic state logic.  Other checks were open-
coded, duplicating logic across panic, crash, and watchdog paths.

The new helpers centralize the functionality in panic.c/panic.h:
  - panic_try_start()
  - panic_reset()
  - panic_in_progress()
  - panic_on_this_cpu()
  - panic_on_other_cpu()

Patches 1–8 add the helpers and convert panic/crash and printk/nbcon
code to use them.

Patch 9 fixes a bug in the watchdog subsystem by skipping checks when a
panic is in progress, avoiding interference with the panic CPU.

Together, this makes panic state handling simpler, more discoverable, and
more robust.

This patch (of 9):

This patch introduces four new helper functions to abstract the management
of the panic_cpu variable.  These functions will be used in subsequent
patches to refactor existing code.

The direct use of panic_cpu can be error-prone and ambiguous, as it
requires manual checks to determine which CPU is handling the panic.  The
new helpers clarify intent:

panic_try_start():
Atomically sets the current CPU as the panicking CPU.

panic_reset():
Reset panic_cpu to PANIC_CPU_INVALID.

panic_in_progress():
Checks if a panic has been triggered.

panic_on_this_cpu():
Returns true if the current CPU is the panic originator.

panic_on_other_cpu():
Returns true if a panic is on another CPU.

This change lays the groundwork for improved code readability
and robustness in the panic handling subsystem.

Link: https://lkml.kernel.org/r/20250825022947.1596226-1-wangjinchao600@gmail.com
Link: https://lkml.kernel.org/r/20250825022947.1596226-2-wangjinchao600@gmail.com
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
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>b
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 36630cafbeed ("printk: Fix possible console use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/panic.h  |  6 +++++
 kernel/panic.c         | 53 ++++++++++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c |  5 ----
 3 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/include/linux/panic.h b/include/linux/panic.h
index 54d90b6c5f47b..f0b779d2915e6 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -44,6 +44,12 @@ void abort(void);
 extern atomic_t panic_cpu;
 #define PANIC_CPU_INVALID	-1
 
+bool panic_try_start(void);
+void panic_reset(void);
+bool panic_in_progress(void);
+bool panic_on_this_cpu(void);
+bool panic_on_other_cpu(void);
+
 /*
  * Only to be used by arch init code. If the user over-wrote the default
  * CONFIG_PANIC_TIMEOUT, honor it.
diff --git a/kernel/panic.c b/kernel/panic.c
index ddad0578355bb..b4005d5d3343a 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -187,6 +187,59 @@ void __weak crash_smp_send_stop(void)
 
 atomic_t panic_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
+bool panic_try_start(void)
+{
+	int old_cpu, this_cpu;
+
+	/*
+	 * Only one CPU is allowed to execute the crash_kexec() code as with
+	 * panic().  Otherwise parallel calls of panic() and crash_kexec()
+	 * may stop each other.  To exclude them, we use panic_cpu here too.
+	 */
+	old_cpu = PANIC_CPU_INVALID;
+	this_cpu = raw_smp_processor_id();
+
+	return atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu);
+}
+EXPORT_SYMBOL(panic_try_start);
+
+void panic_reset(void)
+{
+	atomic_set(&panic_cpu, PANIC_CPU_INVALID);
+}
+EXPORT_SYMBOL(panic_reset);
+
+bool panic_in_progress(void)
+{
+	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
+}
+EXPORT_SYMBOL(panic_in_progress);
+
+/* Return true if a panic is in progress on the current CPU. */
+bool panic_on_this_cpu(void)
+{
+	/*
+	 * We can use raw_smp_processor_id() here because it is impossible for
+	 * the task to be migrated to the panic_cpu, or away from it. If
+	 * panic_cpu has already been set, and we're not currently executing on
+	 * that CPU, then we never will be.
+	 */
+	return unlikely(atomic_read(&panic_cpu) == raw_smp_processor_id());
+}
+EXPORT_SYMBOL(panic_on_this_cpu);
+
+/*
+ * Return true if a panic is in progress on a remote CPU.
+ *
+ * On true, the local CPU should immediately release any printing resources
+ * that may be needed by the panic CPU.
+ */
+bool panic_on_other_cpu(void)
+{
+	return (panic_in_progress() && !this_cpu_in_panic());
+}
+EXPORT_SYMBOL(panic_on_other_cpu);
+
 /*
  * A variant of panic() called from NMI context. We return if we've already
  * panicked on this CPU. If another CPU already panicked, loop in
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index aa5c3e91ffd54..7b7f0fd6adc7f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -345,11 +345,6 @@ static void __up_console_sem(unsigned long ip)
 }
 #define up_console_sem() __up_console_sem(_RET_IP_)
 
-static bool panic_in_progress(void)
-{
-	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
-}
-
 /* Return true if a panic is in progress on the current CPU. */
 bool this_cpu_in_panic(void)
 {
-- 
2.53.0



