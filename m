Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE851E1A27;
	Wed,  6 Nov 2024 12:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897744; cv=none; b=Kv1L+JhdTw98kPztZ6D+yzvpiax5UUr1guzB9z31+23kwnaxYGu6kp8ZMai/O0TIorU7a8FAxBndyPM6E/ypU2lgoksop9U9YnyUTv7q86iQaNIYxFXn4dJKzlqXtd+k1klVjQC/mnBCAER4zyyC8l3K5nBNYf20VhNsgQmDRQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897744; c=relaxed/simple;
	bh=mXLY+fiz24fK57FuGxA+78/Im1P1Y4ZteShMYDDniXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbXcScR9S+XmwRRdKPAuw7W0HCEFl+SFHHdW+EkpE8wk2oCBzHmYDi5pMjLW9Dcv83GZtQLyr8t/5Dt4Fd+sbRvfI23nH4qQRSKawJaJCDtgMM+37HDsNDkH2K9NWtmzMJDsPvCqCBIQLEBajrLgdmKuKO+KTxavXVjb9rd6+LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukemfsWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukemfsWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F01C4CECD;
	Wed,  6 Nov 2024 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897744;
	bh=mXLY+fiz24fK57FuGxA+78/Im1P1Y4ZteShMYDDniXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukemfsWcPOFwkhWHDbbwl2k+2/MhDUftyLSddM+IWNlQ045w3iV4unr5lclp8MfhD
	 tV5VcdewqLyrXgHHVlHyJ6VdwglLSjuUdmsmHR/DuYjlRTSUvOrdXJ2mBcyQgkSrBP
	 2XALP/wVdoPQMkQk5nXgFBPxf44g4sHhPRQPa0TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/151] riscv: Remove duplicated GET_RM
Date: Wed,  6 Nov 2024 13:05:07 +0100
Message-ID: <20241106120312.139781023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e867fe465164e..edae2735ebe34 100644
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



