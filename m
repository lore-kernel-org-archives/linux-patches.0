Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2F21DB520;
	Wed,  6 Nov 2024 12:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897159; cv=none; b=A0CnbPzNuVWZr+YEsKGjn4xonK2bZeN7sNZ+HMOrdt7YsILu0pQLI0us5lu7gB108trwVz7vPG26fT09vP+nVIDqEAkkUHwa+7vlPFgwOtgubIulrl4TNIQTJYLO4buaOjivPGIXSu3ESBBkZvBBk5Lw3g/CabMpIm4lNzPkkLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897159; c=relaxed/simple;
	bh=iqj50jDUMNtjBXUGVmiNLq4LBDUk7N/89JQch0YMgIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcKv20ovTPueJzHnJ84rdCL+cEDOIHTr48wVSJjR2xjEt6e2l8hCzNOlmUWB+aXZ/alVz93wH137cYAYSO+Ax8HmF4FjUL96STrotC8QbgznMEMeM5dcf8I+yLCVA/RaU9YQujiQdl9NYJnRxAuJ+oxn2OmzT1Cmh4tDzpC+DLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivHn3XCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivHn3XCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BB9C4CECD;
	Wed,  6 Nov 2024 12:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897159;
	bh=iqj50jDUMNtjBXUGVmiNLq4LBDUk7N/89JQch0YMgIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivHn3XCQCQW/LuxyH+61Feb4x/INBFVfPJsTYv3GJNzP4bUwuEkn+4/GpUP/jMLwU
	 w/svOd0zzxXz4Hi8tR1FrJGsPRgvNpYZUbHi3F1LddlAvPYQO0tb2W8h76VgmAtLBH
	 8+xi8Wt8nb0RCGffZTPp3HGsF7SrIWIjmNmEp0NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/126] riscv: Remove duplicated GET_RM
Date: Wed,  6 Nov 2024 13:04:48 +0100
Message-ID: <20241106120308.423051291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5348d842c7453..3d16cc803220e 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -132,8 +132,6 @@
 #define REG_PTR(insn, pos, regs)	\
 	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
 
-#define GET_RM(insn)			(((insn) >> 12) & 7)
-
 #define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
 #define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
 #define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
-- 
2.43.0



