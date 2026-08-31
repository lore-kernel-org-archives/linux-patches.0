Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9142E471261;
	Mon, 31 Aug 2026 13:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183312; cv=none; b=ijTwTEkXRqLEUvEKDNLpu8URCQXOT9+eu4e0EWP9wdXJXDUo+SvgJwIVJRPEVUxlRObSAPCr5ZR/VjV5rGSJRwuxl6TLbyVIx26lzjSHu36uCs7Sr6/8Bm5ewzv6dZf8NsmpdH2nB2JevbWav8pToHz16wFQII66ED5DFBoeqOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183312; c=relaxed/simple;
	bh=bxCI9Bw2mENQwrOJ2kSOCCWQ1uPpqfu5jigq8ZSxwHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwwk7VJFNFZAt1mlpBdLJbyE+0XXDA5ch+C2yZZyX52we1UhI/Pohrq64f62rS7cSi362eABeKxaBi9q2+czNNCAtNJZPtQb8H2qHrqHJUWqYO2Ei/1NRPMP1EDg8lBY+GOkUJIWd8/7e8AzBe5kVkI06vwX+FkEHPvkOvtsDeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToeQ/sqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToeQ/sqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B561F00A3F;
	Mon, 31 Aug 2026 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183311;
	bh=7je4D7HCOA1A9JwOZ5zn8NV8msvnyViusw2JmHoGICg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToeQ/sqkcMNUYEMXcqtf1ZSf3nqwry+4ru7zkUUvdcUhIGTSAK1nnotbFZw6Z3tlw
	 S7vqxICM1ccSaM5ZGXe/2ugM34zYjnm6gYLu26oYg66Lnw55KwS1LIQtUF8y5yjkBm
	 df9atEEFYBO0ixuBM5irNPFHQcbxz+/vQRe1pwKQyeyOZ+HH7L24kI+HNpG8IS8JIW
	 TPbq769B4dN7eS9AdIlbcDNWJGOqBFqLxXw6DlDuIUEOHb1Vm69k4wNZll+jUoVL0L
	 1fmxoAiAXpbX+MC0EG5VJ7waR4C3M5M+IWcscuxQky3lwBS3a+zqzOS7lb65PC3P8y
	 INYURhSx0b5Tg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Osama Abdelkader <osama.abdelkader@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] riscv: panic if IRQ handler stacks cannot be allocated
Date: Mon, 31 Aug 2026 09:21:41 -0400
Message-ID: <20260831133314.4125787-73-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit 2abd0dba562551d5c27f97ce560684f534c0cf3a ]

init_irq_stacks() and init_irq_scs() may fail when arch_alloc_vmap_stack
or scs_alloc return NULL, call panic() in this case.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Link: https://patch.msgid.link/20260404185522.21767-1-osama.abdelkader@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The branch check finished: `2abd0dba56255` ("riscv: panic if IRQ handler
stacks cannot be allocated") is on `master` and the `-next` integration
branches, but not on the current `v6.18.44` stable tree. That matches
the earlier **YES** backport recommendation — the fix is mainline-only
and still needs to be cherry-picked into 6.18.y.

 arch/riscv/kernel/irq.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kernel/irq.c b/arch/riscv/kernel/irq.c
index b6af20bc300f5..017d42e778be6 100644
--- a/arch/riscv/kernel/irq.c
+++ b/arch/riscv/kernel/irq.c
@@ -75,28 +75,34 @@ DECLARE_PER_CPU(ulong *, irq_shadow_call_stack_ptr);
 DEFINE_PER_CPU(ulong *, irq_shadow_call_stack_ptr);
 #endif
 
-static void init_irq_scs(void)
+static void __init init_irq_scs(void)
 {
 	int cpu;
+	void *s;
 
 	if (!scs_is_enabled())
 		return;
 
-	for_each_possible_cpu(cpu)
-		per_cpu(irq_shadow_call_stack_ptr, cpu) =
-			scs_alloc(cpu_to_node(cpu));
+	for_each_possible_cpu(cpu) {
+		s = scs_alloc(cpu_to_node(cpu));
+		if (!s)
+			panic("Failed to allocate IRQ shadow call stack resources\n");
+		per_cpu(irq_shadow_call_stack_ptr, cpu) = s;
+	}
 }
 
 DEFINE_PER_CPU(ulong *, irq_stack_ptr);
 
 #ifdef CONFIG_VMAP_STACK
-static void init_irq_stacks(void)
+static void __init init_irq_stacks(void)
 {
 	int cpu;
 	ulong *p;
 
 	for_each_possible_cpu(cpu) {
 		p = arch_alloc_vmap_stack(IRQ_STACK_SIZE, cpu_to_node(cpu));
+		if (!p)
+			panic("Failed to allocate IRQ stack resources\n");
 		per_cpu(irq_stack_ptr, cpu) = p;
 	}
 }
@@ -104,7 +110,7 @@ static void init_irq_stacks(void)
 /* irq stack only needs to be 16 byte aligned - not IRQ_STACK_SIZE aligned. */
 DEFINE_PER_CPU_ALIGNED(ulong [IRQ_STACK_SIZE/sizeof(ulong)], irq_stack);
 
-static void init_irq_stacks(void)
+static void __init init_irq_stacks(void)
 {
 	int cpu;
 
@@ -129,8 +135,8 @@ void do_softirq_own_stack(void)
 #endif /* CONFIG_SOFTIRQ_ON_OWN_STACK */
 
 #else
-static void init_irq_scs(void) {}
-static void init_irq_stacks(void) {}
+static void __init init_irq_scs(void) {}
+static void __init init_irq_stacks(void) {}
 #endif /* CONFIG_IRQ_STACKS */
 
 int arch_show_interrupts(struct seq_file *p, int prec)
-- 
2.53.0

