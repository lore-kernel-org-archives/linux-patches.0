Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213779;
	b=4eM+Yxan9ZehEb7KjzXsQ4VmG/oTkBq0TboLC71mBqamRzSq8weOXYcTb+0LzVs/wQiK
	 v1DgSe9S6KKVEascaG3plg+ucrNKjCN00WvSI2kwo+hEReInrqxXL3Y803SEu+lAAhgwo
	 SpHNChetAEXVvlLMT0qvpjQZd32tEj3LFKLlroJRsRqC//fCWWvigrlBSkUOYl1DS0x9Z
	 nNHj1TKkRe9Ui3iVoor53ooRYgWPxGR5+mIwqpVALSlTpjJ+lxjGqWKaguJsY1gPe2eve
	 0U5J+SMTl3omzqW2ZQAxeW5UrztsihRhyju0cIFg2s9q1rxPXkNocJDaF/5nntwWtoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EEKZxXaLnaruzHs9HLv+sLPw4+lb512ZkOsi7djTnhI=;
	b=wtBNDcPXKVouZr2040QtZqnmoQqP7ph+X6tAS+KP9Wfw/bUsMbRW5CRX5akQPIVHIcWS
	 hc/c8HAxVcdvRQGDykxdbNZmA04CWItVZag9qXj2RfiD0DpdX0Y+JFSiU5zdi0MB0/HTN
	 RT0mVZWD9XVjYNmfpEOrZsG/xw97wZhr6nJXc3E64sl3QeR9LVjbmtFI5UVFEOs5wYwl3
	 jIPJ2aWXsBPApZPj1YBkrFTh45x3RZQDCqupI/6C1Hv64K4tvNhGl6DvUGUUTU9SwshrB
	 WYK1xRDFsSqpGZQr46Snm8veLTh8uhuxoztuE0+UNeNZtR7HkAloVYuAD6ccHUXNM2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGqM+5Za;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8BE606A325;
	Wed, 28 Oct 2026 18:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGqM+5Za
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329001F01828;
	Wed, 28 Oct 2026 18:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213778;
	bh=EEKZxXaLnaruzHs9HLv+sLPw4+lb512ZkOsi7djTnhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGqM+5ZaG2yfa1LZN/guhLR7ufcvRb5N4FJe+3pKJXM85WL3l3bT8/qJ8kcnY2dEp
	 YRnZKDhrXwJ0KsiHIlTIn92ffzwcAXNuNT7+Pt6IyhuxA5d+5DqvxImdTMncyruCht
	 ui8lkQyYK1HlFJY3MfRXMYtRvpV01oHzZgKXYmZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Rob Herring <robh@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0582/1887] arm64: entry: fix ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
Date: Wed, 28 Oct 2026 17:44:38 +0100
Message-ID: <20261028170512.665383939@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 832dd634bd1b4e3bbe9f10b9c9ba5db6f6f2b97f ]

Currently the ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD workaround isn't
quite right, as it is supposed to be applied after the last explicit
memory access, but is immediately followed by an LDR.

The ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD workaround is used to
handle Cortex-A520 erratum 2966298 and Cortex-A510 erratum 3117295,
which are described in:

* https://developer.arm.com/documentation/SDEN2444153/0600/?lang=en
* https://developer.arm.com/documentation/SDEN1873361/1600/?lang=en

In both cases the workaround is described as:

| If pagetable isolation is disabled, the context switch logic in the
| kernel can be updated to execute the following sequence on affected
| cores before exiting to EL0, and after all explicit memory accesses:
|
| 1. A non-shareable TLBI to any context and/or address, including
|    unused contexts or addresses, such as a `TLBI VALE1 Xzr`.
|
| 2. A DSB NSH to guarantee completion of the TLBI.

The important part being that the TLBI+DSB must be placed "after all
explicit memory accesses".

Unfortunately, as-implemented, the TLBI+DSB is immediately followed by
an LDR, as we have:

| alternative_if ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
| 	tlbi	vale1, xzr
| 	dsb	nsh
| alternative_else_nop_endif
| alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
| 	ldr	lr, [sp, #S_LR]
| 	add	sp, sp, #PT_REGS_SIZE		// restore sp
| 	eret
| alternative_else_nop_endif
|
| [ ... KPTI exception return path ... ]

This patch fixes this by reworking the logic to place the TLBI+DSB
immediately before the ERET, after all explicit memory accesses.

The ERET is currently in a separate alternative block, and alternatives
cannot be nested. To account for this, the alternative block for
ARM64_UNMAP_KERNEL_AT_EL0 is replaced with a single alternative branch
to skip the KPTI logic, with the new shape of the logic being:

| alternative_insn "b .L_skip_tramp_exit_\@", nop, ARM64_UNMAP_KERNEL_AT_EL0
| 	[ ... KPTI exception return path ... ]
| .L_skip_tramp_exit_\@:
|
| 	ldr	lr, [sp, #S_LR]
| 	add	sp, sp, #PT_REGS_SIZE		// restore sp
|
| alternative_if ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
| 	tlbi	vale1, xzr
| 	dsb	nsh
| alternative_else_nop_endif
| 	eret

The new structure means that the workaround is only applied when KPTI is
not in use; this is fine as noted in the documented implications of the
erratum:

| Pagetable isolation between EL0 and higher level ELs prevents the
| issue from occurring.

... and as per the workaround description quoted above, the workaround
is only necessary "If pagetable isolation is disabled".

Fixes: 471470bc7052 ("arm64: errata: Add Cortex-A520 speculative unprivileged load workaround")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240116110221.420467-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 4b4a9aa76e1a3..6df98546605d4 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -419,16 +419,9 @@ alternative_else_nop_endif
 	ldp	x28, x29, [sp, #16 * 14]
 
 	.if	\el == 0
-alternative_if ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
-	tlbi	vale1, xzr
-	dsb	nsh
-alternative_else_nop_endif
-alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
-	ldr	lr, [sp, #S_LR]
-	add	sp, sp, #PT_REGS_SIZE		// restore sp
-	eret
-alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+	alternative_insn "b .L_skip_tramp_exit_\@", nop, ARM64_UNMAP_KERNEL_AT_EL0
+
 	bne	4f
 	msr	far_el1, x29
 	tramp_alias	x30, tramp_exit_native, x29
@@ -436,7 +429,18 @@ alternative_else_nop_endif
 4:
 	tramp_alias	x30, tramp_exit_compat, x29
 	br	x30
+
+.L_skip_tramp_exit_\@:
 #endif
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #PT_REGS_SIZE		// restore sp
+
+	/* This must be after the last explicit memory access */
+alternative_if ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
+	tlbi	vale1, xzr
+	dsb	nsh
+alternative_else_nop_endif
+	eret
 	.else
 	ldr	lr, [sp, #S_LR]
 	add	sp, sp, #PT_REGS_SIZE		// restore sp
-- 
2.53.0



