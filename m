Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061370;
	b=EaeWiSYqwt9fa265jmAQTsPC2XUU6uGx19bdnj8QIOtYiZ8aiw6NphNzsWskOJcKe/Q2
	 2k7uvn3dHdBCa6ZKOeTj1PSo2Ah8E22+5rovDiwbsY15LFazPAgAGhPJZfVGOeDfczh3K
	 9ZLsl+Pw+h6nB7H+9wOG1Ej8YMDELsdueFNRSbzacXxofec2ofCbayB0ac8hqx21vNAGd
	 rOYHjmAehX9O10l9aIIoZ1IIFP6qN7Hxans7wk4JiLbP+9R6KrK5GZBRem9XPpCiLha0k
	 umJiPn9BsmJp8tCaXqpSh+fxjErvVZpZBqdSGUb7/BXYGcI0SmDjJK1qjs5LenXewYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8voPBZPajOHNO50JDGZ0P+ydqsOO/nXT0r+pkeyaeVw=;
	b=yaUIe0+QR3CUEsbVQVFxr+kFP9AAOMyXmZq9jAf/ODYFFK33d6WwDpEkY4KHZo06lK/F
	 fxWV45xwUP2+e36vvTjKDCRiU3uvq51tBuSzRqvpx0R1qlZlZFBHoypVsNEG0AujyNRgl
	 pZl+4DEf2pHWQlB8Uh1rwc+LsOrvgsTwqw+ywkaTQr1MWXjGgnbIbYTS+aYA2AnQG780B
	 nPxyqe7xDqQM5auNBUkB0pW77slvG5BcpNpMGDoX7Qb47b/qjmOlukIEP5hALouIpUPJE
	 IP1n1E4YEd7wRNKgRXIbjN1QUAuXTsXoIFKQHQhSVpDS1xEEmIvYQ9EeGb+QNxIQ3SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5o8ds1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7C1606A332;
	Sat,  7 Nov 2026 14:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5o8ds1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162341F008A1;
	Sat,  7 Nov 2026 14:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061369;
	bh=8voPBZPajOHNO50JDGZ0P+ydqsOO/nXT0r+pkeyaeVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5o8ds1Bs7H5Nm2Q1xHp9R4HYTD1RxH5ALimPbttG5KLetvBNuxa0zIv8YsnuZOye
	 +G9Nh81iM9wJ/EeVEMTg6dniQ5FO8ED2HZhzmJSjAfpTlrq2KGObcfa0XdYZ8SCk9y
	 0ims2BZvv5wi3JGLQwtRGRzJv8r+cXMeNElOW1QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Lance Yang <lance.yang@linux.dev>,
	Qian Cai <cai@lca.pw>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0492/1536] mm/kmemleak: stop the task stack scan early when interrupted
Date: Sat,  7 Nov 2026 08:41:48 -0500
Message-ID: <20261107135011.285502975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit eb11f56eeca56069613d00bf623607e305b271d9 ]

scan_block() already checks scan_should_stop() for every pointer and bails
out of the current block, but the task stack walk cannot tell and keeps
issuing a separate scan_should_stop() between every task.

Return that status from scan_block() and use it as the task stack loop
condition, so the walk stops as soon as a scan is interrupted.

Link: https://lore.kernel.org/20260615-kmemleak-stack-resched-v3-2-acecd7d7fd92@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qian Cai <cai@lca.pw>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3541a2b06ecd ("mm/kmemleak: report RCU-tasks quiescent states during the scan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index a54585f0406e6..44a3a95da9963 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1499,22 +1499,25 @@ static int scan_should_stop(void)
 
 /*
  * Scan a memory block (exclusive range) for valid pointers and add those
- * found to the gray list.
+ * found to the gray list. Return non-zero if the scan was interrupted.
  */
-static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned)
+static int scan_block(void *_start, void *_end,
+		      struct kmemleak_object *scanned)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
 	unsigned long flags;
+	int stop = 0;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	for (ptr = start; ptr < end; ptr++) {
 		unsigned long pointer;
 
-		if (scan_should_stop())
+		if (scan_should_stop()) {
+			stop = 1;
 			break;
+		}
 
 		kasan_disable_current();
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
@@ -1524,6 +1527,8 @@ static void scan_block(void *_start, void *_end,
 		pointer_update_refs(scanned, pointer, OBJECT_PERCPU);
 	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+
+	return stop;
 }
 
 /*
@@ -1679,6 +1684,7 @@ static void kmemleak_scan_task_stacks(void)
 {
 	struct pid *pid;
 	int nr = 1;
+	int stop = 0;
 
 	do {
 		struct task_struct *p = NULL;
@@ -1697,13 +1703,13 @@ static void kmemleak_scan_task_stacks(void)
 			void *stack = try_get_task_stack(p);
 
 			if (stack) {
-				scan_block(stack, stack + THREAD_SIZE, NULL);
+				stop = scan_block(stack, stack + THREAD_SIZE, NULL);
 				put_task_stack(p);
 			}
 			put_task_struct(p);
 		}
 		cond_resched();
-	} while (pid && !scan_should_stop());
+	} while (pid && !stop);
 }
 
 /*
-- 
2.53.0



