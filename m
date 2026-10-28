Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213909;
	b=qveplQR81q5SxhFOejeFi6dBtF+tnaLc9DhWe2G1Nuin7sYsoiv9X5tRKr+zPs5NW+iA
	 a0/C3wGlCFM4UwvAitYc7ThQf68eOVZsUd9mMZhjeQ4VgDfYbgz+mgo959Hj+xLknrGNi
	 Fonu31ifruegXxFm4emp+f3Q9NJWKJRsSroX4UEQGsp9F2WrgQpCOcivG2crOH/7XnbrD
	 /otz/WviKiT93l+OBADLDcP5PMsLEi4dA7N3mQuhrQ850yZGMJthhDXFuTmgbnTnsBlYy
	 Dcel2KpsbV24mwkOKPFHmYayI22iveFYUkfJ0UXwzP0IDdB8bVkB/LBtLOXKllpJRbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uf3t67xqN4kzKxjl1rbyGpBAEIKTE0EOK2mNmRmXm7U=;
	b=T6z2CjtprqIcd/bbIWauRF7sjPgsvgK+KkbtjSaQTM4OdcOipB/x5Tk71aRtRVEc8RHV
	 1SUdxUJ6eOp6pM0ZFEeqoLjfn3XJh+ywWbgIXUfOBbcpAi50SPSQ53JWn2CwtCQe4hYuZ
	 uVhThqlPGD/oJOU/UepYgx90hd9WeWkHp0gbl65Epap/pGc8A+ITZXJTx10FPaw2fm6LK
	 hKf6cEhjd8QSQYSEFh3I4viVIkWxFLJORErFPxP+RIvbYA1RsSlG1rcRCRVINYvtq2lPl
	 PbvFXYlouSg1+oKX5s4Vs3aAyooQMi1fEXQrSfGEeOwZhucRZ5Gi4Cm3w7JZ3QBKOuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XeQ3yHYA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E3B606A31A;
	Wed, 28 Oct 2026 18:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XeQ3yHYA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F5C1F01825;
	Wed, 28 Oct 2026 18:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213908;
	bh=uf3t67xqN4kzKxjl1rbyGpBAEIKTE0EOK2mNmRmXm7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeQ3yHYAMr/cnXXvzUH4oypR6R57+cxM2qG5kFCm4xnCjbvvPxSWeMIOKyyPJzchp
	 2tKKTucsuV+NOTQBH61bZnUjNvMWwjXPF5HG7QL42zUchn2yxZrVXbb0c2vM+wJlBr
	 mcviz4oUasnxHqZMIPYbJxi7+PpZXKdfG3RFaioQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0629/1887] sched/deadline: Fix task_struct reference leak
Date: Wed, 28 Oct 2026 17:45:25 +0100
Message-ID: <20261028170513.722312843@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit b58652db66c910c2245f5bee7deca41c12d707b9 ]

During the execution of the following stress test with linux-rt:

stress-ng --cyclic 30 --timeout 30 --minimize --quiet

kmemleak frequently reported a memory leak concerning the task_struct:

unreferenced object 0xffff8881305b8000 (size 16136):
  comm "stress-ng", pid 614, jiffies 4294883961 (age 286.412s)
  object hex dump (first 32 bytes):
    02 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .@..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  debug hex dump (first 16 bytes):
    53 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00  S...............
  backtrace:
    [<00000000046b6790>] dup_task_struct+0x30/0x540
    [<00000000c5ca0f0b>] copy_process+0x3d9/0x50e0
    [<00000000ced59777>] kernel_clone+0xb0/0x770
    [<00000000a50befdc>] __do_sys_clone+0xb6/0xf0
    [<000000001dbf2008>] do_syscall_64+0x5d/0xf0
    [<00000000552900ff>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

The issue occurs in start_dl_timer(), which increments the task_struct
reference count and sets a timer. The timer callback, dl_task_timer,
is supposed to decrement the reference count upon expiration. However,
if enqueue_task_dl() is called before the timer expires and cancels it,
the reference count is not decremented, leading to the leak.

This patch fixes the reference leak by ensuring the task_struct
reference count is properly decremented when the timer is canceled.

Fixes: feff2e65efd8 ("sched/deadline: Unthrottle PI boosted threads while enqueuing")
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20240620125618.11419-1-wander@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 62a7c4ed86753..83204e5b780e4 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1689,8 +1689,12 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 			 * The replenish timer needs to be canceled. No
 			 * problem if it fires concurrently: boosted threads
 			 * are ignored in dl_task_timer().
+			 *
+			 * If the timer callback was running (hrtimer_try_to_cancel == -1),
+			 * it will eventually call put_task_struct().
 			 */
-			hrtimer_try_to_cancel(&p->dl.dl_timer);
+			if (hrtimer_try_to_cancel(&p->dl.dl_timer) == 1)
+				put_task_struct(p);
 			p->dl.dl_throttled = 0;
 		}
 	} else if (!dl_prio(p->normal_prio)) {
-- 
2.53.0



