Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017267;
	b=MtcauptjVTa9Z2QZ+1lXDcbvrrebhwrBJ+jm+nMHxAiqmr72sa8AkUiooaB6tMQoPBTE
	 hNEk+yvwqVuz/aE5g9dXMU/DMefBYihgp66jLtj8PkKYWMp7CkgsWwEGkb0XecmGeqvfK
	 jMLgXxnPf3iMJlTHyi30P+F5IYsSenCoVaZYNPyJr65UjrJ6Upk3GD5buhvV5GWlYaSXw
	 xB/mZs8sHg8tR92NQX4BtKsaXGkqGVQkMi/CqUq/Jt2I5v9hcvfhTyvIfx9fHGciGZIiE
	 5tJyYXgHgdccvrQmI+MCK8YJQoNL9+q4ITbA4uNmywZguxkC9+XSl+zqAvlNZDdVKqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/9upeZjUe6l9qfm81Q4pCAfZmhdsGlsiy+bYjMxZ1f8=;
	b=slBgaNCpLbyNiFS+zdaNGpU4Q9fSXL3+52geV9duYvicV8Nr/SKqbOH/BKCWqJBAs8ef
	 Iz9pCDgeOkpQg5vjGLHP72jzgYhBjCpa0AG33G3oSUyRq0LUb+1z0yFOQNKY45sWcGa9X
	 iPDFj8RYiO4vLCVpdF0Fc0Zch8J9osOfUskoXithn8XuzVOATHHpbGr+bc7YS8u8dye9M
	 /lutkVnN/xVCX9Kp7Q4OMmhGDRfzujeGt6yE6qWIiLyyXAqzRGm5QEwk10n4713oChvPB
	 m9mDjxcipVW3O1p9IYfqaXJZsCLCuZkwdNmF8eMLHMK6egcSgz9GjOOLE5zLPaiLB4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=At0nzGM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368B2606A31C;
	Wed, 18 Nov 2026 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=At0nzGM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F201F000C4;
	Wed, 18 Nov 2026 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017266;
	bh=/9upeZjUe6l9qfm81Q4pCAfZmhdsGlsiy+bYjMxZ1f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=At0nzGM0WpklHXgMWF7MLYiYVbC9NK9kf2NNsQc4myDZHyuIEaBIMka7zFPuUer8n
	 44VcW9R+YLe7xV2Ja+b4DHK9kyabvT/sz9QRvIpwnsxSOFBIubLSdLb7MzY1J2FIEh
	 1GkzzxBLrSX71IGa5mYU2t8NeWHNrj3oaz5rHbzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0821/2651] bpf: Fix uninit read for non-fetch atomics on partially spilled slots
Date: Wed, 18 Nov 2026 15:34:21 +0100
Message-ID: <20261118150317.449289385@linuxfoundation.org>
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

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit 5a84b4424db8ae07f0ac682ab031c37a91dce50b ]

check_stack_read_fixed_off() skips partial spill checks for non-fetch
atomics; the following prog can be loaded:

0: (b7) r1 = 1                        ; R1=1
1: (63) *(u32 *)(r10 -8) = r1         ; R1=1 R10=fp0 fp-8=????1
2: (db) lock *(u64 *)(r10 -8) += r1   ; R1=1 R10=fp0 fp-8=mmmmmmmm
3: (79) r0 = *(u64 *)(r10 -8)         ; R0=scalar() R10=fp0 fp-8=mmmmmmmm
4: (77) r0 >>= 32                     ; R0=scalar(smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
5: (95) exit

When test run:
	retval=4294967295

Note fp-8 is ????1 at #1, yet it becomes fp-8=mmmmmmmm after the
non-fetching atomic add at #2; hence the high 32 bits are leaked.

Fix by applying the partial load check; after the patch, the
prog is rejected:

Verification failed: Memory Safety: Uninitialized stack read

Reason:
  This rejected read uses 8 bytes at stack offset -8, but byte 4 in that range is uninitialized on
  this path. Programs loaded with CAP_PERFMON can be allowed to read uninitialized stack bytes, but
  this program is being rejected without that allowance.

At:
  ...
      0 | (b7) r1 = 1
      1 | (63) *(u32 *)(r10 -8) = r1
  >>> 2 | (db) lock *(u64 *)(r10 -8) += r1
      3 | (79) r0 = *(u64 *)(r10 -8)
      4 | (77) r0 >>= 32

This affects CAP_BPF only.

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Link: https://lore.kernel.org/bpf/20260924131342.934290-1-sunhao.th@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 25cb335e008fd..04c763aa40094 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3910,11 +3910,11 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 				return -EACCES;
 			}
 
-			if (dst_regno < 0)
-				return 0;
-
 			if (size <= spill_size &&
 			    bpf_stack_narrow_access_ok(off, size, spill_size)) {
+				if (dst_regno < 0)
+					return 0;
+
 				if (env->bpf_capable && size == 4 && spill_size == 4 &&
 				    get_reg_width(reg) <= 32)
 					/* Ensure stack slot has an ID to build a relation
@@ -3956,6 +3956,9 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 					return -EACCES;
 				}
 
+				if (dst_regno < 0)
+					return 0;
+
 				if (spill_cnt == size &&
 				    tnum_is_const(reg->var_off) && reg->var_off.value == 0) {
 					__mark_reg_const_zero(env, &state->regs[dst_regno]);
-- 
2.53.0



