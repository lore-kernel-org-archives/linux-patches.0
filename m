Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214579;
	b=cxIy8zXG7PgtRTAtU6X7HoSe8E+s2adqhzMY89yU+8sE57ifVHpCzoiADKGadzWImq56
	 tPciLoPyQg2IucG2TVl7gWCYZ1MuVRTILuXvvTablCWz+D4uKB5Xn4/ThtWjpWQebPfWq
	 ZLeYtJWFYJjTDdfkaMCsz8r7OFCer2MG8HwhrwMBuYopqYy76aXRcAT5Y37qrx0w033yG
	 FVQjKrsGvw8gGsmVXUYL2t0zwZeD8k2py0MWeiTRS7vbwfwF4uKfM3SEB04iKEtdP20cD
	 MAAGfakUDS1eJ/IsdJh/vlfPyD+SWOk7Wua4wz/KG2Av3fcrPWZ5kteoZ7lw3iFpKSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E2plLFvdiZjDAVInLRva7MgDRXOAohscK4XpqrDJZ2s=;
	b=2PwwsdvpzylFzLbN78b9bw/+0dXuvs5i41E5vZylv0aOLagLZNREaKOW6inEuxFra4Z7
	 8Hi8wGyQDnU/XQV5IrGRku0ZSw9AynvVlid4HA9ADW0l4z4A8JNExc6Qp4pRsN6zbLmZV
	 +d5BECCKhA8kQ4Rn79Ng0Z/YeE0RBYhEQpoYrNSF/NlIuCZFyjZKC/lQW7EnoaYvH24uV
	 88kDrZZgrxv4j8DXhEOnQw56gij4G7dpjbVxS/HLXcjLxzqNZEZ1xec01lfm7cBWNC4Jl
	 eehk8Bz6kPqRfz24IB2UB961Xrx6VCDyCN/ssxbC9ziDw//DVOpfTdaWCCLPZmSLfhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIny7IAL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73FB60A263E;
	Wed, 28 Oct 2026 19:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIny7IAL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B7E1F031E0;
	Wed, 28 Oct 2026 19:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214578;
	bh=E2plLFvdiZjDAVInLRva7MgDRXOAohscK4XpqrDJZ2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIny7IALi3xHCtfgUp5yWNHjZO0p0ant55p9nwoQ9XHVJAz+wouS7dHHumNFpShU4
	 Uk9kcN2vAiV7C87F2InnejjxSi1R0Q39rgbO5nTxCN3sX5V732vvkR6YOtxJHfHJiE
	 la/8wXfcBwkInlFq78+/8c6SATAHPUPAKjeOAv9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0909/1887] MIPS: ftrace: Fix memory corruption when kernel is located beyond 32 bits
Date: Wed, 28 Oct 2026 17:50:05 +0100
Message-ID: <20261028170520.101891462@linuxfoundation.org>
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

From: Gregory CLEMENT <gregory.clement@bootlin.com>

[ Upstream commit 36dac9a3dda1f2bae343191bc16b910c603cac25 ]

Since commit e424054000878 ("MIPS: Tracing: Reduce the overhead of
dynamic Function Tracer"), the macro UASM_i_LA_mostly has been used,
and this macro can generate more than 2 instructions. At the same
time, the code in ftrace assumes that no more than 2 instructions can
be generated, which is why it stores them in an int[2] array. However,
as previously noted, the macro UASM_i_LA_mostly (and now UASM_i_LA)
causes a buffer overflow when _mcount is beyond 32 bits. This leads to
corruption of the variables located in the __read_mostly section.

This corruption was observed because the variable
__cpu_primary_thread_mask was corrupted, causing a hang very early
during boot.

This fix prevents the corruption by avoiding the generation of
instructions if they could exceed 2 instructions in
length. Fortunately, insn_la_mcount is only used if the instrumented
code is located outside the kernel code section, so dynamic ftrace can
still be used, albeit in a more limited scope. This is still
preferable to corrupting memory and/or crashing the kernel.

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/ftrace.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index f39e85fd58fa9..b15615b285690 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -54,10 +54,20 @@ static inline void ftrace_dyn_arch_init_insns(void)
 	u32 *buf;
 	unsigned int v1;
 
-	/* la v1, _mcount */
-	v1 = 3;
-	buf = (u32 *)&insn_la_mcount[0];
-	UASM_i_LA(&buf, v1, MCOUNT_ADDR);
+	/* If we are not in compat space, the number of generated
+	 * instructions will exceed the maximum expected limit of 2.
+	 * To prevent buffer overflow, we avoid generating them.
+	 * insn_la_mcount will not be used later in ftrace_make_call.
+	 */
+	if (uasm_in_compat_space_p(MCOUNT_ADDR)) {
+		/* la v1, _mcount */
+		v1 = 3;
+		buf = (u32 *)&insn_la_mcount[0];
+		UASM_i_LA(&buf, v1, MCOUNT_ADDR);
+	} else {
+		pr_warn("ftrace: mcount address beyond 32 bits is not supported (%lX)\n",
+			MCOUNT_ADDR);
+	}
 
 	/* jal (ftrace_caller + 8), jump over the first two instruction */
 	buf = (u32 *)&insn_jal_ftrace_caller;
@@ -189,6 +199,13 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned int new;
 	unsigned long ip = rec->ip;
 
+	/* When the code to patch does not belong to the kernel code
+	 * space, we must use insn_la_mcount. However, if MCOUNT_ADDR
+	 * is not in compat space, insn_la_mcount is not usable.
+	 */
+	if (!core_kernel_text(ip) && !uasm_in_compat_space_p(MCOUNT_ADDR))
+		return -EFAULT;
+
 	new = core_kernel_text(ip) ? insn_jal_ftrace_caller : insn_la_mcount[0];
 
 #ifdef CONFIG_64BIT
-- 
2.53.0



