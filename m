Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF3F4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E71C433EF;
	Wed, 15 Mar 2023 12:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882851;
	bh=w5o682cpPY+xl+Cyxd9yvHew6++fZ2yPQm4pN/S+Xxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiZGJ9JJDjBSS7wBosm2eH/HM6FXR8DprCvslzLOcbhhskRm600fhkWsqAq9JIdIH
	 8ZXEpQGyINRYPYBH4Ztvmqso9SYuGaZADyAAqttBi8kXON0//CnC/Yrg3Sc1fYvpB5
	 1qwfgh6nPsCkCOqPuurrRmaYWs1UQ/dCziJLYsVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chang <liaochang1@huawei.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/104] riscv: Add header include guards to insn.h
Date: Wed, 15 Mar 2023 13:11:56 +0100
Message-Id: <20230315115733.097015974@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit 8ac6e619d9d51b3eb5bae817db8aa94e780a0db4 ]

Add header include guards to insn.h to prevent repeating declaration of
any identifiers in insn.h.

Fixes: edde5584c7ab ("riscv: Add SW single-step support for KDB")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Fixes: c9c1af3f186a ("RISC-V: rename parse_asm.h to insn.h")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230129094242.282620-1-liaochang1@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/parse_asm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/include/asm/parse_asm.h b/arch/riscv/include/asm/parse_asm.h
index 7fee806805c1b..ad254da85e615 100644
--- a/arch/riscv/include/asm/parse_asm.h
+++ b/arch/riscv/include/asm/parse_asm.h
@@ -3,6 +3,9 @@
  * Copyright (C) 2020 SiFive
  */
 
+#ifndef _ASM_RISCV_INSN_H
+#define _ASM_RISCV_INSN_H
+
 #include <linux/bits.h>
 
 /* The bit field of immediate value in I-type instruction */
@@ -217,3 +220,5 @@ static inline bool is_ ## INSN_NAME ## _insn(long insn) \
 	(RVC_X(x_, RVC_B_IMM_5_OPOFF, RVC_B_IMM_5_MASK) << RVC_B_IMM_5_OFF) | \
 	(RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_7_6_OFF) | \
 	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
+
+#endif /* _ASM_RISCV_INSN_H */
-- 
2.39.2



