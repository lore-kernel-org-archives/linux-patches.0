Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028831;
	b=WKJYqUG0qmbRvK8WtHYJqoL+5d/Y6woQPRNzBFTjM9wioZyWQvVYq/7TcOYYJvZKZh2Y
	 y8VO4fYamu7cQTQ1j2yWFnofeauYNeg1f/hThkFsnoca1mctismbl3hNK3YOYTP38cfek
	 qykHZgeRv8K0+RV8d/jrMlnE86fCApNHL1caNEhHjPwCjCRg/KalzKXfHv0lVEjjVwR8m
	 wYGHQTzoy0hKFzForoKrwmQp7MPx1bdAjqFH/qyE6381KegpRlMQvw3KYWQyTz1bIsyFR
	 dx1/NDvHQpKTu6JUadPvyREX20/FOLpE8dCcfx60QedbA9km0PJfv/cJk0PzJ4UIXeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8cZRMm/8Ba1ugNKMBbnRznGdugiBFg2I+S3hWAqQVlI=;
	b=evNm/7IR1EB5l6LsxjfDJInB0zZ48ZKqbsf8yrd9ixsZpLqeOTdJdaYknd2L/RKRj7/o
	 P9weEqMCch92Ho88QHDdcdpLOm1EDpjVWU+qoSi/wm6UKNw1zYrrBrkQZp8yQtPZOems+
	 PS3fxEdI0OCh/1Cer2ypOip6EP5HvSFLfHbjjsT4vRD8JpzsztlHFmJD7c/wKMR+ZVjsN
	 e5qEfU+LhY0YzFRnBAeuXhZrFM4VH+EBO8zIOqQrc47uZoMmvj2UVb766W9lL/AobRAB5
	 fRXJ3MIOAaxr6ANRbqk2lHhZquT/Msr6ttT2bAFgdDDHXRHSMIxfxIRSLDY0TXHbPAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2jBfOsO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBC4606A334;
	Wed, 18 Nov 2026 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2jBfOsO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEC41F000C4;
	Wed, 18 Nov 2026 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028830;
	bh=8cZRMm/8Ba1ugNKMBbnRznGdugiBFg2I+S3hWAqQVlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2jBfOsOcSAmk12TEXUp1DbxxyNFTInyKSl/Be/45kkZ1ivu4mHq2EUlwy2Byhc4B
	 ZAowrCEtBae+VBQiLclDpG+8XlUs5Kd/ez9RVlil3/F4SvbrEjmkD08lwgWLhdIQZU
	 +waL0PUwxHLCgcbTIieG1PruVUrItZoWUypalbzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0134/1756] bpf: Mark dentry->d_inode as trusted_or_null
Date: Wed, 18 Nov 2026 15:37:41 +0100
Message-ID: <20261118150013.515667526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

[ Upstream commit a766cfbbeb3a74397965a8fa2e9a402026d3e1d8 ]

LSM hooks such as security_path_mknod() and security_inode_rename() have
access to newly allocated negative dentry, which has NULL d_inode.
Therefore, it is necessary to do the NULL pointer check for d_inode.

Also add selftests that checks the verifier enforces the NULL pointer
check.

Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Matt Bobrowski <mattbobrowski@google.com>
Link: https://lore.kernel.org/r/20250613052857.1992233-1-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: aed1bf1a352a ("bpf: sched_ext: Mark ops argument container pointer fields as trusted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                          |  5 ++---
 .../selftests/bpf/progs/verifier_vfs_accept.c  | 18 ++++++++++++++++++
 .../selftests/bpf/progs/verifier_vfs_reject.c  | 15 +++++++++++++++
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ecd8595bd5450..5d45edb98e3e3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6850,8 +6850,7 @@ BTF_TYPE_SAFE_TRUSTED(struct file) {
 	struct inode *f_inode;
 };
 
-BTF_TYPE_SAFE_TRUSTED(struct dentry) {
-	/* no negative dentry-s in places where bpf can see it */
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
 
@@ -6889,7 +6888,6 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct file));
-	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct dentry));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_trusted");
 }
@@ -6899,6 +6897,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 				    const char *field_name, u32 btf_id)
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
 					  "__safe_trusted_or_null");
diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
index a7c0a553aa501..3e2d76ee8050f 100644
--- a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
+++ b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2024 Google LLC. */
 
 #include <vmlinux.h>
+#include <errno.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
@@ -82,4 +83,21 @@ int BPF_PROG(path_d_path_from_file_argument, struct file *file)
 	return 0;
 }
 
+SEC("lsm.s/inode_rename")
+__success
+int BPF_PROG(inode_rename, struct inode *old_dir, struct dentry *old_dentry,
+	     struct inode *new_dir, struct dentry *new_dentry,
+	     unsigned int flags)
+{
+	struct inode *inode = new_dentry->d_inode;
+	ino_t ino;
+
+	if (!inode)
+		return 0;
+	ino = inode->i_ino;
+	if (ino == 0)
+		return -EACCES;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c b/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
index d6d3f4fcb24c4..4b392c6c8fc41 100644
--- a/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
+++ b/tools/testing/selftests/bpf/progs/verifier_vfs_reject.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2024 Google LLC. */
 
 #include <vmlinux.h>
+#include <errno.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <linux/limits.h>
@@ -158,4 +159,18 @@ int BPF_PROG(path_d_path_kfunc_non_lsm, struct path *path, struct file *f)
 	return 0;
 }
 
+SEC("lsm.s/inode_rename")
+__failure __msg("invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(inode_rename, struct inode *old_dir, struct dentry *old_dentry,
+	     struct inode *new_dir, struct dentry *new_dentry,
+	     unsigned int flags)
+{
+	struct inode *inode = new_dentry->d_inode;
+	ino_t ino;
+
+	ino = inode->i_ino;
+	if (ino == 0)
+		return -EACCES;
+	return 0;
+}
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



