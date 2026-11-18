Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045625;
	b=NAtyCMxSjDsRz/sZtOXMfGoylcbWSyxhvqD8RsED6z0oG5AoaUsJnfbaI+LWUglKt1IW
	 BqchTJ/H/mnCSr8KApKnKpRhU+Eo4qowWLF504LThBodMrcDQP43Dr/xm7k/N+nmZ2wmH
	 dsbTVMH/gKD1/2vYFxU/8pvewJn398DWDSSe5LFWVqqf1U/OJdLOkg00LRDpvF6yxh3/w
	 bh7AWBnaxL0XcgX7HrH0aB1xXIgAMdXmp+R9GfNKjtcW4fUbMK8vp2uXvMStBdC+QxXGI
	 FWY6mIF9XAuntReeMCu6o9dzUDvDSaqerWVvY+ycMdeaKiZT1xo0hvFVurnBfH7wXxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DOBU8SZSq8OV4TRe+ItRhXan9kSaZSex6UQBroLiNbA=;
	b=NriJX0rvHgaXT9xuekzF1NDzOmJ8WDLi2ir6ybO9M01mO3WmtM9UC4Fdxlfz3Uk0oDjz
	 VSwJcltDSYuO8lRHJerjQDSsSWVXSJSPX95XEgSDcpJBEL/rRaFZDnCkyjuYB2P6qcCyN
	 /RVSbmskOI/QhxOCvsJnJ5csr9O1pqFuiBZgvuAnyY5gq+62VunPoP+mPyhlKpl4mCAsz
	 tqsNBwk2i4abszvTSBjub7yQQPzJ1w+5/X1P7NYZQSvqduSgB3NLiOArIIHsuWZcNZsgO
	 2lIImz/RQCdLvfyBEkV9glDelRSupvpixPPzf0A3M3wNB5/hwV9tUgMXEGCKl5X85Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2suNqwlg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387F0606A32F;
	Wed, 18 Nov 2026 23:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2suNqwlg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD0D1F000C4;
	Wed, 18 Nov 2026 23:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045625;
	bh=DOBU8SZSq8OV4TRe+ItRhXan9kSaZSex6UQBroLiNbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2suNqwlg4ZMzbZsJwjrT1yJ7g9Ey4QltL8aQzuVnAuivFoh6NgnGC/TIW+ynh+2jE
	 TBRneUXzEGRAoClXrXHNXDNEOB48VVxRIzbXjDtQc/DbGfLr8v+rIlJ5rXJVtr1ZxP
	 0zXlIbvScUnw9runjV9tp/i/uqYvoNcYcwEDsTls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0950/2857] ARM: 9491/1: alignment: restore uaccess state on emulation fault
Date: Wed, 18 Nov 2026 15:33:04 +0100
Message-ID: <20261118150235.813422405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 80dafbcb705cead6d25cb821cf29c47da8860c8c ]

The alignment handlers enable access to user memory while emulating
unaligned instructions. If a checked access faults, its exception table
fixup jumps to the handler's fault label and bypasses uaccess_restore().
This leaves DOMAIN_USER as DOMAIN_CLIENT with SW domain PAN, or leaves
TTBR0 page table walks enabled with TTBR0 PAN, while the fault is handled.

An ARM926 QEMU test using LDMIA across an unmapped page boundary reports
DOMAIN_USER=1 at TYPE_FAULT before this change and DOMAIN_USER=0 after it.
SW domain PAN is the default on ARMv5, ARMv6, and non-LPAE ARMv7 builds.

Keep the saved uaccess state at function scope and track whether it was
saved. Restore it at the fault label only when needed. Paths that did not
enable user access continue to skip the restore.

Assisted-by: Codex:gpt-5.6-sol

Fixes: 274e91b81ed2 ("ARM: alignment: fix alignment handling for uaccess changes")
Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/alignment.c | 51 ++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index ee264737be6d2..41f1497e2fd28 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -341,6 +341,8 @@ static int
 do_alignment_ldrhstrh(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd = RD_BITS(instr);
+	unsigned int ua_flags;
+	bool ua_saved = false;
 
 	ai_half += 1;
 
@@ -364,10 +366,11 @@ do_alignment_ldrhstrh(unsigned long addr, u32 instr, struct pt_regs *regs)
  user:
 	if (LDST_L_BIT(instr)) {
 		unsigned long val;
-		unsigned int __ua_flags = uaccess_save_and_enable();
 
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		get16t_unaligned_check(val, addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 
 		/* signed half-word? */
 		if (instr & 0x40)
@@ -375,14 +378,17 @@ do_alignment_ldrhstrh(unsigned long addr, u32 instr, struct pt_regs *regs)
 
 		regs->uregs[rd] = val;
 	} else {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		put16t_unaligned_check(regs->uregs[rd], addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	}
 
 	return TYPE_LDST;
 
  fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	return TYPE_FAULT;
 }
 
@@ -391,6 +397,8 @@ do_alignment_ldrdstrd(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd = RD_BITS(instr);
 	unsigned int rd2;
+	unsigned int ua_flags;
+	bool ua_saved = false;
 	int load;
 
 	if ((instr & 0xfe000000) == 0xe8000000) {
@@ -425,26 +433,30 @@ do_alignment_ldrdstrd(unsigned long addr, u32 instr, struct pt_regs *regs)
  user:
 	if (load) {
 		unsigned long val, val2;
-		unsigned int __ua_flags = uaccess_save_and_enable();
 
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		get32t_unaligned_check(val, addr);
 		get32t_unaligned_check(val2, addr + 4);
 
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 
 		regs->uregs[rd] = val;
 		regs->uregs[rd2] = val2;
 	} else {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		put32t_unaligned_check(regs->uregs[rd], addr);
 		put32t_unaligned_check(regs->uregs[rd2], addr + 4);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	}
 
 	return TYPE_LDST;
  bad:
 	return TYPE_ERROR;
  fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	return TYPE_FAULT;
 }
 
@@ -452,6 +464,8 @@ static int
 do_alignment_ldrstr(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd = RD_BITS(instr);
+	unsigned int ua_flags;
+	bool ua_saved = false;
 
 	ai_word += 1;
 
@@ -469,18 +483,22 @@ do_alignment_ldrstr(unsigned long addr, u32 instr, struct pt_regs *regs)
  trans:
 	if (LDST_L_BIT(instr)) {
 		unsigned int val;
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		get32t_unaligned_check(val, addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 		regs->uregs[rd] = val;
 	} else {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		put32t_unaligned_check(regs->uregs[rd], addr);
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	}
 	return TYPE_LDST;
 
  fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	return TYPE_FAULT;
 }
 
@@ -502,6 +520,8 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 {
 	unsigned int rd, rn, correction, nr_regs, regbits;
 	unsigned long eaddr, newaddr;
+	unsigned int ua_flags;
+	bool ua_saved = false;
 
 	if (LDM_S_BIT(instr))
 		goto bad;
@@ -547,7 +567,8 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 #endif
 
 	if (user_mode(regs)) {
-		unsigned int __ua_flags = uaccess_save_and_enable();
+		ua_flags = uaccess_save_and_enable();
+		ua_saved = true;
 		for (regbits = REGMASK_BITS(instr), rd = 0; regbits;
 		     regbits >>= 1, rd += 1)
 			if (regbits & 1) {
@@ -559,7 +580,7 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 					put32t_unaligned_check(regs->uregs[rd], eaddr);
 				eaddr += 4;
 			}
-		uaccess_restore(__ua_flags);
+		uaccess_restore(ua_flags);
 	} else {
 		for (regbits = REGMASK_BITS(instr), rd = 0; regbits;
 		     regbits >>= 1, rd += 1)
@@ -581,6 +602,8 @@ do_alignment_ldmstm(unsigned long addr, u32 instr, struct pt_regs *regs)
 	return TYPE_DONE;
 
 fault:
+	if (ua_saved)
+		uaccess_restore(ua_flags);
 	regs->ARM_pc -= correction;
 	return TYPE_FAULT;
 
-- 
2.53.0



