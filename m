Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D492F12AC;
	Sat, 12 Sep 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242349; cv=none; b=hgjjJ+JkSmYaAaSczIqJZdr0Jk+xlK1PaWh5U3NtRe43vyh3RWrnYSghtplauAvrIT7qQH4QFrQQSURah5g+G8nvmFJhee5qiUd2px5QaFu6Vn9q8rM7I5G1D6aiD5Wryoe0z8iDI2aJTtw2ZKSRNVTprcedEeGxmHAVhBncWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242349; c=relaxed/simple;
	bh=vm5+z0jxVCTkjpZcaqvuEaAxo8HMMMiIY7w7OFfh17k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPX4aSVmnP6FmEEaVLehw3sKha21qkp7fW/DSH8PYxm9EIeNXeyroB141PdpspUXWDI0iWFe22RRSd6DfBmqPTuyvk6CvCLjtRXaxXJxCnqEtXlwGzG1yk9nrG3o4Dopd4v9SNmUHXCDeV2JtSfydrNDkqsqjpkrUE6cvz1nVrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GammgrTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GammgrTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0B61F000FF;
	Sat, 12 Sep 2026 19:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242348;
	bh=5nqqJUMljGk3URMm2PAaDr37uyPhJy3kTARwwOKp1So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GammgrTJoHNZLBPEPJ0Hy3qs4dhBh9ob96569w1yiki6vrcHJag203m18qDJuBoJn
	 cUV85f8Qc6Qx0sIckSdtmjNUzbpPWOAf1w1/xXU2xH1hE94QHEO7epe3bw3NbUyBzh
	 yP/E0+dLKX8AhdRm6aZJ00VW9SQpBRbiqIUFn1ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 335/798] Smack: fix W=1 build warnings
Date: Sat, 12 Sep 2026 08:59:23 +0200
Message-ID: <20260912065524.840811014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 074c7ebfffd04..94d6eac268550 100644
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
@@ -1245,6 +1245,7 @@ static int smack_inode_getattr(const struct path *path)
 
 /**
  * smack_inode_setxattr - Smack check for setting xattrs
+ * @mnt_userns: active user namespace
  * @dentry: the object
  * @name: name of the attribute
  * @value: value of the attribute
@@ -1371,6 +1372,7 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 
 /**
  * smack_inode_removexattr - Smack check on removexattr
+ * @mnt_userns: active user namespace
  * @dentry: the object
  * @name: name of the attribute
  *
@@ -1429,6 +1431,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 
 /**
  * smack_inode_getsecurity - get smack xattrs
+ * @mnt_userns: active user namespace
  * @inode: the object
  * @name: attribute name
  * @buffer: where to put the result
@@ -1664,13 +1667,14 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
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
@@ -3084,7 +3088,7 @@ static int smack_sem_associate(struct kern_ipc_perm *isp, int semflg)
 }
 
 /**
- * smack_sem_shmctl - Smack access check for sem
+ * smack_sem_semctl - Smack access check for sem
  * @isp: the object
  * @cmd: what it wants to do
  *
@@ -3230,7 +3234,7 @@ static int smack_msg_queue_msgsnd(struct kern_ipc_perm *isp, struct msg_msg *msg
 }
 
 /**
- * smack_msg_queue_msgsnd - Smack access check for msg_queue
+ * smack_msg_queue_msgrcv - Smack access check for msg_queue
  * @isp: the object
  * @msg: unused
  * @target: unused
@@ -3239,8 +3243,10 @@ static int smack_msg_queue_msgsnd(struct kern_ipc_perm *isp, struct msg_msg *msg
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



