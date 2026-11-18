Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044011;
	b=zbD6BXd+pSUK+C99H3MxkEJUcdr4KJgDn187cvKa1ddnz5FRa/Mez9pVpnpTrNkLKP0+
	 gP0512g/yOBru4pYF6k7DsatNfMZu1RlxF9voDRuZ69b0njoeWC8dfDmfU7+5zy6DsUnk
	 sZAUqj7XRm0CMHBlAkE+AVRSn2S1pVumhvF7gCh0w5J6M/yt2iVjdciSuHS7eXk43c05p
	 pg54iYI88LlG26HbGPur7IzGG1q+LBGEGmPV5Ks3TS8IXC6dswodMLwyqh0Lo4zH3vd8V
	 FnCreYc+MO9fLvST/6DVzowsfS+Nfw0tP/8+tuoL7R2mdsCncc30qfvUt1wn35QS7Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dJX7GlFfTZXNW5PryMx56g5iuU9vC5PhBUu+6WG77Xs=;
	b=MqPLpYCjt7kDwMY1QElSaYLo7PIsIfM/hvcozePcVAGUbwjOrJy9yV6OlpCasZxjKR6V
	 LhjHjKRCc4PVCoPUiyKMbctM6d3nRc4gN2sH9yXBZ0h3p4iMRZUgqnhFE8cR0bn4c8DKV
	 aXSC40yHq0Ut2ymT2bW9w4x1Q3WveN+UFrLoiLhmJ9/LmWMHWAZygtuAXC6CFC9x0dvog
	 C+rpOY5p+9t1bYbKcpYtWNcL6NUO4x3ZJj/StlgrZge+fyJefFAFTkR3cLZZO9nOcUlFP
	 I84fYgvJOPK6u0aubMmcIE4Zkb5+trjFgu0pyM5ylapBr6QTpS8B8NQ7c++wJFQ/8+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DM29JPr4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A036606A332;
	Wed, 18 Nov 2026 23:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DM29JPr4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09C51F000C6;
	Wed, 18 Nov 2026 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044011;
	bh=dJX7GlFfTZXNW5PryMx56g5iuU9vC5PhBUu+6WG77Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DM29JPr4/TedyA/LlqFLXVJvSmYmZ+vb2vOO9BI78+8mZP21tKtF/uu2SDTDliz8i
	 xnSxOitfoy6Tuy2uL3pXOMCzPIvHPnaKiV8Qhdey0+Ddp+UftCTIV+iEpVzBH0/yzZ
	 1fm03j469rWCKBUiyR3i+UIVmZDWOQEjuH379VX0=
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
Subject: [PATCH 6.1 0370/2857] mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Wed, 18 Nov 2026 15:23:24 +0100
Message-ID: <20261118150214.744575582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced cond_resched() with cond_resched_tasks_rcu_qs() at six scan-path sites, adapting context for void-returning scan_block helpers, the scan_should_stop() loop condition, and the page-scan loop ordering. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2200f34a4f004..96eafff89a038 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1395,7 +1395,7 @@ static void scan_large_block(void *start, void *end)
 		next = min(start + MAX_SCAN_SIZE, end);
 		scan_block(start, next, NULL);
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 }
 #endif
@@ -1440,7 +1440,7 @@ static void scan_object(struct kmemleak_object *object)
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else
@@ -1467,7 +1467,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1502,7 +1502,7 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1546,7 +1546,7 @@ static void kmemleak_scan_task_stacks(void)
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !scan_should_stop());
 }
 
@@ -1632,7 +1632,7 @@ static void kmemleak_scan(void)
 				continue;
 			scan_block(page, page + 1, NULL);
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 		}
 	}
 	put_online_mems();
-- 
2.53.0



