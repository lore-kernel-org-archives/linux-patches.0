Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AEA22FAF8;
	Mon, 10 Mar 2025 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628624; cv=none; b=RW6C2yxBZcrSi+G80XHk4LPoLbY9kENkUjw8QUvXfgizJLCQ8KonXn3TR6PKzppjkRuGuUx2rlG8HpUdSzA9UtALd4pzchLPv+QQEMQmGbOdfRRcesNZNVH9ado8Awogdzn+pcNEqi4TpblhKXhZ/TzWMM4B8caBxqachoGER8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628624; c=relaxed/simple;
	bh=yQ+/Lc7LoxOdO5omlRrXIKaHNsP8w5MuE32QOFtFWpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeLGO/ycZRWsNijxZlLd1C0FlQ9HjB9iuQInNtAGoXvE+gw7OP2QcA3A9lwFDTylPP8pK8o10Roi2YimaYDBANTuUpb9jr1ljdlLqmYI9cgujwON2SGJ2rDrUjZYjqXjsDwgCFSH3qPDCkWVI+XW8uKa94A5LfAl7kkY1xAno5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xi93d2EW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xi93d2EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E215DC4CEE5;
	Mon, 10 Mar 2025 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628624;
	bh=yQ+/Lc7LoxOdO5omlRrXIKaHNsP8w5MuE32QOFtFWpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xi93d2EWxMuH6Db0sHNKBqsnGXlOqKf2OMlcPWt/ciQs6XAaV+7FN0Ux5k9MGy3Hf
	 v6khZK0b/cCeFaRskII55vYdNwWPEADj5LlPd0Sosaq54SvCq5yxGMjm95ACpDXu3N
	 FxR0fixQXJG70so4CEh0uVlw7oD1Z47pMdPYnUfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Amir Goldstein <amir73il@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	David Airlie <airlied@linux.ie>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Iurii Zaikin <yzaikin@google.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jan Kara <jack@suse.cz>,
	Joel Becker <jlbec@evilplan.org>,
	John Ogness <john.ogness@linutronix.de>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Kees Cook <keescook@chromium.org>,
	Lukas Middendorf <kernel@tuxforce.de>,
	Mark Fasheh <mark@fasheh.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Paul Turner <pjt@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Mladek <pmladek@suse.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	Qing Wang <wangqing@vivo.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sebastian Reichel <sre@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Stephen Kitt <steve@sk2.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	"Theodore Tso" <tytso@mit.edu>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/620] sysctl: share unsigned long const values
Date: Mon, 10 Mar 2025 17:57:31 +0100
Message-ID: <20250310170545.784334390@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b1f2aff888af54a057c2c3c0d88a13ef5d37b52a ]

Provide a way to share unsigned long values.  This will allow others to
not have to re-invent these values.

Link: https://lkml.kernel.org/r/20211124231435.1445213-9-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: d727935cad9f ("fs: fix proc_handler for sysctl_nr_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c  | 3 +++
 include/linux/sysctl.h | 6 ++++++
 kernel/sysctl.c        | 9 +++------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 213ea008fe2db..7c5d472b193f8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -29,6 +29,9 @@ static const struct inode_operations proc_sys_dir_operations;
 const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX };
 EXPORT_SYMBOL(sysctl_vals);
 
+const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
+EXPORT_SYMBOL_GPL(sysctl_long_vals);
+
 /* Support for permanently empty directories */
 
 struct ctl_table sysctl_mount_point[] = {
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 32d79ef906e51..3fa5e2713aace 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -51,6 +51,12 @@ struct ctl_dir;
 
 extern const int sysctl_vals[];
 
+#define SYSCTL_LONG_ZERO	((void *)&sysctl_long_vals[0])
+#define SYSCTL_LONG_ONE		((void *)&sysctl_long_vals[1])
+#define SYSCTL_LONG_MAX		((void *)&sysctl_long_vals[2])
+
+extern const unsigned long sysctl_long_vals[];
+
 typedef int proc_handler(struct ctl_table *ctl, int write, void *buffer,
 		size_t *lenp, loff_t *ppos);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 48eb4e7b72dea..05853e7681512 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -113,9 +113,6 @@
 static int sixty = 60;
 #endif
 
-static const unsigned long zero_ul;
-static const unsigned long one_ul = 1;
-static const unsigned long long_max = LONG_MAX;
 #ifdef CONFIG_PRINTK
 static const int ten_thousand = 10000;
 #endif
@@ -2726,7 +2723,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_background_bytes_handler,
-		.extra1		= (void *)&one_ul,
+		.extra1		= SYSCTL_LONG_ONE,
 	},
 	{
 		.procname	= "dirty_ratio",
@@ -3146,8 +3143,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= (void *)&zero_ul,
-		.extra2		= (void *)&long_max,
+		.extra1		= SYSCTL_LONG_ZERO,
+		.extra2		= SYSCTL_LONG_MAX,
 	},
 	{
 		.procname	= "nr_open",
-- 
2.39.5



