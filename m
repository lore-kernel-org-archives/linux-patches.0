Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7EF35C180;
	Thu, 30 Jul 2026 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422826; cv=none; b=o0dcmV45zeqdyB8GsGQ8ZpTgBSEHMoeaq0qPMTD3A8uxXezCyQmIGvHPTmr2/W6Wk/zZS148/JpOnsVYDhyCHVhvf91KH1zxNluoImY7bd4fecjOOt4DGcxPiLwJIPs/SZ0/sIdoxpa4/hLrgYdSXfo/8bYutKjQ3GfePCvajO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422826; c=relaxed/simple;
	bh=xm2AlbpJlimVNhZ7FGswHw1aFqAVKMl2DzYkzLjh6ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhaQ7tDze6OiUWZoId2vKyvGsV3ghBttSmF8+TsUfSWRe9Gis1nWcFAglRbLBTQNu5pByc96JhbS2PmceGOxt+LaB98I2D1efTGyMjKCrxiZbXE2HVk+tFC+gjnzG0YbyYswzt3S9escntxLQA7IZiV1fryu0qxVVVkqHnrhgtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVYuwX+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVYuwX+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666381F000E9;
	Thu, 30 Jul 2026 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422825;
	bh=NGYEXJ/XXaeTBIJcTw5m+9OMCOx93KcR6A1lptLmKHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVYuwX+TtxSUj0t/mbIdLCGa6pPK2wj6+16+Q3AO5r3ZsJbvrqk0+b7WFAH/ipdLI
	 cYSZE0cKWQaE0n81BpwM2a+cbYw4JxNy5mEoQHyssswLKt0VE6fBLVoN2n7qF9fo3J
	 G9nUXjJfFa6QWW4FDpi3ERtvRiHk8uaFTZloI6i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 570/744] LoongArch: Fix build errors due to wrong instructions for 32BIT
Date: Thu, 30 Jul 2026 16:14:03 +0200
Message-ID: <20260730141456.401136534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 7ea74820edcb22ffa3fb068076d73c6821d7e6d2 upstream.

In some assembly files there are some instructions that only valid for
64BIT, but those files can be compiled for 32BIT and cause build errors.

So, replace those instructions with macros:
li.d --> LONG_LI (li.w or li.d), addi.d --> PTR_ADDI (addi.w or addi.d).

BTW, Re-tab the indention in the assembly files for alignment.

Cc: stable@vger.kernel.org # 6.19+
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/rethook_trampoline.S |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/loongarch/kernel/rethook_trampoline.S
+++ b/arch/loongarch/kernel/rethook_trampoline.S
@@ -71,27 +71,27 @@
 	cfi_ld	s7, PT_R30
 	cfi_ld	s8, PT_R31
 	LONG_L  t0, sp, PT_CRMD
-	li.d	t1, 0x7 /* mask bit[1:0] PLV, bit[2] IE */
+	LONG_LI	t1, 0x7 /* mask bit[1:0] PLV, bit[2] IE */
 	csrxchg t0, t1, LOONGARCH_CSR_CRMD
 	.endm
 
 SYM_CODE_START(arch_rethook_trampoline)
 	UNWIND_HINT_UNDEFINED
-	addi.d	sp, sp, -PT_SIZE
+	PTR_ADDI sp, sp, -PT_SIZE
 	save_all_base_regs
 
-	addi.d	t0, sp, PT_SIZE
-	LONG_S	t0, sp, PT_R3
+	PTR_ADDI t0, sp, PT_SIZE
+	LONG_S	 t0, sp, PT_R3
 
-	move a0, sp /* pt_regs */
+	move	 a0, sp /* pt_regs */
 
-	bl arch_rethook_trampoline_callback
+	bl	 arch_rethook_trampoline_callback
 
 	/* use the result as the return-address */
-	move ra, a0
+	move	 ra, a0
 
 	restore_all_base_regs
-	addi.d	sp, sp, PT_SIZE
+	PTR_ADDI sp, sp, PT_SIZE
 
-	jr ra
+	jr	 ra
 SYM_CODE_END(arch_rethook_trampoline)


