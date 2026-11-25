Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618685;
	b=BX0+SQZUP75sNps+6YoT/4gDYxUkxP1JuMunp5x9WAU0d0RxLCxV99FPJXMdqOF99taq
	 2wCtYb1Btjx7p9wHRvBsSLcPb/io6z3ewpoOsAkASq9MwvfYX/q7c+V0vPo9b/thuKt33
	 E3XEXQPNZZaGbF15F8Lx/vLWtWJsUnJw3foT+3Mstbia/6rLscQHRnnnMh3ofCmTjt3tA
	 WadeI84v7z0gZ7SmaaSJzaEpevyPWHdD/vQyREKN509jcA9TbbLhu9zHKDhkWWRA2sPT2
	 Lx9JhaWpC8LKVmB3R7Id/A/M40Yo8fe+r97QpbPLgYnOkZzc4eTMzOUDZFkU4lvw7Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5R0WEOCl3R0vy8UeWCGQhUvg2t8Z9yrd+b0Z6f1ikE0=;
	b=nWHUSBD/SXwCu3w3LmmWOkmH/Qmch2MP52Q4WGaHcJWm9IbyPl6mKJxgapPnhyWQrZgG
	 byvGNaj4NVDB9i2ptVdAwAFJxxqvlj3t1a+2EEukeFVc0rLt64efl+B40DZrP/EqEfwKu
	 rWGuzvJVQHjtK8i07eLt4MYRs2kV6O3K0skLYEn2yCfpLw5Sie0ZU4k4o1WTCi3sUE3ml
	 D0k8SNByyCfQ2Pf04bxHO6xwNbY6wzoYQ03Etamvg3ow3PqXxKh+o5sWXzMR2UPcXJRkG
	 2jZgYQdQxHnSZVm3yT0jRB4b2jhuOybH9NlExoFgJifZc03/XoPGpxc8sgRT2Va6+RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueyZ7mG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24304606A32E;
	Wed, 25 Nov 2026 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueyZ7mG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5A21F000D8;
	Wed, 25 Nov 2026 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618685;
	bh=5R0WEOCl3R0vy8UeWCGQhUvg2t8Z9yrd+b0Z6f1ikE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueyZ7mG6GT30E7BarwVYW+ZbAk2mlSpOvzpFO8CiBbENEZYy1RtHvPqa39I5azLkt
	 BS9uSooDp3s8MA/VgOB1uwSK4fxuvTn5X1M3kLp/Y6c8mDcaVK+s9PTxokbkvcnCq5
	 b+tOgzGrA+zc1ikIT1Dd5SATa5GL/8GFewkVXsQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0355/1005] locking/osq: Fix unlink queue corruption
Date: Wed, 25 Nov 2026 15:28:13 +0100
Message-ID: <20261125143830.050362078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 408b129aac48b574c0c9d11137a89eefba825d5d ]

Very similar to commit 50972fe78f24 ("locking/osq_lock: Fix osq_lock
queue corruption"), make sure to order the prev->next store against
the next->prev store.

Fixes: 50972fe78f24 ("locking/osq_lock: Fix osq_lock queue corruption")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/osq_lock.c | 60 +++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index 98b12d7b79964..2bcc148eb2ddb 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -90,6 +90,49 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 	}
 }
 
+/*
+ * Set prev->next; this is the counterpart of osq_wait_next() in that
+ * by setting ->next the wait is terminated and progress is resumed.
+ */
+static inline void osq_link_next(struct optimistic_spin_node *prev,
+				 struct optimistic_spin_node *next)
+{
+	/*
+	 * Suppose:
+	 *
+	 *                   tail
+	 *                    |
+	 *                    V
+	 *   CPU1 -> CPU2 -> CPU3:
+	 *   n: 2    n: 3    n: nil
+	 *   p: nil  p: 1    p: 2
+	 *
+	 * And this is CPU2 doing the self-unqueue concurrent against CPU1s
+	 * unlock()/unqueue(). Since 'prev->next == NULL' and CPU1 will be
+	 * stuck in osq_wait_next() until the below store of 'prev->next'.
+	 *
+	 * CPU2				CPU1
+	 *
+	 * next->prev = prev;		osq_wait_next()
+	 * WMB				MB
+	 * prev->next = next;		next->prev = prev
+	 *
+	 * Without the WMB it would be possible to have conflicting stores
+	 * like:
+	 *
+	 * CPU2				CPU1
+	 *
+	 * prev->next = next // CPU1.n = 3
+	 *				next = osq_wait_next() // = 3
+	 *				next->prev = prev // CPU3.p = nil
+	 * next->prev = prev // CPU3.p = 1
+	 *
+	 * Which would result in list corruption.
+	 */
+	smp_wmb();
+	WRITE_ONCE(prev->next, next);
+}
+
 bool osq_lock(struct optimistic_spin_queue *lock)
 {
 	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
@@ -113,20 +156,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 
 	prev = decode_cpu(old);
 	node->prev = prev;
-
-	/*
-	 * osq_lock()			unqueue
-	 *
-	 * node->prev = prev		osq_wait_next()
-	 * WMB				MB
-	 * prev->next = node		next->prev = prev // unqueue-C
-	 *
-	 * Here 'node->prev' and 'next->prev' are the same variable and we need
-	 * to ensure these stores happen in-order to avoid corrupting the list.
-	 */
-	smp_wmb();
-
-	WRITE_ONCE(prev->next, node);
+	osq_link_next(prev, node);
 
 	/*
 	 * Normally @prev is untouchable after the above store; because at that
@@ -202,7 +232,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 	 */
 
 	WRITE_ONCE(next->prev, prev);
-	WRITE_ONCE(prev->next, next);
+	osq_link_next(prev, next);
 
 	return false;
 }
-- 
2.53.0



