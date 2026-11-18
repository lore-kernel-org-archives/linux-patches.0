Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024116;
	b=pSlP7uchTW46dYd+kDHlP/d7gDXFMXoml2qqSS5sb5W4xnsKocg0NMO9GL1toH8iQKRU
	 Nhi1EgFU4dQ5py+3Fg4wAqvjx3i3Ljf/t0RrZ6ID+3sgl1oa+5IkjbEgJoObEJJBR1GcG
	 f+sTG20tG3LiHDNwPZR26z9t7VrEJ8tYSzHRjih/NudAMd0xQ+n7PM2tMen+vjYKFGQg8
	 Bjeg1Pu28WTOizLS8TVS0rM3DKh8ld3bsBzgOM0MYhbKNDSpaQCu8iXv84FwKN0FeMh5h
	 8J+jDNRBEZjwfjR0oGdO7fnHA78+2yNpH+TRefPRuNBGxXxNkaekNlsP4SUfd7QWWTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y5Hcr5ggJVYC4yZs3iX/+nqn94yFFhmyKsX+tq5pqLo=;
	b=IBvwYfXdXcp1WZKCOqdz9bBlQX3HqqhrlkzhPdV/bEffKFIQMbhY0zBgghPd/TqrwlGM
	 FL78AM5f3EBNrzH9BUw+bbnhKI6PETJ+nDtZjb++pKHbzSYxVU6N1qJsh5+QfgYdbIr1g
	 +8bLPHi49jl4g1JIgMo5JBiaji4LssH5eNP3XaD83GEnQ5FVh5s3leBZI2VzvteVhUDKW
	 avVHDynP5zrwVUAua0VOm8n0rbdtiyson4Zj/dSg09XnnK82cpz1jPXkMIgeiwz4mCVSO
	 /FlE4jkTHERjp3ZTXsLJWYNz9PKHYw1gg6CcHtuxraoU0faU9J0tHWGp1xtwc/DpI7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUt1kj8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA58606A31C;
	Wed, 18 Nov 2026 17:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SUt1kj8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE86C1F000C4;
	Wed, 18 Nov 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024116;
	bh=y5Hcr5ggJVYC4yZs3iX/+nqn94yFFhmyKsX+tq5pqLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUt1kj8pNFoLOjEH7Dh9EDXU7v68IGT+DS1Lygdob/dIAuIdW/IJkGuGh7UiEbfZI
	 X/Pm5icHnOZYPdnj1e1emT+wrY9dZWpycKOx1rjeEA7lHPGUrXvnZhxmTIP8zEViwi
	 n2PXh0AiDb1CbwcGTeNg3RWh5otzc5RA8o7HBXqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0612/2151] x86/asm: Group inline string functions
Date: Wed, 18 Nov 2026 15:39:07 +0100
Message-ID: <20261118150144.217156250@linuxfoundation.org>
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



