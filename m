Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034612;
	b=JZJtbZRMLIMgF87XYWsaaWy7u4v/95KNKU39xKFHTs3n5ZswAouZZqWq1a2u6gxm6k+r
	 SDYweceafJt3HwQTxYEcM7dHER9MNltdTRU3aSkIaCzhb5NYs1FW83FVOavOtGCQSO9mZ
	 uZTMUn5t/7kC3FEmX9sGnCIgxVdjQYSBwivxBa5nwSXAUke5SH/Mwl98UJNYICkPkV5aJ
	 yRaw4amMf7smF9TyEZUd00is/x8FULgK2alvX1SRLhfW1o2EylxcBuc6/Xt89V9KykjYA
	 78MtzzFHUgef9R+U6W0i1Yb6+WHaKK3wTFp5cpJynDOQxg7nMfjrArt34I7p/+bd1tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PX/cF3WOoAhxsvK08yf1LzIn7EhRPCLP8BuJ5flNdJs=;
	b=oIshnY55MICFtvwinAcLydAiIP5Gahkx+S3mkxKNUWFe4GJqvVjLUQZlcW2D5VMyj/rn
	 RnzvSYyR9oUdGPJcGQOKQ7P0t8XQFgLa2+Mp++Xk2E7LDqbqZ7F5iZesVszpTp1QBj9eU
	 oxJLZuISuJ15BbCO7LnoLL8XFN7L2yiVnmzgaL/IxKWZjWx5i7tN+4z6zIbTrBqih4E60
	 orimejLMUSgR95uFhClQ8WNfKFUhc8NKz4N3RnFdxfcm+SsyuxL0DYGvwpBdqkNn602pP
	 F308CX2O4pOfl49lOhp66XQT+qDzW66Z+h4tIccAhJQ6lc09MerLwgVvk7Rhwh3Jmjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HPt/WbWJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C04660A5BE1;
	Wed, 18 Nov 2026 20:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPt/WbWJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8361F1F000C8;
	Wed, 18 Nov 2026 20:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034612;
	bh=PX/cF3WOoAhxsvK08yf1LzIn7EhRPCLP8BuJ5flNdJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPt/WbWJM6otE3sUbjx9bTfLGaxeLv3QFH5Af+HgBdoCouiI6x65mW+08hBek7VBz
	 Yd6TK+Q1ns7Yh8lT2ZGFcGkhdbl753pHTfXQjxhpEf8koh8vYrLPRBjYrPoM94hbJW
	 Zxvztc8Mc7jQANwWGNHUmtVho9rWgyLEdy6/UGaI=
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
Subject: [PATCH 6.6 0428/3318] mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Wed, 18 Nov 2026 15:17:30 +0100
Message-ID: <20261118150329.445375339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the per-CPU OBJECT_PERCPU hunk in scan_object() since that code doesn't exist here, and hand-converted the kmemleak_scan_task_stacks() call because its surrounding loop condition differs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index fceb28690f2fc..39f258dd6761e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1397,7 +1397,7 @@ static void scan_large_block(void *start, void *end)
 		next = min(start + MAX_SCAN_SIZE, end);
 		scan_block(start, next, NULL);
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 }
 #endif
@@ -1442,7 +1442,7 @@ static void scan_object(struct kmemleak_object *object)
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else
@@ -1469,7 +1469,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1504,7 +1504,7 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1548,7 +1548,7 @@ static void kmemleak_scan_task_stacks(void)
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !scan_should_stop());
 }
 
@@ -1624,7 +1624,7 @@ static void kmemleak_scan(void)
 			struct page *page = pfn_to_online_page(pfn);
 
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 
 			if (!page)
 				continue;
-- 
2.53.0



