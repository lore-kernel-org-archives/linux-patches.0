Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615D91DF756;
	Wed,  6 Nov 2024 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896424; cv=none; b=OGOkPtfujqCOrrV9iop7w/PU1AH/LRCyNatKVQjku43LGUu8/KfVzBXJopSUD1dDr/vJoDKGy6MRIyW0baA1pTvh2eQAeDBPRBCyOgyVAsl4YkPgWKMjgheeh8vwCgojkQ5Dj6iBQYFRSuX+6JonYA0Tgv3IuhDgqoBVhnYrsTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896424; c=relaxed/simple;
	bh=0tWiqgKWg1fGSBQ0YSWFigxSMuQAcRUsIpWvNVM+BMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bncGlRDDkWa6GWazEU4EUAkqtx1FljNOLJH4JG67o5ZPF+Hc8xMPg07y81Uf2TQj48vv+pv2FWgf35hdvdKoGbNgVuu0+3BeOpGtLqHTfjGVCNfrjJX5yhSJGlOvA2LYZCzpH5EZCYF0RUw3lpWe3fZRtEdAPgLXrwPj0PhXbzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBuP3Nyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBuP3Nyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC182C4CECD;
	Wed,  6 Nov 2024 12:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896424;
	bh=0tWiqgKWg1fGSBQ0YSWFigxSMuQAcRUsIpWvNVM+BMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBuP3NybOBoTOwtng4GvrDt3LhcofDsv34MO5rJtkMI+LuGUwC7SHsoOmF/aKKiX/
	 AiCMvVoKKqkOWQ2GQYisj3o7YISFlvus5AEh3PNkP71+pj5DpxlksECZfUlbBc7Jjw
	 8g0sy4+UZ2ePz38pf0EFOU+K/vBhawBEx1hzNi8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 160/245] riscv: Remove duplicated GET_RM
Date: Wed,  6 Nov 2024 13:03:33 +0100
Message-ID: <20241106120323.172727723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

[ Upstream commit 164f66de6bb6ef454893f193c898dc8f1da6d18b ]

The macro GET_RM defined twice in this file, one can be removed.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Fixes: 956d705dd279 ("riscv: Unaligned load/store handling for M_MODE")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241008094141.549248-3-zhangchunyan@iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps_misaligned.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index d4fd8af7aaf5a..1b9867136b610 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -136,8 +136,6 @@
 #define REG_PTR(insn, pos, regs)	\
 	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
 
-#define GET_RM(insn)			(((insn) >> 12) & 7)
-
 #define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
 #define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
 #define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
-- 
2.43.0



