Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCD4429000;
	Sat, 12 Sep 2026 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219036; cv=none; b=DmX/0ftodq6pYqYeTqljVTZLKamrSEeoNP0y3wW7SzkuqKz+8fhB/r0P4EAuaopRvZOhkKwGPtOitfzbVRRJNxJrnXKh2uVYUbJidMd3TugNnbXtr2fWkNCruekxqA3fXSvx+Nkot1IMxsCFBbdul0N6ebuFJiCd+0uLQiFX0lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219036; c=relaxed/simple;
	bh=a/8HNHR0aBtcTL1jLWZPHtT6AY7G/xq1maerQyqgYnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK9LnC1SvI/x4tjfAWnO0HMfNCNcotJ+yXz0GoKu+1NreI2UiUi5LRRAUdGZnXMJ4KbzvvWB+tE40asXoDrAIKuoBBtDp5XkJpXBdtGD4joIH1UQUctviAFGPFAB7renBtDONgBwnqhNTTMdh3erLDfbQLe2JPGKOhlGgO70bW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIeXB08H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIeXB08H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194EC1F000FF;
	Sat, 12 Sep 2026 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219034;
	bh=KlMS+oNCn16Vwlnc8znrwFWphRC+QSpSyRmRPEWUJNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pIeXB08HyoCCD8tevjTHkAGkeZkSqeAJ77YBHRTsaMDScuw9MJyzvmND6KLmFmF+U
	 RtVa+D+Q403onhpImLaf6EUN0vgF61Mc8P2gPrgWQSdKr3R9fsElL7kphiC/yCc3mA
	 RC/OW+qQ7au++zbR5YaoeVNmrYxV+kHPXQbRD8xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1268/1376] s390: Add ARCH_HAS_PREEMPT_LAZY support
Date: Sat, 12 Sep 2026 09:01:34 +0200
Message-ID: <20260912065635.800686097@linuxfoundation.org>
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

[ Upstream commit 9de3e4bf6cfbcb62e9ec658e3b291cd479018b43 ]

Just add the required TIF bit for ARCH_HAS_PREEMPT_LAZY support.

Shuffle TIF bits to get TIF_NEED_RESCHED_LAZY next to TIF_NEED_RESCHED.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 902caade3cfd ("arm64: ptdump: Make note_page_flush() range aware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig                   | 1 +
 arch/s390/include/asm/thread_info.h | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 53dd642281776..69aac02d5fc4c 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -80,6 +80,7 @@ config S390
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
+	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SCALED_CPUTIME
 	select ARCH_HAS_SET_DIRECT_MAP
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index 3802f281eeedc..c33f7144d1b97 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -64,11 +64,12 @@ void arch_setup_new_exec(void);
 #define TIF_NOTIFY_RESUME	0	/* callback before returning to user */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_UPROBE		3	/* breakpointed or single-stepping */
-#define TIF_GUARDED_STORAGE	4	/* load guarded storage control block */
+#define TIF_NEED_RESCHED_LAZY	3	/* lazy rescheduling needed */
+#define TIF_UPROBE		4	/* breakpointed or single-stepping */
 #define TIF_PATCH_PENDING	5	/* pending live patching update */
 #define TIF_PGSTE		6	/* New mm's will use 4K page tables */
 #define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
+#define TIF_GUARDED_STORAGE	8	/* load guarded storage control block */
 #define TIF_ISOLATE_BP_GUEST	9	/* Run KVM guests with isolated BP */
 #define TIF_PER_TRAP		10	/* Need to handle PER trap on exit to usermode */
 #define TIF_31BIT		16	/* 32bit process */
@@ -85,11 +86,12 @@ void arch_setup_new_exec(void);
 #define _TIF_NOTIFY_RESUME	BIT(TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		BIT(TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	BIT(TIF_NEED_RESCHED)
+#define _TIF_NEED_RESCHED_LAZY	BIT(TIF_NEED_RESCHED_LAZY)
 #define _TIF_UPROBE		BIT(TIF_UPROBE)
-#define _TIF_GUARDED_STORAGE	BIT(TIF_GUARDED_STORAGE)
 #define _TIF_PATCH_PENDING	BIT(TIF_PATCH_PENDING)
 #define _TIF_PGSTE		BIT(TIF_PGSTE)
 #define _TIF_NOTIFY_SIGNAL	BIT(TIF_NOTIFY_SIGNAL)
+#define _TIF_GUARDED_STORAGE	BIT(TIF_GUARDED_STORAGE)
 #define _TIF_ISOLATE_BP_GUEST	BIT(TIF_ISOLATE_BP_GUEST)
 #define _TIF_PER_TRAP		BIT(TIF_PER_TRAP)
 #define _TIF_31BIT		BIT(TIF_31BIT)
-- 
2.53.0



