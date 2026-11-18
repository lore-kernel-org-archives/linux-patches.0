Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017165;
	b=lMIfhfmggQjybd7nPHN0dIeVRsnq/PcGqQ2Or2yJkzsjh+QbdsO97qKIc/UDwviKTKRP
	 3HM7KtJSW6Eo+0Tgrt5wlK39cXTGG4jFBSjDszuuhqrY3YmuTU2ENLWMMslsNnBWVt5x1
	 6wpHtN9isJ3Uh5qu8pdtXaIR3UOL5lOp7o9AMZKNgpL10O0IyLOJMeVlEQQccc9a0CcCi
	 1QhN78pV21FzOiDFrQBSPvnuu5agvlcmHi2a9aC8kIsLcxskBpx8AZ5/MUbetvYzGm8Bi
	 Js/7qvhjve8M1Hza1HeKiICMK1vg03aZ9OnBccqQBpGgAnp5WagpL3PvxdGCDg3jJ0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kLDj6D8iK40CE+5r8WlCcfIcTa0xVJdisTjqTRA7h8A=;
	b=aIl6XK2CJ3Msr3sRtP0STii2YGIG+MGpSFXIfWl7pnKdW0klXqQz9ZUmi/xldzfSa0Id
	 iHhJMso0xebg2UahqTgzz/ehg8oHTp52Pj6BdQswezGE5M1/y2uPtUbkZsEACy5G0MVi6
	 Klha+i1xUCLOIoG+ARzy+9o4oxeuPafYjU+cC6wLixbeqcd3PPr4DRXH32Sxe/6nfTj1h
	 tB9nwBVQUlhkz8WBtGUc+YQLLvJU2/c39mbyl5wqGNJm31DVNDoI0sP+YytrODqaeOh1a
	 e6Mk/PIc+euu7A/io1Q2aGlCf16fbEsdtvy7PAW4biUSKBChpYo00g+g/As5jfOlnzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYXZPFIG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866BA606A325;
	Wed, 18 Nov 2026 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYXZPFIG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E3C1F000C4;
	Wed, 18 Nov 2026 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017165;
	bh=kLDj6D8iK40CE+5r8WlCcfIcTa0xVJdisTjqTRA7h8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYXZPFIG96Voo8yPStQahTBewnfV2zuGPCW+GgzTFJ0UcO9VbmTLxlQueSY3+pKbS
	 ceDS3kXO9z4YAuBSqrhxx0YJ8UOHAt36uJ323WML8Ftmosss+Z4eWl6WeyF3KzG5g/
	 PU35UszWnSxFhCzkT7fHr8azi9o09tN/ftNRKoS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0780/2651] bpf: Check fastcall stack contract once for all stack accesses
Date: Wed, 18 Nov 2026 15:33:40 +0100
Message-ID: <20261118150315.971213076@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit ec3a69e7c021cd826be8886ba6af4ee3147788fb ]

When the verifier inlines a bpf_fastcall helper or kfunc, it removes the
spill/fill pairs that clang emitted around the call and lowers the
subprogram's stack depth so that their slots are no longer part of the
frame. This is only safe if nothing else accesses those slots or any slot
below them. check_fastcall_stack_contract() enforces this: an access to
that region from outside a fastcall pattern disables the rewrite for the
subprogram. It is called from the four stack load and store paths, and
two kinds of access escape it.

Stack buffers passed to helpers and kfuncs are validated by
check_stack_range_initialized(), which does not call it. If such a buffer
is the only other access to the region, the rewrite is still applied, the
JIT reserves a frame that does not contain the buffer, and the helper
reads or writes live kernel stack below the program's frame. For example,
without CAP_PERFMON:

	*(u64 *)(r10 - 8) = r1;
	call bpf_get_smp_processor_id;
	r1 = *(u64 *)(r10 - 8);
	r2 = 0;
	r3 = r10;
	r3 += -64;
	r4 = 8;
	call bpf_skb_load_bytes;

is accepted with a stack depth of 0 instead of 64.

Some buffers got the check indirectly. For constant-sized outputs in raw
mode, mark_raw_stack() marks the buffer initialized through ordinary
byte stores, which call the check. Commit 5da4a9f26fca ("bpf: Preserve
stack initialization for generic output buffers") limited raw mode to
programs that may read uninitialized stack, so outputs of programs
without CAP_PERFMON lost the check, as in the example above. Buffers
that never used raw mode have lacked the check since fastcall support
was added: helper inputs such as a map key whose only store is a fastcall
spill, variable-sized outputs, and buffers at a variable stack offset.

check_stack_read_fixed_off() applies the check to the current frame,
even when the pointer targets a caller's stack. A callee can therefore
read a caller's fastcall spill slot without disabling the caller's
rewrite:

	caller:
	r1 = 1;
	*(u64 *)(r10 - 8) = r1;
	call bpf_get_smp_processor_id;
	r1 = *(u64 *)(r10 - 8);
	r1 = r10;
	r1 += -8;
	call callee;

	callee:
	r0 = *(u64 *)(r1 + 0);

The caller's spill and fill are removed and its stack depth drops to 0,
but the verifier still tracks the slot as holding the spilled constant.
The callee's load then reads kernel stack outside the caller's frame,
while the verifier assumes r0 is 1.

Every stack access first goes through check_stack_access_within_bounds():
loads and stores from check_mem_access(), helper and kfunc buffers from
check_stack_range_initialized(), and the dynptr, iterator and irq flag
slots that kfuncs initialize, whose handlers use check_mem_access(). It
resolves the frame that owns the slots and the lowest offset the access
can touch, and it is the only place where a frame's stack depth grows.
Check the contract there, once for every access, and drop the calls from
the stack read and write paths. Zero-sized buffers touch no stack and
leave the rewrite enabled.

Fixes: 5b5f51bff1b6 ("bpf: no_caller_saved_registers attribute for helper calls")
Fixes: 5da4a9f26fca ("bpf: Preserve stack initialization for generic output buffers")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/85f9995a43edb70c76615280e103dc5325742e88330f36c97962ee35f17e3e32@mail.kernel.org
Link: https://patch.msgid.link/20260924075352.2343553-2-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 729dc8e072ea3..07ac0986f1449 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3575,7 +3575,6 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	if (err)
 		return err;
 
-	check_fastcall_stack_contract(env, state, insn_idx, off);
 	mark_stack_slot_scratched(env, spi);
 	if (reg && !(off % BPF_REG_SIZE) && reg->type == SCALAR_VALUE && env->bpf_capable) {
 		bool reg_value_fits;
@@ -3696,7 +3695,6 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
 			return err;
 	}
 
-	check_fastcall_stack_contract(env, state, insn_idx, min_off);
 	/* Variable offset writes destroy any spilled pointers in range. */
 	for (i = min_off; i < max_off; i++) {
 		u8 new_type, *stype;
@@ -3881,7 +3879,6 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 	reg = &reg_state->stack[spi].spilled_ptr;
 
 	mark_stack_slot_scratched(env, spi);
-	check_fastcall_stack_contract(env, state, env->insn_idx, off);
 
 	/*
 	 * Refine the in-progress load record's origin to the source stack slot.
@@ -4068,7 +4065,6 @@ static int check_stack_read_var_off(struct bpf_verifier_env *env, struct bpf_reg
 				  dst_regno);
 	if (err)
 		return err;
-	check_fastcall_stack_contract(env, ptr_state, env->insn_idx, min_off);
 	return 0;
 }
 
@@ -6324,6 +6320,15 @@ static int check_stack_access_within_bounds(
 		return err;
 	}
 
+	/*
+	 * Every stack access passes through here, including buffers passed to
+	 * helpers and kfuncs and accesses into a caller's frame, so check the
+	 * fastcall contract of the frame that owns the slots once for all of
+	 * them. Zero-sized accesses touch no stack and keep the rewrite enabled.
+	 */
+	if (access_size)
+		check_fastcall_stack_contract(env, state, env->insn_idx, min_off);
+
 	/* Note that there is no stack access with offset zero, so the needed stack
 	 * size is -min_off, not -min_off+1.
 	 */
-- 
2.53.0



