Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D3E22652B;
	Thu, 12 Dec 2024 17:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025562; cv=none; b=SlULszXc67xbgYoJFer709cafq57llUzD4UnlyOUppMN/P9FWBxkqIbbeTEj2B75/B7n8HF1XS7Iq4RzQ0zTNbaVZcHfnfQjQHlv1+REOsE4cWcF2nZQPuxy+6UB22Tyta1j8ktZ3oyhfZuLA+bwpvNfG1kl2erlk1CAXsgzymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025562; c=relaxed/simple;
	bh=FMTVdITsuBqwi0d1NYRLlse56rvyKjWMCLtdycMeAQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7sN6rOxUAImhgk2ZpluS9UdQ3iCYbHJvz552MQjYoXPYy2Gc72yeFX/1rPfcrPvZiR8Ha2KT9r2D37MF8Ri77MRphq5uYzds7dTrVdO8MWMEnfBFbuANfBOo5vWrtphlzCgTsjzYMTSjAhJpQANN4V/+YHCC758WwCtl2oOzT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yobWPFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yobWPFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87139C4CECE;
	Thu, 12 Dec 2024 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025562;
	bh=FMTVdITsuBqwi0d1NYRLlse56rvyKjWMCLtdycMeAQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yobWPFKLk4Xvlxp30KOyBbhTSAZfSH/Hi+tV0qMmoNWxvYpX5OD7+8IXov6OOqe6
	 Q2kOGfXmKcYxzjFT8zJoQw3MObtzV468/iYDy/cLE/sRjYG0u7BO6sfSDuMN2trkJy
	 42rdmZ+eAJaZVedoIFEFvj7e46QAQScotbcKoodc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <dima@arista.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jeff Dike <jdike@addtoit.com>,
	Richard Weinberger <richard@nod.at>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/321] um/sysrq: remove needless variable sp
Date: Thu, 12 Dec 2024 16:01:38 +0100
Message-ID: <20241212144237.099952516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit 3dd923f39a03dede001afe0edcc08613d5f403e5 ]

`sp' is a needless excercise here.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/20200418201944.482088-36-dima@arista.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 0f659ff362ea ("um: Always dump trace for specified task in show_stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index c71b5ef7ea8c3..c831a1c2eb94a 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -27,7 +27,6 @@ static const struct stacktrace_ops stackops = {
 
 void show_stack(struct task_struct *task, unsigned long *stack)
 {
-	unsigned long *sp = stack;
 	struct pt_regs *segv_regs = current->thread.segv_regs;
 	int i;
 
@@ -38,10 +37,9 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	}
 
 	if (!stack)
-		sp = get_stack_pointer(task, segv_regs);
+		stack = get_stack_pointer(task, segv_regs);
 
 	pr_info("Stack:\n");
-	stack = sp;
 	for (i = 0; i < 3 * STACKSLOTS_PER_LINE; i++) {
 		if (kstack_end(stack))
 			break;
-- 
2.43.0



