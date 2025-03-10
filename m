Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC889230BD4;
	Mon, 10 Mar 2025 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628618; cv=none; b=pUii7AC9zEXhtv3luQDB57OXLGdKFN8GzS1UvkzuyrZc2ABA4SXqoGlXBgR6HP7nj3CQ9iBESQRG37m48VBcQ/S9glHxfqWmLhCBNLhkt0kT1xnxy2euBg3eQsTKHnfJwoBwVWuj/NCKEKHIBurnkoiJn99xchPhVYO6AY3yjnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628618; c=relaxed/simple;
	bh=Q1KsTFXA+o54pEEI72BlR6wNd3FQAQiiUakhtKDVlJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx/WdAmWinbj2UoczcmpZdcuMv+Rj58252oWjxB1ggrockPuQOfw2IwXYcy3U098RkdJ6FodBt7nNt+Qdrn9QHq/tmchlkD7pGb8dJROdczAxQDdzMDB7EaCAY7kFU8mjEbBfDtUl7pp1PK37XBiWkbMRLVv40paumOsaKhE5Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkLoa5Bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkLoa5Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197D2C4CEE5;
	Mon, 10 Mar 2025 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628618;
	bh=Q1KsTFXA+o54pEEI72BlR6wNd3FQAQiiUakhtKDVlJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkLoa5BvZnFgomk1mLdza9GLNDSOedHI3yCZFFoJ3HckzavQLOsWvEYmwY5gdPz3x
	 pAm0QuJ7cIXQMalJzBOb5TI6Nvm1UnTyaJCc7S541/6DJIJ+te2V3PbDWPWBIHqJTf
	 tPcUibBhtaDaCddyPphQAwGjuJBBHKwL+VJC1eeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Amir Goldstein <amir73il@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Iurii Zaikin <yzaikin@google.com>,
	Jan Kara <jack@suse.cz>,
	Paul Turner <pjt@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qing Wang <wangqing@vivo.com>,
	Sebastian Reichel <sre@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Stephen Kitt <steve@sk2.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Antti Palosaari <crope@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	David Airlie <airlied@linux.ie>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Lukas Middendorf <kernel@tuxforce.de>,
	Mark Fasheh <mark@fasheh.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Jani Nikula <jani.nikula@intel.com>,
	John Ogness <john.ogness@linutronix.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Theodore Tso" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/620] hung_task: move hung_task sysctl interface to hung_task.c
Date: Mon, 10 Mar 2025 17:57:29 +0100
Message-ID: <20250310170545.700145424@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoming Ni <nixiaoming@huawei.com>

[ Upstream commit bbe7a10ed83a5fa0b0ff6161ecdc4e65a0e9c993 ]

The kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we
just care about the core logic.

So move hung_task sysctl interface to hung_task.c and use
register_sysctl() to register the sysctl interface.

[mcgrof@kernel.org: commit log refresh and fixed 2-3 0day reported compile issues]

Link: https://lkml.kernel.org/r/20211123202347.818157-4-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: d727935cad9f ("fs: fix proc_handler for sysctl_nr_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/sysctl.h | 14 +------
 kernel/hung_task.c           | 81 ++++++++++++++++++++++++++++++++++--
 kernel/sysctl.c              | 61 ---------------------------
 3 files changed, 79 insertions(+), 77 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 304f431178fd9..c19dd5a2c05c6 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -7,20 +7,8 @@
 struct ctl_table;
 
 #ifdef CONFIG_DETECT_HUNG_TASK
-
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_hung_task_all_cpu_backtrace;
-#else
-#define sysctl_hung_task_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
-extern int	     sysctl_hung_task_check_count;
-extern unsigned int  sysctl_hung_task_panic;
+/* used for hung_task and block/ */
 extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_check_interval_secs;
-extern int sysctl_hung_task_warnings;
-int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos);
 #else
 /* Avoid need for ifdefs elsewhere in the code */
 enum { sysctl_hung_task_timeout_secs = 0 };
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 9888e2bc8c767..52501e5f76554 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -63,7 +63,9 @@ static struct task_struct *watchdog_task;
  * Should we dump all CPUs backtraces in a hung task event?
  * Defaults to 0, can be changed via sysctl.
  */
-unsigned int __read_mostly sysctl_hung_task_all_cpu_backtrace;
+static unsigned int __read_mostly sysctl_hung_task_all_cpu_backtrace;
+#else
+#define sysctl_hung_task_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
 /*
@@ -222,11 +224,13 @@ static long hung_timeout_jiffies(unsigned long last_checked,
 		MAX_SCHEDULE_TIMEOUT;
 }
 
+#ifdef CONFIG_SYSCTL
 /*
  * Process updating of timeout sysctl
  */
-int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
-				  void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
+				  void __user *buffer,
+				  size_t *lenp, loff_t *ppos)
 {
 	int ret;
 
@@ -241,6 +245,76 @@ int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 	return ret;
 }
 
+/*
+ * This is needed for proc_doulongvec_minmax of sysctl_hung_task_timeout_secs
+ * and hung_task_check_interval_secs
+ */
+static const unsigned long hung_task_timeout_max = (LONG_MAX / HZ);
+static struct ctl_table hung_task_sysctls[] = {
+#ifdef CONFIG_SMP
+	{
+		.procname	= "hung_task_all_cpu_backtrace",
+		.data		= &sysctl_hung_task_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_SMP */
+	{
+		.procname	= "hung_task_panic",
+		.data		= &sysctl_hung_task_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "hung_task_check_count",
+		.data		= &sysctl_hung_task_check_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "hung_task_timeout_secs",
+		.data		= &sysctl_hung_task_timeout_secs,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= (void *)&hung_task_timeout_max,
+	},
+	{
+		.procname	= "hung_task_check_interval_secs",
+		.data		= &sysctl_hung_task_check_interval_secs,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_dohung_task_timeout_secs,
+		.extra2		= (void *)&hung_task_timeout_max,
+	},
+	{
+		.procname	= "hung_task_warnings",
+		.data		= &sysctl_hung_task_warnings,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_NEG_ONE,
+	},
+	{}
+};
+
+static void __init hung_task_sysctl_init(void)
+{
+	register_sysctl_init("kernel", hung_task_sysctls);
+}
+#else
+#define hung_task_sysctl_init() do { } while (0)
+#endif /* CONFIG_SYSCTL */
+
+
 static atomic_t reset_hung_task = ATOMIC_INIT(0);
 
 void reset_hung_task_detector(void)
@@ -310,6 +384,7 @@ static int __init hung_task_init(void)
 	pm_notifier(hungtask_pm_notify, 0);
 
 	watchdog_task = kthread_run(watchdog, NULL, "khungtaskd");
+	hung_task_sysctl_init();
 
 	return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4554e80c42729..0a84cb7a8bffe 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -133,13 +133,6 @@ static int minolduid;
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
-/*
- * This is needed for proc_doulongvec_minmax of sysctl_hung_task_timeout_secs
- * and hung_task_check_interval_secs
- */
-#ifdef CONFIG_DETECT_HUNG_TASK
-static unsigned long hung_task_timeout_max = (LONG_MAX/HZ);
-#endif
 
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
@@ -2510,60 +2503,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_DETECT_HUNG_TASK
-#ifdef CONFIG_SMP
-	{
-		.procname	= "hung_task_all_cpu_backtrace",
-		.data		= &sysctl_hung_task_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
-	{
-		.procname	= "hung_task_panic",
-		.data		= &sysctl_hung_task_panic,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "hung_task_check_count",
-		.data		= &sysctl_hung_task_check_count,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "hung_task_timeout_secs",
-		.data		= &sysctl_hung_task_timeout_secs,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_dohung_task_timeout_secs,
-		.extra2		= &hung_task_timeout_max,
-	},
-	{
-		.procname	= "hung_task_check_interval_secs",
-		.data		= &sysctl_hung_task_check_interval_secs,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_dohung_task_timeout_secs,
-		.extra2		= &hung_task_timeout_max,
-	},
-	{
-		.procname	= "hung_task_warnings",
-		.data		= &sysctl_hung_task_warnings,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_NEG_ONE,
-	},
-#endif
 #ifdef CONFIG_RT_MUTEXES
 	{
 		.procname	= "max_lock_depth",
-- 
2.39.5



