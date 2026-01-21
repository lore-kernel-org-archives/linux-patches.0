Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27C42222D1
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769031366; cv=none; b=u4LfK2EO/ur9Y1nXNWv/O8uRgtMkcEztlEiiWDC0HZ5r/j8FhOWPnbADIaOHPNg2eYkZAOYb4HB9gL1wWwt/rt3fAN20+LTxlBdBte8XGAG1tlWRhFsTeN3WF1k4BtjYpfzE74fSjZwpF8EEs9WfDCrwMbjsqlEXn4xwjYdLTRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769031366; c=relaxed/simple;
	bh=K5Kg79MYUEbLRwnoSUB/w8wal8aEH0LarYOxU+jEfoE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=EJVX7EJDUupNjBksnA1EBJV7niuw/LIAwBeUPbU5lMfwA35+w7Ssq5S1Uju0IgyekbMoNwukdBSywXiWtG8KySWJEkP/d8CjRZSA5myecpCcB4ENYag+sIucvXvtnkpVCA2HaSNlJfvVCSCJWgliRkoK4o4zvaNAPfyyH/Rnbls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZZD+HBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZZD+HBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17C2C4CEF1;
	Wed, 21 Jan 2026 21:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769031366;
	bh=K5Kg79MYUEbLRwnoSUB/w8wal8aEH0LarYOxU+jEfoE=;
	h=From:Date:Subject:To:Cc:From;
	b=hZZD+HBLJCD6eTD2NDuhMQzEwyiYlnPhN2i6ODAq9tHQTRgXp0ainrQFSedzjOEdf
	 yyL4E4G+XZAWi1aD2oPheZJI3clEkG3KVPRDbBzGZkw/n6Htcjij+g/QT9bhqDXhe6
	 h2mUV5YzN1aWME2+OQ9Z36cBuEtKD7VuwQqMKPUg5Zl5nHfGzyFxcnZoUFnp1Shw01
	 L0ROORZYrrellJrzVNcUykc9Bmi1gRK3+5UbK03w7TUTdjZBP0d7ROm2GLgCfl+f7G
	 aR1G0p/AeKSrETRoz4HHnBs5c6AY7NWU2vChUQ/zQ6ExQCgyHcnCO9vfrLXwXhqmLG
	 iTPWnytsR9Kdw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 21 Jan 2026 14:36:00 -0700
Subject: [PATCH] riscv: Add intermediate cast to 'unsigned long' in
 __get_user_asm
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-riscv-fix-int-to-pointer-cast-v1-1-b83eebe57c76@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBCF4avIrDtg0iDiVUoXJo7tuEhkJpWCe
 PdOdfc+ePw7KAmTwtDsILSxcskGd2sgvcf8IuTJDL71Xeu8Q2FNG878Rc4Va8G12CDBNGrFPk7
 hHkLfzT6CNVYhu579x/OyfuJCqf6jcBw/GnzmlIEAAAA=
X-Change-ID: 20260121-riscv-fix-int-to-pointer-cast-8bd434486f2b
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-riscv@lists.infradead.org, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3284; i=nathan@kernel.org;
 h=from:subject:message-id; bh=K5Kg79MYUEbLRwnoSUB/w8wal8aEH0LarYOxU+jEfoE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJmFbkd+KZTGdgtwfreb3Prk2YX9R3346vIesDDcOH6WQ
 aAwUKq8o5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEwk3YHhn9XuctZFMYnS8gkz
 /p15KmrUfyvt2P7H2663G649+f54pxnD/2AFxmdrnbUZr/JM7uHxDPh+kaXy9o5Lahsa50eou2g
 f5QQA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit bdce162f2e57 ("riscv: Use 64-bit variable for output in
__get_user_asm"), there is a warning when building for 32-bit RISC-V:

  In file included from include/linux/uaccess.h:13,
                   from include/linux/sched/task.h:13,
                   from include/linux/sched/signal.h:9,
                   from include/linux/rcuwait.h:6,
                   from include/linux/mm.h:36,
                   from include/linux/migrate.h:5,
                   from mm/migrate.c:16:
  mm/migrate.c: In function 'do_pages_move':
  arch/riscv/include/asm/uaccess.h:115:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    115 |         (x) = (__typeof__(x))__tmp;                             \
        |               ^
  arch/riscv/include/asm/uaccess.h:198:17: note: in expansion of macro '__get_user_asm'
    198 |                 __get_user_asm("lb", (x), __gu_ptr, label);     \
        |                 ^~~~~~~~~~~~~~
  arch/riscv/include/asm/uaccess.h:218:9: note: in expansion of macro '__get_user_nocheck'
    218 |         __get_user_nocheck(x, ptr, __gu_failed);                        \
        |         ^~~~~~~~~~~~~~~~~~
  arch/riscv/include/asm/uaccess.h:255:9: note: in expansion of macro '__get_user_error'
    255 |         __get_user_error(__gu_val, __gu_ptr, __gu_err);         \
        |         ^~~~~~~~~~~~~~~~
  arch/riscv/include/asm/uaccess.h:285:17: note: in expansion of macro '__get_user'
    285 |                 __get_user((x), __p) :                          \
        |                 ^~~~~~~~~~
  mm/migrate.c:2358:29: note: in expansion of macro 'get_user'
   2358 |                         if (get_user(p, pages + i))
        |                             ^~~~~~~~

Add an intermediate cast to 'unsigned long', which is guaranteed to be the same
width as a pointer, before the cast to the type of the output variable to clear
up the warning.

Fixes: bdce162f2e57 ("riscv: Use 64-bit variable for output in __get_user_asm")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601210526.OT45dlOZ-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Since the patch that causes the warning is at the top of the fixes
branch currently, this could be squashed into it with a link to this
submission but I sent it as a standalone change to allow application on
top if desired.
---
 arch/riscv/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 53a643c0f6fe..11c9886c3b70 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -112,7 +112,7 @@ do {								\
 		_ASM_EXTABLE_UACCESS_ERR(1b, %l2, %0)		\
 		: "=&r" (__tmp)					\
 		: "m" (*(ptr)) : : label);			\
-	(x) = (__typeof__(x))__tmp;				\
+	(x) = (__typeof__(x))(unsigned long)__tmp;		\
 } while (0)
 #else /* !CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
 #define __get_user_asm(insn, x, ptr, label)			\

---
base-commit: bdce162f2e57a969803e5e9375999a3e0546905f
change-id: 20260121-riscv-fix-int-to-pointer-cast-8bd434486f2b

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

