Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016859;
	b=g/PyQl94LC1H37VHlb5TpcNniML5tAUlCMThmmYJFa/NpSA5cTowjGXBZ6PLS4qv5sV1
	 Fa2a0gJ64ojWSy5sT9GIGjxOY1Nhc1JXRdIoF4Kid05j1aCPePUtDjkBtp+SXmvxzSvsr
	 KN4zj2naPImWhGA2hyCnVwZDs/4GlT90C6u5BfDnSGUvaJs+qSAZjG1FHOB4yHEBlfZa6
	 gtPcCofG/cLZCEy6pHHZNPZyeEVYnVajBJJ8BGtpmXBtxcdjW6vJCpBPCAVc1Ra1q1OeG
	 h8Qb61KtP7kojf/021IZ4b+XcZ2P2XUf3XSA0lfXpk0K7eKqg0aDYcLcujmzqkGbFcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tF8Pv3rR8HgqSUS+1ixQY+bSIQz/Y9nYvMXXdGROoeA=;
	b=bonBRI6Kz35p8b2+1Pnw+CLWHTKsd2i5YPwtTyBUdFM1PbtV0l9qKIzTH7+CMjM+bCyH
	 1YNcT9wApmxKprpn7YDCJPFS2hQB4SpM/0yf3ke85NEvdXT+T+tDTkxhZVEgsRoejAsP0
	 W2Ww50bDf0gLUlLJn7iqK8okS55Fos7lYPBcrwX8KOL9Upaq4MUaabkvS6MHWjoCcSox5
	 IzkTzhFVT4bqZJUQ7Q1/ryqGUe/Nnpur7+YmvrHm3n+dlv3rV0PP3V98mUBx00z7ukwfY
	 kpQ55Ucb+5L4Wk2T65Q1uiwVGq2gn2NsrmiA/liIt956jlg+YpbJmMfNmfzn+A5+8gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IYoBeyqe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317A8606A331;
	Wed, 18 Nov 2026 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IYoBeyqe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874321F000C4;
	Wed, 18 Nov 2026 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016859;
	bh=tF8Pv3rR8HgqSUS+1ixQY+bSIQz/Y9nYvMXXdGROoeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYoBeyqe8LLor1aBQUnbW3z1ZrevuU1qKaA0JK6SoITJR0bcWHXPFKtQCIWunfur+
	 oVxpI4U89x0itY5tne70nxcLh5hwMWnEMiufYPES9n0snJf1hW0go/aNE6K6lM8pTm
	 Zut5GSZQj86Rq54VkIyNIhE821kp6o/kJ/pUVFe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0677/2651] x86/asm: Group inline string functions
Date: Wed, 18 Nov 2026 15:31:57 +0100
Message-ID: <20261118150312.243553372@linuxfoundation.org>
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

[ Upstream commit 85f11c17b261772cddc4606f98f6c604aded4607 ]

Group the __inline string functions in the same header.

Use <asm/shared/string.h> since __inline_memcmp() must remain there for use
by arch/x86/boot/string.c.

No functional changes.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260921-pvh-kasan-inline-v10-3-08da47943d8e@igalia.com
Stable-dep-of: b24bc9dec9c8 ("x86/pvh: Really inline memcmp() and memset() to fix unbootable VMs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/shared/string.h | 21 +++++++++++++++++++++
 arch/x86/include/asm/string.h        | 21 +--------------------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/shared/string.h b/arch/x86/include/asm/shared/string.h
index 6291653fe629b..6bef90d62a211 100644
--- a/arch/x86/include/asm/shared/string.h
+++ b/arch/x86/include/asm/shared/string.h
@@ -2,6 +2,27 @@
 #ifndef _ASM_X86_SHARED_STRING_H
 #define _ASM_X86_SHARED_STRING_H
 
+static __always_inline void *__inline_memcpy(void *to, const void *from, size_t len)
+{
+	void *ret = to;
+
+	asm volatile("rep movsb"
+		     : "+D" (to), "+S" (from), "+c" (len)
+		     : : "memory");
+	return ret;
+}
+
+static __always_inline void *__inline_memset(void *s, int v, size_t n)
+{
+	void *ret = s;
+
+	asm volatile("rep stosb"
+		     : "+D" (s), "+c" (n)
+		     : "a" ((uint8_t)v)
+		     : "memory");
+	return ret;
+}
+
 /*
  * Returns:	0 (equal)
  * 		1 (not equal)
diff --git a/arch/x86/include/asm/string.h b/arch/x86/include/asm/string.h
index 9cb5aae7fba9f..dbf59f0d4cca7 100644
--- a/arch/x86/include/asm/string.h
+++ b/arch/x86/include/asm/string.h
@@ -8,25 +8,6 @@
 # include <asm/string_64.h>
 #endif
 
-static __always_inline void *__inline_memcpy(void *to, const void *from, size_t len)
-{
-	void *ret = to;
-
-	asm volatile("rep movsb"
-		     : "+D" (to), "+S" (from), "+c" (len)
-		     : : "memory");
-	return ret;
-}
-
-static __always_inline void *__inline_memset(void *s, int v, size_t n)
-{
-	void *ret = s;
-
-	asm volatile("rep stosb"
-		     : "+D" (s), "+c" (n)
-		     : "a" ((uint8_t)v)
-		     : "memory");
-	return ret;
-}
+#include <asm/shared/string.h>
 
 #endif /* _ASM_X86_STRING_H */
-- 
2.53.0



