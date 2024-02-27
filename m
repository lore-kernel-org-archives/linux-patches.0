Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0206313A26F;
	Tue, 27 Feb 2024 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042757; cv=none; b=FsqqgU/knn3gJGJE5+Mf9VXV5rNJ4FRUJOw+mpu+r73ykGjuiuWaFoUJV/HlhSIpwEfJ3CIxU+IH3+9CHgB7M5o+GQb10DHt1AbFNYN/d8/tGcNgttDIevOXG9vByHHLDY3Q89DZD+fUW8jvi7Z8O4MV6VPUpU63rLh4JERAafk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042757; c=relaxed/simple;
	bh=9Zn55SfMajOpEzQwKuwgP3syqh8ttLGWPk2IfbeyOuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPZcfTwp2E+D+mOf5o0BIBZ2wxfaTUjvAUzbZtUXTVsf9qlUjTWPwSHJNPzN9sWPtU6Vx+0iJHH+HCclpDQW4zM96OHNRakJdwwKqDisGwFnKVVAYJ9ZdnR3eIDnWjdAg+hAKx2ULYFswIGRg/UcyN4g4Sl6bhi6Q7Ad5PutxBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzbLcuh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzbLcuh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC0BC433C7;
	Tue, 27 Feb 2024 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042756;
	bh=9Zn55SfMajOpEzQwKuwgP3syqh8ttLGWPk2IfbeyOuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzbLcuh9P/2PqagShLq0ZLYOg9AcLHCmgPhiOvO9RtblxsYX0ruVXKxGI81nxqdfF
	 u/uwoHjIxfLCUNkxYWAqWbRyAey11D2Uye7IQvyCpBcahKcr3v+bSUOvxPz/IeAO6c
	 9waON+4xlSVN1g7Njv9AiGgxWPWgpzpZQMPmUFKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Heiko Stuebner <heiko.stuebner@vrull.eu>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/245] RISC-V: fix funct4 definition for c.jalr in parse_asm.h
Date: Tue, 27 Feb 2024 14:24:57 +0100
Message-ID: <20240227131618.759302029@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

[ Upstream commit a3775634f6da23f5511d0282d7e792cf606e5f3b ]

The opcode definition for c.jalr is
    c.jalr c_rs1_n0  1..0=2 15..13=4 12=1 6..2=0

This means funct4 consisting of bit [15:12] is 1001b, so the value is 0x9.

Fixes: edde5584c7ab ("riscv: Add SW single-step support for KDB")
Reported-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Link: https://lore.kernel.org/r/20221223221332.4127602-2-heiko@sntech.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/parse_asm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/parse_asm.h b/arch/riscv/include/asm/parse_asm.h
index 3cd00332d70f5..ad254da85e615 100644
--- a/arch/riscv/include/asm/parse_asm.h
+++ b/arch/riscv/include/asm/parse_asm.h
@@ -128,7 +128,7 @@
 #define FUNCT3_C_J		0xa000
 #define FUNCT3_C_JAL		0x2000
 #define FUNCT4_C_JR		0x8000
-#define FUNCT4_C_JALR		0xf000
+#define FUNCT4_C_JALR		0x9000
 
 #define FUNCT12_SRET		0x10200000
 
-- 
2.43.0



