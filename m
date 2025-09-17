Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340BC368086;
	Wed, 17 Sep 2025 12:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113905; cv=none; b=XtBLILWvkkLJJZPok979L0A6Q2c/wQXg6uk2COVe7n27C4iHoeWTx/qlObIW3OmOmKUX648dD0yckM8hs1ZGP64GdM9His2uS92biftsprDoa5gr79fwaFNxhwCgsYxM1czHu9H1x+mB8r489zhsoIkFA0XZdRq2SHzPnjfcU9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113905; c=relaxed/simple;
	bh=1W3fK+bHRCz9MOoB9SEH3cVITPGahdl3G8BuhSxSRCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YbNPMGEtYiaL2EbIFTpHKxfmVl2ViID76qtlNxXyHMEOGSO7GB8nElBxD1l+wZ+ouAKib4hEb+NyiBKeSxPEd0b2hXf+MBhU8HX6jya+RM8I9bHJcIzgj3tVyXAebQJnlLbB05LxOO49L8XCi6m4XOqULfltgzSRkSEMe9x550Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fod13F3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fod13F3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0518C4CEF7;
	Wed, 17 Sep 2025 12:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113905;
	bh=1W3fK+bHRCz9MOoB9SEH3cVITPGahdl3G8BuhSxSRCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fod13F3RUrJzLuX2IcyIslGYUXvoOD/zUx7xPIKYCLNwFZy/LpC//dMyZRJgVMne9
	 PGkf1f3pgGo8mstDXAVkpF26XLxaRaqTRMO0YWBILt3C/kQ9RSNUgJX6EHqGnaLLsb
	 EHx7yEHE7s5c1eu5mFZpnDc2kQobA/FEmE+t62FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/101] RISC-V: Remove unnecessary include from compat.h
Date: Wed, 17 Sep 2025 14:35:12 +0200
Message-ID: <20250917123338.988988168@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit 8d4f1e05ff821a5d59116ab8c3a30fcae81d8597 ]

Without this I get a bunch of build errors like

    In file included from ./include/linux/sched/task_stack.h:12,
                     from ./arch/riscv/include/asm/compat.h:12,
                     from ./arch/riscv/include/asm/pgtable.h:115,
                     from ./include/linux/pgtable.h:6,
                     from ./include/linux/mm.h:30,
                     from arch/riscv/kernel/asm-offsets.c:8:
    ./include/linux/kasan.h:50:37: error: ‘MAX_PTRS_PER_PTE’ undeclared here (not in a function); did you mean ‘PTRS_PER_PTE’?
       50 | extern pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
          |                                     ^~~~~~~~~~~~~~~~
          |                                     PTRS_PER_PTE
    ./include/linux/kasan.h:51:8: error: unknown type name ‘pmd_t’; did you mean ‘pgd_t’?
       51 | extern pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD];
          |        ^~~~~
          |        pgd_t
    ./include/linux/kasan.h:51:37: error: ‘MAX_PTRS_PER_PMD’ undeclared here (not in a function); did you mean ‘PTRS_PER_PGD’?
       51 | extern pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD];
          |                                     ^~~~~~~~~~~~~~~~
          |                                     PTRS_PER_PGD
    ./include/linux/kasan.h:52:8: error: unknown type name ‘pud_t’; did you mean ‘pgd_t’?
       52 | extern pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD];
          |        ^~~~~
          |        pgd_t
    ./include/linux/kasan.h:52:37: error: ‘MAX_PTRS_PER_PUD’ undeclared here (not in a function); did you mean ‘PTRS_PER_PGD’?
       52 | extern pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD];
          |                                     ^~~~~~~~~~~~~~~~
          |                                     PTRS_PER_PGD
    ./include/linux/kasan.h:53:8: error: unknown type name ‘p4d_t’; did you mean ‘pgd_t’?
       53 | extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
          |        ^~~~~
          |        pgd_t
    ./include/linux/kasan.h:53:37: error: ‘MAX_PTRS_PER_P4D’ undeclared here (not in a function); did you mean ‘PTRS_PER_PGD’?
       53 | extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
          |                                     ^~~~~~~~~~~~~~~~
          |                                     PTRS_PER_PGD

Link: https://lore.kernel.org/r/20241126143250.29708-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/compat.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/include/asm/compat.h b/arch/riscv/include/asm/compat.h
index 2ac955b51148f..6b79287baecc0 100644
--- a/arch/riscv/include/asm/compat.h
+++ b/arch/riscv/include/asm/compat.h
@@ -9,7 +9,6 @@
  */
 #include <linux/types.h>
 #include <linux/sched.h>
-#include <linux/sched/task_stack.h>
 #include <asm-generic/compat.h>
 
 static inline int is_compat_task(void)
-- 
2.51.0



