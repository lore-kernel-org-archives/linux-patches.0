Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034815;
	b=2W6gNbU7grkK6DrkuuF1//EXwqFTTJsuOXEyPPH4wOP4cSC6xCdG0L0Yt0GMvH8Ojlyh
	 qxY1Ppyv7rGe1g8i43ZWIGc02LUYVDf8cxfZqRoyyDAxudDElMCPXesBVzaom8y+ENvOm
	 zF7WmA9NgQSXPM5mBwCETO3ovjVmMEHyPG3bu5nvntyvlfh1JqOxlfU7BEQHou/sjQvh9
	 XVYTtn4Dv1AAygiWzrVuiZBgl7huj6UaehEdjI+oKXf8KThYE6x4+JK2gsEtGRV9SgvCN
	 1K3eGdmNuMYKsCWd/bQKUbF+ZsdoS49xVxc0k8t2n/19HgOA/6hMk/FZw/PA4kAz4nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/xBd/Pyt2m1jNTwObEYQ3YH9SfsnYZ8th/XeYp1hSJw=;
	b=alUWIxGJdyAUELekSDR81w+jOoY9Fej0VfpNqyc1xtG4cZxTsxtV+ni28SmahTGpiy7Q
	 w6yM7qRA0ZulYA1ka5zUnmIjRfh16Jpbu8Q6EWKMesDRLfpTEBvSrSeBgySXZY/p5b/EG
	 xkZisrmER+s7P31HMGbe0D23vvxP7sTc0JAfHWVW932tHIDR+kSgDTigokxWwjLnKk3V3
	 Z/BY8pTZ9UZq9jZ+/cq4gJxrsx6GlWOMzcdn3meTPnI42dRUVGXGaioF1Uie6E4GqOlSo
	 zHymQ0eSlX3S/+2tmzQCswS6yt8r0B6D+1DmS9sFOptL2DepW9gUDdZooD8FPCuGaKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGCnWCAx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6C606A320;
	Wed, 18 Nov 2026 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGCnWCAx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1881F000C5;
	Wed, 18 Nov 2026 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034815;
	bh=/xBd/Pyt2m1jNTwObEYQ3YH9SfsnYZ8th/XeYp1hSJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGCnWCAx/UTcAlF0/4x4sCK+o2MxX6SpUlKMm9Oy3qwrRyiebRHFD1TGL7mI5+bLJ
	 KUO+bMSVG/E6mupEnhaZG3KMQqGtZnAb8rTT9xzlT+hUwhuhgiXFlyQrs0rSUddxYC
	 8V5BcwPAJ9fSEOPhpzf1WvNFUZLP8VQavwT4M4/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0504/3318] x86/mce: Fix hardware debug register corruption on task migration
Date: Wed, 18 Nov 2026 15:18:46 +0100
Message-ID: <20261118150332.200760731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit b8d1d5b63a8ef532038eebd9d97d406860385668 ]

In exc_machine_check_user(), local_db_save() and local_db_restore() are
invoked in the outer entry stubs (DEFINE_IDTENTRY_MCE_USER,
DEFINE_FREDENTRY_MCE, and DEFINE_IDTENTRY_RAW), surrounding
exc_machine_check_user().

However, exc_machine_check_user() calls irqentry_exit_to_user_mode(), which
handles pending thread work and may schedule() if TIF_NEED_RESCHED is set. If
the task migrates to another CPU during schedule(), local_db_restore() runs on
the new CPU with the dr7 state saved from the old CPU. This corrupts the new
CPU's DR7 hardware debug register and leaves the old CPU's DR7 disabled.  In
short, local_db_save() and local_db_restore() pair must be run on the same
CPU.

To fix this, move local_db_save() and local_db_restore() inside
exc_machine_check_user() and exc_machine_check_kernel(). In
exc_machine_check_user(), DR7 is saved and restored strictly around
do_machine_check() to avoid schedule() during migration. In
exc_machine_check_kernel(), local_db_save() is called at the entry point to
prevent early memory accesses from triggering nested #DB exceptions, and
restored on all exits.

Fixes: cd840e424f27 ("x86/entry, mce: Disallow #DB during #MC")
Assisted-by: LLM
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/179005109564.388919.3937970081044095776.stgit@devnote2
[ sashal: Dropped the FRED machine-check hunk because this tree has no FRED MCE entry, and applied the dr7 save/restore move to the remaining three places. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 106436ec3c005..fe1bbe1973321 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2114,6 +2114,9 @@ bool filter_mce(struct mce *m)
 static __always_inline void exc_machine_check_kernel(struct pt_regs *regs)
 {
 	irqentry_state_t irq_state;
+	unsigned long dr7;
+
+	dr7 = local_db_save();
 
 	WARN_ON_ONCE(user_mode(regs));
 
@@ -2122,20 +2125,26 @@ static __always_inline void exc_machine_check_kernel(struct pt_regs *regs)
 	 * mce_check_crashing_cpu() for details.
 	 */
 	if (mca_cfg.initialized && mce_check_crashing_cpu())
-		return;
+		goto out;
 
 	irq_state = irqentry_nmi_enter(regs);
 
 	do_machine_check(regs);
 
 	irqentry_nmi_exit(regs, irq_state);
+out:
+	local_db_restore(dr7);
 }
 
 static __always_inline void exc_machine_check_user(struct pt_regs *regs)
 {
+	unsigned long dr7;
+
 	irqentry_enter_from_user_mode(regs);
 
+	dr7 = local_db_save();
 	do_machine_check(regs);
+	local_db_restore(dr7);
 
 	irqentry_exit_to_user_mode(regs);
 }
@@ -2144,34 +2153,22 @@ static __always_inline void exc_machine_check_user(struct pt_regs *regs)
 /* MCE hit kernel mode */
 DEFINE_IDTENTRY_MCE(exc_machine_check)
 {
-	unsigned long dr7;
-
-	dr7 = local_db_save();
 	exc_machine_check_kernel(regs);
-	local_db_restore(dr7);
 }
 
 /* The user mode variant. */
 DEFINE_IDTENTRY_MCE_USER(exc_machine_check)
 {
-	unsigned long dr7;
-
-	dr7 = local_db_save();
 	exc_machine_check_user(regs);
-	local_db_restore(dr7);
 }
 #else
 /* 32bit unified entry point */
 DEFINE_IDTENTRY_RAW(exc_machine_check)
 {
-	unsigned long dr7;
-
-	dr7 = local_db_save();
 	if (user_mode(regs))
 		exc_machine_check_user(regs);
 	else
 		exc_machine_check_kernel(regs);
-	local_db_restore(dr7);
 }
 #endif
 
-- 
2.53.0



