Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212192;
	b=CEL9NyIYd+Gs2jH3lvRB6yJL0ddgYH+Dyg+d8xlZ00C1LmoHU6IFhLxzbgxdj/nkFS+D
	 JQnCgNhx2pViT1+nhmM0zJz9WDyPL1X1mdlg2ATTvJtdsGla2I8QGW2TNSWvKgncwRqco
	 Vye2a+r1Ndm5Rmr+QtJ0Ewq5nbDsuaQfsKu6SPn8PvTfbltea25rGCd/iMmef8RPtLyuI
	 zDfFpk3sf2ycAY/mYKg4qQ6EGd4EkbzbEKlCDq1V4Wp6KCVeeYZgcpLgXSCyHvRjAgo+a
	 pPFJxFPor3ur0juR65neGBBbB6iBZESZX7Cgd+JmXzSohFhHeEkL0tdpUHOyxxCDJFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZlZjyjTzhMD8AarFVVmN5xzvUcNX0zhm4uXFUwCKp6Y=;
	b=rxrP20h45CVkLbJxw1pfo3NJPi60bJlq4v53o+D5PzNUVGYMzmxtK9J6uHLGtn5k+rYN
	 hzVrr8uJ0EyvLqb4KL8nqZqJGWTx5P3v+3vHk5OR0lpF2R8698rCjcES4A1t+5pwle2WK
	 xMTFEx46u94D0CgXGd7QY4LCd/3lCmUVDx724l2lRav5lbBspA95QYJvKjkruVnmY6sMB
	 ejGqeLW+2tfO9WPaFRnsoI8iBcinEhhZpdHT7Nk/6ADAHGGrN2PP7DPdim7HVl5b7UpKz
	 R71oFQeijReswRFoIJMQi53BjXaBv4Y254VdHEX95hLcZq7nQ4dV4qTvfavqqDGAFmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUjxCm8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A2606A31A;
	Wed, 28 Oct 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUjxCm8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854E31F01825;
	Wed, 28 Oct 2026 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212192;
	bh=ZlZjyjTzhMD8AarFVVmN5xzvUcNX0zhm4uXFUwCKp6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUjxCm8VYU7BVQ57GA81hEAV53J0xx8RCr00bGi/ByIeLa3fqJrHwzdZ48N2iow1a
	 GXYkOhhg+J9VfN6usvFcQi83OBqEfHDH5nmLDeLtEB+7MSRc49QsSx3xzDcLthaXIy
	 OZ+5+jrAdNSNhhLBNokWOO+juRgFjj89Oz0xX+08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang1.zhang@intel.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0071/1887] kasan: fix lockdep report invalid wait context
Date: Wed, 28 Oct 2026 17:36:07 +0100
Message-ID: <20261028170500.849881150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit be41d814c6c7bbf3ffa66faeefa01f6cea8e3c98 ]

For kernels built with the following options and booting

CONFIG_SLUB=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RAW_LOCK_NESTING=y

[    0.523115] [ BUG: Invalid wait context ]
[    0.523315] 6.3.0-rc1-yocto-standard+ #739 Not tainted
[    0.523649] -----------------------------
[    0.523663] swapper/0/0 is trying to lock:
[    0.523663] ffff888035611360 (&c->lock){....}-{3:3}, at: put_cpu_partial+0x2e/0x1e0
[    0.523663] other info that might help us debug this:
[    0.523663] context-{2:2}
[    0.523663] no locks held by swapper/0/0.
[    0.523663] stack backtrace:
[    0.523663] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.3.0-rc1-yocto-standard+ #739
[    0.523663] Call Trace:
[    0.523663]  <IRQ>
[    0.523663]  dump_stack_lvl+0x64/0xb0
[    0.523663]  dump_stack+0x10/0x20
[    0.523663]  __lock_acquire+0x6c4/0x3c10
[    0.523663]  lock_acquire+0x188/0x460
[    0.523663]  put_cpu_partial+0x5a/0x1e0
[    0.523663]  __slab_free+0x39a/0x520
[    0.523663]  ___cache_free+0xa9/0xc0
[    0.523663]  qlist_free_all+0x7a/0x160
[    0.523663]  per_cpu_remove_cache+0x5c/0x70
[    0.523663]  __flush_smp_call_function_queue+0xfc/0x330
[    0.523663]  generic_smp_call_function_single_interrupt+0x13/0x20
[    0.523663]  __sysvec_call_function+0x86/0x2e0
[    0.523663]  sysvec_call_function+0x73/0x90
[    0.523663]  </IRQ>
[    0.523663]  <TASK>
[    0.523663]  asm_sysvec_call_function+0x1b/0x20
[    0.523663] RIP: 0010:default_idle+0x13/0x20
[    0.523663] RSP: 0000:ffffffff83e07dc0 EFLAGS: 00000246
[    0.523663] RAX: 0000000000000000 RBX: ffffffff83e1e200 RCX: ffffffff82a83293
[    0.523663] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8119a6b1
[    0.523663] RBP: ffffffff83e07dc8 R08: 0000000000000001 R09: ffffed1006ac0d66
[    0.523663] R10: ffff888035606b2b R11: ffffed1006ac0d65 R12: 0000000000000000
[    0.523663] R13: ffffffff83e1e200 R14: ffffffff84a7d980 R15: 0000000000000000
[    0.523663]  default_idle_call+0x6c/0xa0
[    0.523663]  do_idle+0x2e1/0x330
[    0.523663]  cpu_startup_entry+0x20/0x30
[    0.523663]  rest_init+0x152/0x240
[    0.523663]  arch_call_rest_init+0x13/0x40
[    0.523663]  start_kernel+0x331/0x470
[    0.523663]  x86_64_start_reservations+0x18/0x40
[    0.523663]  x86_64_start_kernel+0xbb/0x120
[    0.523663]  secondary_startup_64_no_verify+0xe0/0xeb
[    0.523663]  </TASK>

The local_lock_irqsave() is invoked in put_cpu_partial() and happens in
IPI context, due to the CONFIG_PROVE_RAW_LOCK_NESTING=y (the
LD_WAIT_CONFIG not equal to LD_WAIT_SPIN), so acquire local_lock in IPI
context will trigger above calltrace.

This commit therefore moves qlist_free_all() from hard-irq context to task
context.

Link: https://lkml.kernel.org/r/20230327120019.1027640-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 8790303cbaac ("kasan: fix cache shrink race with CPU hotplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kasan/quarantine.c | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 75585077eb6dd..152dca73f3984 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -99,7 +99,6 @@ static unsigned long quarantine_size;
 static DEFINE_RAW_SPINLOCK(quarantine_lock);
 DEFINE_STATIC_SRCU(remove_cache_srcu);
 
-#ifdef CONFIG_PREEMPT_RT
 struct cpu_shrink_qlist {
 	raw_spinlock_t lock;
 	struct qlist_head qlist;
@@ -108,7 +107,6 @@ struct cpu_shrink_qlist {
 static DEFINE_PER_CPU(struct cpu_shrink_qlist, shrink_qlist) = {
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(shrink_qlist.lock),
 };
-#endif
 
 /* Maximum size of the global queue. */
 static unsigned long quarantine_max_size;
@@ -319,16 +317,6 @@ static void qlist_move_cache(struct qlist_head *from,
 	}
 }
 
-#ifndef CONFIG_PREEMPT_RT
-static void __per_cpu_remove_cache(struct qlist_head *q, void *arg)
-{
-	struct kmem_cache *cache = arg;
-	struct qlist_head to_free = QLIST_INIT;
-
-	qlist_move_cache(q, &to_free, cache);
-	qlist_free_all(&to_free, cache);
-}
-#else
 static void __per_cpu_remove_cache(struct qlist_head *q, void *arg)
 {
 	struct kmem_cache *cache = arg;
@@ -340,7 +328,6 @@ static void __per_cpu_remove_cache(struct qlist_head *q, void *arg)
 	qlist_move_cache(q, &sq->qlist, cache);
 	raw_spin_unlock_irqrestore(&sq->lock, flags);
 }
-#endif
 
 static void per_cpu_remove_cache(void *arg)
 {
@@ -362,6 +349,8 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
 {
 	unsigned long flags, i;
 	struct qlist_head to_free = QLIST_INIT;
+	int cpu;
+	struct cpu_shrink_qlist *sq;
 
 	/*
 	 * Must be careful to not miss any objects that are being moved from
@@ -372,20 +361,13 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
 	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
-#ifdef CONFIG_PREEMPT_RT
-	{
-		int cpu;
-		struct cpu_shrink_qlist *sq;
-
-		for_each_online_cpu(cpu) {
-			sq = per_cpu_ptr(&shrink_qlist, cpu);
-			raw_spin_lock_irqsave(&sq->lock, flags);
-			qlist_move_cache(&sq->qlist, &to_free, cache);
-			raw_spin_unlock_irqrestore(&sq->lock, flags);
-		}
-		qlist_free_all(&to_free, cache);
+	for_each_online_cpu(cpu) {
+		sq = per_cpu_ptr(&shrink_qlist, cpu);
+		raw_spin_lock_irqsave(&sq->lock, flags);
+		qlist_move_cache(&sq->qlist, &to_free, cache);
+		raw_spin_unlock_irqrestore(&sq->lock, flags);
 	}
-#endif
+	qlist_free_all(&to_free, cache);
 
 	raw_spin_lock_irqsave(&quarantine_lock, flags);
 	for (i = 0; i < QUARANTINE_BATCHES; i++) {
-- 
2.53.0



