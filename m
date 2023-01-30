Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517FA3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F64CC433EF;
	Mon, 30 Jan 2023 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088271;
	bh=OUpHPG1jDuMPWy5rGZzA37BYAiAnsdDeQyyDo4TKPGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C56fRgRlKz+iELGfGgEi5cNi4dr9u48IBuPtjNJ6B16mdNYMhdH6z/wDYUgpzg15q
	 hbJJBklppuD3oVweuRvcR0h7e2XV/WYyt9ALtlZ5ewQn4SZC3XwlFtFSg+nOoxSHwT
	 OQKuP4ZVgUbh8bqTDE+WNdMQW0vyVOzJaSU5TB3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Guo Ren <guoren@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/204] csky: Fix function name in csky_alignment() and die()
Date: Mon, 30 Jan 2023 14:51:37 +0100
Message-Id: <20230130134322.346038651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
index b445c5aee220..6e426fba0119 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -109,7 +109,7 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		make_dead_task(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
-- 
2.39.0



