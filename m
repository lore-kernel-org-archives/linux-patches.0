Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424FB334373;
	Thu, 27 Nov 2025 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255831; cv=none; b=N3o0dHvQDMaKTkOlZM2X5w4YyUvrlXSHiasE334sHVXKDchH8RVD5RLDZ2eie21ZByCDj+PNuskaFx2atKBXL8Frfvyq078eyJPkpWic/5pMF9+vFcKUtw5mYv4uEJpKmreVw5Ngg3VHUFRe3v+2zjsVPSQLjTOf9F8hOMGidtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255831; c=relaxed/simple;
	bh=ubFin7g+yBdblMMLzh6F8fzKzADErJe8DvRb3ap80A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+Kspi9lA3g+AXqU/BbETVyvjfpYWkxcKdPu4XuC28lbsplcujSFhu5u4BQ6IiTkoRI0refGyFr44px+shUopY26GQKyZes5l0SjaWg6ik/UAMDm4K7miDnz215CpcbMGoAN2ixyjNcILQ36ER3LpWSAbaHkU+I9fo9DksqFm0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ryw0UhJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ryw0UhJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A20C116D0;
	Thu, 27 Nov 2025 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255831;
	bh=ubFin7g+yBdblMMLzh6F8fzKzADErJe8DvRb3ap80A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ryw0UhJPSfDjlQ0Budf8g7/0FZG6QzN0rjGLEY68eyoiqkOGrrWqYaGrdmzXJgqZH
	 RFp165EacVT1KkXEmkkkUbDx8IT2iSPKvJojfZq0x0895+FSHEMPqHhMPa2ccfbnEK
	 bB+YDlcuswFXZMbwLACaE6/uJPtoRSEBC1bXmO4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 128/175] LoongArch: Use UAPI types in ptrace UAPI header
Date: Thu, 27 Nov 2025 15:46:21 +0100
Message-ID: <20251127144047.632691337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 20d7338f2d3bcb570068dd6d39b16f1a909fe976 ]

The kernel UAPI headers already contain fixed-width integer types, there
is no need to rely on the libc types. There may not be a libc available
or the libc may not provides the <stdint.h>, like for example on nolibc.

This also aligns the header with the rest of the LoongArch UAPI headers.

Fixes: 803b0fc5c3f2 ("LoongArch: Add process management")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/uapi/asm/ptrace.h | 40 +++++++++++-------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/loongarch/include/uapi/asm/ptrace.h b/arch/loongarch/include/uapi/asm/ptrace.h
index aafb3cd9e943e..215e0f9e8aa32 100644
--- a/arch/loongarch/include/uapi/asm/ptrace.h
+++ b/arch/loongarch/include/uapi/asm/ptrace.h
@@ -10,10 +10,6 @@
 
 #include <linux/types.h>
 
-#ifndef __KERNEL__
-#include <stdint.h>
-#endif
-
 /*
  * For PTRACE_{POKE,PEEK}USR. 0 - 31 are GPRs,
  * 32 is syscall's original ARG0, 33 is PC, 34 is BADVADDR.
@@ -41,44 +37,44 @@ struct user_pt_regs {
 } __attribute__((aligned(8)));
 
 struct user_fp_state {
-	uint64_t fpr[32];
-	uint64_t fcc;
-	uint32_t fcsr;
+	__u64 fpr[32];
+	__u64 fcc;
+	__u32 fcsr;
 };
 
 struct user_lsx_state {
 	/* 32 registers, 128 bits width per register. */
-	uint64_t vregs[32*2];
+	__u64 vregs[32*2];
 };
 
 struct user_lasx_state {
 	/* 32 registers, 256 bits width per register. */
-	uint64_t vregs[32*4];
+	__u64 vregs[32*4];
 };
 
 struct user_lbt_state {
-	uint64_t scr[4];
-	uint32_t eflags;
-	uint32_t ftop;
+	__u64 scr[4];
+	__u32 eflags;
+	__u32 ftop;
 };
 
 struct user_watch_state {
-	uint64_t dbg_info;
+	__u64 dbg_info;
 	struct {
-		uint64_t    addr;
-		uint64_t    mask;
-		uint32_t    ctrl;
-		uint32_t    pad;
+		__u64    addr;
+		__u64    mask;
+		__u32    ctrl;
+		__u32    pad;
 	} dbg_regs[8];
 };
 
 struct user_watch_state_v2 {
-	uint64_t dbg_info;
+	__u64 dbg_info;
 	struct {
-		uint64_t    addr;
-		uint64_t    mask;
-		uint32_t    ctrl;
-		uint32_t    pad;
+		__u64    addr;
+		__u64    mask;
+		__u32    ctrl;
+		__u32    pad;
 	} dbg_regs[14];
 };
 
-- 
2.51.0



