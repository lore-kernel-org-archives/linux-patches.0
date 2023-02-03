Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C481FBC
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E93C433D2;
	Fri,  3 Feb 2023 10:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420289;
	bh=b1yZA9BhvISqTldKefzHm6YwhVGopOL6TPdcuDbEgSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0m+onB7OVIeI9D6q0PYvYsn6Fx+hEKvzYc0k9agqabcOVBSMns+DjFWsqoUoEAMA/
	 vJT/4WFhCzhAmoahiNtfxlcZihGG9I0RStXnXWcj/OOHHIvynsWfE/Qt5NZkYWDZ3U
	 5eNmaGyzjsEIyx+kP1u9EavKLU+vUIgyW7885XqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Guo Ren <guoren@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/134] csky: Fix function name in csky_alignment() and die()
Date: Fri,  3 Feb 2023 11:13:46 +0100
Message-Id: <20230203101029.254899632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

commit 751971af2e3615dc5bd12674080bc795505fefeb upstream.

When building ARCH=csky defconfig:

arch/csky/kernel/traps.c: In function 'die':
arch/csky/kernel/traps.c:112:17: error: implicit declaration of function
'make_dead_task' [-Werror=implicit-function-declaration]
  112 |                 make_dead_task(SIGSEGV);
      |                 ^~~~~~~~~~~~~~

The function's name is make_task_dead(), change it so there is no more
build error.

Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lkml.kernel.org/r/20211227184851.2297759-4-nathan@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/abiv1/alignment.c | 2 +-
 arch/csky/kernel/traps.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/csky/abiv1/alignment.c b/arch/csky/abiv1/alignment.c
index 5e2fb45d605c..2df115d0e210 100644
--- a/arch/csky/abiv1/alignment.c
+++ b/arch/csky/abiv1/alignment.c
@@ -294,7 +294,7 @@ void csky_alignment(struct pt_regs *regs)
 				__func__, opcode, rz, rx, imm, addr);
 		show_regs(regs);
 		bust_spinlocks(0);
-		make_dead_task(SIGKILL);
+		make_task_dead(SIGKILL);
 	}
 
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)addr);
diff --git a/arch/csky/kernel/traps.c b/arch/csky/kernel/traps.c
index af7562907f7f..8cdbbcb5ed87 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -85,7 +85,7 @@ void die_if_kernel(char *str, struct pt_regs *regs, int nr)
 	pr_err("%s: %08x\n", str, nr);
 	show_regs(regs);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	make_dead_task(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 void buserr(struct pt_regs *regs)
-- 
2.39.0



