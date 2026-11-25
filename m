Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621851;
	b=bncWmNqkMPP4kh9Fw8kUQ2n1xbey18i4utMwF2mTAYiMggwxKg/NgbO5iwC2E3obMau4
	 CizH+0sK/k0wu02qeS3dgksota6ed3WAQf64Ed7ccpff8clB78rHTjxjqlXxYmYRPzyYE
	 o1ka2Wtl74fqfzbpdczSvFqVSyxcHzfFIO8/XPw7qFYsrHpR6Zr/lS58fzJfJ1r05wHlh
	 jyy6Amz75hpQiMmSFqUisw6tpi6DbjVG9sRxCbx3MYbPRceKXNlpLryw01ZqO+nC025Xv
	 LUKYXBmRrtDxmpDh6dRkqnsLYQCMGPcA5I9MSvcDM2faUdU2qyakZ4mUcYH0unRr6bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6NoqEb8a4e4luC4KyyAogPoXsp/QGtTAM+JCAsB4N/4=;
	b=Pcrx3BmkAjvOlIoRT8v2hT9Q4RYu9ouyq8oha22SqNd57D2YSoEt6ZhkBxor3XJUJ7v3
	 HQ8b6nUJHaCpD2dEuTLwuAE89zpYiBwF5guGUPx+tc11Ax2v03rBRniSPEXmE0uSY+iMH
	 JfAHwyTuEhDaslRE5u/Xaxj6+eMG+prn+39bRAcOWKQljzfL76OEc0OXcHBR9ESNrpm1R
	 J0oXfBxaU3+5LpdN2zIPuIASAXv9hvaF6VQG1e5HGalvYWoE2Dkreu1VXVwR64BVroy7N
	 dzxHDMUg6t5gFG0Vwg2oIrHWlcwrHsXvYO4GVQUo7GGjCpiQc+uJBKiafWbnReh7Rmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPpwrdoH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF29606A31E;
	Wed, 25 Nov 2026 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPpwrdoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495201F000C0;
	Wed, 25 Nov 2026 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621851;
	bh=6NoqEb8a4e4luC4KyyAogPoXsp/QGtTAM+JCAsB4N/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPpwrdoHzLQEI5/6YL0TdtpYEtEZ1iNZxIr+eLoiL+zHv+AfDeFuM82E6FomjwVhE
	 MPSttU218+UKxTTBTTylJFUKWaDvzSApEY+1nfNPYOwz7cHiP8DDb5iy24f3Ek9dA5
	 r4j4A7LrHn/eXoah11AQE+q+smmWNhNEsaQXxmG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/990] perf: Eliminate duplicate arch-specific function definitions
Date: Wed, 25 Nov 2026 15:27:56 +0100
Message-ID: <20261125143829.328695026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit cb388bd530cc518b0e245fb4eabc40f3de538e4f ]

Define default common __weak functions for perf_reg_value(),
perf_reg_validate(), perf_reg_abi() and perf_get_regs_user(). This helps
to eliminate the duplicated arch-specific definitions.

No function changes intended.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260824082731.1013973-5-dapeng1.mi@linux.intel.com
Stable-dep-of: b61c12527223 ("perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/perf_regs.c       |  6 ------
 arch/arm64/kernel/perf_regs.c     |  6 ------
 arch/csky/kernel/perf_regs.c      |  6 ------
 arch/loongarch/kernel/perf_regs.c |  6 ------
 arch/mips/kernel/perf_regs.c      |  6 ------
 arch/parisc/kernel/perf_regs.c    |  6 ------
 arch/riscv/kernel/perf_regs.c     |  6 ------
 arch/x86/kernel/perf_regs.c       |  6 ------
 include/linux/perf_regs.h         | 32 ++++++-------------------------
 kernel/events/core.c              | 22 +++++++++++++++++++++
 10 files changed, 28 insertions(+), 74 deletions(-)

diff --git a/arch/arm/kernel/perf_regs.c b/arch/arm/kernel/perf_regs.c
index 0529f90395c94..d575a4c3ca56f 100644
--- a/arch/arm/kernel/perf_regs.c
+++ b/arch/arm/kernel/perf_regs.c
@@ -31,9 +31,3 @@ u64 perf_reg_abi(struct task_struct *task)
 	return PERF_SAMPLE_REGS_ABI_32;
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
index b4eece3eb17d0..70e2f13f587f5 100644
--- a/arch/arm64/kernel/perf_regs.c
+++ b/arch/arm64/kernel/perf_regs.c
@@ -98,9 +98,3 @@ u64 perf_reg_abi(struct task_struct *task)
 		return PERF_SAMPLE_REGS_ABI_64;
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
diff --git a/arch/csky/kernel/perf_regs.c b/arch/csky/kernel/perf_regs.c
index 09b7f88a2d6ad..94601f37b596d 100644
--- a/arch/csky/kernel/perf_regs.c
+++ b/arch/csky/kernel/perf_regs.c
@@ -31,9 +31,3 @@ u64 perf_reg_abi(struct task_struct *task)
 	return PERF_SAMPLE_REGS_ABI_32;
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
diff --git a/arch/loongarch/kernel/perf_regs.c b/arch/loongarch/kernel/perf_regs.c
index 263ac4ab5af68..8dd604f017454 100644
--- a/arch/loongarch/kernel/perf_regs.c
+++ b/arch/loongarch/kernel/perf_regs.c
@@ -45,9 +45,3 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
 	return regs->regs[idx];
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
diff --git a/arch/mips/kernel/perf_regs.c b/arch/mips/kernel/perf_regs.c
index e686780d1647a..7736d3c5ebd2c 100644
--- a/arch/mips/kernel/perf_regs.c
+++ b/arch/mips/kernel/perf_regs.c
@@ -60,9 +60,3 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
 	return (s64)v; /* Sign extend if 32-bit. */
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
diff --git a/arch/parisc/kernel/perf_regs.c b/arch/parisc/kernel/perf_regs.c
index 68458e2f6197e..87e6990569a76 100644
--- a/arch/parisc/kernel/perf_regs.c
+++ b/arch/parisc/kernel/perf_regs.c
@@ -53,9 +53,3 @@ u64 perf_reg_abi(struct task_struct *task)
 	return PERF_SAMPLE_REGS_ABI_64;
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
diff --git a/arch/riscv/kernel/perf_regs.c b/arch/riscv/kernel/perf_regs.c
index fd304a248de68..3bba8deababbf 100644
--- a/arch/riscv/kernel/perf_regs.c
+++ b/arch/riscv/kernel/perf_regs.c
@@ -35,9 +35,3 @@ u64 perf_reg_abi(struct task_struct *task)
 #endif
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
index 624703af80a19..81204cb7f7239 100644
--- a/arch/x86/kernel/perf_regs.c
+++ b/arch/x86/kernel/perf_regs.c
@@ -100,12 +100,6 @@ u64 perf_reg_abi(struct task_struct *task)
 	return PERF_SAMPLE_REGS_ABI_32;
 }
 
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
 #else /* CONFIG_X86_64 */
 #define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
 		       (1ULL << PERF_REG_X86_ES) | \
diff --git a/include/linux/perf_regs.h b/include/linux/perf_regs.h
index f632c5725f162..144bcc3ff19fe 100644
--- a/include/linux/perf_regs.h
+++ b/include/linux/perf_regs.h
@@ -9,6 +9,12 @@ struct perf_regs {
 	struct pt_regs	*regs;
 };
 
+u64 perf_reg_value(struct pt_regs *regs, int idx);
+int perf_reg_validate(u64 mask);
+u64 perf_reg_abi(struct task_struct *task);
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs);
+
 #ifdef CONFIG_HAVE_PERF_REGS
 #include <asm/perf_regs.h>
 
@@ -16,35 +22,9 @@ struct perf_regs {
 #define PERF_REG_EXTENDED_MASK	0
 #endif
 
-u64 perf_reg_value(struct pt_regs *regs, int idx);
-int perf_reg_validate(u64 mask);
-u64 perf_reg_abi(struct task_struct *task);
-void perf_get_regs_user(struct perf_regs *regs_user,
-			struct pt_regs *regs);
 #else
 
 #define PERF_REG_EXTENDED_MASK	0
 
-static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
-{
-	return 0;
-}
-
-static inline int perf_reg_validate(u64 mask)
-{
-	return mask ? -ENOSYS : 0;
-}
-
-static inline u64 perf_reg_abi(struct task_struct *task)
-{
-	return PERF_SAMPLE_REGS_ABI_NONE;
-}
-
-static inline void perf_get_regs_user(struct perf_regs *regs_user,
-				      struct pt_regs *regs)
-{
-	regs_user->regs = task_pt_regs(current);
-	regs_user->abi = perf_reg_abi(current);
-}
 #endif /* CONFIG_HAVE_PERF_REGS */
 #endif /* _LINUX_PERF_REGS_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6e194e4ce4a03..e7e052f62204b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7606,6 +7606,28 @@ unsigned long perf_instruction_pointer(struct perf_event *event,
 		0 : perf_arch_instruction_pointer(regs);
 }
 
+u64 __weak perf_reg_value(struct pt_regs *regs, int idx)
+{
+	return 0;
+}
+
+int __weak perf_reg_validate(u64 mask)
+{
+	return mask ? -ENOSYS : 0;
+}
+
+u64 __weak perf_reg_abi(struct task_struct *task)
+{
+	return PERF_SAMPLE_REGS_ABI_NONE;
+}
+
+void __weak perf_get_regs_user(struct perf_regs *regs_user,
+			       struct pt_regs *regs)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
+
 static void
 perf_output_sample_regs(struct perf_output_handle *handle,
 			struct pt_regs *regs, u64 mask)
-- 
2.53.0



