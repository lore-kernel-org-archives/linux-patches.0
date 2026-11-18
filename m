Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024229;
	b=EgVnv4h7AQZxlFcR8txJEXuaLWlu3xvbbZuTWLPW2fy40autVypKROfy46pfBdIMmEDX
	 YdFXrOaEyVB0uQcqx+OPY+pxuqHUwG/sBrzhvwqkv7EtEXs5wVK/R/hBNtAP/+wcsG6Lb
	 TXOpoyIsa5FhrHmORXcf8flgA8AzmTxFEqp+yyYW+CFhh1l4nWHTnS5MxTPlp+FEVlryx
	 HTSRPI3DEuX1u6n0iN3n3V5I9jn3YWOnKH3G5avajJ9iXtxC61pS49tmnzRswF7NLAvnk
	 Tkn/+e/1NwPf+owsyNnqb1kMw+HbSFgzoGuayqRpW9A9GPom2ELMvXFEsGH/mh7RKqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+sfAR/usd4Ku9YOY7bs188VhZlWbBFokjVI2PdViaI=;
	b=3B8Dc4l9olQb1uV9BbmQ7s1k7XcME+zd11VPhrgLYnbEv8LS9dipHZzPck1M1+Nw9b+T
	 7Vl2aTLiz9n+to6979tLAuNEer/vTmRE8oM2YDT1EQ5t1vARlO+Ke4NBPcZzVyKyCgHCa
	 LYD6Jp1ojLzBjnoHJJ5tFCbu+uqCYpPzrkynYRKjrMdoopDFAz4JscEzt7jVE5+VroRh7
	 fil3zDaKVhWn58sDdlUNfm3+a/sVdbM9BZJ6xt7HUPyGYtzufbeS2TwY5q2A9T2PDuC1s
	 /sTP1AcjDTW9Se//nNQs5jNRFHSwzvUsGfT4DZ2cWnEfx1lBT/JO7/LwllMpf7e3JcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiDPGbsS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD24E606A31C;
	Wed, 18 Nov 2026 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiDPGbsS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD361F000C6;
	Wed, 18 Nov 2026 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024229;
	bh=Q+sfAR/usd4Ku9YOY7bs188VhZlWbBFokjVI2PdViaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiDPGbsSm3jSJq0JQR13c7HXTTVbRKRR+TmZx8svB+vSPlu2BSKkLDZtxYsF0FSvY
	 c2Dvi1ahI+PSnwOG/bCiLuArNwfcDSk6vFNgaMc8hwp0uMbaLtnr01sFLcZUdHCcI/
	 vZI/WSdK3mV8z4PznvNjCYzwLgW3fQk9m3XCKz00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0610/2151] x86/asm: Introduce inline memcpy and memset
Date: Wed, 18 Nov 2026 15:39:05 +0100
Message-ID: <20261118150144.150145206@linuxfoundation.org>
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

From: Peter Zijlstra (Intel) <peterz@infradead.org>

[ Upstream commit d9a96cc18bec65c39822ee0a1672d7dc3fda150a ]

Provide inline memcpy and memset functions that can be used instead of
the GCC builtins when necessary. The immediate use case is for the text
poking functions to avoid the standard memcpy()/memset() calls because
objtool complains about such dynamic calls within an AC=1 region. See
tools/objtool/Documentation/objtool.txt, warning #9, regarding function
calls with UACCESS enabled.

Some user copy functions such as copy_user_generic() and __clear_user()
have similar rep_{movs,stos} usages. But, those are highly specialized
and hard to combine or reuse for other things. Define these new helpers
for all other usages that need a completely unoptimized, strictly inline
version of memcpy() or memset().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://patch.msgid.link/20251118182911.2983253-4-sohil.mehta%40intel.com
Stable-dep-of: b24bc9dec9c8 ("x86/pvh: Really inline memcmp() and memset() to fix unbootable VMs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/string.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/string.h b/arch/x86/include/asm/string.h
index c3c2c1914d657..9cb5aae7fba9f 100644
--- a/arch/x86/include/asm/string.h
+++ b/arch/x86/include/asm/string.h
@@ -1,6 +1,32 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_STRING_H
+#define _ASM_X86_STRING_H
+
 #ifdef CONFIG_X86_32
 # include <asm/string_32.h>
 #else
 # include <asm/string_64.h>
 #endif
+
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
+#endif /* _ASM_X86_STRING_H */
-- 
2.53.0



