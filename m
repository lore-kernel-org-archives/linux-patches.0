Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAAE61FA9;
	Thu, 30 Nov 2023 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGqdtrnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF3FC433CA;
	Thu, 30 Nov 2023 22:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385114;
	bh=6B3WBsqOa3ticox48HEDLj1h+F7k8TzJ0v5X9n+J3X0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dGqdtrnz/Ljn+/A+OGBlIfKO4Iw6LCmVI0B1823ixDHGdY0FdSdZIRq9myq8MqOBW
	 6R1XFv+ILTi0uqBZgG8cDtIYh4B5mnT+5IJHVXeSsHGefrry19lkujYZ3Y9idAQHp9
	 Zh4ZS6nvYWeqKv8Tu8+rv9JM40H2XX5MqUb+a18vwKV9R1/S/aR+3jZFLyI6lTybv/
	 QiMA4p/R+1MJs/S3eZUesFMX21qXGujaHC2GsZba1xKESJzR/ojZTSd7H297dihGxb
	 uIR2qzaSAhra7S1fCo613sC87njnf9PRnezouqt1QlqA+eIPSkk5C079vPX6htQlwV
	 GKNzdZi/id98Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:32 -0700
Subject: [PATCH 19/19] hexagon: traps: Add internal prototypes for
 functions only called from asm
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-19-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2978; i=nathan@kernel.org;
 h=from:subject:message-id; bh=6B3WBsqOa3ticox48HEDLj1h+F7k8TzJ0v5X9n+J3X0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwv1b2AoPm936+lOmQ6xgWvH+7l/RqQpfzY+H9PPv9
 LcPWOPeUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbid5qR4dvrLWtnr78dkvqM
 TW3h3Ysffn/49HDeyr8/zidGvFnLci+akeFPRPsJx3saCxsqRFxMGYyOHGtWPvDLp2KD+/W/Fkc
 emHACAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/kernel/traps.c:284:6: warning: no previous prototype for function 'do_genex' [-Wmissing-prototypes]
    284 | void do_genex(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:284:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    284 | void do_genex(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:341:6: warning: no previous prototype for function 'do_trap0' [-Wmissing-prototypes]
    341 | void do_trap0(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:341:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    341 | void do_trap0(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:418:6: warning: no previous prototype for function 'do_machcheck' [-Wmissing-prototypes]
    418 | void do_machcheck(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:418:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    418 | void do_machcheck(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:428:6: warning: no previous prototype for function 'do_debug_exception' [-Wmissing-prototypes]
    428 | void do_debug_exception(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:428:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    428 | void do_debug_exception(struct pt_regs *regs)
        | ^
        | static

These functions are only called from assembly or this translation unit,
so just add prototypes right above the definitions to silence the
warnings.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/traps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 3f6ff43cb514..75e062722d28 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -281,6 +281,7 @@ static void cache_error(struct pt_regs *regs)
 /*
  * General exception handler
  */
+void do_genex(struct pt_regs *regs);
 void do_genex(struct pt_regs *regs)
 {
 	/*
@@ -331,6 +332,7 @@ void do_genex(struct pt_regs *regs)
 	}
 }
 
+void do_trap0(struct pt_regs *regs);
 void do_trap0(struct pt_regs *regs)
 {
 	syscall_fn syscall;
@@ -408,6 +410,7 @@ void do_trap0(struct pt_regs *regs)
 /*
  * Machine check exception handler
  */
+void do_machcheck(struct pt_regs *regs);
 void do_machcheck(struct pt_regs *regs)
 {
 	/* Halt and catch fire */
@@ -418,6 +421,7 @@ void do_machcheck(struct pt_regs *regs)
  * Treat this like the old 0xdb trap.
  */
 
+void do_debug_exception(struct pt_regs *regs);
 void do_debug_exception(struct pt_regs *regs)
 {
 	regs->hvmer.vmest &= ~HVM_VMEST_CAUSE_MSK;

-- 
2.43.0

