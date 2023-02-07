Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F6E3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD138C433EF;
	Tue,  7 Feb 2023 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774998;
	bh=MsX6TvKUrOgdywcPMMp13ZeuJnNul08OEcEkHSl1LGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nf/6S0kPMngMqrlHrX5ZI1U2mVP5xe/zcObP6fNqTC6wRsqzzx04HXsHLA3MP+JFr
	 N7/GBadw0SmafeENo7CAK/e4OMSFmJFsz1EkvkmCYzc9yj4RHsQwzPzS2OrjyfY30E
	 Oek+Ttls7mdawBdxAwPX9NLNdaQ/u4QOWGZvXj2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/208] x86/build: Move -mindirect-branch-cs-prefix out of GCC-only block
Date: Tue,  7 Feb 2023 13:55:57 +0100
Message-Id: <20230207125639.021360699@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 27b5de622ea3fe0ad5a31a0ebd9f7a0a276932d1 ]

LLVM 16 will have support for this flag so move it out of the GCC-only
block to allow LLVM builds to take advantage of it.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/1665
Link: https://github.com/llvm/llvm-project/commit/6f867f9102838ebe314c1f3661fdf95700386e5a
Link: https://lore.kernel.org/r/20230120165826.2469302-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 415a5d138de4..3419ffa2a350 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -14,13 +14,13 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
-RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
 RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
 endif
 ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
 RETPOLINE_VDSO_CFLAGS	:= -mretpoline
 endif
+RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
 
 ifdef CONFIG_RETHUNK
 RETHUNK_CFLAGS		:= -mfunction-return=thunk-extern
-- 
2.39.0



