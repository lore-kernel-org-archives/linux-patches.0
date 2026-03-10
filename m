Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60F2BF3E2;
	Tue, 10 Mar 2026 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141170; cv=none; b=myhUWPOoyl+kpB+mWR6Z4d1vvEiwu8qhrOYQu9pFajVMtQdglMyPFwthnDP2etMETbRxq9gL0OnbIvDReAN52rS26r0y1NFLgtZjMsaxsqFULZAK+JHKJyfP1q8tRGqwxZBfND/lCtK1mQZbeIa2MWRzDZgF63hwkQWNw0clpRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141170; c=relaxed/simple;
	bh=QJXwbPjyVp0+kak7buhcLdYWSXN30mid9G2jcPYUiPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/hOh4ro1hm7ChgXeSo0yg4S5NfuL8pry9J2pqJ6dTlXb4JxGm8/juXzXE9YO44F00DjqfzxaTMonPozGNWCzdT2bzJQAv6bbbYgw9WT6FjPfOtfoRtJvwkRuP29zYVvP2sPToa0yKYv9GZkOJwIp2NdE8MRcMNfik3ZfIwZG24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kh5YQfhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kh5YQfhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6EAC19423;
	Tue, 10 Mar 2026 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141170;
	bh=QJXwbPjyVp0+kak7buhcLdYWSXN30mid9G2jcPYUiPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kh5YQfhw4BgIYxieQG5yy2scZB7KKHW4JEoCVNr6I4kQ2LoyaHjujW7mk5Xy2yjbe
	 t3ZWaZeY/c5FVzwF+70HTm+lm6Nhe9TbOTlju7mO+YULkKb+ET7P/CiyRVRcoyx391
	 pYRcadu34wxL8VBccc90I+AXShcpu36Mla9z9l/tyQAKqq3CrXxLt37//w9gThFKUT
	 DGxnOOTJGR40SWQarlxQMIcfWT3jZcifip7p5C+js3mT40lTxQVoEHyHMYms4XPwos
	 EPv84QGrPJGpMg8LIFjV2BQJ63G6n5rtECzmNiH3DxbFHDfE5xjzDyEg/Fyv8up8og
	 Ss20dk2sDLMxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 171/311] ARM: clean up the memset64() C wrapper
Date: Tue, 10 Mar 2026 07:03:38 -0400
Message-ID: <48ca97eadcdb666dd6af3510ca9844bbf2bf1b38.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

