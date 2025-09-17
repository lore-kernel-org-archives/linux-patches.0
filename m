Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEE2316186;
	Wed, 17 Sep 2025 12:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113620; cv=none; b=dcEKv9xRdjEUb+bEfQh7wqdW+CkyoEJUX0i96e8TB4TchXXcF5ho2ZJMvmCqj9/6Y7phs9T0LReASWNM3NlnVk4QKshpPf5nMmH9OtarYdpguTprPTCrwDz9tOsWj31uoRkuqHxV52/7ojQyM15lpLrT1JVQXtyWUEFY6eHF4W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113620; c=relaxed/simple;
	bh=vrWltyQ1UfaxoR7WwObSfKKLIxNFrN3C3rf87Fdmrsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y7aUaQCDpKg49+0/RhzobgeaZP0MglIlXE4ktiD/WmS4pLAFEDcjAsTzxf2uR69xCdnyrUOdZZ8NtjQlwSDwGTt1Z1GDuTmjsAyr9AvKWTQ4oJFfXKips9M7jGL1iIKEYeAbYVQO5hAr/PCCTrxDI0nLyxEIynOPx+g4R91miRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9EFaEnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9EFaEnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAADC4CEF0;
	Wed, 17 Sep 2025 12:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113619;
	bh=vrWltyQ1UfaxoR7WwObSfKKLIxNFrN3C3rf87Fdmrsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9EFaEnXthPjG79GB52SpTha+Hj6ULmKF84jxkYz/I/rFH2TcZJh/Kx4Wm/ZHcCMs
	 vWG5N6GFMfz6U6kJ3/x1+yeeYQP0ABJheyg3It3gTVxbjRuMIvg0+4bgH7tabYZnHv
	 +WxMD1K2b6EW7ErzJZz8i8LdJxa4M5Cm50moyJ/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/140] RISC-V: Remove unnecessary include from compat.h
Date: Wed, 17 Sep 2025 14:34:58 +0200
Message-ID: <20250917123347.388002933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa103530a5c83..6081327e55f5b 100644
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



