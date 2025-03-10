Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFB822FAF8;
	Mon, 10 Mar 2025 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628621; cv=none; b=LZEnZ8p+eBR8sxbGA9w5e/KRck3s3F5/z7y/qGrZ54f2VFn3Jg2yH39WsngGGErA+RYp/cmrEZl9iVm0BamkjjkG1R+NA8i7LDEV22KiWoaCS2oV8xoVdcp4xUyKxsjIPeErWuLDSSj0JnVsvYJjhNKg4HKBWYhfGMG5mm1Gxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628621; c=relaxed/simple;
	bh=AWcHeGMDZcl1RPTMGTcnDZHTICRdnQYEYbEg3/97/sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UF/uO4+YqZy0w/yAOOqvsk14a/32u5ELZzMuhjFsYQEu9vXZbfKh6H5j/sNHDBo9pTGe4kuTCR3Erfus5DUN28zgy5RynJmDjlKibulC8pP6ZVHs582yIrARLv9BHT4Ytf1kdHe34mJ+wJmyglgwl6sXKE1WPhFPQQej6X2csYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAHSeXYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAHSeXYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F5EC4CEE5;
	Mon, 10 Mar 2025 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628621;
	bh=AWcHeGMDZcl1RPTMGTcnDZHTICRdnQYEYbEg3/97/sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAHSeXYWxmbbMNIxwfvgWd8a+G8wmaq2+kUazyZfU5OsSM8mpTkRazSPuV4oFn37w
	 13+RrdNiU4JXESG7YvudZof28CAuzgdYDGf2zoAJGNwPdQwuwbYI1+umQTKMDg+1OE
	 K+semy0Czp3AfaFuAL5zZY2bWan+6BmS71w9gnmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Amir Goldstein <amir73il@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Iurii Zaikin <yzaikin@google.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <keescook@chromium.org>,
	Paul Turner <pjt@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Mladek <pmladek@suse.com>,
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
Subject: [PATCH 5.15 004/620] sysctl: use const for typically used max/min proc sysctls
Date: Mon, 10 Mar 2025 17:57:30 +0100
Message-ID: <20250310170545.744365283@linuxfoundation.org>
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

[ Upstream commit d73840ec2f747b860331bbba53677d0ce38fb9c1 ]

When proc_dointvec_minmax() or proc_doulongvec_minmax() are used we are
using the extra1 and extra2 parameters on the sysctl table only for a
min and max boundary, these extra1 and extra2 arguments are then used
for read-only operations.  So make them const to reflect this.

[mcgrof@kernel.org: commit log love]

Link: https://lkml.kernel.org/r/20211123202347.818157-7-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
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
 kernel/sysctl.c | 53 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0a84cb7a8bffe..48eb4e7b72dea 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -113,27 +113,26 @@
 static int sixty = 60;
 #endif
 
-static unsigned long zero_ul;
-static unsigned long one_ul = 1;
-static unsigned long long_max = LONG_MAX;
+static const unsigned long zero_ul;
+static const unsigned long one_ul = 1;
+static const unsigned long long_max = LONG_MAX;
 #ifdef CONFIG_PRINTK
-static int ten_thousand = 10000;
+static const int ten_thousand = 10000;
 #endif
 #ifdef CONFIG_PERF_EVENTS
-static int six_hundred_forty_kb = 640 * 1024;
+static const int six_hundred_forty_kb = 640 * 1024;
 #endif
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
-static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
+static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
-static int maxolduid = 65535;
-static int minolduid;
+static const int maxolduid = 65535;
+static const int minolduid;
 
 static int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
-
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
 #endif
@@ -177,8 +176,8 @@ int sysctl_legacy_va_layout;
 #endif
 
 #ifdef CONFIG_COMPACTION
-static int min_extfrag_threshold;
-static int max_extfrag_threshold = 1000;
+static const int min_extfrag_threshold;
+static const int max_extfrag_threshold = 1000;
 #endif
 
 #endif /* CONFIG_SYSCTL */
@@ -2196,8 +2195,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 	{
 		.procname	= "overflowgid",
@@ -2205,8 +2204,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_S390
 	{
@@ -2269,7 +2268,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &ten_thousand,
+		.extra2		= (void *)&ten_thousand,
 	},
 	{
 		.procname	= "printk_devkmsg",
@@ -2571,7 +2570,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_event_max_stack_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &six_hundred_forty_kb,
+		.extra2		= (void *)&six_hundred_forty_kb,
 	},
 	{
 		.procname	= "perf_event_max_contexts_per_stack",
@@ -2727,7 +2726,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_background_bytes_handler,
-		.extra1		= &one_ul,
+		.extra1		= (void *)&one_ul,
 	},
 	{
 		.procname	= "dirty_ratio",
@@ -2744,7 +2743,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(vm_dirty_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_bytes_handler,
-		.extra1		= &dirty_bytes_min,
+		.extra1		= (void *)&dirty_bytes_min,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
@@ -2860,8 +2859,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_extfrag_threshold,
-		.extra2		= &max_extfrag_threshold,
+		.extra1		= (void *)&min_extfrag_threshold,
+		.extra2		= (void *)&max_extfrag_threshold,
 	},
 	{
 		.procname	= "compact_unevictable_allowed",
@@ -3147,8 +3146,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &zero_ul,
-		.extra2		= &long_max,
+		.extra1		= (void *)&zero_ul,
+		.extra2		= (void *)&long_max,
 	},
 	{
 		.procname	= "nr_open",
@@ -3172,8 +3171,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 	{
 		.procname	= "overflowgid",
@@ -3181,8 +3180,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_FILE_LOCKING
 	{
-- 
2.39.5



