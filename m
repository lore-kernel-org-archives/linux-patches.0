Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09180307AFA;
	Mon, 18 Aug 2025 18:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543488; cv=none; b=nteLWDya+YMKPCW1EitqkuDALehnvfSDisdgiGNP/6H8wA31GgMdrrAkxzJ/6glHpI2rPRD3j99kTPHo+9Rs6hLw7bFJUGMMOCGhONGq3jnTzRmmgJTpGaZV217Ff+fwwvim0GEIXG2zZxhy4abgKJsZgyzXB8k83X6ZEFw28gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543488; c=relaxed/simple;
	bh=yP6TXKyp3wFtCTQQgfaLfBJQK+omSBoiOGIP+6rEIXo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jRHn7hqpArbKSmS8sOEdK/twRBxLfwMYIxdhK5I6ovTv+MoVVvwhKRlwgGHe27GEDxmZX4d3PsTcp1qYRyK7RqpTYrscCD9MImYVbUkv+sOpPqUXltn/PizBsDT/qSBBvZV5VDOTR0MOgX1IOhKdR28PT3YF3A4HX+8cS3XWd6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHGKFArC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHGKFArC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF422C4CEEB;
	Mon, 18 Aug 2025 18:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543487;
	bh=yP6TXKyp3wFtCTQQgfaLfBJQK+omSBoiOGIP+6rEIXo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QHGKFArCJTUAj/4j71Zdn+I2H0iuG6XcnHNbVD8uPB2wuew8n8jZ4GtrIQcgeMHsa
	 WrAP2Y00VCz+w41MZMeaBrob7KSqBbPFMTianNvx2Uz4B80oDEiBjuHtlU8MLboprP
	 Wa+9/yGozzTetrybFbSJW7OHpdbgexK0KCVqLsgDP+BriAixGFItHhDfK87pEJV8bE
	 rY+IE/zY1P8qTpVUzz//rqUlFxShQM2UV+T90kJWkI7MABqI/Ch3MWYn0sfO5DUmOH
	 FbYBdYpez+jZ7KixeqQPgToxbaD0ODm28Ibz8ICQYcOC/gBXy8+rCjKZU6DA3Fo8G+
	 CM/f4XOJ3VOwA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:23 -0700
Subject: [PATCH 07/10] riscv: Remove version check for LTO_CLANG selects
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-7-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1426; i=nathan@kernel.org;
 h=from:subject:message-id; bh=yP6TXKyp3wFtCTQQgfaLfBJQK+omSBoiOGIP+6rEIXo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmLyxfNO22xXGNVXHPY9RlTRJe0v4js3Jx5JD8meyJXb
 43krj3TO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBE3BgZ/mnf7Je7FvVuwseN
 OdE122KiPvG3bxeczpydLuQszvQoqobhf7GiYGLfPo4zf5bczungvs9SzKjI/Lq9lOe5hlji4V9
 pHAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, there is no need to check the LLD version
before selecting ARCH_SUPPORTS_LTO_CLANG{,_THIN} because it will always
be true.

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

