Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5116C2C3745;
	Mon, 27 Oct 2025 19:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591674; cv=none; b=TFr25H9w+63a/z9tpAsP3Q6JoCJ6+K4B8jHUOIxvHt3q7j9r+LU7T9ERvDI4ftKE7erSzBFJ0gM9mH3ufJ4EMh8kD2wWlqUEmHA47SR7BIQDehetSuD7MoPECk0PKKPXMLJfMoKNFCxivXM7aAC5lZ92NKynFcUu4tPJx4fLpVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591674; c=relaxed/simple;
	bh=KqduGBqKlYyl2Sd6bNpNcLS/2n0t5y0gsmFsaC+By74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOHJD2Twth+p9faiiNngCa4i2GX4nIBveDus/VHDrrHedvOUsilnubVVAbHQdSmIURmRXPka9ZC6RP1pv4xPuAyxPFF0XsWBwD1HTEDibKREzkY/Uh+o951dq3cIfLhi0kv1slMAwfrREtUZIXILghMIYLCjpM2AnIKVup2YIZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PH7qMVNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PH7qMVNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA26C4CEF1;
	Mon, 27 Oct 2025 19:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591674;
	bh=KqduGBqKlYyl2Sd6bNpNcLS/2n0t5y0gsmFsaC+By74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PH7qMVNQm8KMbbItcorMEZIoping7lggX9hWmgPUETC6sTIk7mYImySPcDNe6w/cq
	 KpzHrfQ3tOEFrTFWeH/cPCebMo9qvA3JPKCU8hg/lhsXR9PIMIpiW/QgII7gnfGAvt
	 0v1res6pIdtDqF7aQc+fr8jElS5fYS+/cN2swq6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <anup@brainfault.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Tsukasa OI <research_trasio@irq.a4lg.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/332] RISC-V: Correctly print supported extensions
Date: Mon, 27 Oct 2025 19:35:40 +0100
Message-ID: <20251027183532.436417175@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tsukasa OI <research_trasio@irq.a4lg.com>

[ Upstream commit 58004f266918912771ee71f46bfb92bf64ab9108 ]

This commit replaces BITS_PER_LONG with number of alphabet letters.

Current ISA pretty-printing code expects extension 'a' (bit 0) through
'z' (bit 25).  Although bit 26 and higher is not currently used (thus never
cause an issue in practice), it will be an annoying problem if we start to
use those in the future.

This commit disables printing high bits for now.

Reviewed-by: Anup Patel <anup@brainfault.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Tsukasa OI <research_trasio@irq.a4lg.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: d2721bb165b3 ("RISC-V: Don't print details of CPUs disabled in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index ac202f44a6702..ece126dad3547 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -13,6 +13,8 @@
 #include <asm/smp.h>
 #include <asm/switch_to.h>
 
+#define NUM_ALPHA_EXTS ('z' - 'a' + 1)
+
 unsigned long elf_hwcap __read_mostly;
 
 /* Host ISA bitmap */
@@ -63,7 +65,7 @@ void riscv_fill_hwcap(void)
 {
 	struct device_node *node;
 	const char *isa;
-	char print_str[BITS_PER_LONG + 1];
+	char print_str[NUM_ALPHA_EXTS + 1];
 	size_t i, j, isa_len;
 	static unsigned long isa2hwcap[256] = {0};
 
@@ -133,13 +135,13 @@ void riscv_fill_hwcap(void)
 	}
 
 	memset(print_str, 0, sizeof(print_str));
-	for (i = 0, j = 0; i < BITS_PER_LONG; i++)
+	for (i = 0, j = 0; i < NUM_ALPHA_EXTS; i++)
 		if (riscv_isa[0] & BIT_MASK(i))
 			print_str[j++] = (char)('a' + i);
 	pr_info("riscv: ISA extensions %s\n", print_str);
 
 	memset(print_str, 0, sizeof(print_str));
-	for (i = 0, j = 0; i < BITS_PER_LONG; i++)
+	for (i = 0, j = 0; i < NUM_ALPHA_EXTS; i++)
 		if (elf_hwcap & BIT_MASK(i))
 			print_str[j++] = (char)('a' + i);
 	pr_info("riscv: ELF capabilities %s\n", print_str);
-- 
2.51.0



