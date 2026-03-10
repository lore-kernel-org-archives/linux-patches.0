Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A750C3876A3;
	Tue, 10 Mar 2026 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142108; cv=none; b=JT6TrWyLJx88FqhmeMPG87Vo5oEWm06gr8Z/x4Q3IIkrNYfGEVrqSlQ65NGvYwx3Q6TSljjfm3VWDZ853Wy9vQYwtLp/NMBUNbcbwtX7SQ3AuJCbThWXIZheCXjXbEOoe8K2jN+pMpDRhIH+CoruE6UlEEHWnLIto2egF2aeouU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142108; c=relaxed/simple;
	bh=QJXwbPjyVp0+kak7buhcLdYWSXN30mid9G2jcPYUiPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMGz4A7B5KNzP6SOsJ7h9L3adMP8T6ddJXBC/WVaFrH6GVLCUcHYxPQgaJ5DRczVMdhwyZuyAKTW7ExPCnHCsXmlMr0mmE1ZIlHNHuR1LUD7R96mldouXo4NW3igtgkihdQVIEtdgOY7fCs2GWw6NZAfqMtaz3B5IGpkDeCrGCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAeOuzJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAeOuzJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBF3C19423;
	Tue, 10 Mar 2026 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142108;
	bh=QJXwbPjyVp0+kak7buhcLdYWSXN30mid9G2jcPYUiPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAeOuzJ+96Nk0TQgHdZctiyi8sPPGDN9ibEOB9Nm3o6wxmUOyrwTfTrFZod6nd+rE
	 ouWu1FFePgSLxze19r8cWUBUFCfRskrlTuIvQg9R1XOMSWZSpbew1IhSAO3/hSWMYg
	 RquGFHiBTc3hOaf9Id5RkxNp21wgj9kR8RI7ofB9lg9MgPMcS0CyZ592nSAXLePo0x
	 H4w8dfM9fg5xnUouEebLG/vpbXEMqNBZOMfhUtV4N81DBhz6dyA+OeWoXMrFSfFCMD
	 Dq0Eb4HF/HJgAqKQaS3xxAvSe1Fqktqjd112m6Dv+Z8q0eZMc0017YQLb+JTjR8uMd
	 HNmzphvsOWNzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 196/314] ARM: clean up the memset64() C wrapper
Date: Tue, 10 Mar 2026 07:17:35 -0400
Message-ID: <e90c017f26ea6eb53039ae658d41e54e8e20cd52.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit b52343d1cb47bb27ca32a3f4952cc2fd3cd165bf upstream.

The current logic to split the 64-bit argument into its 32-bit halves is
byte-order specific and a bit clunky.  Use a union instead which is
easier to read and works in all cases.

GCC still generates the same machine code.

While at it, rename the arguments of the __memset64() prototype to
actually reflect their semantics.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk> # for -stable
Link: https://lore.kernel.org/all/1a11526ae3d8664f705b541b8d6ea57b847b49a8.camel@decadent.org.uk/
Suggested-by: https://lore.kernel.org/all/aZonkWMwpbFhzDJq@casper.infradead.org/ # for -stable
Link: https://lore.kernel.org/all/aZonkWMwpbFhzDJq@casper.infradead.org/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/string.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/string.h b/arch/arm/include/asm/string.h
index c35250c4991bc..96fc6cf460ecb 100644
--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -39,13 +39,17 @@ static inline void *memset32(uint32_t *p, uint32_t v, __kernel_size_t n)
 }
 
 #define __HAVE_ARCH_MEMSET64
-extern void *__memset64(uint64_t *, uint32_t low, __kernel_size_t, uint32_t hi);
+extern void *__memset64(uint64_t *, uint32_t first, __kernel_size_t, uint32_t second);
 static inline void *memset64(uint64_t *p, uint64_t v, __kernel_size_t n)
 {
-	if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
-		return __memset64(p, v, n * 8, v >> 32);
-	else
-		return __memset64(p, v >> 32, n * 8, v);
+	union {
+		uint64_t val;
+		struct {
+			uint32_t first, second;
+		};
+	} word = { .val = v };
+
+	return __memset64(p, word.first, n * 8, word.second);
 }
 
 /*
-- 
2.51.0

