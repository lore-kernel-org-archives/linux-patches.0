Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821E747043D;
	Tue, 21 Jul 2026 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655191; cv=none; b=mqAQ5dpYN+hGUk+xv4TcUg8C6fwbZnXIzeqj63ZA9uQVnu4YGhMxhlJ7iiBLhyqneh81prvfUSIN9AsiGYFqSEeM2i+5VTyRWbvsyFQrY+FBZNBIn1DbvjAim1Bir3xPL9ncNHpHPv7o7hxjeeWTVuI2LUTYfBvUN+UMXRh8w5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655191; c=relaxed/simple;
	bh=meH2NYF4sOxFITijo7qb6TmhPUzMUjEX8UYWFduaMQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHKG5yMc7G1+98+b6DRjCAGBaq16r/sacR6TlK4sYnd3j6TtBs4MZ6WuPfREWqcHso893XZ1ijKKAOTIyVjuhLAePXUnzHOhzV1gsn3bevisTFNrt13oz1sMcTIwpPipB2rVHUufRvrYkuWReyImd6rsuzLfvUCNw/9px46NuHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPjTfMCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPjTfMCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39C11F000E9;
	Tue, 21 Jul 2026 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655190;
	bh=p1cXj8mGJT8ACLXXSHSz1yFvDVOdqinloLxXncl3cNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPjTfMCYkq4YGxwz4B3BpvnJJFot3Gp0DXcIjEFhLNIQ0isUWr/kUxSsGjhhRIHOx
	 Kca468PRUeOyXki2BdpO/B18jac3jahuEwOg06DTOiObYX8+h/bMTJgzMHYA6vgV+K
	 odLdBbf5422qYFApHvBW3t6P2OOssvTMzC181Oc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1936/2077] riscv: vdso: Always declare vdso_start symbols
Date: Tue, 21 Jul 2026 17:26:49 +0200
Message-ID: <20260721152638.372642092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 499578e22ae0cc33d05803f22e5c71ffb7077b2f ]

Make the declarations of vdso_start and its related symbols always
visible. With that their users don't have to use ifdeffery but can
use the better IS_ENABLED() compile-time checks.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260504-riscv-cfi-vdso-alternative-v1-1-bcdf3d37f62e@linutronix.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/vdso.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
index 35bf830a557612..f7998d9ad9b2d7 100644
--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -12,12 +12,15 @@
  * All systems with an MMU have a VDSO, but systems without an MMU don't
  * support shared libraries and therefore don't have one.
  */
-#ifdef CONFIG_MMU
 
 #define __VDSO_PAGES    4
 
 #ifndef __ASSEMBLER__
+
+#ifdef CONFIG_MMU
 #include <generated/vdso-offsets.h>
+#endif
+
 #ifdef CONFIG_RISCV_USER_CFI
 #include <generated/vdso-cfi-offsets.h>
 #endif
@@ -38,15 +41,12 @@
 #define COMPAT_VDSO_SYMBOL(base, name)						\
 	(void __user *)((unsigned long)(base) + compat__vdso_##name##_offset)
 
-extern char compat_vdso_start[], compat_vdso_end[];
-
 #endif /* CONFIG_COMPAT */
 
 extern char vdso_start[], vdso_end[];
 extern char vdso_cfi_start[], vdso_cfi_end[];
+extern char compat_vdso_start[], compat_vdso_end[];
 
 #endif /* !__ASSEMBLER__ */
 
-#endif /* CONFIG_MMU */
-
 #endif /* _ASM_RISCV_VDSO_H */
-- 
2.53.0



