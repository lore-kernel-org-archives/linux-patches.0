Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028833;
	b=qNc1WVhyhDuZ7Q9ho9o/c7TBxkDTBSbpzd0rn6Q2dx9rzl6UkLWijy3JvELjzhsjdPHw
	 xd7nRVTXzYLDAc7h4dmrdf2LcOKZGHoxUBsWaEWfchPo0La9DoeGjtT3VUxwsyTa5LYdI
	 VBLWt1gGNT2RcWIiy+fzsbfLNfLlRfRx7OZGdjZlknJ/oM8KJTZRwZUlxvxkrLA6KXnjI
	 Qh8KYKoQpzob/FtkvpBxSbcYVt2z5Ylmo2kzdswTEWuw19WQwFVDIKdp8HIIl7qNWlqD7
	 F5MP6wNxLS5d0/WB0YwN+ido2s+cFP4XAy3eq5tPCVUSvJnbNNt6u9O1ziHThgV17gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/PZgS5HypoXcmsYJ4XE9KwHQ9LvnPz2RY5d78C0t7SE=;
	b=v2rycy9a9sAcNqop8vLkHgNlTreeMG33tP/z+s2eqlEyvM6Mr8bQuQV8uaXgmAZs/XEO
	 CB13JJlu2iVYoI+GLeReuYKlTjDm9kQqHQda6R/dQOgOKSCZOqo1oLp5DHtMEdRcg4aQ/
	 rrVnstWY9L2wu7sUbWQBqqXlIkAEYPksyA5zEfNmC+f9/KyA82IYaSV0IWuBl4fJh+9mE
	 f02U/PCOxOkRzLqbcter9O/B6YVhUA0PJZsaQAvterMzJ+RJEmmuzY6laxO2nZ0zfL4yP
	 iHHJfqGsZs9z/zgnLmgm24YrPB9EWAqgsA6faVhFe1rPDZVezBTr2AamXN34e3V6mWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJoV3lLp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B353606A33F;
	Wed, 18 Nov 2026 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJoV3lLp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F311F000C4;
	Wed, 18 Nov 2026 19:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028832;
	bh=/PZgS5HypoXcmsYJ4XE9KwHQ9LvnPz2RY5d78C0t7SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJoV3lLpJv00NCyKUvv2t+1R/GAepOXj3GXeoI4xWIhhC48L/DC9FkzMCz7HTp1pH
	 p6Eo5av1j/MtZPcdjLeKYOH31nMvpi9/aqHLjUWAgota1Y4Ks+cmX2C3JPSmA1U05C
	 25Ly6SoNwfgn6uE9wnKGvJwJ/umL3MUmiUwUbp+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0135/1756] bpf: sched_ext: Mark ops argument container pointer fields as trusted
Date: Wed, 18 Nov 2026 15:37:42 +0100
Message-ID: <20261118150013.554165537@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit aed1bf1a352acd4f5ffd2a81e23d2bb6e8e9b636 ]

Walking an unannotated pointer field of a trusted struct yields a bare
PTR_TO_BTF_ID in non-sleepable programs, which kfuncs and helpers accept,
but PTR_UNTRUSTED in sleepable programs, which they reject. This gets in the
way of making ops.init_task() sleepable, which schedulers want for
allocations. For example, passing args->cgroup into bpf_cgrp_storage_get()
then fails verification and the only recourse is round-tripping through the
cgroup ID with bpf_cgroup_from_id().

The pointer fields in the sched_ext ops argument containers are all pinned
by the callers for the duration of the ops calls and are never NULL. Add
them to the verifier's trusted-fields whitelist so that they are PTR_TRUSTED
in both sleepable and non-sleepable programs.

Fixes: 8195136669661 ("sched_ext: Add cgroup support")
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/95d7ccc17681aa3a4a2eeb1b073f00f7@kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5d45edb98e3e3..7d29b6b77f4ea 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6850,6 +6850,28 @@ BTF_TYPE_SAFE_TRUSTED(struct file) {
 	struct inode *f_inode;
 };
 
+/*
+ * The pointer fields in the sched_ext ops argument containers are pinned by the
+ * callers for the duration of the ops calls and are never NULL.
+ */
+BTF_TYPE_SAFE_TRUSTED(struct scx_init_task_args) {
+#ifdef CONFIG_EXT_GROUP_SCHED
+	struct cgroup *cgroup;
+#endif
+};
+
+BTF_TYPE_SAFE_TRUSTED(struct scx_cpu_release_args) {
+	struct task_struct *task;
+};
+
+BTF_TYPE_SAFE_TRUSTED(struct scx_sub_attach_args) {
+	struct sched_ext_ops *ops;
+};
+
+BTF_TYPE_SAFE_TRUSTED(struct scx_sub_detach_args) {
+	struct sched_ext_ops *ops;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
@@ -6888,6 +6910,10 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct bpf_iter__task));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct file));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct scx_init_task_args));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct scx_cpu_release_args));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct scx_sub_attach_args));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED(struct scx_sub_detach_args));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_trusted");
 }
-- 
2.53.0



