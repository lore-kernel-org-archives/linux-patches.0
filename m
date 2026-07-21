Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1220246E00B;
	Tue, 21 Jul 2026 18:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659535; cv=none; b=j+l1h3rgdojITPBdJIdl4quGgX1pEBMs5Axt2eJmwLr8KRkVQhicQYJgtL2reLt7uaKVeqxcqhtVlWO7qGag+txwIa4XGw7TABJJLJSM+ukiha/AjGCbGraOhAjzo+zrktmSFi5kkQO+SqVVV5NclzUy6MFjQxdxO7HSLqyeZEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659535; c=relaxed/simple;
	bh=ltRqpmVsKGySUs2iFLxjwQsiI+B33pimrVLi7g650QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9IkxnZfi7fq2qcF23HOFVcSJzxsNSlJX+YbPEjD0pgrDlc6nsIhmZ/L/wjv0kFqf+/Z68Iljb+hpdDhWhx/1NSbtLODku5p3yylJetNnc8nLw1m4p7hWatHFL+HvDe4PFYgPmRLbRoBpY0e6xuobAQOHIl1iupHRsQA8q9F04o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HP+76qxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HP+76qxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D541F000E9;
	Tue, 21 Jul 2026 18:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659534;
	bh=BIQ5iPD+l8taIKg9nE71lviaeLIUwMc0bfkgVe13+wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HP+76qxsxBYIUylcHAQCD+ND8Cg9lxIa6qWxDI7+alUKHlUfgK6/wfnvGpKBFTKTj
	 2WItQxPuYejKNbw4loInZxcWzPw+9g9WQ7ty9GLR0RAaKhsYTyDpYiWEmChKjBdz1s
	 cxn2rD3vwuyLRahbxPzZmdqBxGMNTz8Dz4ZslQPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1557/1611] proc: rename proc_setattr to proc_nochmod_setattr
Date: Tue, 21 Jul 2026 17:27:53 +0200
Message-ID: <20260721152550.478920562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/proc/fd.c         |    6 +++---
 fs/proc/internal.h   |    4 ++--
 fs/proc/namespaces.c |    4 ++--
 fs/proc/proc_net.c   |    2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -721,7 +721,7 @@ static bool proc_fd_access_allowed(struc
 	return allowed;
 }
 
-int proc_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+int proc_nochmod_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct iattr *attr)
 {
 	int error;
@@ -794,7 +794,7 @@ static int proc_pid_permission(struct mn
 
 
 static const struct inode_operations proc_def_inode_operations = {
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static int proc_single_show(struct seq_file *m, void *v)
@@ -1866,7 +1866,7 @@ out:
 const struct inode_operations proc_pid_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.get_link	= proc_pid_get_link,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 
@@ -2319,7 +2319,7 @@ proc_map_files_get_link(struct dentry *d
 static const struct inode_operations proc_map_files_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.get_link	= proc_map_files_get_link,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static struct dentry *
@@ -2398,7 +2398,7 @@ out:
 static const struct inode_operations proc_map_files_inode_operations = {
 	.lookup		= proc_map_files_lookup,
 	.permission	= proc_fd_permission,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static int
@@ -2885,7 +2885,7 @@ static struct dentry *proc_##LSM##_attr_
 static const struct inode_operations proc_##LSM##_attr_dir_inode_ops = { \
 	.lookup		= proc_##LSM##_attr_dir_lookup, \
 	.getattr	= pid_getattr, \
-	.setattr	= proc_setattr, \
+	.setattr	= proc_nochmod_setattr, \
 }
 
 #ifdef CONFIG_SECURITY_SMACK
@@ -2944,7 +2944,7 @@ static struct dentry *proc_attr_dir_look
 static const struct inode_operations proc_attr_dir_inode_operations = {
 	.lookup		= proc_attr_dir_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 #endif
@@ -3460,7 +3460,7 @@ static struct dentry *proc_tgid_base_loo
 static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 	.permission	= proc_pid_permission,
 };
 
@@ -3659,7 +3659,7 @@ static int proc_tid_comm_permission(stru
 }
 
 static const struct inode_operations proc_tid_comm_inode_operations = {
-		.setattr	= proc_setattr,
+		.setattr	= proc_nochmod_setattr,
 		.permission	= proc_tid_comm_permission,
 };
 
@@ -3788,7 +3788,7 @@ static const struct file_operations proc
 static const struct inode_operations proc_tid_base_inode_operations = {
 	.lookup		= proc_tid_base_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static struct dentry *proc_task_instantiate(struct dentry *dentry,
@@ -4001,7 +4001,7 @@ static loff_t proc_dir_llseek(struct fil
 static const struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 	.permission	= proc_pid_permission,
 };
 
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -102,7 +102,7 @@ static int proc_fdinfo_permission(struct
 
 static const struct inode_operations proc_fdinfo_file_inode_operations = {
 	.permission	= proc_fdinfo_permission,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static const struct file_operations proc_fdinfo_file_operations = {
@@ -361,7 +361,7 @@ const struct inode_operations proc_fd_in
 	.lookup		= proc_lookupfd,
 	.permission	= proc_fd_permission,
 	.getattr	= proc_fd_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 static struct dentry *proc_fdinfo_instantiate(struct dentry *dentry,
@@ -402,7 +402,7 @@ static int proc_fdinfo_iterate(struct fi
 const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
 	.permission	= proc_fdinfo_permission,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
 
 const struct file_operations proc_fdinfo_operations = {
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -257,8 +257,8 @@ extern int proc_pid_statm(struct seq_fil
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct mnt_idmap *, const struct path *,
 		       struct kstat *, u32, unsigned int);
-extern int proc_setattr(struct mnt_idmap *, struct dentry *,
-			struct iattr *);
+int proc_nochmod_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+			struct iattr *attr);
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
@@ -178,5 +178,5 @@ out_no_task:
 const struct inode_operations proc_ns_dir_inode_operations = {
 	.lookup		= proc_ns_dir_lookup,
 	.getattr	= pid_getattr,
-	.setattr	= proc_setattr,
+	.setattr	= proc_nochmod_setattr,
 };
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -322,7 +322,7 @@ static int proc_tgid_net_getattr(struct
 const struct inode_operations proc_net_inode_operations = {
 	.lookup		= proc_tgid_net_lookup,
 	.getattr	= proc_tgid_net_getattr,
-	.setattr        = proc_setattr,
+	.setattr        = proc_nochmod_setattr,
 };
 
 static int proc_tgid_net_readdir(struct file *file, struct dir_context *ctx)


