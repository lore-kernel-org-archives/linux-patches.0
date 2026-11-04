Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831195;
	b=oaZVPd7cyqiXLm9DYj4vT56WHusZb/rHeXUiSnGZixkkqAy48nX2g2ZlrBYG9ExT6Eyu
	 Amc/UPLJjF/zYavSBOjMeqUVXhNuMLECH4bF++qXcr5VkFjKhg/ZVMzEI5ytM9e5tk+Vw
	 iLemybEZo9ATIGwvupLwhL7jbVofOg4pRC+F2Oi9KHMd0V4Oe77A9j3SMDG3fHLuS74K5
	 7OXtrARYWta6biNhCHv4EsGbx6rsYbOn7Cp5OJOzndyaqjA8Cc1v6LnMA284Vn4JfOMQr
	 8XIUjI54D35G9c8uMjcTuI7W60VrHB8JxyVhNv4kN1MEA1EbD3GyoR5wniLK9x+eQvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vh0qKmXVBFsoTL4A0DbsTfTuhX+kJosQKOcCnRNbE/s=;
	b=WaaXUEb9cTK9S9y9bubUfDcRAA/HGQKNtf4JiCm42M9ENmGEW3+GA8kZSQSfiwua+t6l
	 xljti565hYiyxOTRYFoG2VjLUeeIHcTlLM1X0fbHZF0mKTWOV5ayAoEosmV7hEB237n1e
	 APGufpUeL0RSnEybekvjWGzpGOQEx+kG5YU/FiCYLgpny+egluQYrdpi7BWa/cDkvpP0o
	 7Bu6MIfr8SrcWmQEIhINcQ9cq4xHvrI6MOoAx/CiTh3rpbxehCRFaEEUmKB7KtFRzrXqx
	 B1Ts1n8Lhejwm851eDdeEhrEAvQDFHmEbC4EmMx5pBNxoLy1hIeqRIxFGPoEtWiNM2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiFCusQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DC606E83C;
	Wed,  4 Nov 2026 22:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiFCusQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2F41F000C1;
	Wed,  4 Nov 2026 22:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831194;
	bh=vh0qKmXVBFsoTL4A0DbsTfTuhX+kJosQKOcCnRNbE/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiFCusQxASLIIoFu22Z0XXtKpy1jmrFH2jNxFuhNjQyg4+0psYVsBEzrAdcTF36LW
	 Go2qrhWYlFoCLOZ6IC/WG6+4W6ZEnN4z7dQZnz8+2hnBVeLPfc/+avbMIZinxGip9P
	 F3dicdYqX+g/XCuSmNfO2atpMMeI74OQLORZ90g4=
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
Subject: [PATCH 6.18 0557/1005] mm/kmemleak: stop the task stack scan early when interrupted
Date: Wed,  4 Nov 2026 16:04:50 -0500
Message-ID: <20261104211059.495999083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 452f3714f337b..b5e1a493f1462 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1518,22 +1518,25 @@ static int scan_should_stop(void)
 
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
@@ -1543,6 +1546,8 @@ static void scan_block(void *_start, void *_end,
 		pointer_update_refs(scanned, pointer, OBJECT_PERCPU);
 	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+
+	return stop;
 }
 
 /*
@@ -1698,6 +1703,7 @@ static void kmemleak_scan_task_stacks(void)
 {
 	struct pid *pid;
 	int nr = 1;
+	int stop = 0;
 
 	do {
 		struct task_struct *p = NULL;
@@ -1716,13 +1722,13 @@ static void kmemleak_scan_task_stacks(void)
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



