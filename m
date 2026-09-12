Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FEA39BFFE;
	Sat, 12 Sep 2026 18:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238115; cv=none; b=YrFe8eW/NmCj33d/+OJwewI/JGLg9ALeUHgb/pNzBx0tR61aDK0h4Rcd2GTfjTCLfT1Fx/i0IamjPjS6M1VsnUix76Lh+M30Jg9BRZK/Yo9pS/1DzImapGXsK2EHWrmbRMXvLpjuSXdhn3L6OA7VgpIqyCWX+z12I82fO++mf0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238115; c=relaxed/simple;
	bh=BQ94MkfligErha2sS+x2kuaKNFepY31pRPjtoyLCROk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6EGjuh8hU3q1Tjl3kvpW1HU090rr/MEyWNWYor7bAgIQX8UbHrHEwQNkvLPDhySXhWTxwEkG3+JhgBv6b66dHCTUhHmEiUwCnd8/NXF4J4A13FmFSxrfb7VfNM2Qif5H4GROo3OmsAUOe7izKzS6k9oRHVgh5RsPZ4jqFwD9w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Agxmluov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Agxmluov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173861F000FF;
	Sat, 12 Sep 2026 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238114;
	bh=rtcx0RnP37LvG10aBnGwn8ZKOcsN8FLQvoqbJYTayNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgxmluovYnHVTnDJhZGK5qJNinmV8RJuvJybZPo+Vum8BUxJFTBkCho5arT/KAzix
	 mgCFccD0J1fDTRmBslFT79FvNyN8jj0nYzTKabsT3yEWJMrYvhH5vzkW31T4Oso0ND
	 Kyuz+0D/4w7HEEO3rSox7t+rAMNjW10Boe6anThw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/935] Smack: fix W=1 build warnings
Date: Sat, 12 Sep 2026 08:57:04 +0200
Message-ID: <20260912065535.859967864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit b57d02091b8f5eae1fce5652bb2b53857cd3c720 ]

A couple of functions had malformed comment blocks.
Namespace parameters were added without updating the
comment blocks. These are all repaired in the Smack code,
so "% make W=1 security/smack" is warning free.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Stable-dep-of: fba3d32825f4 ("smack: fix incorrect task context in smack_msg_queue_msgrcv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 29fb25caadec1..574a740eb1be7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -389,7 +389,7 @@ static int smk_copy_relabel(struct list_head *nhead, struct list_head *ohead,
 
 /**
  * smk_ptrace_mode - helper function for converting PTRACE_MODE_* into MAY_*
- * @mode - input mode in form of PTRACE_MODE_*
+ * @mode: input mode in form of PTRACE_MODE_*
  *
  * Returns a converted MAY_* mode usable by smack rules
  */
@@ -1228,6 +1228,7 @@ static int smack_inode_getattr(const struct path *path)
 
 /**
  * smack_inode_setxattr - Smack check for setting xattrs
+ * @mnt_userns: active user namespace
  * @dentry: the object
  * @name: name of the attribute
  * @value: value of the attribute
@@ -1355,6 +1356,7 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 
 /**
  * smack_inode_removexattr - Smack check on removexattr
+ * @mnt_userns: active user namespace
  * @dentry: the object
  * @name: name of the attribute
  *
@@ -1414,6 +1416,7 @@ static int smack_inode_removexattr(struct user_namespace *mnt_userns,
 
 /**
  * smack_inode_getsecurity - get smack xattrs
+ * @mnt_userns: active user namespace
  * @inode: the object
  * @name: attribute name
  * @buffer: where to put the result
@@ -1649,13 +1652,14 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 }
 
 /**
- * smack_mmap_file :
- * Check permissions for a mmap operation.  The @file may be NULL, e.g.
- * if mapping anonymous memory.
- * @file contains the file structure for file to map (may be NULL).
- * @reqprot contains the protection requested by the application.
- * @prot contains the protection that will be applied by the kernel.
- * @flags contains the operational flags.
+ * smack_mmap_file - Check permissions for a mmap operation.
+ * @file: contains the file structure for file to map (may be NULL).
+ * @reqprot: contains the protection requested by the application.
+ * @prot: contains the protection that will be applied by the kernel.
+ * @flags: contains the operational flags.
+ *
+ * The @file may be NULL, e.g. if mapping anonymous memory.
+ *
  * Return 0 if permission is granted.
  */
 static int smack_mmap_file(struct file *file,
@@ -3083,7 +3087,7 @@ static int smack_sem_associate(struct kern_ipc_perm *isp, int semflg)
 }
 
 /**
- * smack_sem_shmctl - Smack access check for sem
+ * smack_sem_semctl - Smack access check for sem
  * @isp: the object
  * @cmd: what it wants to do
  *
@@ -3229,7 +3233,7 @@ static int smack_msg_queue_msgsnd(struct kern_ipc_perm *isp, struct msg_msg *msg
 }
 
 /**
- * smack_msg_queue_msgsnd - Smack access check for msg_queue
+ * smack_msg_queue_msgrcv - Smack access check for msg_queue
  * @isp: the object
  * @msg: unused
  * @target: unused
@@ -3238,8 +3242,10 @@ static int smack_msg_queue_msgsnd(struct kern_ipc_perm *isp, struct msg_msg *msg
  *
  * Returns 0 if current has read and write access, error code otherwise
  */
-static int smack_msg_queue_msgrcv(struct kern_ipc_perm *isp, struct msg_msg *msg,
-			struct task_struct *target, long type, int mode)
+static int smack_msg_queue_msgrcv(struct kern_ipc_perm *isp,
+				  struct msg_msg *msg,
+				  struct task_struct *target, long type,
+				  int mode)
 {
 	return smk_curacc_msq(isp, MAY_READWRITE);
 }
-- 
2.53.0



