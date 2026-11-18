Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028297;
	b=lflTLA9Ywn8gqJhGY0+Kccwllx59MVcIUKgGkddEnRC+AzDN4BQ/Q7D0JzHapziPOygt
	 ejM8pdbU7rVpOv194Uf5S/N5ErdGoDbOhZs3qTum6q5I0gEo7RJwa2n2sDb5sihQM8mIP
	 m5QEnqpyXWhX04an3k0pXP7CUoaLP5rVHZZYYYL73WIOqiwTyXLiAHLu1mayHwGDiyqSG
	 rDk7k+ERVP3NVXqOWugh0+9D/DY46DORBPbEaHpasCZ4l9sm6VyFUaymX1UBijkVYlpfW
	 rYJMYe/Bo4yWAmKbm72OQwO4t3tclPgxyruRYdySNeunDKay0ISPeHV5u/vM0Vgen7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3yKjlZ1ltG96yOB0rjAXMiITV2wmUvV/c1NqSX/JMFM=;
	b=wf+3NxZCIUdxc4S1If3BglbMLoG2/OD67IwdCX5NXb6G/4oEYb+PEQ654SljT2AkYxCn
	 qwP4fQm+mSpYfTS48RhCOMgrxpDV/et6ohYukaIjLkwiwlCQbquyuWUYlNOVQz6+Fublt
	 H2K1+I2SZN15eERNwfBhNQZOnqYtDNwOPHYt9/2TN3XSIo8+4n1xeMPj3apsSviLPgOil
	 rqLkydJpJTAJSLHXkpyrxmq87R24z7xD8/fRJD+0pjyzfnTy12bMTpsAsCbl2AdvvR4Dv
	 fw37QaeLQBQroZ0RKr6cTQGCHK4yP7RxyjubzVsoI+/t4KnBrPCYWWKcL7JrB9nslOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSfW8FTQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5A0606A32A;
	Wed, 18 Nov 2026 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSfW8FTQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A931F000C4;
	Wed, 18 Nov 2026 18:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028297;
	bh=3yKjlZ1ltG96yOB0rjAXMiITV2wmUvV/c1NqSX/JMFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSfW8FTQXFhlvBKvcIHZIqFgqZ5aJnzL7Zt7hqC+FtoKFvChaQzbhHBCtyQwE5FIN
	 73L7gtZ9egdBf/WvqNbMLoeDDkB6ttq6NgKkzfF+Py2jqvyDXSQVpxE82M34APvraL
	 +G9oc4SAoJhdv8ZlNnac93d314ZURkY26lQLrXks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2088/2151] block/blk-iocost: Inline iocg_lock() and iocg_unlock()
Date: Wed, 18 Nov 2026 16:03:43 +0100
Message-ID: <20261118150237.766396563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit a255026594e9b7eea24c12d2bd4acae0c11eea94 ]

Both iocg_lock() and iocg_unlock() use conditional locking. Fold these
functions into their callers such that unlocking becomes unconditional.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://patch.msgid.link/f8c9867788957d2e40a32e23c6d9b866e480ad9d.1780682325.git.bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0150554a3f38 ("blk-iocost: publish hweights as one atomic value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 53 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6f9611c9314e4..11d4162bb533b 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -727,26 +727,6 @@ static void iocg_commit_bio(struct ioc_gq *iocg, struct bio *bio,
 	put_cpu_ptr(gcs);
 }
 
-static void iocg_lock(struct ioc_gq *iocg, bool lock_ioc, unsigned long *flags)
-{
-	if (lock_ioc) {
-		spin_lock_irqsave(&iocg->ioc->lock, *flags);
-		spin_lock(&iocg->waitq.lock);
-	} else {
-		spin_lock_irqsave(&iocg->waitq.lock, *flags);
-	}
-}
-
-static void iocg_unlock(struct ioc_gq *iocg, bool unlock_ioc, unsigned long *flags)
-{
-	if (unlock_ioc) {
-		spin_unlock(&iocg->waitq.lock);
-		spin_unlock_irqrestore(&iocg->ioc->lock, *flags);
-	} else {
-		spin_unlock_irqrestore(&iocg->waitq.lock, *flags);
-	}
-}
-
 #define CREATE_TRACE_POINTS
 #include <trace/events/iocost.h>
 
@@ -1589,9 +1569,17 @@ static enum hrtimer_restart iocg_waitq_timer_fn(struct hrtimer *timer)
 
 	ioc_now(iocg->ioc, &now);
 
-	iocg_lock(iocg, pay_debt, &flags);
-	iocg_kick_waitq(iocg, pay_debt, &now);
-	iocg_unlock(iocg, pay_debt, &flags);
+	if (pay_debt) {
+		spin_lock_irqsave(&iocg->ioc->lock, flags);
+		spin_lock(&iocg->waitq.lock);
+		iocg_kick_waitq(iocg, pay_debt, &now);
+		spin_unlock(&iocg->waitq.lock);
+		spin_unlock_irqrestore(&iocg->ioc->lock, flags);
+	} else {
+		spin_lock_irqsave(&iocg->waitq.lock, flags);
+		iocg_kick_waitq(iocg, pay_debt, &now);
+		spin_unlock_irqrestore(&iocg->waitq.lock, flags);
+	}
 
 	return HRTIMER_NORESTART;
 }
@@ -2740,10 +2728,21 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	use_debt = bio_issue_as_root_blkg(bio) || fatal_signal_pending(current);
 	ioc_locked = use_debt || READ_ONCE(iocg->abs_vdebt);
 retry_lock:
-	iocg_lock(iocg, ioc_locked, &flags);
-	action = iocg_handle_over_budget(rqos, iocg, bio, &now, &wait, use_debt,
-					 ioc_locked, abs_cost, cost);
-	iocg_unlock(iocg, ioc_locked, &flags);
+	if (ioc_locked) {
+		spin_lock_irqsave(&iocg->ioc->lock, flags);
+		spin_lock(&iocg->waitq.lock);
+		action = iocg_handle_over_budget(rqos, iocg, bio, &now, &wait,
+						 use_debt, ioc_locked, abs_cost,
+						 cost);
+		spin_unlock(&iocg->waitq.lock);
+		spin_unlock_irqrestore(&iocg->ioc->lock, flags);
+	} else {
+		spin_lock_irqsave(&iocg->waitq.lock, flags);
+		action = iocg_handle_over_budget(rqos, iocg, bio, &now, &wait,
+						 use_debt, ioc_locked, abs_cost,
+						 cost);
+		spin_unlock_irqrestore(&iocg->waitq.lock, flags);
+	}
 	switch (action) {
 	case action_retry:
 		ioc_locked = true;
-- 
2.53.0



