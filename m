Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33A9383983;
	Thu, 30 Jul 2026 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426694; cv=none; b=LoQcgh+EmxwTmh6IU/mFzCBVrGk91SzAXZrI5cqP75zcqk5p72EJZRzNvRyL1nZJgRJ0+cQvCLWgnfGRiILzgEt9X9VgAdms0SBJRzE4mNaUWkFr/GyuChpIeTjG8vWAc5COSS5OzP0kcZOwlUnlN4id8xaxp9NHNeJJzrubx4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426694; c=relaxed/simple;
	bh=bzYgSgTi18AmUhMpOexN4UAq9cgKxTemthWSggJXl8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwnJWlVeYVMcD7lYjYFSHDJ5THSfZZrQR5UOWyyHPZ5eA+MozcPUcsiV1A+tAlKF1rj49AQuDjpv0or9E6iJoe0Kvkwyl9o7pNBSyArpKHgF1cwRjMqeF01B/bgm/z3ckidJ6fhM1msi2VbSSuIh08kAw23l2zxXT3JZkQcwToA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KV1sYOyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KV1sYOyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B64D1F000E9;
	Thu, 30 Jul 2026 15:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426692;
	bh=fuH7GQOhQQLQppxYoVj69+8swTokp7dRE6kVk+FP508=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KV1sYOyvWeNmt3GeGdBolnQkUiNUHRgeWQb3elqa0PJ2e6JKoA93pjdbwpNANTnRS
	 LZlcCrnAWWEZi7V8w3yRqF4aRopmD7bqdDCf7h2upReNeyqDTNE+bu8in9SIBbfyPJ
	 ksnkvQ/6zArQnq1Jo4zS6ddgDuIjNc2jp2Qn5b5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 472/602] audit: use unsigned int instead of unsigned
Date: Thu, 30 Jul 2026 16:14:24 +0200
Message-ID: <20260730141445.881432096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Ricardo Robaina <rrobaina@redhat.com>

[ Upstream commit 8b226771014beab1292081151a99530886ce54b4 ]

Address checkpatch.pl warning below, across the audit subsystem:

  WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

Minor cleanup, no functional changes.

Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: 81905b5acbe7 ("audit: fix recursive locking deadlock in audit_dupe_exe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/audit.h      |    4 ++--
 include/linux/audit_arch.h |   12 ++++++------
 kernel/audit.c             |    2 +-
 kernel/audit.h             |    2 +-
 kernel/audit_tree.c        |    2 +-
 kernel/auditfilter.c       |    8 ++++----
 kernel/auditsc.c           |    2 +-
 lib/compat_audit.c         |   12 ++++++------
 8 files changed, 22 insertions(+), 22 deletions(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -123,8 +123,8 @@ enum audit_nfcfgop {
 	AUDIT_NFT_OP_INVALID,
 };
 
-extern int __init audit_register_class(int class, unsigned *list);
-extern int audit_classify_syscall(int abi, unsigned syscall);
+extern int __init audit_register_class(int class, unsigned int *list);
+extern int audit_classify_syscall(int abi, unsigned int syscall);
 extern int audit_classify_arch(int arch);
 
 /* audit_names->type values */
--- a/include/linux/audit_arch.h
+++ b/include/linux/audit_arch.h
@@ -21,13 +21,13 @@ enum auditsc_class_t {
 	AUDITSC_NVALS /* count */
 };
 
-extern int audit_classify_compat_syscall(int abi, unsigned syscall);
+extern int audit_classify_compat_syscall(int abi, unsigned int syscall);
 
 /* only for compat system calls */
-extern unsigned compat_write_class[];
-extern unsigned compat_read_class[];
-extern unsigned compat_dir_class[];
-extern unsigned compat_chattr_class[];
-extern unsigned compat_signal_class[];
+extern unsigned int compat_write_class[];
+extern unsigned int compat_read_class[];
+extern unsigned int compat_dir_class[];
+extern unsigned int compat_chattr_class[];
+extern unsigned int compat_signal_class[];
 
 #endif
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1985,7 +1985,7 @@ static void audit_log_vformat(struct aud
 		 * here and AUDIT_BUFSIZ is at least 1024, then we can
 		 * log everything that printk could have logged. */
 		avail = audit_expand(ab,
-			max_t(unsigned, AUDIT_BUFSIZ, 1+len-avail));
+			max_t(unsigned int, AUDIT_BUFSIZ, 1+len-avail));
 		if (!avail)
 			goto out_va_end;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -227,7 +227,7 @@ static inline int audit_hash_ino(u64 ino
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
-extern int audit_match_class(int class, unsigned syscall);
+extern int audit_match_class(int class, unsigned int syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
 extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
 extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -33,7 +33,7 @@ struct audit_chunk {
 	struct audit_node {
 		struct list_head list;
 		struct audit_tree *owner;
-		unsigned index;		/* index; upper bit indicates 'will prune' */
+		unsigned int index;	/* index; upper bit indicates 'will prune' */
 	} owners[] __counted_by(count);
 };
 
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -165,13 +165,13 @@ static inline int audit_to_inode(struct
 
 static __u32 *classes[AUDIT_SYSCALL_CLASSES];
 
-int __init audit_register_class(int class, unsigned *list)
+int __init audit_register_class(int class, unsigned int *list)
 {
 	__u32 *p = kcalloc(AUDIT_BITMASK_SIZE, sizeof(__u32), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 	while (*list != ~0U) {
-		unsigned n = *list++;
+		unsigned int n = *list++;
 		if (n >= AUDIT_BITMASK_SIZE * 32 - AUDIT_SYSCALL_CLASSES) {
 			kfree(p);
 			return -EINVAL;
@@ -186,7 +186,7 @@ int __init audit_register_class(int clas
 	return 0;
 }
 
-int audit_match_class(int class, unsigned syscall)
+int audit_match_class(int class, unsigned int syscall)
 {
 	if (unlikely(syscall >= AUDIT_BITMASK_SIZE * 32))
 		return 0;
@@ -237,7 +237,7 @@ static int audit_match_signal(struct aud
 /* Common user-space to kernel rule translation. */
 static inline struct audit_entry *audit_to_entry_common(struct audit_rule_data *rule)
 {
-	unsigned listnr;
+	unsigned int listnr;
 	struct audit_entry *entry;
 	int i, err;
 
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -150,7 +150,7 @@ static const struct audit_nfcfgop_tab au
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
-	unsigned n;
+	unsigned int n;
 
 	if (unlikely(!ctx))
 		return 0;
--- a/lib/compat_audit.c
+++ b/lib/compat_audit.c
@@ -4,32 +4,32 @@
 #include <linux/audit_arch.h>
 #include <asm/unistd32.h>
 
-unsigned compat_dir_class[] = {
+unsigned int compat_dir_class[] = {
 #include <asm-generic/audit_dir_write.h>
 ~0U
 };
 
-unsigned compat_read_class[] = {
+unsigned int compat_read_class[] = {
 #include <asm-generic/audit_read.h>
 ~0U
 };
 
-unsigned compat_write_class[] = {
+unsigned int compat_write_class[] = {
 #include <asm-generic/audit_write.h>
 ~0U
 };
 
-unsigned compat_chattr_class[] = {
+unsigned int compat_chattr_class[] = {
 #include <asm-generic/audit_change_attr.h>
 ~0U
 };
 
-unsigned compat_signal_class[] = {
+unsigned int compat_signal_class[] = {
 #include <asm-generic/audit_signal.h>
 ~0U
 };
 
-int audit_classify_compat_syscall(int abi, unsigned syscall)
+int audit_classify_compat_syscall(int abi, unsigned int syscall)
 {
 	switch (syscall) {
 #ifdef __NR_open


