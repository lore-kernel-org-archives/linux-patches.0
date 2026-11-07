Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061372;
	b=ygmX1lf/pYRUibomenWLmHEQyH63aRo20t/YAggZd3sMBPpPCd1K7Xwx+O5woWmzzDl9
	 lJEj4YDkooOV++BcFMpFXjC3HnKHT5LpjwMuHy5Eu10OScQTiSvgxMDeIJ/Efq0UH2pnL
	 UK2+xrUpKMPONjToPceVMGxcPm6t4vq8rFaCen4bLqNibURllQTf3wTeIkjiTsjXmPnuC
	 wtIwEFvxMiBU78d+WhEWJqtejE8Bl31OsNTqy/1c1KMK60b5E5Ae2DWITknxZdnygGHEn
	 hxHwlaAbVMAHM8zOMPU+60Ay/Fb8wVTXsTghGd8UiBXH4+FUUwHCBHHi8t2e1+rfHlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+51UW2sFQMjf3/glEJT0dHYgZpMbfR8J68BUUVQ4CE=;
	b=fZZ8SkmfRFIIFwx3E7Qa1eYiVpjhZqij1enwQ6CBpxUV6gJxtX0QzAYTo1ri8uTEweda
	 vLqKR2rKXA/TDAmHjWUg8NRfOQGh7sks/k7GxngpUuxTepU8zeuLW7PZkuiNGkmV2vFda
	 0LDeXHwE0pKvLcQgt2c5wL6+TNq2/MtloLdO6J3+HE6GsCHkdUx9SKwW+QGJ+l1/hj4/Z
	 19ofRJr4Q1Y9Uht6b4ZsrkdPaSXwY44bVxmc4UyddwBJDhL4xKPXonnEGlIsjYGPtDOMD
	 Wdt8mf/hHUNkviCKc3pHQsH6wQc04UYAwq4H7AFMRNc3zP2ItkAUKH5/sM1JueYYQdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVHBmV51;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF867606A338;
	Sat,  7 Nov 2026 14:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVHBmV51
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702071F008A4;
	Sat,  7 Nov 2026 14:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061371;
	bh=M+51UW2sFQMjf3/glEJT0dHYgZpMbfR8J68BUUVQ4CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVHBmV51yWfdj75x43024cH7EY6CWy9wud2DpYYF/rbGcWzplBUiiU5Np+qmbwMXY
	 utCy6CbsnL94KddzSv+prGhqEp8lWmh7BnYopV+ibJdr6EicbWVvPn2ZRqA18hmsFK
	 QHRf734FkXn2TF0hj7fKjvaGXWTUGt4fQdGSFJfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	SJ Park <sj@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0493/1536] mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Sat,  7 Nov 2026 08:41:49 -0500
Message-ID: <20261107135011.311818295@linuxfoundation.org>
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

[ Upstream commit 3541a2b06ecd78ba333188df04368dcf97273d6a ]

kmemleak_scan() can run for ages on large debug kernels. It was
causing some soft-lockups which I got fixed with commit
3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
stacks") with our beloved cond_resched().

I've got the fix above deployed in the Meta fleet, and now I am seeing:

  INFO: rcu_tasks detected stalls on tasks:
    task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
     scan_block
     scan_gray_list
     kmemleak_scan

and, worse, blocks the callers waiting on that grace period.  Here a BPF
struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
call_rcu_tasks), is stuck long enough to also trip the hung task check:

  INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
     __wait_rcu_gp
     bpf_struct_ops_map_free

Then I've learned that cond_resched() is not an RCU-tasks quiescent
state, so, we need to use stronger primitives.

Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
reports an RCU-tasks quiescent state as it proceeds.

Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
quiescent state for task rcu").

Link: https://lore.kernel.org/20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org
Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 44a3a95da9963..8f4080c0cf399 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1543,7 +1543,7 @@ static void scan_large_block(void *start, void *end)
 		next = min(start + MAX_SCAN_SIZE, end);
 		scan_block(start, next, NULL);
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 }
 #endif
@@ -1578,7 +1578,7 @@ static void scan_object(struct kmemleak_object *object)
 			scan_block(start, end, object);
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 			if (!(object->flags & OBJECT_ALLOCATED))
 				break;
@@ -1600,7 +1600,7 @@ static void scan_object(struct kmemleak_object *object)
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else {
@@ -1628,7 +1628,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1663,7 +1663,7 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1708,7 +1708,7 @@ static void kmemleak_scan_task_stacks(void)
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !stop);
 }
 
@@ -1784,7 +1784,7 @@ static void kmemleak_scan(void)
 			struct page *page = pfn_to_online_page(pfn);
 
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 
 			if (!page)
 				continue;
-- 
2.53.0



