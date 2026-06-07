Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F273148A8;
	Sun,  7 Jun 2026 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827748; cv=none; b=k73c9sKEOwNCiSuEYOk6122dxQpZGt4Tdxbx6GddIh+q22W4dLBKdnJFCsdqcbAoDtEoQiJVxUNP4G2my2EeZJocoGsfUeN66I+i8XAOwR4XPR5OjHZ6BDcIHFHXoWIm/Z718jrpTd9KmALOE8/tLzbzdyStKq68f7PNfo/zk8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827748; c=relaxed/simple;
	bh=V+xexobf7HRZ4ATChQbSzCfikaO2WN/HpDjG1qlM0+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXwB3pqD9HhiVridC4dMidjHpfjUKRe+6WnhloZDevERxL2jFfmxX884X/fFxXnPihq8DvIq+YYJMI53EidkEeOm5bIrd5NTbRw6bdq62SBC/o5jgkZ5GYOVzahLU710u/br3SP0t/0a5TIYBWLMtldr3umyAZnYign83LOmFWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSHqXWJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSHqXWJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC18A1F00893;
	Sun,  7 Jun 2026 10:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827746;
	bh=AU+m2P2QhMIMoM67Ootoiyd/CR3J6KohfuA0pszryfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSHqXWJFItXL4Rt+4Xey8JCtLtanlFe3/+L4lBrOk49mOxTYzY9bf196HoLw1pryS
	 ROcf2Qoj3inybfNFMtPlR0Kf2jfGGij/hCG7jr0CbzqaLfuamqOI+BNj0v+iLDRoU1
	 y5OtgPa/AvJgOcA4G5NiVrZiGKaTXOOEEKnX2AjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/307] remove pointless includes of <linux/fdtable.h>
Date: Sun,  7 Jun 2026 11:58:00 +0200
Message-ID: <20260607095730.821106213@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit be5498cac2ddb112c5bd7433d5e834a1a2493427 ]

some of those used to be needed, some had been cargo-culted for
no reason...

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: ea5fe6a73ca5 ("net/handshake: Drain pending requests at net namespace exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c                         | 1 -
 fs/file_table.c                    | 1 -
 fs/notify/fanotify/fanotify.c      | 1 -
 fs/notify/fanotify/fanotify_user.c | 1 -
 fs/overlayfs/copy_up.c             | 1 -
 fs/proc/base.c                     | 1 -
 io_uring/io_uring.c                | 1 -
 kernel/bpf/bpf_inode_storage.c     | 1 -
 kernel/bpf/bpf_task_storage.c      | 1 -
 kernel/bpf/token.c                 | 1 -
 kernel/exit.c                      | 1 -
 kernel/module/dups.c               | 1 -
 kernel/module/kmod.c               | 1 -
 kernel/umh.c                       | 1 -
 net/handshake/request.c            | 1 -
 security/apparmor/domain.c         | 1 -
 16 files changed, 16 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 3d89de31066ae0..a7947a615db6b4 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -12,7 +12,6 @@
 #include <linux/fs.h>
 #include <linux/filelock.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/capability.h>
 #include <linux/dnotify.h>
 #include <linux/slab.h>
diff --git a/fs/file_table.c b/fs/file_table.c
index f7661a70874640..2a08bc93b0b9c1 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -9,7 +9,6 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index bb00e1e1683838..4d86a05258b970 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fanotify.h>
-#include <linux/fdtable.h>
 #include <linux/fsnotify_backend.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 93c1619cdad659..b89ad128bf09cf 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fanotify.h>
 #include <linux/fcntl.h>
-#include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 57f635d050eb5a..75e804bc152ccf 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -16,7 +16,6 @@
 #include <linux/sched/signal.h>
 #include <linux/cred.h>
 #include <linux/namei.h>
-#include <linux/fdtable.h>
 #include <linux/ratelimit.h>
 #include <linux/exportfs.h>
 #include "overlayfs.h"
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d060af34a6e837..704cf6a0612ede 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -58,7 +58,6 @@
 #include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/generic-radix-tree.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eef59b9eccfab1..e515aeafa87813 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -51,7 +51,6 @@
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/percpu.h>
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index 29da6d3838f678..e16e79f8cd6dc3 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -16,7 +16,6 @@
 #include <uapi/linux/btf.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
-#include <linux/fdtable.h>
 #include <linux/rcupdate_trace.h>
 
 DEFINE_BPF_STORAGE_CACHE(inode_cache);
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index adf6dfe0ba68a4..1eb9852a9f8ebb 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -16,7 +16,6 @@
 #include <linux/filter.h>
 #include <uapi/linux/btf.h>
 #include <linux/btf_ids.h>
-#include <linux/fdtable.h>
 #include <linux/rcupdate_trace.h>
 
 DEFINE_BPF_STORAGE_CACHE(task_cache);
diff --git a/kernel/bpf/token.c b/kernel/bpf/token.c
index dcbec1a0dfb33f..26057aa1350398 100644
--- a/kernel/bpf/token.c
+++ b/kernel/bpf/token.c
@@ -1,6 +1,5 @@
 #include <linux/bpf.h>
 #include <linux/vmalloc.h>
-#include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
diff --git a/kernel/exit.c b/kernel/exit.c
index b91124b2d334ee..e798078f958c89 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -25,7 +25,6 @@
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/freezer.h>
 #include <linux/binfmts.h>
 #include <linux/nsproxy.h>
diff --git a/kernel/module/dups.c b/kernel/module/dups.c
index 9a92f2f8c9d382..bd2149fbe11738 100644
--- a/kernel/module/dups.c
+++ b/kernel/module/dups.c
@@ -18,7 +18,6 @@
 #include <linux/completion.h>
 #include <linux/cred.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/mount.h>
diff --git a/kernel/module/kmod.c b/kernel/module/kmod.c
index 0800d989169219..25f25381251281 100644
--- a/kernel/module/kmod.c
+++ b/kernel/module/kmod.c
@@ -15,7 +15,6 @@
 #include <linux/completion.h>
 #include <linux/cred.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/mount.h>
diff --git a/kernel/umh.c b/kernel/umh.c
index ff1f13a27d29fd..be923427077731 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -13,7 +13,6 @@
 #include <linux/completion.h>
 #include <linux/cred.h>
 #include <linux/file.h>
-#include <linux/fdtable.h>
 #include <linux/fs_struct.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
diff --git a/net/handshake/request.c b/net/handshake/request.c
index 2f58d74f16554b..62efb7e32730ea 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/inet.h>
-#include <linux/fdtable.h>
 #include <linux/rhashtable.h>
 
 #include <net/sock.h>
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index cccd61cca509ce..fbfb1d48dc88f2 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/errno.h>
-#include <linux/fdtable.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/mount.h>
-- 
2.53.0



