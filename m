Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEB13E2764;
	Wed, 20 May 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294573; cv=none; b=RvHrlf0EK3JPwVIvACMt8jbhhQA+UDnhyQa/5ohQGQTX+AysiKtmd4cxnuuD8kH7AdGON8/VBsCwODWcFEXiLimWJs7V9JobK0ZarukeKzVhBJSdwkiBTll7dqpc/Mrg+sTJRE8u6bNoY+WEu/hY5sCFAuL09ceZu24S62WlKsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294573; c=relaxed/simple;
	bh=lbcwavmg6CB2CPSPYr5ClHj1U8AvymfBpL5cAW8R3lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxhV5058L/V8rOkRL4R0Bnw31yRyfYy8SfHDa11oV/zVKi7eAyRo4lMbc4cLUl7gjTqHkABLO9OhAzd8iG2SJG0dSZzmbNaBPfK1d5TcFjMHqq4ho8wmz58yk4IWtr0DU/ySRzhtGvePGq8ztD9+vgsUWIAagzmApliX1xeXpuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyNUyone; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyNUyone"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297E71F000E9;
	Wed, 20 May 2026 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294571;
	bh=EBHPKRYYJ2U6VOF8wO69aqegEJ3vNaap7lQXWDwVA7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyNUyonePdP95YYdSWgIjbiUzxEm/GaeRqrpfrVNdFqXFJkg4aCFfm2wKbv9VKTLV
	 rm72/NXDdE4qbgN8NKQBmvBfbX+sB/TvjgnvnZHBhYdWnz87r8rn7GoCH2RRcYnl3c
	 U05xKuTvkCn2qlWfIPk1bqB7GKsLmy35JMhFwrnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0091/1146] tools/nolibc: MIPS: fix clobbers of lo and hi registers on different ISAs
Date: Wed, 20 May 2026 18:05:41 +0200
Message-ID: <20260520162150.412219106@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit e83b07dc8c05a55d02057b1484724a0b188f6f8d ]

All MIPS ISAs before r6 use the 'lo' and 'hi' special registers.
These are clobbered by system calls and need to be marked as such to
avoid miscompilations. Currently nolibc ties the clobbers to the ABI.
But this is wrong and leads to ISA<->ABI combinations which are not
handled correctly, leading to compiler errors or miscompilations.

Handle all different combinations of ABI and ISA.

Fixes: a6a2a8a42972 ("tools/nolibc: MIPS: add support for N64 and N32 ABIs")
Fixes: 66b6f755ad45 ("rcutorture: Import a copy of nolibc")
Suggested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/lkml/alpine.DEB.2.21.2603141744240.55200@angie.orcam.me.uk/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260317-nolibc-mips-clobber-v2-1-5b9a97761a9e@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-mips.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
index a72506ceec6bd..0c5818149f17e 100644
--- a/tools/include/nolibc/arch-mips.h
+++ b/tools/include/nolibc/arch-mips.h
@@ -39,11 +39,19 @@
  *   - stack is 16-byte aligned
  */
 
+#if !defined(__mips_isa_rev) || __mips_isa_rev < 6
+#define _NOLIBC_SYSCALL_CLOBBER_HI_LO "hi", "lo"
+#else
+#define _NOLIBC_SYSCALL_CLOBBER_HI_LO "$0"
+#endif
+
 #if defined(_ABIO32)
 
 #define _NOLIBC_SYSCALL_CLOBBERLIST \
-	"memory", "cc", "at", "v1", "hi", "lo", \
-	"t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9"
+	"memory", "cc", "at", "v1", \
+	"t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7", "t8", "t9", \
+	_NOLIBC_SYSCALL_CLOBBER_HI_LO
+
 #define _NOLIBC_SYSCALL_STACK_RESERVE "addiu $sp, $sp, -32\n"
 #define _NOLIBC_SYSCALL_STACK_UNRESERVE "addiu $sp, $sp, 32\n"
 
@@ -52,7 +60,8 @@
 /* binutils, GCC and clang disagree about register aliases, use numbers instead. */
 #define _NOLIBC_SYSCALL_CLOBBERLIST \
 	"memory", "cc", "at", "v1", \
-	"10", "11", "12", "13", "14", "15", "24", "25"
+	"10", "11", "12", "13", "14", "15", "24", "25", \
+	_NOLIBC_SYSCALL_CLOBBER_HI_LO
 
 #define _NOLIBC_SYSCALL_STACK_RESERVE
 #define _NOLIBC_SYSCALL_STACK_UNRESERVE
-- 
2.53.0



