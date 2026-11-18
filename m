Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016853;
	b=osshP/NP8QQYJRp/uDIrY9qgJ6YWAisTYbkeQud6jD5zvT/jmf9tdMdx4DGtedZxSn3n
	 b1WEIIg3UoUGCCTPOEyc5KxnVcw4vwvuejbUlQemIBxsyhYQ2AGZBGBqHxAFP6LmtSJDZ
	 5Ecoa3ioDrux03tXwfAYdyFxd2tir/0G40h2YARicipus5qbJu2ZKk+OHSCwuwZmODz2u
	 eqLQUic/4b5y7sVDlTzErB0gR46Fl7Ra1QEaYIUsYtACADXIqiwOjX1B7t/C0FHNBZtB0
	 dCxYc0STdmroTLBMsqN0batTxS/5LFgLCapKNfMH8QmkVK2eKSn188wW2jxcnFEOm1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jRKlgO04vXnMcYPVrNcuqSTLpmC+RL5U9DI5TQn07WQ=;
	b=rq+jCJ+IAiAT8gKJm39fCs9moQPqeMhit8MIReCWocxTGeeGtCHdSLKn/KXZVJBa/70i
	 6RcIK2TceeDvu/jmbqhUEXdGI7ku+koz6h18MAdEoFX1ptBNWglq6FutOXXpMvHcw93Wu
	 4PhA6wbRMwErU36UoN27bR9bciMuAIS8i9PGHCFMnDvNv+ltlK1GGPaPlVRBRdAQEKH8S
	 5uzrCeeyHVRl5cPj2C7v3jF6yW5H2LTHwE/PSLFc06yUHBi/FH4417hwfDs8ZUPr6jj5V
	 0FtAA7hJUKACugbKxyToNHkBxfr2znqk5M/0NiFThu70FEKAlH4ihYhvIWV+u+pWnrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oiy5vQ5h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF2A606A31C;
	Wed, 18 Nov 2026 15:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oiy5vQ5h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C5A1F000C4;
	Wed, 18 Nov 2026 15:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016853;
	bh=jRKlgO04vXnMcYPVrNcuqSTLpmC+RL5U9DI5TQn07WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oiy5vQ5hD76ZEW4Fxif/T7g3/em9B5mrFEuK2+/RtEbaIQ/7dUW4qhBCXGzAqGoty
	 JJCFUDHl877g4zNHYcuIecJ99VuZDG+9jFlx79bdMydx3OCriydA0HX0nwj0zWWX3J
	 uWpx58JDBKWW5aFzRjl6fd+dmawHsEFDxOBOPekI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0676/2651] x86/asm, x86/boot: Carve out inline memcmp() into a separate header
Date: Wed, 18 Nov 2026 15:31:56 +0100
Message-ID: <20261118150312.207331522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit 5b6fe00406ce967c556d544a7fc80233341c67c8 ]

Move the inline memcmp() function currently only available in boot/string.c
into the shared string function header <asm/shared/string.h> to be reused.

This is not done through <asm/string.h> to avoid pulling unnecessary code
in boot/string.c that causes build errors in boot/compressed/string.c
and purgatory/purgatory.ro.

No functional changes.

  [ bp: Massage commit message. ]

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260921-pvh-kasan-inline-v10-2-08da47943d8e@igalia.com
Stable-dep-of: b24bc9dec9c8 ("x86/pvh: Really inline memcmp() and memset() to fix unbootable VMs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/string.c               | 17 ++-------------
 arch/x86/include/asm/shared/string.h | 31 ++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/shared/string.h

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index e10260ed58b69..be454a6864225 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/limits.h>
 #include <asm/asm.h>
+#include <asm/shared/string.h>
 #include "ctype.h"
 #include "string.h"
 
@@ -31,21 +32,7 @@
 
 int memcmp(const void *s1, const void *s2, size_t len)
 {
-	bool diff;
-
-	/*
-	 * Make sure ZF is properly set in the len==0 case because in it,
-	 * RCX==0 and the REPE; CMPSB won't get executed.
-	 *
-	 * The "cc" clobber has no meaning anymore, just source compatibility.
-	 * On x86 the flag status bits are automatically added to the clobber
-	 * set when there are no =@ccXY constraints. Keep it as documentation.
-	 */
-	asm volatile("test %3, %3\n\t"
-		     "repe cmpsb"
-		     : "=@ccnz" (diff), "+D" (s1), "+S" (s2), "+c" (len)
-		     : : /* "cc", */ "memory");
-	return diff;
+	return __inline_memcmp(s1, s2, len);
 }
 
 /*
diff --git a/arch/x86/include/asm/shared/string.h b/arch/x86/include/asm/shared/string.h
new file mode 100644
index 0000000000000..6291653fe629b
--- /dev/null
+++ b/arch/x86/include/asm/shared/string.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_SHARED_STRING_H
+#define _ASM_X86_SHARED_STRING_H
+
+/*
+ * Returns:	0 (equal)
+ * 		1 (not equal)
+ *
+ * In contrast, the regular memcmp() follows glibc return value semantics.
+ */
+static __always_inline int __inline_memcmp(const void *s1, const void *s2, size_t len)
+{
+	bool diff;
+
+	/*
+	 * Make sure ZF is properly set in the len==0 case because in it,
+	 * RCX==0 and the REPE; CMPSB won't get executed.
+	 *
+	 * The "cc" clobber has no meaning anymore, just source compatibility.
+	 * On x86 the flag status bits are automatically added to the clobber
+	 * set when there are no =@ccXY constraints. Keep it as documentation.
+	 */
+	asm volatile("test %3, %3\n\t"
+		     "repe cmpsb"
+		     : "=@ccnz" (diff), "+D" (s1), "+S" (s2), "+c" (len)
+		     : : /* "cc", */ "memory");
+
+	return diff;
+}
+
+#endif /* _ASM_X86_SHARED_STRING_H */
-- 
2.53.0



