Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A842EA16A;
	Thu, 21 Aug 2025 21:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810980; cv=none; b=koQqbDSnAYL+/sxlARmbV61AZnbhh9nDx+xCPTkf175ok08M01QCsZ3UGENILADZsfvG0rOH9jI9ujAhRW/OA7NgzIjMY9XklcC8+ATY7j0UaMEsKbii6SICx8DUT4qDZAYiEUl84CBc8wJoMaWiuFGXj+iGQGnFbkQLqA4YXZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810980; c=relaxed/simple;
	bh=biYkmUo8TAJXy73mLcX/CFarTLOLNQB3EGVWaVOUDFw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rMKUm8nfaP1HxaLxW+GBiEZpdv2/zuan5zlPZvPHzXNYaufoEF2BDL9jAtamD/cxm8TwXmAhy7D05itpd+lWm3IrwXQN1W/1KwNEoYHb4fVwsh/CiS5tMReJnRTCWcK8SSg0E8jkhD/HZemN6ZBvuWO/44PCa15tWUZK2qNDtow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3k96ish; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3k96ish"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5031C4CEEB;
	Thu, 21 Aug 2025 21:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810980;
	bh=biYkmUo8TAJXy73mLcX/CFarTLOLNQB3EGVWaVOUDFw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=j3k96ishoifW0pQeOjVUoRbJPvZXyjS6WKwJSVBdIvp0TRdTESk5Zs8PswhmICClY
	 5EhhWALMJwWwKNcJcpgA3gdSr/69A+CU1UP80MPQkFrR0ZrqxqSgxJLplA3jLxsh7j
	 VDXCtxRpctonDqejZQMi7JVKG8xoB2TV05rjDM6uSQW56hnEUB6qrfyzv2p5anZA1H
	 UnpytY3hZCs6bG11fcNx8CYKIQwh+y1Sq1r8pKUsiCb+BIDvyq94Hz9Iz5dv6Zu6Oc
	 iJpvWBUDlb8frca/Pzt09TLis1okQ1lP8OSsN6lXZBooOAww9icI5V0wyO8g4kX9Bi
	 SYPZnNDXKvlnA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:46 -0700
Subject: [PATCH v2 09/12] riscv: Remove ld.lld version checks from many
 TOOLCHAIN_HAS configs
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-9-635f3294e5f0@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2502; i=nathan@kernel.org;
 h=from:subject:message-id; bh=biYkmUo8TAJXy73mLcX/CFarTLOLNQB3EGVWaVOUDFw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe5pfLeLL/fn86IuTL6Z8f/5Voja6RWfCFCelrJ9ZZ
 Qmb5smKdJSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJVJ9jZNjeMa3txeTJZgZa
 M9J4OfXun5xwfKfWyR3Pvoi2S22NS4plZDgrOPNHRpeL08IkyYbutBzzactYpb4Khm2xfGQdv9u
 QmxEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, several ld.lld version checks become
tautological, as they are always true. Replace them with a simple
CONFIG_LD_IS_LLD check.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-riscv@lists.infradead.org
---
 arch/riscv/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d482236e93f4..850ba4b4b534 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -620,7 +620,7 @@ config TOOLCHAIN_HAS_V
 	default y
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64imv)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32imv)
-	depends on LLD_VERSION >= 140000 || LD_VERSION >= 23800
+	depends on LD_IS_LLD || LD_VERSION >= 23800
 	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_V
@@ -721,7 +721,7 @@ config TOOLCHAIN_HAS_ZBB
 	default y
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbb)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbb)
-	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
+	depends on LD_IS_LLD || LD_VERSION >= 23900
 	depends on AS_HAS_OPTION_ARCH
 
 # This symbol indicates that the toolchain supports all v1.0 vector crypto
@@ -736,7 +736,7 @@ config TOOLCHAIN_HAS_ZBA
 	default y
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zba)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zba)
-	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
+	depends on LD_IS_LLD || LD_VERSION >= 23900
 	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_ZBA
@@ -771,7 +771,7 @@ config TOOLCHAIN_HAS_ZBC
 	default y
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbc)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbc)
-	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
+	depends on LD_IS_LLD || LD_VERSION >= 23900
 	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_ZBC
@@ -794,7 +794,7 @@ config TOOLCHAIN_HAS_ZBKB
 	default y
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbkb)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbkb)
-	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
+	depends on LD_IS_LLD || LD_VERSION >= 23900
 	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_ZBKB

-- 
2.50.1

