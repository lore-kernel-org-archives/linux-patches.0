Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5A479880;
	Sat, 12 Sep 2026 13:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219031; cv=none; b=kGoafMG5701bmuERgau1k6XvtSTCJiIg+R09vO6A0VcmuIt+IzOxKGNmSd5yoBSbz2ONW3Hu2uqyG1SdCXIAA3ClS/Ss5DkEeg7WxyrB0VBlJIMWcYc2k5gALlZfALkEDYdH8o+o20XXFBUT9gQYPV34Frqau5cVRFq4vY9XeA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219031; c=relaxed/simple;
	bh=lcPfrTR5fDTCWL8UaOwdE0Kf8ncCre1IW3G+K7+wbYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR1bnxwaI3ay6sC3j+cybX9jkoZ1cTorbVb/G23P5Jlk8jolBypVN0RTAb4D8Q9u9prVP+G/y6MNlRs1z6JWzd8oLFdUbERHZeHWM47jJUK9+8yVTnIKtxcadB4G3y8bTCEhWln1S4Vo5qg1x/zouVllF0lors87mqODL3CULxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqxfW6Im; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqxfW6Im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5411F000FF;
	Sat, 12 Sep 2026 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219030;
	bh=NiTGjmsmVG6Jy8vhdYb5nXKDh17lLMxLMGXJKBzK6eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqxfW6ImQ7rU1A7FTDAylXx7Csa16igwb1p03Ogt+qPqTXQEpMYZBleKd7CLvDiAs
	 iZkrnxCT9MVC+8EyIycVdT24Wrc2eG9yb/gF6XOsOpob/X/fK2zGDaIPFYmYClCJj3
	 tra6KcHlsLRWtCgafuckMp0846hple+ckY+28EZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1267/1376] s390: Add missing _TIF defines
Date: Sat, 12 Sep 2026 09:01:33 +0200
Message-ID: <20260912065635.779447317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 546d7bd47973790073b824d69ee59440337b407b ]

Add missing _TIF defines so that for every TIF bit its corresponding
_TIF mask exists. Sort the _TIF list to match the TIF order.

Also remove two leftover comments from the pre generic entry time.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/thread_info.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index 00ac01874a129..3802f281eeedc 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -61,7 +61,6 @@ void arch_setup_new_exec(void);
 /*
  * thread information flags bit numbers
  */
-/* _TIF_WORK bits */
 #define TIF_NOTIFY_RESUME	0	/* callback before returning to user */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
@@ -72,33 +71,33 @@ void arch_setup_new_exec(void);
 #define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_ISOLATE_BP_GUEST	9	/* Run KVM guests with isolated BP */
 #define TIF_PER_TRAP		10	/* Need to handle PER trap on exit to usermode */
-
 #define TIF_31BIT		16	/* 32bit process */
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	18	/* restore signal mask in do_signal() */
 #define TIF_SINGLE_STEP		19	/* This task is single stepped */
 #define TIF_BLOCK_STEP		20	/* This task is block stepped */
 #define TIF_UPROBE_SINGLESTEP	21	/* This task is uprobe single stepped */
-
-/* _TIF_TRACE bits */
 #define TIF_SYSCALL_TRACE	24	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	25	/* syscall auditing active */
 #define TIF_SECCOMP		26	/* secure computing */
 #define TIF_SYSCALL_TRACEPOINT	27	/* syscall tracepoint instrumentation */
 
 #define _TIF_NOTIFY_RESUME	BIT(TIF_NOTIFY_RESUME)
-#define _TIF_NOTIFY_SIGNAL	BIT(TIF_NOTIFY_SIGNAL)
 #define _TIF_SIGPENDING		BIT(TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	BIT(TIF_NEED_RESCHED)
 #define _TIF_UPROBE		BIT(TIF_UPROBE)
 #define _TIF_GUARDED_STORAGE	BIT(TIF_GUARDED_STORAGE)
 #define _TIF_PATCH_PENDING	BIT(TIF_PATCH_PENDING)
+#define _TIF_PGSTE		BIT(TIF_PGSTE)
+#define _TIF_NOTIFY_SIGNAL	BIT(TIF_NOTIFY_SIGNAL)
 #define _TIF_ISOLATE_BP_GUEST	BIT(TIF_ISOLATE_BP_GUEST)
 #define _TIF_PER_TRAP		BIT(TIF_PER_TRAP)
-
 #define _TIF_31BIT		BIT(TIF_31BIT)
+#define _TIF_MEMDIE		BIT(TIF_MEMDIE)
+#define _TIF_RESTORE_SIGMASK	BIT(TIF_RESTORE_SIGMASK)
 #define _TIF_SINGLE_STEP	BIT(TIF_SINGLE_STEP)
-
+#define _TIF_BLOCK_STEP		BIT(TIF_BLOCK_STEP)
+#define _TIF_UPROBE_SINGLESTEP	BIT(TIF_UPROBE_SINGLESTEP)
 #define _TIF_SYSCALL_TRACE	BIT(TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	BIT(TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		BIT(TIF_SECCOMP)
-- 
2.53.0



