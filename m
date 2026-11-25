Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617771;
	b=gsX+1pv4fWceYSQHmV8vbphfftO8JlcjMQ4EDz7e8VfBK8Y8qsb23TF3A2kejEFkQ8lD
	 pBoDUnhQJJ7fpEMCiYvkd9soyWeqca+RNmb3dvFNYZztJJci/4EeNExjJgZ40ERWGDsz2
	 YtDNzc+tuQfCNnte2bY5t1/tf00DfGVexfsoX5iM3aZjoI5T03YzAw2/PsUVmOULGHADu
	 DHNyWPFEAVjYsUReQFdSw/S88wZRudPdj2bQvQeljw8uIo3YkBARXThYVkneaqv1sqry4
	 s0nWkNlFqNOOXb7XcblPx5TeU9fM2/K6t4Kzfh8nz6+6yjcwoJ4pTbJubRb3tmDuvqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7yn3EON213Cjgo9cYu5b9IZFVGcAFqxxCyaoNnHEIaE=;
	b=BQSOlAWNG5LI2q7BnyuNJSQ5KCFV4JNd6u5L9DU60lPO6SNilqWOC6C7aVykcbYtEtxo
	 Un5FTFr7NkNgmoHLGpu+jgEUtm7QoLSno5OddlcAsRfsy4U6s0AERGgGej9gMHZL+7XdJ
	 V8oQqF1rVzXw9Hm1Gn+mUNGro9IGkh4ytCtc4ZBc5/4BecRkS4sYrRcRcUuuFXHYZuL1u
	 1m7hK9ntLeIzYwqXvSkTRNYo7V3d6+aeCGzKIS9jMAuuotyQDxrTx5slbh/JvUtKEVL8w
	 K+nYZWQxtb0MFPRf5+AB2A3VU7sNtgkZFjrGAUkcK+y174xtuo661qcGg+IGdvhtqdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNQaQHSu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71173606A321;
	Wed, 25 Nov 2026 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNQaQHSu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5F31F000C4;
	Wed, 25 Nov 2026 14:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617770;
	bh=7yn3EON213Cjgo9cYu5b9IZFVGcAFqxxCyaoNnHEIaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNQaQHSu0ipR0swNSEbsjfCde8xC9pPh+JycyRl/82H65zQSoaeXzNZ4YGYsb8Um1
	 SzuFsoWtYVuLLLuO2MEDEUUSY4PlXIF1YTixqc97ZhrdqdFChGan8XEdRlI2zmXZv+
	 MupftWc4ayXKpGa2zb3k07Xm80irgZrgMw7bmgKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0067/1005] x86/ftrace: Mark jmp mode by clearing bit 63 of trampoline address
Date: Wed, 25 Nov 2026 15:23:25 +0100
Message-ID: <20261125143823.314972405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 31ac959c915cc7f379d84cf9dadf3664cbcace02 ]

Since commit 0c3772a8db1f ("x86/ftrace: Implement DYNAMIC_FTRACE_WITH_JMP")
ftrace_call_replace() emits a jmp instead of a call when bit 0 of the
target is set, the mark of a direct trampoline that is entered by a jmp.
ftrace_update_ftrace_func() and arch_ftrace_update_trampoline() use it
too, for the call of the ftrace callback in ftrace_caller, ftrace_regs_caller
and the ftrace trampolines, but a callback is a C function and can start
at an odd address. It does with gcc13 and CONFIG_CC_OPTIMIZE_FOR_SIZE=y:
gcc13 has no -fmin-function-alignment, so CONFIG_CC_HAS_SANE_FUNCTION_ALIGNMENT
is not set, and the -falign-functions=16 used in its place does not apply
to functions optimized for size. Here ftrace_ops_list_func() starts at:

  ffffffff810e0147 T ftrace_ops_list_func

ftrace_regs_call then becomes a jmp to the byte before it:

  ftrace_regs_call ffffffff810374f3: e9 4e 8c 0a 00

That byte is the last one of the preceding function's tail jump, and with
the first two of ftrace_ops_list_func() it decodes as an inc DWORD PTR
[rcx+0x57], which swallows the push %r15 of the prologue. Entered without
a return address and one push short, the list function returns through
the pt_regs that ftrace_regs_caller saved, here to the saved R14:

  BUG: unable to handle page fault for address: ffff888116c29f40
  #PF: supervisor instruction fetch in kernel mode
  RIP: 0010:0xffff888116c29f40
  R13: 0000000000000000 R14: ffff888116c29f40 R15: 0000000000000000
  Call Trace:
   ? bpf_trampoline_6442499918+0x1/0x149
   ? bpf_lsm_file_open+0x5/0x8
   ? bpf_lsm_file_open+0x5/0x8
   ? security_file_open+0x19/0x46
   ? do_dentry_open+0x16c/0x32a

The list function is installed whenever two ftrace_ops are registered,
and a function that two of them trace calls it. A kprobe next to a BPF
trampoline is one such case, and with the single ftrace_ops of the BPF
trampolines every update_ftrace_direct_mod() is another, as it registers
a stub ops for the sites it modifies. Here, detaching one of several BPF
LSM programs from a busy hook crashed the tasks that ran the hook during
the update.

Bit 0 is free only in the direct trampolines that a dyn_ftrace record can
point to, but bit 63 is set in every kernel text address on x86_64. Thus,
mark jmp mode by clearing bit 63 instead, so that ftrace_is_jmp() is false
for any callback, whatever its alignment, and ftrace_regs_caller sets the
bit again where it cleared bit 0 before. A marked address is not canonical,
so a return or indirect branch to one that missed ftrace_jmp_get() faults
instead of running from a byte before its target.

Fixes: 0c3772a8db1f ("x86/ftrace: Implement DYNAMIC_FTRACE_WITH_JMP")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Link: https://patch.msgid.link/20261028202345.1215859-1-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/ftrace_64.S | 6 +++---
 include/linux/ftrace.h      | 8 +++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 62c1c93aa1c6a..4b20673a33959 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -286,9 +286,9 @@ SYM_INNER_LABEL(ftrace_regs_caller_end, SYM_L_GLOBAL)
 	RET
 
 1:
-	testb	$1, %al
-	jz	2f
-	andq $0xfffffffffffffffe, %rax
+	/* See ftrace_jmp_set(), jmp to the trampoline */
+	btsq	$63, %rax
+	jc	2f
 	movq %rax, MCOUNT_REG_SIZE+8(%rsp)
 	restore_mcount_regs
 	/* Restore flags */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b041d9142d2b8..1c2056a1a68b3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -618,19 +618,21 @@ static inline void arch_ftrace_set_direct_caller(struct ftrace_regs *fregs,
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_JMP
+#define FTRACE_JMP_BIT	BIT(BITS_PER_LONG - 1)
+
 static inline bool ftrace_is_jmp(unsigned long addr)
 {
-	return addr & 1;
+	return !(addr & FTRACE_JMP_BIT);
 }
 
 static inline unsigned long ftrace_jmp_set(unsigned long addr)
 {
-	return addr | 1UL;
+	return addr & ~FTRACE_JMP_BIT;
 }
 
 static inline unsigned long ftrace_jmp_get(unsigned long addr)
 {
-	return addr & ~1UL;
+	return addr | FTRACE_JMP_BIT;
 }
 #else
 static inline bool ftrace_is_jmp(unsigned long addr)
-- 
2.53.0



