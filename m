Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026552;
	b=oGVZMIBojin77eJB5pR58jbtxJIJZZxQhqOhVjukbbS7iJxMsoytF7IwIYs0HukzD2I8
	 a4M/P9FrwvNa6nULzBv94UDnkjQhPXAv6Z9GP2C2ykJfD+wdUdyQo4IsIXyeXQXZp10Lm
	 4s+Ny4LZar3qsbkCQDgpjK3iPaofq04USBSNAzeT6/zRJ15JBTC/PQ07zFYMMAOBUAuhW
	 QDn2X8iZ5ZDW6m32Abht+5s07dzIsUQ8WghcVUUnFNuPOUNEi4h1TZw3gt3fQV0S+70QE
	 NumyYcERBIioZSmvpm3MIAEyDqbR9DLydhhPG2FGyjC6JZ4dqgNrK5GfOxt4ua/1JFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hGZlXnXH69GY4WS+lhgclWIt7K88wYWCO7CnWu5yF/w=;
	b=Eg8Gp4Amz1i0aLY1ycfvCK6RNJQxtJtpKa3vymBxoCiS+/W6JdxOowJsEOLkHOuBduq7
	 CO+u1TAz3FRWxIYl+LiDIoZC2QrUUToaeoITQ/a5z1uyGvgOatUzTzDk0F18C8q1Avsis
	 qh2L3skTvPrAZuWIEu93W5sz9X6nSi5oe/1TDId2XMMFsV91ewhwdzYUz9qBuRBBhHMdp
	 MXxOKtxbxk+Yl8zsF3b0hbxh5KTxJZ7BRx531ZvbWi30SXMDIcyS2hDHobRRi2f//V++G
	 kpwp5kpcARds7A1qmPPUR+6yF3tPblAdR3u5DD/TPiPf2HFjSljVlSy/Kq7FfOS7t7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oq0M5c9N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC1F606A31C;
	Wed, 18 Nov 2026 18:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oq0M5c9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C891F000C4;
	Wed, 18 Nov 2026 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026551;
	bh=hGZlXnXH69GY4WS+lhgclWIt7K88wYWCO7CnWu5yF/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oq0M5c9N6jtb5IVEiKgW/4YqIf3+aO8mcOQMc5o7HVZFUG+nsFSbszK19NguxGZYj
	 teD6Acc0WBb1/1BUEM0ok2n3m5ZDaOrguxd+ZLmZbZVAh1ssChNsoWMuinxDbEYcHc
	 AAK1QU7tX2jp/t10KMi19GfFQpEO32Ngbgi52q3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Bradley Morgan <brads@mainlining.org>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1477/2151] kcov: report spurious PCs in the interrupt selftest
Date: Wed, 18 Nov 2026 15:53:32 +0100
Message-ID: <20261118150215.688131301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5d9f31ed855fa89e533b222d0365da81ad3b10cc ]

The KCOV interrupt selftest enables KCOV_MODE_TRACE_PC without a coverage
area so that spurious coverage causes a fault.  If the fault path is
instrumented, the coverage callback faults recursively.  Observed failure
modes include a stack overflow on x86_64 and arm32 getting stuck in abort
handling, neither of which identifies the original coverage event.

The recursive failure is not new, but commit 9a79524d1420 ("kcov: use
WRITE_ONCE() for selftest mode stores") made the selftest effective on
configurations where the compiler had previously removed the mode store,
exposing it more broadly.

Replace the open-coded kcov_mode stores with kcov_start() and kcov_stop(),
passing a 16-word buffer that records up to 15 spurious PCs, with the
first word holding the count.  Keep KCOV enabled for the original 300 ms
window, then disable it, print all recorded PCs and panic if any were
recorded.  Once the buffer fills, further PCs are discarded by the
existing coverage callback.  This preserves the selftest's hard failure
while avoiding the recursive fault path.

Add decanonicalize_ip() as the inverse of canonicalize_ip(), which
subtracts kaslr_offset() from recorded PCs.  Restore that offset before
printing the PCs with %pB, since KCOV records return addresses.

Link: https://lore.kernel.org/20261002181357.14293-1-kmehltretter@gmail.com
Fixes: 6cd0dd934b03 ("kcov: Add interrupt handling self test")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Bradley Morgan <brads@mainlining.org> # Power10
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Assisted-by: LLM
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Bradley Morgan <include@grrlz.net>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcov.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/kernel/kcov.c b/kernel/kcov.c
index 2546992d2c810..2c7e01a1db74b 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -198,6 +198,16 @@ static notrace unsigned long canonicalize_ip(unsigned long ip)
 	return ip;
 }
 
+#ifdef CONFIG_KCOV_SELFTEST
+static unsigned long __init decanonicalize_ip(unsigned long ip)
+{
+#ifdef CONFIG_RANDOMIZE_BASE
+	ip += kaslr_offset();
+#endif
+	return ip;
+}
+#endif
+
 /*
  * Entry point from instrumented code.
  * This is called once per basic-block/edge.
@@ -1083,9 +1093,11 @@ u64 kcov_common_handle(void)
 EXPORT_SYMBOL(kcov_common_handle);
 
 #ifdef CONFIG_KCOV_SELFTEST
+static unsigned long selftest_area[16] __initdata;
+
 static void __init selftest(void)
 {
-	unsigned long start;
+	unsigned long start, i, ip, count;
 
 	pr_err("running self test\n");
 	/*
@@ -1095,15 +1107,26 @@ static void __init selftest(void)
 	 * leaks out of that section and leads to spurious coverage.
 	 * It's hard to call the actual interrupt handler directly,
 	 * so we just loop here for a bit waiting for a timer interrupt.
-	 * We set kcov_mode to enable tracing, but don't setup the area,
-	 * so any attempt to trace will crash. Note: we must not call any
+	 * A small coverage area records the PCs of any leaks. The first word
+	 * holds the count, leaving room for 15 PCs. Note: we must not call any
 	 * potentially traced functions in this region.
 	 */
+	kcov_start(current, NULL, ARRAY_SIZE(selftest_area),
+		   selftest_area, KCOV_MODE_TRACE_PC, 0);
 	start = jiffies;
-	WRITE_ONCE(current->kcov_mode, KCOV_MODE_TRACE_PC);
 	while ((jiffies - start) * MSEC_PER_SEC / HZ < 300)
-		;
-	WRITE_ONCE(current->kcov_mode, 0);
+		cpu_relax();
+	kcov_stop(current);
+
+	count = READ_ONCE(selftest_area[0]);
+	if (count) {
+		pr_err("spurious coverage detected during interrupt selftest:\n");
+		for (i = 1; i <= count; i++) {
+			ip = decanonicalize_ip(selftest_area[i]);
+			pr_err("  %pB\n", (void *)ip);
+		}
+		panic("kcov: interrupt selftest detected spurious coverage");
+	}
 	pr_err("done running self test\n");
 }
 #endif
-- 
2.53.0



