Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059220;
	b=GIdlV04jsze1baKCkZGmlTiHVrlEY/zw7K+TilbGdhvH8nHF0i9xlw/juyr4TAMUXoWM
	 EJIMi5RRakArXC+Ij9TfeHgSQJttrW/J/vG9OlyJnddRuywDyo2GkNbiazC94fL7+6iKG
	 7BCEy7bH/2AvUQyj9NTpyxcW7uPaDtrmVvzHM25WtBKP8ZyQX537cNiOh/VewhAxyug3a
	 qh9sjgYYN6hV/j1BKyatt2yUWqFfZexD0vfKqJ+G02EA9olfrCUnSxfSIky+pCKrYfh0b
	 OsBsgbr3R42m3a2X6tZCCLG3rhKBpWbYn+xlja2krJqRau57zAAKBPp7anHHOrTjHDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PWA9d9aEpMgocTLUwuXKQXuno+CObOrrxswdczJU9KY=;
	b=rdACcHviPEbjwl/9VtrpOgdD9VmbpUhB9iFbq3xtzqQObYRMk+icuPOWJFufkvB2YDQC
	 PJJaXm6PJHvtORNBdNw059ffhjplwVz3gpJ3MS7ymuL2pAYm/a4+zN8f/6qpmfmxAOmL7
	 3UWxQO4Qjft3YZCO/4Kbo8ikKIfPvstQEBCuHPJ+Q0p6rQpwhGfSWVcOJ+Ve2H/j1GdIu
	 YYoM9rrufwtyb3beotrry33e9D0PBK07Iocxb1syUyTBAQINd/HDD3sJS9j+CprNwqrPH
	 jZsz14V4lPRzNu4rQYL/25qb+D6ZpjdZJGtAwWa5Mh/Lt1gekA3XnpZUaZPKmoSmFSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHKXNTAy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C6E606A320;
	Thu, 19 Nov 2026 03:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHKXNTAy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692DD1F000C4;
	Thu, 19 Nov 2026 03:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059219;
	bh=PWA9d9aEpMgocTLUwuXKQXuno+CObOrrxswdczJU9KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHKXNTAyAU/Lx+ZaUKE4SuaEVdMDNesUQO7x1D2refoaoY3PjsxIJtW2SJUjl5jk5
	 WQuPfNKhUaclSCw2KxYTV2Z5lvKuoURMGeyuOBpRM7JHs3FsFM3VRk5Et1zQFOzwlZ
	 PaBLIuFzY1mey/+EYMtdMw9gLcEv/DF1/vPecJ2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@xilinx.com>,
	Mahesh Bodapati <mbodapat@xilinx.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0765/1848] microblaze: Use simple memset implementation from lib/string.c
Date: Wed, 18 Nov 2026 15:46:43 +0100
Message-ID: <20261118145948.448580148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit 8f0f265e6cf5b6d99a5a5d01b36985bc1131183e ]

On microblaze systems which are not using OPT_LIB_FUNCTION only simple
memset is used. This function is already implemented in lib/string.c that's
why it should be used instead.
This change is done in respect of issue fixed by commit 33d0f96ffd73
("lib/string.c: Use freestanding environment") where gcc-10.x moved
-ftree-loop-distribute-patterns optimization is to O2 optimization level.
This optimization causes GCC to convert the while loop in memset.c into a
call to memset. So This optimization is transforming a loop in a
memset/memcpy into a call to the function itself. This makes the memset
implementation as recursive.

Based on fix above -ffreestanding was used and it needs to be used on
Microblaze too but the patch is not adding this flag it removes simple
implementation to cause that generic implementation is used where this flag
is already setup.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Mahesh Bodapati <mbodapat@xilinx.com>
Link: https://lore.kernel.org/r/4a143e7654f72ee893dcea9769946e17d3570b16.1645797329.git.michal.simek@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/include/asm/string.h |  2 ++
 arch/microblaze/lib/memset.c         | 20 ++------------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/microblaze/include/asm/string.h b/arch/microblaze/include/asm/string.h
index 34071a848b6a2..dbdb9eb4a733c 100644
--- a/arch/microblaze/include/asm/string.h
+++ b/arch/microblaze/include/asm/string.h
@@ -8,7 +8,9 @@
 
 #ifdef __KERNEL__
 
+#ifdef CONFIG_OPT_LIB_FUNCTION
 #define __HAVE_ARCH_MEMSET
+#endif
 #define __HAVE_ARCH_MEMCPY
 #define __HAVE_ARCH_MEMMOVE
 
diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
index 04ea72c8a81dd..8810a89de851f 100644
--- a/arch/microblaze/lib/memset.c
+++ b/arch/microblaze/lib/memset.c
@@ -30,22 +30,7 @@
 #include <linux/compiler.h>
 #include <linux/string.h>
 
-#ifdef __HAVE_ARCH_MEMSET
-#ifndef CONFIG_OPT_LIB_FUNCTION
-void *memset(void *v_src, int c, __kernel_size_t n)
-{
-	char *src = v_src;
-
-	/* Truncate c to 8 bits */
-	c = (c & 0xFF);
-
-	/* Simple, byte oriented memset or the rest of count. */
-	while (n--)
-		*src++ = c;
-
-	return v_src;
-}
-#else /* CONFIG_OPT_LIB_FUNCTION */
+#ifdef CONFIG_OPT_LIB_FUNCTION
 void *memset(void *v_src, int c, __kernel_size_t n)
 {
 	char *src = v_src;
@@ -92,6 +77,5 @@ void *memset(void *v_src, int c, __kernel_size_t n)
 
 	return v_src;
 }
-#endif /* CONFIG_OPT_LIB_FUNCTION */
 EXPORT_SYMBOL(memset);
-#endif /* __HAVE_ARCH_MEMSET */
+#endif /* CONFIG_OPT_LIB_FUNCTION */
-- 
2.53.0



