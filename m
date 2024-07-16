Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FC619DF75;
	Tue, 16 Jul 2024 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145912; cv=none; b=lMyfz8+nqVvBON853M3nfHcK0NxC1AuPjXtZizlTxUgFJLVKfnlUzmkqJCdTxXSUum7tM5iGEy/ZhZthDP61pW3xz4J7y4pcMxtIw09ObAF2W5J25deLt/FifrMKWcwkQfoE2PhR/JM1fiJvq+Ih/mXbzmfHJQReUtqI2QULr/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145912; c=relaxed/simple;
	bh=64haWf7velmHhYhKYJBGrY1t0eNKofGVFUBRGqh7ckw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e03fc5v/TGKZLpPVVCYNwrdD/JEhNAJxH2H36w7R9/UXaj/YJF6uB1G5iunm15iHsfra82Y5v3CVRocKY8zvwSvM+GTyuCLdymyqKSUuP6IGdQjXSfhCRUGcYHNK5z+/Zbj1iL/ws0WjbrFpouWwNefROHUL5NB6/oWTN6/qNio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGIyC9/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGIyC9/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE32DC116B1;
	Tue, 16 Jul 2024 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145912;
	bh=64haWf7velmHhYhKYJBGrY1t0eNKofGVFUBRGqh7ckw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGIyC9/535evsx+gTB/zxhl4s+Mxtchr0CvQWjclqoxlOj3mC4C4Pa44idNpx0fQV
	 y9vtm/mW2Q062cgbUKgaVkotRgrLEf5qM99e2wGdGLlI/p8keNzJGMnAnrIDrd7hj8
	 7zEdMjkRQ2kr31e8+tfx8G6AT0UoruQLfHHnHKKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Gerst <brgerst@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/121] x86/entry/64: Remove obsolete comment on tracing vs. SYSRET
Date: Tue, 16 Jul 2024 17:33:00 +0200
Message-ID: <20240716152755.867345736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Gerst <brgerst@gmail.com>

[ Upstream commit eb43c9b1517b48e2ff0d3a584aca197338987d7b ]

This comment comes from a time when the kernel attempted to use SYSRET
on all returns to userspace, including interrupts and exceptions.  Ever
since commit fffbb5dc ("Move opportunistic sysret code to syscall code
path"), SYSRET is only used for returning from system calls. The
specific tracing issue listed in this comment is not possible anymore.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20230721161018.50214-2-brgerst@gmail.com
Stable-dep-of: ac8b270b61d4 ("x86/bhi: Avoid warning in #DB handler due to BHI mitigation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 1edb8e1b9e018..2192b6c33ea00 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -167,22 +167,9 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_hwframe, SYM_L_GLOBAL)
 	jne	swapgs_restore_regs_and_return_to_usermode
 
 	/*
-	 * SYSCALL clears RF when it saves RFLAGS in R11 and SYSRET cannot
-	 * restore RF properly. If the slowpath sets it for whatever reason, we
-	 * need to restore it correctly.
-	 *
-	 * SYSRET can restore TF, but unlike IRET, restoring TF results in a
-	 * trap from userspace immediately after SYSRET.  This would cause an
-	 * infinite loop whenever #DB happens with register state that satisfies
-	 * the opportunistic SYSRET conditions.  For example, single-stepping
-	 * this user code:
-	 *
-	 *           movq	$stuck_here, %rcx
-	 *           pushfq
-	 *           popq %r11
-	 *   stuck_here:
-	 *
-	 * would never get past 'stuck_here'.
+	 * SYSRET cannot restore RF.  It can restore TF, but unlike IRET,
+	 * restoring TF results in a trap from userspace immediately after
+	 * SYSRET.
 	 */
 	testq	$(X86_EFLAGS_RF|X86_EFLAGS_TF), %r11
 	jnz	swapgs_restore_regs_and_return_to_usermode
-- 
2.43.0



