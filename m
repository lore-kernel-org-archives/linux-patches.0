Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7210364DE;
	Fri, 24 Nov 2023 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAfDiN5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431E3C433C7;
	Fri, 24 Nov 2023 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851446;
	bh=vXYp83PBvvRrVErXk/+78wHmM+TVuHpt/3xx05IlIYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAfDiN5lpZobXd0FR1v9hCtB2THv/MnJsvRx0qO5HnuB8W5VQ0iyo1M4mpt0fIBCi
	 ENJ016qajsPMSwhEoHp2L0I1hDJQQoSyYfYzHoK4DwuvhftnLOZwsRhYRnpVD+jlWM
	 jKxxVyvdlk99WNwrvak5R/j2EkU9SROD4VSIYfF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minda Chen <minda.chen@starfivetech.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.5 434/491] riscv: Using TOOLCHAIN_HAS_ZIHINTPAUSE marco replace zihintpause
Date: Fri, 24 Nov 2023 17:51:10 +0000
Message-ID: <20231124172037.650326887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minda Chen <minda.chen@starfivetech.com>

commit dd16ac404a685cce07e67261a94c6225d90ea7ba upstream.

Actually it is a part of Conor's
commit aae538cd03bc ("riscv: fix detection of toolchain
Zihintpause support").
It is looks like a merge issue. Samuel's
commit 0b1d60d6dd9e ("riscv: Fix build with
CONFIG_CC_OPTIMIZE_FOR_SIZE=y") do not base on Conor's commit and
revert to __riscv_zihintpause. So this patch can fix it.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
Fixes: 3c349eacc559 ("Merge patch "riscv: Fix build with CONFIG_CC_OPTIMIZE_FOR_SIZE=y"")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230802064215.31111-1-minda.chen@starfivetech.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/vdso/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/vdso/processor.h b/arch/riscv/include/asm/vdso/processor.h
index 14f5d27783b8..96b65a5396df 100644
--- a/arch/riscv/include/asm/vdso/processor.h
+++ b/arch/riscv/include/asm/vdso/processor.h
@@ -14,7 +14,7 @@ static inline void cpu_relax(void)
 	__asm__ __volatile__ ("div %0, %0, zero" : "=r" (dummy));
 #endif
 
-#ifdef __riscv_zihintpause
+#ifdef CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE
 	/*
 	 * Reduce instruction retirement.
 	 * This assumes the PC changes.
-- 
2.43.0



