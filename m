Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024232;
	b=QxjfoZEqqc2+FMwWn//cgDC2XAhWm5gWCFPgBG+L0M3vRT4j6ELmSRRrVNPYAEe71zdA
	 o/nudClIAVg12kUT/q0Oa0yetI/bLj0YCXyYCXWSFp4wfbMPkE1g2QGpXn21S8UeI2jZx
	 o5cgdFhe4gkXxDa3ecILXBK9ZHLPnaXnU2/CTZ82sO7d7OAXWlxjv67Fktxw/vRb8H/5+
	 vPVst/0WYcii12OuKdGkJOjCy2gw8FPy7NrxQuzqCrtjFyyQ01EmWifJkEt8H2CvCYm+x
	 MosR2/N2EGJJnceQEl24zvCx/qErWU2P0n/TUrhb2HH2MfPz4I0MQl8vTiQhFwLwfLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RUEeiEDqkJlSG7EklqUu7aGw4Vz1stgiPM1J2fVpK/o=;
	b=gjW0SsBTifgSJMoC0rx6HYI/OOq6jXfEZgf40ioRvCYrqjNNIyiecolf9oXZP4vPDMeE
	 2YkE1cP6Kx3vPwuhRMhgbj8Mw5CBG5o4HKaROk6TU8yxHE8j8N7247XJGZLl8UosACdlu
	 DHBpMfowuTefqfMTiJxFOTrm+sqWAOxY56Gv0z7labPekUt+P2XTQ5bcNsTU2/iOg9kzi
	 JTJDCunQMIAoyAU3fEwyzf8AsbQZ06+jc+NDGeDDJugHDNtMjhvVPcwTRFAd8ZAZ9Mrt8
	 TmzmaKzu+f1fPi/YfprGrkHHrBRmNkanWlWg6OG0QMqiHWhp1OVr+rQQ+IrUI5Kzyng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEm0DgjK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBAA606A31C;
	Wed, 18 Nov 2026 17:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEm0DgjK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65511F000C4;
	Wed, 18 Nov 2026 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024232;
	bh=RUEeiEDqkJlSG7EklqUu7aGw4Vz1stgiPM1J2fVpK/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEm0DgjKcJI0U64kWHK/Q9fU+j0ehm1gWSfJ/gOkr8MuhZqxOFuWKOekcctRi3VtC
	 5rloP2tZVjNhrufan6kvqWv54+lVp09GI5b6O/Z3c7OSPGnV1Xeq8KQayG5xAT8pKI
	 tWTonmUyTDXvekcruFen2wZs3iJziWQeYWsg/8fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0611/2151] x86/asm, x86/boot: Carve out inline memcmp() into a separate header
Date: Wed, 18 Nov 2026 15:39:06 +0100
Message-ID: <20261118150144.183885991@linuxfoundation.org>
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
index fa9623988826b..ab37cf5fcc78a 100644
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



