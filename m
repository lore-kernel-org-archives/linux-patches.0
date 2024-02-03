Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85D8134D1;
	Sat,  3 Feb 2024 04:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933751; cv=none; b=YGBkJBnzQnUQwt9t6nwzsqnYHokCFkRuh80fSw7mpMwGNuQzOIUB+8NgVJZ0304oYeQpn3T0NAYWlE4ATd2zmUsgWt9pDZaIiyLs/n2WJOTKyzBmzmMEOOVoomxEZ8/Hbr+BP3/AV6UsMie7H+xUoMrJt0iEE8shwKPmThuYkiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933751; c=relaxed/simple;
	bh=v7b9FR7S5mVC3TLMk/DhsK8OroTCAOq9q7adPjK8IUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNoJaVvB4buIWceaw+6nmw/zWQDjY6dpYkvWovBL+izsEfRgJTg0erxL5lXv75kMnUTSxKYJQuvnG4oxXXi4GsRLErmxTalLjdR2doQx2SsRuZ90laXyJKfWouA5eQze5eguxZpNIXYJI2sW4d6RfvI0+UItu0PFlLbXyH0kM44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UC6DUwaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UC6DUwaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E87C43394;
	Sat,  3 Feb 2024 04:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933751;
	bh=v7b9FR7S5mVC3TLMk/DhsK8OroTCAOq9q7adPjK8IUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UC6DUwaM17KfgEmLGLh7rUBXXyhY8466h22gtw71LNj9KcaNJRtsd9VP1l9oybhFR
	 gFnq3v2bt5gKTwDs30NVRaF5CZA1jn3wuDs5qwbx1ASJVbF/mgUXjQmfPuOox9N/7E
	 uwK/NRvviRvE71iDwheoAhErcccBTAWh+2+Pi9r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 047/353] arch: consolidate arch_irq_work_raise prototypes
Date: Fri,  2 Feb 2024 20:02:45 -0800
Message-ID: <20240203035405.302262031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 64bac5ea17d527872121adddfee869c7a0618f8f ]

The prototype was hidden in an #ifdef on x86, which causes a warning:

kernel/irq_work.c:72:13: error: no previous prototype for 'arch_irq_work_raise' [-Werror=missing-prototypes]

Some architectures have a working prototype, while others don't.
Fix this by providing it in only one place that is always visible.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/irq_work.h     | 2 --
 arch/arm64/include/asm/irq_work.h   | 2 --
 arch/csky/include/asm/irq_work.h    | 2 +-
 arch/powerpc/include/asm/irq_work.h | 1 -
 arch/riscv/include/asm/irq_work.h   | 2 +-
 arch/s390/include/asm/irq_work.h    | 2 --
 arch/x86/include/asm/irq_work.h     | 1 -
 include/linux/irq_work.h            | 3 +++
 8 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
index 3149e4dc1b54..8895999834cc 100644
--- a/arch/arm/include/asm/irq_work.h
+++ b/arch/arm/include/asm/irq_work.h
@@ -9,6 +9,4 @@ static inline bool arch_irq_work_has_interrupt(void)
 	return is_smp();
 }
 
-extern void arch_irq_work_raise(void);
-
 #endif /* _ASM_ARM_IRQ_WORK_H */
diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
index 81bbfa3a035b..a1020285ea75 100644
--- a/arch/arm64/include/asm/irq_work.h
+++ b/arch/arm64/include/asm/irq_work.h
@@ -2,8 +2,6 @@
 #ifndef __ASM_IRQ_WORK_H
 #define __ASM_IRQ_WORK_H
 
-extern void arch_irq_work_raise(void);
-
 static inline bool arch_irq_work_has_interrupt(void)
 {
 	return true;
diff --git a/arch/csky/include/asm/irq_work.h b/arch/csky/include/asm/irq_work.h
index 33aaf39d6f94..d39fcc1f5395 100644
--- a/arch/csky/include/asm/irq_work.h
+++ b/arch/csky/include/asm/irq_work.h
@@ -7,5 +7,5 @@ static inline bool arch_irq_work_has_interrupt(void)
 {
 	return true;
 }
-extern void arch_irq_work_raise(void);
+
 #endif /* __ASM_CSKY_IRQ_WORK_H */
diff --git a/arch/powerpc/include/asm/irq_work.h b/arch/powerpc/include/asm/irq_work.h
index b8b0be8f1a07..c6d3078bd8c3 100644
--- a/arch/powerpc/include/asm/irq_work.h
+++ b/arch/powerpc/include/asm/irq_work.h
@@ -6,6 +6,5 @@ static inline bool arch_irq_work_has_interrupt(void)
 {
 	return true;
 }
-extern void arch_irq_work_raise(void);
 
 #endif /* _ASM_POWERPC_IRQ_WORK_H */
diff --git a/arch/riscv/include/asm/irq_work.h b/arch/riscv/include/asm/irq_work.h
index b53891964ae0..b27a4d64fc6a 100644
--- a/arch/riscv/include/asm/irq_work.h
+++ b/arch/riscv/include/asm/irq_work.h
@@ -6,5 +6,5 @@ static inline bool arch_irq_work_has_interrupt(void)
 {
 	return IS_ENABLED(CONFIG_SMP);
 }
-extern void arch_irq_work_raise(void);
+
 #endif /* _ASM_RISCV_IRQ_WORK_H */
diff --git a/arch/s390/include/asm/irq_work.h b/arch/s390/include/asm/irq_work.h
index 603783766d0a..f00c9f610d5a 100644
--- a/arch/s390/include/asm/irq_work.h
+++ b/arch/s390/include/asm/irq_work.h
@@ -7,6 +7,4 @@ static inline bool arch_irq_work_has_interrupt(void)
 	return true;
 }
 
-void arch_irq_work_raise(void);
-
 #endif /* _ASM_S390_IRQ_WORK_H */
diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
index 800ffce0db29..6b4d36c95165 100644
--- a/arch/x86/include/asm/irq_work.h
+++ b/arch/x86/include/asm/irq_work.h
@@ -9,7 +9,6 @@ static inline bool arch_irq_work_has_interrupt(void)
 {
 	return boot_cpu_has(X86_FEATURE_APIC);
 }
-extern void arch_irq_work_raise(void);
 #else
 static inline bool arch_irq_work_has_interrupt(void)
 {
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 8cd11a223260..136f2980cba3 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -66,6 +66,9 @@ void irq_work_sync(struct irq_work *work);
 void irq_work_run(void);
 bool irq_work_needs_cpu(void);
 void irq_work_single(void *arg);
+
+void arch_irq_work_raise(void);
+
 #else
 static inline bool irq_work_needs_cpu(void) { return false; }
 static inline void irq_work_run(void) { }
-- 
2.43.0



