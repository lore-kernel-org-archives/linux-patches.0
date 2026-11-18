Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022769;
	b=CYpgcWlO8gcnp0KB60vpFP16/Df+rm4UqJ5CfX+nvvpGckpe4f6R8usgpvgOJLaQnEDi
	 56VDN8Uj/mlu0xiNYNUzM7zyUN6mEHWcscPoLt71M/W65wFUrxM3Xk8AHANXAaVLRarkg
	 wIfMcQwiGSwSft9a4910UdXtUO7bEBu/Ddr6zGxofBdEUbxT+/5D0ChAyCGaAGvh2/z7A
	 CUaTdpJtbDo1JWlmJOqPBo69qDJwgUqrMn5H32MGmYUFubzrxqJWZDwpNcCIj0twfEvRr
	 YXqWBRD6rO9lxwP/r2PYEwXrJO04DGn9PQ3bdf8RkIuXdiyf7SZch2Tq0zEfHeBgVgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=974Rls0lWClN0mTiWid5FEvEuPfvpN2IHwPfg7LHzDM=;
	b=UMIb/8ZkIXnbJJiJRTXVAzv0MynA4vaFXgtNydcjNvqBga4yg36rKxztKeCUnY7q/ajR
	 1x94Ji7g0Iu3AaIcou8Bhr9s8U4r3tq9iXfmcjZYGIvZhpbCknHr8SKq4+pclIMQGoj21
	 xMyx0FtdCgbPMh2HTdH10ZbKZUizimqikijwU2QGZGP8c49uJQ2dRBujD3F2hcpqNZ646
	 UHhC8knZeBLNEKHFOP2ejoqnOnttKae9PcFuW8Zk+tLAlSxykfn9P02LF2H4P4kB4zBoK
	 wYdAN1KetJAwLb3KZ2pMSPAF5/gwYZtZ+nLNMIZLS6ZzQdj5gU/ppI9FAQP3znNsVJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5SI2JGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65687606CA7A;
	Wed, 18 Nov 2026 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5SI2JGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6614A1F000C6;
	Wed, 18 Nov 2026 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022768;
	bh=974Rls0lWClN0mTiWid5FEvEuPfvpN2IHwPfg7LHzDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5SI2JGxwSVkB8L5oIP8z2PhEkncmhFLBNM3+ayc+dCClNZSkh8eNEYbwBkbtJKHe
	 xY23kun9LgZEllHDWAou/+KFQQrYO8po927NFMdCIhTlzewppF0W3gbcFgcYFPZwP/
	 bdvdyEfcWaJ56K2WATrm7b+MnsWIv9CS1QE05u2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0130/2151] bpf: sched_ext: Mark ops argument container pointer fields as trusted
Date: Wed, 18 Nov 2026 15:31:05 +0100
Message-ID: <20261118150126.527528260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b89a5d717e422..1ce3bfc12b304 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7304,6 +7304,28 @@ BTF_TYPE_SAFE_TRUSTED(struct file) {
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
@@ -7343,6 +7365,10 @@ static bool type_is_trusted(struct bpf_verifier_env *env,
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



