Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF71CBE89
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530609; cv=none; b=gEagIlJSdHUKyrsdFz57NvH09qFagH0KQ5NSTjoSrcPNnUHiGoOTfTWdEN1iNcGm8GFoaWQFs9pobHygowcXricGq+RVYFkjOQWx7DF/oqcGILzNMHsifWdlbF7LH0rILwPqvYeGR9Oa7TFLfWYCBxYqczhmRsObGkyFB76HSEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530609; c=relaxed/simple;
	bh=EgxByLbqMuyVq+wsrIwXYH52ePf7l1ykLcKjgCJd7fk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=koVHOMead6mytlsoWK+fYeYwFtSOeWGuT87pgf9Hv21vj5WuNUy1Pm/rwc9qmo7agUYh8m1pu4tdBqb7cikQrwMKAWef0UFvXU4melKmAxRiRxqEcK/XH6GiYPyQDDOrBIAykIBLga7OPpBBtAcJ88MUXUtG629TqxuxVREvNvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WyymfIv4; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WyymfIv4"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e29716957d9so8412732276.1
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 10:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729530606; x=1730135406; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KW8xVNW7kAHLKAdfvzj4axh/ytWTysYE+wy9p2w6gm4=;
        b=WyymfIv4q4G5p21IA9D2xg6EAlqIRdtBc/zNkywXayjS3gSkaGlWIuimO6864Y5KAX
         95qhAuAtA4G8wL73VYE6PVjZgDBVEHnsv/W9vQUJX9/os3SGrrEOJnEva9WBVr2WkI+X
         C9GJTHep2jRdJ9SnvFUwrrqyFtHAb1kMCYWW+drYE6Lq5F+UXo9BH7jMiT0uBeg5A78K
         xeUX8yEzfw5ws5Ak1KvtIoKmLdLke5Hkhn2PamsTgamyop1IEZQbxtUuV6HzPvoC3j2p
         moleyGeDPvbHPguM5eYdFP4thZGYjr2sfq1UKVtIXs+S1ll30E4L9beex6fvhtvJ9fNs
         Q9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729530606; x=1730135406;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KW8xVNW7kAHLKAdfvzj4axh/ytWTysYE+wy9p2w6gm4=;
        b=bM6V7jGVD1VlOc+sWQ1uex3Jj3KhRRBkdYYEJj2r97J+CKo7ciXrp6Ef3LSjD4lXre
         z0pl6ozB1bNlFiF8gbYmSqPzhslYZmcXr+HOYLSiQJ6DEI45OGrYP+QxhGSc9tCxU2EF
         mKuIRf9vQUm+6txlfpfkrrSGVZQKEgfEofkpdp9lTycNI5uKZ78OD0d15bD96qCnNo06
         SQMKiKic3K/V0iqUQobPqkxK9WNzHWsr0uwK2+4ODvhaHVlwEAjUDzLPQHJuVW1/bLx3
         yws1KLZUXRwdCIIVgGlfx9Jr9Ze9/Z4rCZKCOGwMyhb4xpPrTAdpjtk6RHux1PN1yUaA
         uEhw==
X-Forwarded-Encrypted: i=1; AJvYcCVhaHdvLbRvDVZuLj9J/a5jCQ9QjKzOi6tT2du1qfv7wpXT1mDvdrER+/y2Pwn2IbNps7usMYkX@lists.linux.dev
X-Gm-Message-State: AOJu0YzrSLX0AeHOeRKwWdAXy9shWrhjtliEthrTlhDK9CgpLk5nuxFd
	+A5/AZV/ifiyUnHUB0OaGNedQjY22o4OBQR547eHycOYgzl3plLs4O+Qq0b+XyImwXhG0AHWd5S
	wQQ==
X-Google-Smtp-Source: AGHT+IHFDt81jPcPeIVKlm6JLoSlE7G+Zs5Md8NJw339+HdffO+tG2R8vi5CkfIVuwkpe6wI38+cZC1BM54=
X-Received: from surenb-desktop.mtv.corp.google.com ([2a00:79e0:2e3f:8:cfa8:1167:32cd:5d81])
 (user=surenb job=sendgmr) by 2002:a25:868a:0:b0:e24:9f58:dd17 with SMTP id
 3f1490d57ef6-e2bb11aae47mr15746276.1.1729530606487; Mon, 21 Oct 2024 10:10:06
 -0700 (PDT)
Date: Mon, 21 Oct 2024 10:10:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241021171003.2907935-1-surenb@google.com>
Subject: [PATCH 6.11.y 1/2] rcu/kvfree: Add kvfree_rcu_barrier() API
From: Suren Baghdasaryan <surenb@google.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com, vbabka@suse.cz, 
	greearb@candelatech.com, kent.overstreet@linux.dev, surenb@google.com, 
	stable@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

From: Uladzislau Rezki <urezki@gmail.com>

commit 3c5d61ae919cc377c71118ccc76fa6e8518023f8 upstream.

Add a kvfree_rcu_barrier() function. It waits until all
in-flight pointers are freed over RCU machinery. It does
not wait any GP completion and it is within its right to
return immediately if there are no outstanding pointers.

This function is useful when there is a need to guarantee
that a memory is fully freed before destroying memory caches.
For example, during unloading a kernel module.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/rcutiny.h |   5 ++
 include/linux/rcutree.h |   1 +
 kernel/rcu/tree.c       | 109 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index d9ac7b136aea..522123050ff8 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -111,6 +111,11 @@ static inline void __kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	kvfree(ptr);
 }
 
+static inline void kvfree_rcu_barrier(void)
+{
+	rcu_barrier();
+}
+
 #ifdef CONFIG_KASAN_GENERIC
 void kvfree_call_rcu(struct rcu_head *head, void *ptr);
 #else
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 254244202ea9..58e7db80f3a8 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,6 +35,7 @@ static inline void rcu_virt_note_context_switch(void)
 
 void synchronize_rcu_expedited(void);
 void kvfree_call_rcu(struct rcu_head *head, void *ptr);
+void kvfree_rcu_barrier(void);
 
 void rcu_barrier(void);
 void rcu_momentary_dyntick_idle(void);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e641cc681901..be00aac5f4e7 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3584,18 +3584,15 @@ kvfree_rcu_drain_ready(struct kfree_rcu_cpu *krcp)
 }
 
 /*
- * This function is invoked after the KFREE_DRAIN_JIFFIES timeout.
+ * Return: %true if a work is queued, %false otherwise.
  */
-static void kfree_rcu_monitor(struct work_struct *work)
+static bool
+kvfree_rcu_queue_batch(struct kfree_rcu_cpu *krcp)
 {
-	struct kfree_rcu_cpu *krcp = container_of(work,
-		struct kfree_rcu_cpu, monitor_work.work);
 	unsigned long flags;
+	bool queued = false;
 	int i, j;
 
-	// Drain ready for reclaim.
-	kvfree_rcu_drain_ready(krcp);
-
 	raw_spin_lock_irqsave(&krcp->lock, flags);
 
 	// Attempt to start a new batch.
@@ -3634,11 +3631,27 @@ static void kfree_rcu_monitor(struct work_struct *work)
 			// be that the work is in the pending state when
 			// channels have been detached following by each
 			// other.
-			queue_rcu_work(system_wq, &krwp->rcu_work);
+			queued = queue_rcu_work(system_wq, &krwp->rcu_work);
 		}
 	}
 
 	raw_spin_unlock_irqrestore(&krcp->lock, flags);
+	return queued;
+}
+
+/*
+ * This function is invoked after the KFREE_DRAIN_JIFFIES timeout.
+ */
+static void kfree_rcu_monitor(struct work_struct *work)
+{
+	struct kfree_rcu_cpu *krcp = container_of(work,
+		struct kfree_rcu_cpu, monitor_work.work);
+
+	// Drain ready for reclaim.
+	kvfree_rcu_drain_ready(krcp);
+
+	// Queue a batch for a rest.
+	kvfree_rcu_queue_batch(krcp);
 
 	// If there is nothing to detach, it means that our job is
 	// successfully done here. In case of having at least one
@@ -3859,6 +3872,86 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 }
 EXPORT_SYMBOL_GPL(kvfree_call_rcu);
 
+/**
+ * kvfree_rcu_barrier - Wait until all in-flight kvfree_rcu() complete.
+ *
+ * Note that a single argument of kvfree_rcu() call has a slow path that
+ * triggers synchronize_rcu() following by freeing a pointer. It is done
+ * before the return from the function. Therefore for any single-argument
+ * call that will result in a kfree() to a cache that is to be destroyed
+ * during module exit, it is developer's responsibility to ensure that all
+ * such calls have returned before the call to kmem_cache_destroy().
+ */
+void kvfree_rcu_barrier(void)
+{
+	struct kfree_rcu_cpu_work *krwp;
+	struct kfree_rcu_cpu *krcp;
+	bool queued;
+	int i, cpu;
+
+	/*
+	 * Firstly we detach objects and queue them over an RCU-batch
+	 * for all CPUs. Finally queued works are flushed for each CPU.
+	 *
+	 * Please note. If there are outstanding batches for a particular
+	 * CPU, those have to be finished first following by queuing a new.
+	 */
+	for_each_possible_cpu(cpu) {
+		krcp = per_cpu_ptr(&krc, cpu);
+
+		/*
+		 * Check if this CPU has any objects which have been queued for a
+		 * new GP completion. If not(means nothing to detach), we are done
+		 * with it. If any batch is pending/running for this "krcp", below
+		 * per-cpu flush_rcu_work() waits its completion(see last step).
+		 */
+		if (!need_offload_krc(krcp))
+			continue;
+
+		while (1) {
+			/*
+			 * If we are not able to queue a new RCU work it means:
+			 * - batches for this CPU are still in flight which should
+			 *   be flushed first and then repeat;
+			 * - no objects to detach, because of concurrency.
+			 */
+			queued = kvfree_rcu_queue_batch(krcp);
+
+			/*
+			 * Bail out, if there is no need to offload this "krcp"
+			 * anymore. As noted earlier it can run concurrently.
+			 */
+			if (queued || !need_offload_krc(krcp))
+				break;
+
+			/* There are ongoing batches. */
+			for (i = 0; i < KFREE_N_BATCHES; i++) {
+				krwp = &(krcp->krw_arr[i]);
+				flush_rcu_work(&krwp->rcu_work);
+			}
+		}
+	}
+
+	/*
+	 * Now we guarantee that all objects are flushed.
+	 */
+	for_each_possible_cpu(cpu) {
+		krcp = per_cpu_ptr(&krc, cpu);
+
+		/*
+		 * A monitor work can drain ready to reclaim objects
+		 * directly. Wait its completion if running or pending.
+		 */
+		cancel_delayed_work_sync(&krcp->monitor_work);
+
+		for (i = 0; i < KFREE_N_BATCHES; i++) {
+			krwp = &(krcp->krw_arr[i]);
+			flush_rcu_work(&krwp->rcu_work);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
+
 static unsigned long
 kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {

base-commit: 17365d66f1c6aa6bf4f4cb9842f5edeac027bcfb
-- 
2.47.0.105.g07ac214952-goog

