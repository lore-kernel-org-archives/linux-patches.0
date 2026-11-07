Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061134;
	b=bqHBZzvmqZZGRdoXpZzKO9HuHEE1QR3TALZFBMxF7DXtrwqqO1iKEXtGR4ceGapL6j3B
	 TD0eYw9I4fVAOzV06VqVtYbBSaehaI9nt6xS2y+0secJ1oUwr6wvOdmGDG7EJItNHTH9l
	 71RQIcoQ70i+9lSIPDXqIBYqd2Rc4kwj4wRaVEEbgOIjIlfKEAihyhUchp4w+2jYTP+p/
	 zuwUzYu/O9w4QHSeudNOJA1QPdMcW3EQGLy6wKsn9ArV+MCrfT/KSk8Xp+5v+fommdebn
	 yTvkjITPwS8dl/PPfSi/+XVtUOOU6Jw1/jMI55fbRmxzqeagolRa6YDTl6eSJ1d5gsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uwTbreai3FbXmQiU3AQoqbdYgQ+ohFZfpYnlDaTYWRo=;
	b=3Z3WqmHaARq2KVgW+AU3h1YWcWXK5dQz1sU3V/x4qgGEl3BfFbb5wb3t1Il3pwA+xlIj
	 EcYNNHTUncefJ3y1sejVCL6nunaKLXFUutUGe2XaqOouHw4jU+ogMop6tiqM0ONw81IwU
	 IuTSHUih8S+w4uEPxvrJuaf/VZO8uVEe2Fkj+uamWcIb2gaQAe4bPgPGFDnWy+pnOc9ck
	 2wQypiVc9HIvh0V0pt867iHNxFASHuB9bizyToTs2OChffphnQa0LtGrLmHJss1Bkahcx
	 aMKGB4UGaaMhKLafsBXy3NHKQaNAzuEk03OYpeU5Ko5PhqKij9s35ks+Rvt+70nvtDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVCXfPEY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518E6606A332;
	Sat,  7 Nov 2026 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVCXfPEY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5BA1F0089F;
	Sat,  7 Nov 2026 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061134;
	bh=uwTbreai3FbXmQiU3AQoqbdYgQ+ohFZfpYnlDaTYWRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVCXfPEYoObDN0MpgxlfFf11vNGLLodSwoPHv+PJ8cm2guC4B9+YJNZf2pWfwu+FX
	 UnOnjJcFsZSKa8RkzdA/SjcRCWDMmBgLPlNJp8qLv3Lg745cBF7xm6g+HrK9Jyg01S
	 82w2qsx/r5lQjTsbBHFWUSLpBBd4cOUYVDFHZnJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Kees Cook <kees@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Yufan Chen <ericterminal@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Zhang Cen <rollkingzzc@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 6.12 0443/1536] ocfs2: pin owning modules for open debugfs files
Date: Sat,  7 Nov 2026 08:40:59 -0500
Message-ID: <20261107135009.987088270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

commit 26d7e34b4226709084461a07bf28d9066fa96d8c upstream.

The OCFS2 debugfs file operation tables do not set owner. The
full debugfs proxy obtains real_fops with fops_get() at open and
keeps it until final release. Without an owner, this does not acquire
a reference to the module containing the table and its callbacks.
Removing the debugfs entries does not drain retained open files.

An open connected_nodes file can therefore outlive ocfs2_nodemanager
and make full_proxy_release() read real_fops->release from freed
module memory. Heming also reproduced the issue with fs_state and
asked for the other OCFS2 debugfs operation tables to be checked.

Set owner to THIS_MODULE in all eleven explicit debugfs operation
tables: five in ocfs2_nodemanager, four in ocfs2_dlm, and two in
ocfs2. The existing debugfs get/put pair then holds the appropriate
module until final release. Leave the open, read and release callbacks
unchanged. The blockcheck table already sets owner through
DEFINE_DEBUGFS_ATTRIBUTE(), so it needs no change.

The original controlled test used an unloadable OCFS2 module and
case-local probe filters without changing the candidate open, unload
or release logic. Closing a retained connected_nodes file after
normal unload produced:

  BUG: unable to handle page fault for address: fffffbfff804cfef
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:full_proxy_release+0xbf/0x190
  Call Trace:
   <TASK>
   __fput+0x39a/0xa60
   fput_close_sync+0xff/0x200
   __x64_sys_close+0x8c/0xf0
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in: [last unloaded: ocfs2_nodemanager]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0089-v6-f7fda843f80887488145@gmail.com
Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
Fixes: 87d3d3f3931f ("ocfs2/hb: Expose the list of heartbeating nodes via debugfs")
Fixes: 3ba169ccec1c ("ocfs2/cluster: Add new function o2net_fill_node_map()")
Fixes: 50397507e856 ("ocfs2: Expose the file system state via debugfs")
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Fixes: 7209300a9b98 ("ocfs2/dlm: Dumps the purgelist into a debugfs file")
Fixes: d0129aceaecc ("ocfs2/dlm: Dumps the mles into a debugfs file")
Fixes: 4e3d24ed1a12 ("ocfs2/dlm: Dumps the lockres' into a debugfs file")
Fixes: 007dce53a29c ("ocfs2/dlm: Dump the dlm state in a debugfs file")
Fixes: db02754c8a12 ("ocfs2/cluster: Show o2net timing statistics")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Yufan Chen <ericterminal@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Zhang Cen <rollkingzzc@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/cluster/heartbeat.c |    1 +
 fs/ocfs2/cluster/netdebug.c  |    4 ++++
 fs/ocfs2/dlm/dlmdebug.c      |    5 +++++
 fs/ocfs2/dlmglue.c           |    2 ++
 fs/ocfs2/super.c             |    1 +
 5 files changed, 13 insertions(+)

--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1427,6 +1427,7 @@ static ssize_t o2hb_debug_read(struct fi
 #endif  /* CONFIG_DEBUG_FS */
 
 static const struct file_operations o2hb_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		o2hb_debug_open,
 	.release =	o2hb_debug_release,
 	.read =		o2hb_debug_read,
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -183,6 +183,7 @@ static int nst_fop_release(struct inode
 }
 
 static const struct file_operations nst_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = nst_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -415,6 +416,7 @@ static int stats_fop_open(struct inode *
 }
 
 static const struct file_operations stats_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = stats_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -427,6 +429,7 @@ static int sc_fop_open(struct inode *ino
 }
 
 static const struct file_operations sc_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = sc_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -476,6 +479,7 @@ static ssize_t o2net_debug_read(struct f
 }
 
 static const struct file_operations nodes_fops = {
+	.owner		= THIS_MODULE,
 	.open		= nodes_fop_open,
 	.release	= o2net_debug_release,
 	.read		= o2net_debug_read,
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -393,6 +394,7 @@ bail:
 }
 
 static const struct file_operations debug_purgelist_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_purgelist_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -450,6 +452,7 @@ bail:
 }
 
 static const struct file_operations debug_mle_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_mle_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -657,6 +660,7 @@ static int debug_lockres_release(struct
 }
 
 static const struct file_operations debug_lockres_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_lockres_open,
 	.release =	debug_lockres_release,
 	.read =		seq_read,
@@ -852,6 +856,7 @@ bail:
 }
 
 static const struct file_operations debug_state_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_state_open,
 	.release =	debug_release,
 	.read =		debug_read,
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2003, 2004 Oracle.  All rights reserved.
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -3312,6 +3313,7 @@ static int ocfs2_dlm_debug_open(struct i
 }
 
 static const struct file_operations ocfs2_dlm_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		ocfs2_dlm_debug_open,
 	.release =	ocfs2_dlm_debug_release,
 	.read =		seq_read,
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -383,6 +383,7 @@ static ssize_t ocfs2_debug_read(struct f
 #endif	/* CONFIG_DEBUG_FS */
 
 static const struct file_operations ocfs2_osb_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		ocfs2_osb_debug_open,
 	.release =	ocfs2_debug_release,
 	.read =		ocfs2_debug_read,


