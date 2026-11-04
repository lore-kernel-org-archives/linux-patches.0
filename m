Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831196;
	b=NeBS4e4yxgjgpZy5jLaixMKWI2RGnB+Fkm6jRs9XV+jp8BhGNXAIDHe9FVLWpfAQ2HMA
	 HS9+8Pm+YgYNY2fz7hFsXZhEACq3GgqIPODFPKRLpyP2R1c9MrrLbL4levuHkjwryZk3I
	 3X6SCPS4cQm0D/8kymIXwe31hc0OpEnmiyouqOzc0ISqTsqLyvz110IsBsPDskCXRiEO4
	 R5Nx4bpSCCGV6OsF9TKSzJ05YqIorXKrlqDA4v/Rl3Cx3CgaMS5MTbKl2ulkzDpz/j5IU
	 DUIKhqU/kpeF4BVwgtM7UMOBfgsiMuZHPOAL8Nb/djVlZcNwMlvcZI+y9j0825HTnhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aBaPbyWIwzj3O81hehdKiG+2/qpYgH87+WfBOfbKT3E=;
	b=OwoqDg2sD3UC80Xw/bY1Iee1wALIfLkB6IdYK8SGDhg9ypZRMCrXy1Tqx3XQ1u4AX3WT
	 1aDlyohj4A0ZllC8esat+8sLgL06lLtwqFHGGV4y7Y/MPP1bPfZvzElqQjHVLhZS7usQ9
	 uy6dEJ3xLjovGlIdMk8cfNyZZRYCIs+0P1xtDEiFl54rVy2yqEktmGprg3WMye7doNXd1
	 R+YHtuE2kBpMQP0CX4uq88/cZTV3+X6DDnOGX7Hj6eYaKDghnQCg9PnXMwMF6zeXlIkMX
	 6z+FUPm5rfHiqhK+5o1APK/M3H5FoXzvOZ8oTJLXf+N7g5IiYMMk3hbCOuQMK3XAEAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnx5b2zx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE61606E83A;
	Wed,  4 Nov 2026 22:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnx5b2zx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3AF1F0093A;
	Wed,  4 Nov 2026 22:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831196;
	bh=aBaPbyWIwzj3O81hehdKiG+2/qpYgH87+WfBOfbKT3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnx5b2zx7syjWwzVCqnw3LuZo2YpB8qbPXK43X1KjIGEn6XaSKLavl0hiZbU46952
	 PLPwXu/PtxKvw/y8KkPeu1pltUL5she2/p8hVgg/nKqUhSD7b3ZoyQJhnvZQXAPDrt
	 l/+gPa3Ulpiu4pBgpee50H4olcaegh4GR3RtVL0Y=
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
Subject: [PATCH 6.18 0558/1005] mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Wed,  4 Nov 2026 16:04:51 -0500
Message-ID: <20261104211059.525344310@linuxfoundation.org>
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
index b5e1a493f1462..52de6314204f0 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1562,7 +1562,7 @@ static void scan_large_block(void *start, void *end)
 		next = min(start + MAX_SCAN_SIZE, end);
 		scan_block(start, next, NULL);
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 }
 #endif
@@ -1597,7 +1597,7 @@ static void scan_object(struct kmemleak_object *object)
 			scan_block(start, end, object);
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 			if (!(object->flags & OBJECT_ALLOCATED))
 				break;
@@ -1619,7 +1619,7 @@ static void scan_object(struct kmemleak_object *object)
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else {
@@ -1647,7 +1647,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1682,7 +1682,7 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1727,7 +1727,7 @@ static void kmemleak_scan_task_stacks(void)
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !stop);
 }
 
@@ -1803,7 +1803,7 @@ static void kmemleak_scan(void)
 			struct page *page = pfn_to_online_page(pfn);
 
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 
 			if (!page)
 				continue;
-- 
2.53.0



