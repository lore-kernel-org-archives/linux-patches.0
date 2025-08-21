Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0113D2E92C6;
	Thu, 21 Aug 2025 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810975; cv=none; b=b/sci+nIPoJxbtXSYiw4IHSvhIDXpL1snkryNCsnx4svF2g2h4YI9BakiowEr3DZ3GPLie7TpQNdE6VftSSDQz+YFjcEkD63DYU+tyBU+1yg1EHyI7flwcRDMo5a82Ha132e0Qj8pGXMvO3LwnZC62E9wEByF3burTClmPbW6t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810975; c=relaxed/simple;
	bh=VYJ/3Og460FvKVmmzAjxmjg94FV8xklZJeBiFr5mKfo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kp1ZPtn5WPCwvG0Xx3CEZDksrTVOltzWzHriW2eBSZ1n6ieVGjjl+iviMCI+aZWF1R3plJa9zBhFPU+autxfXhHokjCb+4c+gX+vJJBjNvAQVCAaLpZZgS1pDGCa5UUprOsHKR4sg0B1+cUVqPMjs7g0DQciNz+QzvrLV2/VAbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEcECcyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEcECcyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F479C4CEEB;
	Thu, 21 Aug 2025 21:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810974;
	bh=VYJ/3Og460FvKVmmzAjxmjg94FV8xklZJeBiFr5mKfo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YEcECcyYrBMrAwn6owMjROwcvn9APF9mq3vwMadEfmJU2ImyjMIUaRC9P7kvZhRss
	 aVHetJxVgwampwYPBB4FadtEnyBoG/bo1yYDOyQonjDpKMRDkIiz6fRzQzKNvJ65Ft
	 a+4kXZHE4FSoC0eOP+SdQmJhV+B6iGDSqbM/+qMqG3HipQalah7zqoL+M6rG4GJAVv
	 axkmZXBMpzLCbsR0Vlz3YK8hGXiPrnWCrh8mf1oOz3LwDZnvLNBWDSWleau14QT0PN
	 IhrYXIG8z2Ghko5jyzi4MSTT3JeHiX3FXWFEliLCsFEu4iBKx2Qnrw4eqYMqIxWKxz
	 pgxF3mEu1QR6A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:44 -0700
Subject: [PATCH v2 07/12] riscv: Remove version check for LTO_CLANG selects
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-7-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1468; i=nathan@kernel.org;
 h=from:subject:message-id; bh=VYJ/3Og460FvKVmmzAjxmjg94FV8xklZJeBiFr5mKfo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe5r1vLOvWH+xsD/gzbyJ2c4hufDL21gxoWk/5C/Je
 ZgEnwvsKGVhEONikBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABNZ/pnhf9aDa9W5X7cVbGQP
 nTt1j9XCB3rMC9OXPJH+/mFb3ay1cTwM/zRf34m8/Mjsdmd2SBHXLfPrMZeKupg2dz7012Wca/d
 iIxsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, there is no need to check the LLD version
before selecting ARCH_SUPPORTS_LTO_CLANG{,_THIN} because it will always
be true.

Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-riscv@lists.infradead.org

Small note, this will conflict with
https://lore.kernel.org/20250710-riscv-restrict-lto-to-medany-v1-1-b1dac9871ecf@kernel.org/
but I think it is simple enough to deal with.
---
 arch/riscv/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index a4b233a0659e..1d53bf02d0fa 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -64,9 +64,8 @@ config RISCV
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS if MMU
-	# LLD >= 14: https://github.com/llvm/llvm-project/issues/50505
-	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000
-	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >= 140000
+	select ARCH_SUPPORTS_LTO_CLANG
+	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU

-- 
2.50.1

