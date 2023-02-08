Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994141F921
	for <patches@lists.linux.dev>; Thu, 11 May 2023 12:58:31 +0000 (UTC)
Received: from zn.tnic (p5de8e8ea.dip0.t-ipconnect.de [93.232.232.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2A5E81EC0523
	for <patches@lists.linux.dev>; Thu, 11 May 2023 14:58:29 +0200 (CEST)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Thu, 11 May 2023 14:58:24 +0200
Resent-Message-ID: <20230511125824.GCZFzmcJ3APgWqUzLn@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from deliver ([unix socket])
	 by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
	 Wed, 08 Feb 2023 18:17:34 +0100
X-Sieve: CMU Sieve 2.4
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id A18401EC06BD
	for <bp@alien8.de>; Wed,  8 Feb 2023 18:17:31 +0100 (CET)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 83A86B81B34;
	Wed,  8 Feb 2023 17:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 4CCBFC433A0; Wed,  8 Feb 2023 17:17:30 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8B5EEC433D2;
	Wed,  8 Feb 2023 17:17:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 8B5EEC433D2
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=DiLSGmqcStuArg3rBLGq8SAJVRgpykpD6jS64w6JEaQ=; b=PY9dHY4LGKzmsD4arTwPvnp+04
	Pz+INK98Gns8DlNsOywp5ywYxQl9D4p0pZEqP1Iy6QZrVrRPQDG4NwR9nx4fke4v/s6/B24ihYDP7
	QtEjEoVvzX1FCqadQQHrdRaytGrXp/At0zPubXzkFYAdDMxQByQqMhW7eg1Lh5lVjACygnzBgJxYt
	oXZ4TCd4Og0fOScCXFnNZru+01VvVrbmFjyEaXu+cq7kiNGBbQ1M7FIxJ06Ht+cK0/a4uUSKDzn+j
	vH5rc/N3o/kOVq5qJPAncK9BamyD/FByHO3D+3ukeJqt157gLxiSXkOjmTnp45ifVSzUAbtufQL8v
	U+tuRvMw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pPo4R-001OV6-R6; Wed, 08 Feb 2023 17:17:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 83CAD300912;
	Wed,  8 Feb 2023 18:17:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
	id 65962203D3415; Wed,  8 Feb 2023 18:17:22 +0100 (CET)
Message-ID: <20230208171431.433132442@infradead.org>
User-Agent: quilt/0.66
Date: Wed, 08 Feb 2023 18:10:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 mhiramat@kernel.org,
 kirill.shutemov@linux.intel.com,
 Andrew.Cooper3@citrix.com,
 jpoimboe@redhat.com
Subject: [PATCH v3 4/4] x86/alternative: Complicate optimize_nops() some more
References: <20230208171050.490809180@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Authentication-Results: mail.skyhub.de;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PY9dHY4L;
	spf=pass (mail.skyhub.de: domain of SRS0=D0VR=6E=infradead.org=peterz@kernel.org designates 2604:1380:4601:e00::1 as permitted sender) smtp.mailfrom=SRS0=D0VR=6E=infradead.org=peterz@kernel.org
X-Spamd-Bar: -------

Because:
￼
  SMP alternatives: ffffffff810026dc: [2:44) optimized NOPs: eb 2a eb 28 cc cc
    cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
    cc cc cc cc cc cc cc cc cc cc cc cc cc

is quite daft, make things more complicated and have the NOP runlength
detection eat the preceding JMP if they both end at the same target.

  SMP alternatives: ffffffff810026dc: [0:44) optimized NOPs: eb 2a cc cc cc cc
    cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
    cc cc cc cc cc cc cc cc cc cc cc cc cc

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/alternative.c |   59 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -126,6 +126,7 @@ static void __init_or_module add_nops(vo
 	}
 }
 
+/* Fill the buffer with a single effective instruction of size @len */
 static void __init_or_module add_nop(u8 *instr, unsigned int len)
 {
 	u8 *target = instr + len;
@@ -158,6 +159,9 @@ extern struct alt_instr __alt_instructio
 extern s32 __smp_locks[], __smp_locks_end[];
 void text_poke_early(void *addr, const void *opcode, size_t len);
 
+/*
+ * Matches NOP and NOPL, not any of the other possible NOPs.
+ */
 static bool insn_is_nop(struct insn *insn)
 {
 	if (insn->opcode.bytes[0] == 0x90)
@@ -171,6 +175,10 @@ static bool insn_is_nop(struct insn *ins
 	return false;
 }
 
+/*
+ * Find the offset of the first non-nop instruction starting at @offset
+ * but no further than @len.
+ */
 static int skip_nops(u8 *instr, int offset, int len)
 {
 	struct insn insn;
@@ -187,11 +195,46 @@ static int skip_nops(u8 *instr, int offs
 }
 
 /*
+ * Optimize a sequence of NOPs, possibly preceded by a unconditional jump
+ * to the end of the NOP sequence into a single 'NOP'.
+ */
+static bool __optimize_nops(u8 *instr, size_t len, struct insn *insn,
+			    int *next, int *prev, int *target)
+{
+	int i = *next - insn->length;
+
+	switch (insn->opcode.bytes[0]) {
+	case JMP8_INSN_OPCODE:
+	case JMP32_INSN_OPCODE:
+		*prev = i;
+		*target = *next + insn->immediate.value;
+		return false;
+	}
+
+	if (insn_is_nop(insn)) {
+		int nop = i;
+
+		*next = skip_nops(instr, *next, len);
+		if (*target && *next == *target)
+			nop = *prev;
+
+		add_nop(instr + nop, *next - nop);
+		DUMP_BYTES(ALT, instr, len, "%px: [%d:%d) optimized NOPs: ", instr, nop, *next);
+		return true;
+	}
+
+	*target = 0;
+	return false;
+}
+
+/*
  * "noinline" to cause control flow change and thus invalidate I$ and
  * cause refetch after modification.
  */
 static void __init_or_module noinline optimize_nops(u8 *instr, size_t len)
 {
+	int prev, target = 0;
+
 	for (int next, i = 0; i < len; i = next) {
 		struct insn insn;
 
@@ -200,11 +243,7 @@ static void __init_or_module noinline op
 
 		next = i + insn.length;
 
-		if (insn_is_nop(&insn)) {
-			next = skip_nops(instr, next, len);
-			add_nop(instr + i, next - i);
-			DUMP_BYTES(ALT, instr, len, "%px: [%d:%d) optimized NOPs: ", instr, i, next);
-		}
+		__optimize_nops(instr, len, &insn, &next, &prev, &target);
 	}
 }
 
@@ -275,6 +314,8 @@ bool need_reloc(unsigned long offset, u8
 static void __init_or_module noinline
 apply_relocation(u8 *buf, size_t len, u8 *dest, u8 *src, size_t src_len)
 {
+	int prev, target = 0;
+
 	for (int next, i = 0; i < len; i = next) {
 		struct insn insn;
 
@@ -283,6 +324,9 @@ apply_relocation(u8 *buf, size_t len, u8
 
 		next = i + insn.length;
 
+		if (__optimize_nops(buf, len, &insn, &next, &prev, &target))
+			continue;
+
 		switch (insn.opcode.bytes[0]) {
 		case 0x0f:
 			if (insn.opcode.bytes[1] < 0x80 ||
@@ -324,11 +368,6 @@ apply_relocation(u8 *buf, size_t len, u8
 					    src - dest);
 			}
 		}
-
-		if (insn_is_nop(&insn)) {
-			next = skip_nops(buf, next, len);
-			add_nop(buf + i, next - i);
-		}
 	}
 }
 


