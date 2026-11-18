Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015141;
	b=rETaflTv3Jx+HRLBm1pnvPUsVN5PmId2kU8oxoR7dIGWvwAUMTdcSQr4GjIq1tnIaYLk
	 0ZRB9ZJSdVdsXoreFty3+jPmFDDCwi79ujPG8eYCliFDQWOrUpsanQT9r1mSjX53rCxjJ
	 qX58+RlGfWT6iGzEyC0KyTnI1FD/uOKW00QHkIh4aH0xcuf+UVZcDZa0AIMQRGAUpzCfX
	 rECmr/N1UJG40UhtWT2QVp9SBQE8R/DTXGMT0wq2w41d3hGSWpA3XyG2oM7wcC4y4LwaN
	 P6+slauVSvBidjlzxFdzA4wyxwuAihZvSpLgxAPcEcJMEofkwkHytV4BFHNzSbeMSkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3SHqtvyrHfj5I/mFmjeSkLjNpB5fYPCWAC/JB1dNLVg=;
	b=aD/Gze9A5JrpC8+qr2sAgV4e6c69toi3nAhQKt119iQhUbKIGFK/4jMLVkWNH5eIB4lr
	 aAkjRzg59udEwhCBqypKeLy4ghXIohHu+SZmdZtKPUO3xZkHPxcibgK+Gz0ydh2WZLEWd
	 5uNS3RZd4PQ1scGsTcXjYkCp++wR2Zo2D/KGPFQqR0mrT136RKTV/5thCjmu/RlRdSyK5
	 ehIXyMQr4qCqlXAnBH/EqQWgtNcFF3+PvgSaCQQrLCaNTsQeRGjO2zveUAUpZfmn6ZVGn
	 vxv7CKozwzzIyQp+Dkn9uaTEV35/G8qH7zUFPyHsz35UIu8qN8YMrta6OTo74cN5kYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj2YmKyS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D86606A31C;
	Wed, 18 Nov 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj2YmKyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7261F000C7;
	Wed, 18 Nov 2026 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015141;
	bh=3SHqtvyrHfj5I/mFmjeSkLjNpB5fYPCWAC/JB1dNLVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cj2YmKyS7G5SuifyRDRwGohJ+q1p0wqa3cuSkAlzI35tRgL+SRK5BNAJ9YdwydWwD
	 8eh1RIjdNfT1zTN9AH9NSMcd3GAgITUL2yz2b7xpOuNThhLS8BIrrBsjC6S7E+o6tu
	 DGML9IpOf88CZHT3P5x2KxwvXvuuZYlCEQ94vYOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0065/2651] bpf: sched_ext: Mark ops argument container pointer fields as trusted
Date: Wed, 18 Nov 2026 15:21:45 +0100
Message-ID: <20261118150250.282089867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5f874979b8d75..bc87b15d4556c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5923,6 +5923,28 @@ BTF_TYPE_SAFE_TRUSTED(struct file) {
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
@@ -5967,6 +5989,10 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
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



