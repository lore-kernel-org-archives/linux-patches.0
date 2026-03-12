Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23457310620;
	Thu, 12 Mar 2026 20:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346894; cv=none; b=DQPZP4Qv9wHpit4VpaFe9HLX/E1SjQwcylNVRoVMbIAtpei/y16lk+liDzgCUsDe9T1/Id/xy49fap6+lzwW99WZTmqDybQfW4zTOt/oa6EkZQa5MNttpT+6hJp/3DMPgq/nLQDAFLvIcqR1yqog0PtITSgPiWCmEeVOVpWgGBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346894; c=relaxed/simple;
	bh=9KILnywb1EL2d7Jrj/xMeCPcL90bmglkqAXjfxXiFMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdyx4AomiODQTub2tKTl8pb9tVGfxxFTzrVLOa335ACxvIb30j3wqV7jhfpVUCzZTbOFZuOnDM3EqMkokBarxHkE2xjNBWPE5QrAbV45pqb6SsmHh5pidfY2t/5lb3BDdm/DrmK7/T3aBqBLGxQpVq6ebGq/1yl0Kj9ZLjL4+4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YndbJjFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YndbJjFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AB6C4CEF7;
	Thu, 12 Mar 2026 20:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346894;
	bh=9KILnywb1EL2d7Jrj/xMeCPcL90bmglkqAXjfxXiFMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YndbJjFeFhBnLTg5ivz3SZ+4R/nkGA+1vhYn8dW0U8MTPTG6q5JF2jVkU3fCDLKHZ
	 JoZt21990bt5e053sYnuMkYoQ0w38iZbrWmMnXM/w/PsS8FlZqPkakFWYPi7gdRr3X
	 QR+SkqWdBOBL/0e736h+vjvEBN+h+BOm2bYsDglw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/265] LoongArch: Remove some extern variables in source files
Date: Thu, 12 Mar 2026 21:08:28 +0100
Message-ID: <20260312201022.615317119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 9512fa4fff0f9..e8b95f1bc5786 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -357,8 +357,6 @@ static bool is_entry_func(unsigned long addr)
 
 static inline unsigned long bt_address(unsigned long ra)
 {
-	extern unsigned long eentry;
-
 #if defined(CONFIG_NUMA) && !defined(CONFIG_PREEMPT_RT)
 	int cpu;
 	int vec_sz = sizeof(exception_handlers);
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index c9ee6892d81c7..d4c42dc67134c 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -22,10 +22,6 @@ extern const int unwind_hint_lasx;
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



