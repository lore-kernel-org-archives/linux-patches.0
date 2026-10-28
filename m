Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209568;
	b=i9l+vMjk1RSTkwDGuL8EStfrI37vT1mm/02EC7NCMGEqfkvsolsDEkomCtNCF7nJnb5P
	 NaJneMkWa8JTyRHPIivvOXjxvA0K+ZhxHTSa7jUs9Zx3HXtS2jj5uwexeWgiC4Cn+EGaE
	 oiqLmZL4BVqiuHKE1D2faNVQK5gwCrx9TkIYEULNw6vHyUNtAkwCiNFl0lsBI3NfFDTDy
	 epelw8vWF47Y9yfdIPN+0o3H2EkXbcVlTjY96CpdPPleeEJZwi6vyeo0ObtbIPFuZEpOd
	 BpLinSy52D85Obr7fMtm0L9boWTuwkYcmh85UrBfRPSPrh8MnNb8yk0P2ePMzRm7jwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pImRQHxedjHPPQDtuRmVDXiNIia2MGWCh/UoyMB4gk=;
	b=pmkf2QBW8lAjEFJ+H4CW2H8fTtrcy0/FBA6UXQm0av43yLedbtO8RdzjeH7IFIEcShUC
	 1l9udzRWDpC5aUxB5Yv4Zs7KVxOnyrkei40LN/bcr1h5/vbxVlarUZ3PrFJeTUhU+IP+Z
	 l1kAmBgvlzOYea7RovYr9WmGR6aw3gI9JtM8bnXj1Q4lMaIce2/kVAn2rr6jSQPbvj825
	 inplNs5gxSEkWJCqw6UT6tlm76LORjVNPR40ohCjSbYESgkqZtTlfIxokFuK5umbeW+y2
	 irOhkseX0lf2hepacxDcH/j8ng/cqzU3nvCISAtOC415a8R+nQVAHjkeYLqTeiYLztg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F/4esZZ4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A003606A31D;
	Wed, 28 Oct 2026 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F/4esZZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7341F01825;
	Wed, 28 Oct 2026 17:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209568;
	bh=7pImRQHxedjHPPQDtuRmVDXiNIia2MGWCh/UoyMB4gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/4esZZ4dmBJOmOVBxRr51CykYQig8JS7mylawebAKauvdFTLQsa3e7/M11KI0GTM
	 wIt2bKmrF8lyaiK6ZR7wq3lejv0bu121YHxf5KyWkHbe5rnJjUVezdr7yS6Gjjm9xU
	 RGkLb5+6Yo1TvK9n5a2Y98l0M56B/ClLfxSme06Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 474/516] bpf: Reject variable offset alu on PTR_TO_FLOW_KEYS
Date: Wed, 28 Oct 2026 18:00:26 +0100
Message-ID: <20261028170014.710458875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit 22c7fa171a02d310e3a3f6ed46a698ca8a0060ed ]

For PTR_TO_FLOW_KEYS, check_flow_keys_access() only uses fixed off
for validation. However, variable offset ptr alu is not prohibited
for this ptr kind. So the variable offset is not checked.

The following prog is accepted:

  func#0 @0
  0: R1=ctx() R10=fp0
  0: (bf) r6 = r1                       ; R1=ctx() R6_w=ctx()
  1: (79) r7 = *(u64 *)(r6 +144)        ; R6_w=ctx() R7_w=flow_keys()
  2: (b7) r8 = 1024                     ; R8_w=1024
  3: (37) r8 /= 1                       ; R8_w=scalar()
  4: (57) r8 &= 1024                    ; R8_w=scalar(smin=smin32=0,
  smax=umax=smax32=umax32=1024,var_off=(0x0; 0x400))
  5: (0f) r7 += r8
  mark_precise: frame0: last_idx 5 first_idx 0 subseq_idx -1
  mark_precise: frame0: regs=r8 stack= before 4: (57) r8 &= 1024
  mark_precise: frame0: regs=r8 stack= before 3: (37) r8 /= 1
  mark_precise: frame0: regs=r8 stack= before 2: (b7) r8 = 1024
  6: R7_w=flow_keys(smin=smin32=0,smax=umax=smax32=umax32=1024,var_off
  =(0x0; 0x400)) R8_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=1024,
  var_off=(0x0; 0x400))
  6: (79) r0 = *(u64 *)(r7 +0)          ; R0_w=scalar()
  7: (95) exit

This prog loads flow_keys to r7, and adds the variable offset r8
to r7, and finally causes out-of-bounds access:

  BUG: unable to handle page fault for address: ffffc90014c80038
  [...]
  Call Trace:
   <TASK>
   bpf_dispatcher_nop_func include/linux/bpf.h:1231 [inline]
   __bpf_prog_run include/linux/filter.h:651 [inline]
   bpf_prog_run include/linux/filter.h:658 [inline]
   bpf_prog_run_pin_on_cpu include/linux/filter.h:675 [inline]
   bpf_flow_dissect+0x15f/0x350 net/core/flow_dissector.c:991
   bpf_prog_test_run_flow_dissector+0x39d/0x620 net/bpf/test_run.c:1359
   bpf_prog_test_run kernel/bpf/syscall.c:4107 [inline]
   __sys_bpf+0xf8f/0x4560 kernel/bpf/syscall.c:5475
   __do_sys_bpf kernel/bpf/syscall.c:5561 [inline]
   __se_sys_bpf kernel/bpf/syscall.c:5559 [inline]
   __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:5559
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0x3f/0x110 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x63/0x6b

Fix this by rejecting ptr alu with variable offset on flow_keys.
Applying the patch rejects the program with "R7 pointer arithmetic
on flow_keys prohibited".

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20240115082028.9992-1-sunhao.th@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 50bcf15eaa171..9eda0b168a7c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6284,6 +6284,10 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		verbose(env, "R%d pointer arithmetic on %s prohibited, null-check it first\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
+	case PTR_TO_FLOW_KEYS:
+		if (known)
+			break;
+		fallthrough;
 	case CONST_PTR_TO_MAP:
 		/* smin_val represents the known value */
 		if (known && smin_val == 0 && opcode == BPF_ADD)
-- 
2.53.0



