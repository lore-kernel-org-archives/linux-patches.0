Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E05143B48C;
	Tue, 21 Jul 2026 22:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674723; cv=none; b=QHZ9a9eLCLL2AlRIFJmWk3LlTVxgC/jIb3MxqStuNmKJbXi5ljBVE1+PfERjWZDdqFAGXTrpMVamits76ZWjvJmnbTbuYH9Ukg6hyWYLeI75+kJSNyD7mcEjt1F9mZR/9AwhtQYAUjdrlyu5USt/2tvKpBfSDUwYN3Fkw4WJIBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674723; c=relaxed/simple;
	bh=ZYRBDLvkcXZbBbOEU8nFtNAlVK0LRLAabLYM6RCHkj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdCUebDrqMdZkRuxL8xtiug/nSVCX0azBGV2rcpxfYM1o3H1c9c1WOdR/8DifQpw8re5ZYQAxmDu3Sy3OteqeiaALa9CwizLNa9+CJ/aVIBuYTC9NE2uOGn4MSmByCuWWaK3e7txIXhxUsd39TiedsIrGZf8N+0fbI/rXjlnpO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ztDFQC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ztDFQC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D8F1F000E9;
	Tue, 21 Jul 2026 22:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674721;
	bh=T20hh2ns5dUfCTI3XjSnaDU/RM2AWDwoKNjdVHBwacg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ztDFQC961AN8Hv9UI0FTzsOSiHOQ/PTo1MbFgZlW+bVciF35oZTUGX3IkXEkX7DL
	 Ln9OWs+k0agPFJi5hyblrOz3xQgd5M+HzpA5A19vPr6koR6JuaXW/l+CT9sUh6HVls
	 K00KYspuLwzvVqCNUePq1kYzv6jNw9vhvFYqLkBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 649/699] proc: rename proc_setattr to proc_nochmod_setattr
Date: Tue, 21 Jul 2026 17:26:48 +0200
Message-ID: <20260721152410.395942209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 690005b0b1e6b567c88b7790e6d90d4d6c9e09cc ]

What is currently proc_setattr is a special version added after the more
general procfs ->seattr in commit 6d76fa58b050 ("Don't allow chmod() on
the /proc/<pid>/ files").  Give it a name that reflects that to free the
proc_setattr name and better describe what is doing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260325063711.3298685-5-hch@lst.de
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 6255da28d4bb ("proc: protect ptrace_may_access() with exec_update_lock (FD links)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c       |   22 +++++++++++-----------
 fs/proc/fd.c         |    4 ++--
 fs/proc/internal.h   |    2 +-
 fs/proc/namespaces.c |    4 ++--
 fs/proc/proc_net.c   |    2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -720,7 +720,7 @@ static int proc_fd_access_allowed(struct
 	return allowed;
 }
 
-int proc_setattr(struct dentry *dentry, struct iattr *attr)
+int proc_nochmod_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int error;
 	struct inode *inode = d_inode(dentry);
@@ -792,7 +792,7 @@ static int proc_pid_permission(struct in
 
 
 static const struct inode_operations proc_def_inode_operations = {
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static int proc_single_show(struct seq_file *m, void *v)
@@ -1863,7 +1863,7 @@ out:
 const struct inode_operations proc_pid_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.get_link	= proc_pid_get_link,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 
@@ -2311,7 +2311,7 @@ proc_map_files_get_link(struct dentry *d
 static const struct inode_operations proc_map_files_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.get_link	= proc_map_files_get_link,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static struct dentry *
@@ -2390,7 +2390,7 @@ out:
 static const struct inode_operations proc_map_files_inode_operations = {
 	.lookup		= proc_map_files_lookup,
 	.permission	= proc_fd_permission,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static int
@@ -2882,7 +2882,7 @@ static struct dentry *proc_##LSM##_attr_
 static const struct inode_operations proc_##LSM##_attr_dir_inode_ops = { \
 	.lookup		= proc_##LSM##_attr_dir_lookup, \
 	.getattr	= pid_getattr, \
-	.setattr	= proc_setattr, \
+	.setattr	= proc_nochmod_setattr, \
 }
 
 #ifdef CONFIG_SECURITY_SMACK
@@ -2941,7 +2941,7 @@ static struct dentry *proc_attr_dir_look
 static const struct inode_operations proc_attr_dir_inode_operations = {
 	.lookup		= proc_attr_dir_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 #endif
@@ -3395,7 +3395,7 @@ static struct dentry *proc_tgid_base_loo
 static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 	.permission	= proc_pid_permission,
 };
 
@@ -3594,7 +3594,7 @@ static int proc_tid_comm_permission(stru
 }
 
 static const struct inode_operations proc_tid_comm_inode_operations = {
-		.setattr	= proc_setattr,
+		.setattr	= proc_nochmod_setattr,
 		.permission	= proc_tid_comm_permission,
 };
 
@@ -3718,7 +3718,7 @@ static const struct file_operations proc
 static const struct inode_operations proc_tid_base_inode_operations = {
 	.lookup		= proc_tid_base_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static struct dentry *proc_task_instantiate(struct dentry *dentry,
@@ -3913,7 +3913,7 @@ static int proc_task_getattr(const struc
 static const struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 	.permission	= proc_pid_permission,
 };
 
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -297,7 +297,7 @@ int proc_fd_permission(struct inode *ino
 const struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
 	.permission	= proc_fd_permission,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static struct dentry *proc_fdinfo_instantiate(struct dentry *dentry,
@@ -335,7 +335,7 @@ static int proc_readfdinfo(struct file *
 
 const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 const struct file_operations proc_fdinfo_operations = {
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -177,7 +177,7 @@ extern int proc_pid_statm(struct seq_fil
  */
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(const struct path *, struct kstat *, u32, unsigned int);
-extern int proc_setattr(struct dentry *, struct iattr *);
+int proc_nochmod_setattr(struct dentry *dentry, struct iattr *attr);
 extern void proc_pid_evict_inode(struct proc_inode *);
 extern struct inode *proc_pid_make_inode(struct super_block *, struct task_struct *, umode_t);
 extern void pid_update_inode(struct task_struct *, struct inode *);
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -92,7 +92,7 @@ static int proc_ns_readlink(struct dentr
 static const struct inode_operations proc_ns_link_inode_operations = {
 	.readlink	= proc_ns_readlink,
 	.get_link	= proc_ns_get_link,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static struct dentry *proc_ns_instantiate(struct dentry *dentry,
@@ -179,5 +179,5 @@ out_no_task:
 const struct inode_operations proc_ns_dir_inode_operations = {
 	.lookup		= proc_ns_dir_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -310,7 +310,7 @@ static int proc_tgid_net_getattr(const s
 const struct inode_operations proc_net_inode_operations = {
 	.lookup		= proc_tgid_net_lookup,
 	.getattr	= proc_tgid_net_getattr,
-	.setattr        = proc_setattr,
+	.setattr        = proc_nochmod_setattr,
 };
 
 static int proc_tgid_net_readdir(struct file *file, struct dir_context *ctx)


