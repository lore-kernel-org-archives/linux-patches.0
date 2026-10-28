Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216288;
	b=iVCJJszWbzXO3VdqNPU3LNCidW6GoTP8d3m1jtgCY4NVUBU1KurHPiG44fyAvy+4E7qs
	 NVyRsgKOD56VKtlqy20Hv3hKPPxc0bawUPZd6B3IFnEOEhL4ZrxlURJWbIzpCcab6skee
	 3hcxdVYE/EPvhQq4jXNvvbQxSUFCE/Q612AazNCuYOYQ58Zva1NHQ7/rhGUYqSw4qzxAq
	 7ywMmrkEEET6D269/4Tlb/O0LTMV1H34cJpRIMh7iK2qeMV0UHocrFS/Y1ykkYpNHN9uV
	 AYy0KqvovfP7+3jl9nNUWqvxUO0tyL5gS+2dwab4E/y9N3oGu7DTeDf/v6udFRUEfzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFWn7h/u3dFX41DgFUIB67xqkl5xZ1I6PzfuT8i7mP4=;
	b=onSa9v/Uax5yk4H3YpLJ0lLuxVIqsEx/pu3UcvXRSJoeOYQwp1ttGtafgZZ24BiIWat5
	 3soo4jGVKrW2D3Lq+MFCZMOQ5X8WxmwbMHJYo9/lGo3uMbg2nPxHxpNJpbFPWF7Ry7NMG
	 BcIOVIjHkxThTGLxwD3tDNlQmvdvnN/AhozjfLuMNTyQj+dxsXCC665pf57HggUsdrFXQ
	 AIowWhj4SzzoCczBbtF/SDBjED4fQDbOTXzshD7P6rDoDx8upDdcWAwTnP09hxR+QQSa9
	 7hBH+dq0ZTQqf3nquObvYVQkoB5vB9pi6fLlbQZe8U119piInPi2m+kBUk7KsbV3PiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZCCURWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765D6606A334;
	Wed, 28 Oct 2026 19:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZCCURWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808301F01828;
	Wed, 28 Oct 2026 19:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216288;
	bh=DFWn7h/u3dFX41DgFUIB67xqkl5xZ1I6PzfuT8i7mP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZCCURWk1VWul2rHPrcaDYbtBqHS5BJm501ZOcb3J4l4eedD1dMxoA1tzdzpBJBp7
	 tY7uFRGLMuALFaIdPFzOzpjMPUcO6nnFwi/9TXb3yBIAd3cyo0aYtzkI7DjfmU9Cww
	 AW7WkFZIuiHGtT+90zi1PMXxMS2FDG3YUc7WVyn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1462/1887] bpf: Reject sleepable BPF_LSM_CGROUP programs at load time
Date: Wed, 28 Oct 2026 17:59:18 +0100
Message-ID: <20261028170532.725736597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Windsor <dwindsor@gmail.com>

[ Upstream commit 5b038319be442c620f774e6fc9e9283deeca1c75 ]

The cgroup shim runs under rcu_read_lock_dont_migrate(), so we should
not attach any sleepable BPF programs there. Add support to the verifier
to explicitly reject attempts to load sleepable BPF programs destined
for LSM cgroup attachment.

Without this, we get the following splat from a BPF_LSM_CGROUP
program marked BPF_F_SLEEPABLE attached to file_open when it calls
bpf_get_dentry_xattr():

  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1567
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 34317, name: load
  preempt_count: 0, expected: 0
  RCU nest depth: 2, expected: 0
  Call Trace:
   down_read+0x76/0x480
   ext4_xattr_get+0x11f/0x700
   __vfs_getxattr+0xf0/0x150
   bpf_get_dentry_xattr+0xbb/0xf0
   bpf_prog_e76a298dac9218c6_test_open+0x6a/0x85
   __cgroup_bpf_run_lsm_current+0x326/0x840
   bpf_trampoline_6442534646+0x62/0x14d
   security_file_open+0x34/0x60
   do_dentry_open+0x340/0x1260
   vfs_open+0x7a/0x440
   path_openat+0x1bac/0x30a0

libbpf provides a .s named section variant for every sleepable
program type except lsm_cgroup, reflecting that per-cgroup LSM programs
are intended to only run in a non-sleepable context.

The above splat was obtained by bypassing libbpf by using bpf(2)
directly.

Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
Signed-off-by: David Windsor <dwindsor@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20260605145707.608579-1-dwindsor@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2e26fdfa59e99..1ba6ce6765e0c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15433,6 +15433,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return -EINVAL;
 	}
 
+	if (prog->aux->sleepable && prog->type == BPF_PROG_TYPE_LSM &&
+	    prog->expected_attach_type == BPF_LSM_CGROUP) {
+		verbose(env, "BPF_LSM_CGROUP programs cannot be sleepable\n");
+		return -EINVAL;
+	}
+
 	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
 		return check_struct_ops_btf_id(env);
 
-- 
2.53.0



