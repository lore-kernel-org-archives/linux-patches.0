Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12F123A6
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20F1C433EF;
	Tue, 10 Jan 2023 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374004;
	bh=MNSnkI6d27yEiX6A/sPeo2+ooVeTpGc/VdS6BYJXUBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sljHr4XG914QJ6oNczwhsWmgjBKEHpG1aRtvM46zTsL72he29HwZ+K/vANe8L0gn
	 TB2y+8NPtAvnKF9yJ/kEFAx1aRcQJg+h9bRe+/gbIDFP5a//B4xCiUZOI7UzpJO4NS
	 KDUslImcQfJcWyXgvZmDecL3MHXUmTq6DH6Bs/Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Hui Tang <tanghui20@huawei.com>
Subject: [PATCH 6.0 001/148] ARM: renumber bits related to _TIF_WORK_MASK
Date: Tue, 10 Jan 2023 19:01:45 +0100
Message-Id: <20230110180017.205530671@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 191f8453fc99a537ea78b727acea739782378b0d upstream.

We want to ensure that the mask related to calling do_work_pending()
is within the first 16 bits. Move bits unrelated to that outside of
that range, to avoid spuriously calling do_work_pending() when we don't
need to.

Cc: stable@vger.kernel.org
Fixes: 32d59773da38 ("arm: add support for TIF_NOTIFY_SIGNAL")
Reported-and-tested-by: Hui Tang <tanghui20@huawei.com>
Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Link: https://lore.kernel.org/lkml/7ecb8f3c-2aeb-a905-0d4a-aa768b9649b5@huawei.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/thread_info.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -128,15 +128,16 @@ extern int vfp_restore_user_hwstate(stru
 #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_UPROBE		3	/* breakpointed or singlestepping */
-#define TIF_SYSCALL_TRACE	4	/* syscall trace active */
-#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
-#define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
-#define TIF_SECCOMP		7	/* seccomp syscall filtering active */
-#define TIF_NOTIFY_SIGNAL	8	/* signal notifications exist */
+#define TIF_NOTIFY_SIGNAL	4	/* signal notifications exist */
 
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
-#define TIF_RESTORE_SIGMASK	20
+#define TIF_RESTORE_SIGMASK	19
+#define TIF_SYSCALL_TRACE	20	/* syscall trace active */
+#define TIF_SYSCALL_AUDIT	21	/* syscall auditing active */
+#define TIF_SYSCALL_TRACEPOINT	22	/* syscall tracepoint instrumentation */
+#define TIF_SECCOMP		23	/* seccomp syscall filtering active */
+
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)


