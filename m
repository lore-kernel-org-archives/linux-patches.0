Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9799133C8;
	Fri, 20 Jan 2023 17:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7518C433EF;
	Fri, 20 Jan 2023 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674234049;
	bh=dwZhp8aBPBiICpzA8NU+t7gKAGEqi9aHyM2Bfh2kUgw=;
	h=From:To:Cc:Subject:Date:From;
	b=sC5wWNOJA8pXM1aycutcIitS/YTxVe8MeT+enIMQSbnzTgia9j8dd2MAFAiqoXD21
	 uuvuB3cqdaC4R3l+vhiPktWu3EBmG2XUMY1sEC4Ice+0BFVgJmo4u68Mrkep8uZPj5
	 LJzg32IL3gNMUQqcTzXfw6vlriOE6Awj1TuUI0eijkdKOHaqctGac11YOZWOz/M6ct
	 IRwIzWcsjMrezC5Ixpw4RevXoRHKD+BJ9j7IhcW6tS0tntG4EzYgYrefZPXHTY18Jv
	 HEuXYy1pGOhP/dIWROPDnyjJ72ttHaI0L3dEZpvN1GM6XSjFhvzPhGnZuclWUOi5ft
	 J72S6op2xriCQ==
From: Nathan Chancellor <nathan@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	llvm@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH RESEND] x86/build: Move '-mindirect-branch-cs-prefix' out of GCC-only block
Date: Fri, 20 Jan 2023 09:58:27 -0700
Message-Id: <20230120165826.2469302-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LLVM 16 will have support for this flag so move it out of the GCC-only
block to allow LLVM builds to take advantage of it.

Link: https://github.com/ClangBuiltLinux/linux/issues/1665
Link: https://github.com/llvm/llvm-project/commit/6f867f9102838ebe314c1f3661fdf95700386e5a
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

I picked up the tags on the previous patch but otherwise, this is
indentical to the original posting:

https://lore.kernel.org/20220817185410.1174782-1-nathan@kernel.org/

 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9cf07322875a..73ed982d4100 100644
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

base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.1

