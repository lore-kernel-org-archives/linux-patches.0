Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0E389471;
	Tue, 10 Mar 2026 11:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142000; cv=none; b=YYK4Rd6EvwWE154El2alx62fSCJrhJ04im6WG63aUEqvHRpg8Ck4JvDBubFnO+mqzYSiZ4oG1C1xPfPmx2bCbBvbtZsLJbS+/KvwtJW6mW5xyMlA3fJx5Jegnin2wFYCSjaBHaDWWP4nJ7L7tKLLlBjqm9l+11oaPrZKDvbDvTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142000; c=relaxed/simple;
	bh=JuDxmJUgq2+uPQiB2+BL+9a4iPlkMPBRu8zA64fCl0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cseqFuqtm6cx3mF869TyH/VlnmA3UmhOmE5ruZ2RSt53aeONiy5S/p9AZXmZ85tcRTjdbnqTL2F1o1XUuJ9uytaqg3wfMVUeliMDebWRLcrmwm+IX/4f9iC73w3jYsUJAysFYbglCn00VcGVRsy99+6Kh2U1d4JLJbsc/E3bGIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/Qy8lp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/Qy8lp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06F9C2BCB3;
	Tue, 10 Mar 2026 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142000;
	bh=JuDxmJUgq2+uPQiB2+BL+9a4iPlkMPBRu8zA64fCl0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/Qy8lp2qPJMF3G7p5wX6LSNJq9yU6lZXZE8x5Sl03ONA8Sl+yYo/t+EKsd7wYsEd
	 oMQcTXEl30DSfYqaafBJNNSHwMLnzjBXhiRPiCJo2bAGQgmM5xZPjOBzop2egxTCEX
	 oxZJhnTlwznSujqFfffuaATm7lhjXlYXls1QWstKuZYEobvzNSJM282A5p4ura4Ub7
	 zqNx6rDdgXHxw7McBhqsKeefBGHIOKXX+5X+0V04ne1WWqFoNRg+OgRrt7dU95mDAa
	 xeGgq5k9E1rZr+wt+MBWPv8dOsCdS/g2nin+WpmuQheUEc5JbHw8d7RupH/Md9im+C
	 CplorOBwK0quA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/314] LoongArch: Remove some extern variables in source files
Date: Tue, 10 Mar 2026 07:16:25 -0400
Message-ID: <b8042dbe30c4ec464d269af9ceb00201680b3788.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 0e6f596d6ac635e80bb265d587b2287ef8fa1cd6 ]

There are declarations of the variable "eentry", "pcpu_handlers[]" and
"exception_handlers[]" in asm/setup.h, the source files already include
this header file directly or indirectly, so no need to declare them in
the source files, just remove the code.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_orc.c      | 2 --
 arch/loongarch/kernel/unwind_prologue.c | 4 ----
 arch/loongarch/mm/tlb.c                 | 1 -
 3 files changed, 7 deletions(-)

diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index ad7e63f495045..85c2fcb76930c 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -358,8 +358,6 @@ static bool is_entry_func(unsigned long addr)
 
 static inline unsigned long bt_address(unsigned long ra)
 {
-	extern unsigned long eentry;
-
 #if defined(CONFIG_NUMA) && !defined(CONFIG_PREEMPT_RT)
 	int cpu;
 	int vec_sz = sizeof(exception_handlers);
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index ee1c29686ab05..da07acad7973a 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -23,10 +23,6 @@ extern const int unwind_hint_lasx;
 extern const int unwind_hint_lbt;
 extern const int unwind_hint_ri;
 extern const int unwind_hint_watch;
-extern unsigned long eentry;
-#ifdef CONFIG_NUMA
-extern unsigned long pcpu_handlers[NR_CPUS];
-#endif
 
 static inline bool scan_handlers(unsigned long entry_offset)
 {
diff --git a/arch/loongarch/mm/tlb.c b/arch/loongarch/mm/tlb.c
index f46c15d6e7eae..24add95ecb65e 100644
--- a/arch/loongarch/mm/tlb.c
+++ b/arch/loongarch/mm/tlb.c
@@ -260,7 +260,6 @@ static void output_pgtable_bits_defines(void)
 #ifdef CONFIG_NUMA
 unsigned long pcpu_handlers[NR_CPUS];
 #endif
-extern long exception_handlers[VECSIZE * 128 / sizeof(long)];
 
 static void setup_tlb_handler(int cpu)
 {
-- 
2.51.0

