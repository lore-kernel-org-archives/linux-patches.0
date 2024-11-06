Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C571E22EF;
	Wed,  6 Nov 2024 12:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896877; cv=none; b=mbz5w932C/ye+NEZs7FsODKc+TC6ioWeREXpTP/Ch1WK5G6foA4MXRZgaOMvNpJxWL2le6FCdFqC1V47y6hUqM5kkGnmYJd1zm3TB2RUp6GZicdW7uEmQBDS6SD3NjUOtriH/bTsnkyXsYb2D5/YWjGWL5SB4N4wVSnSvvIi7Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896877; c=relaxed/simple;
	bh=Cf/fmzCWNhYPbQlqeIKVmrdjhtYxI5OUgZD3kQDLR1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz5Z0nJKIWg6medEDo5sea8oc4YheJq1NP7dw4XGNme77H9XwAhTZfo6OWwaVjugI/6Htrtrs4m5y6rgKzLNN/snOzVMefm8U0WllmNW8skd1S8muWxTL3Y4QE6A7C1xCv22ApArVD6PZwtj1VO5Po7/XGIR64F/3nD3q8uqZCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HF9W8/nS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HF9W8/nS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAD1C4CECD;
	Wed,  6 Nov 2024 12:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896877;
	bh=Cf/fmzCWNhYPbQlqeIKVmrdjhtYxI5OUgZD3kQDLR1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HF9W8/nSnnk8Xge7AQg2p5ihuILnKF+OnUTv+cVXNQWzDOSDZeePyjGi7yFy8OXYL
	 KAYTnyt2rQX5wZoS2dWKufRpcZefRF8Wl6+TbmoUyGFW0A5yBx7zkyuO88yz5V3sVT
	 MvZ1vCdyxNwnU/OViyr4Wo4qkzSXsLxBgABPZ5pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/110] riscv: Remove unused GENERATING_ASM_OFFSETS
Date: Wed,  6 Nov 2024 13:05:07 +0100
Message-ID: <20241106120305.965761501@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

[ Upstream commit 46d4e5ac6f2f801f97bcd0ec82365969197dc9b1 ]

The macro is not used in the current version of kernel, it looks like
can be removed to avoid a build warning:

../arch/riscv/kernel/asm-offsets.c: At top level:
../arch/riscv/kernel/asm-offsets.c:7: warning: macro "GENERATING_ASM_OFFSETS" is not used [-Wunused-macros]
    7 | #define GENERATING_ASM_OFFSETS

Fixes: 9639a44394b9 ("RISC-V: Provide a cleaner raw_smp_processor_id()")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Link: https://lore.kernel.org/r/20241008094141.549248-2-zhangchunyan@iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/asm-offsets.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 877ff65b4e136..a3d4317309d4c 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -4,8 +4,6 @@
  * Copyright (C) 2017 SiFive
  */
 
-#define GENERATING_ASM_OFFSETS
-
 #include <linux/kbuild.h>
 #include <linux/sched.h>
 #include <asm/thread_info.h>
-- 
2.43.0



