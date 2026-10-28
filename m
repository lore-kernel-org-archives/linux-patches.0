Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212405;
	b=ss5TXjEUxlqbVFHbA96s0DW2P/JQNpnIdvv+EDPzNNgtuz4X9RL3eCt2zFIULYNaDutH
	 q3T3FrUrW1+mYQFjWsB4ldfCSB2Sfa282k4rBujMu8r6L2LBFsovcdUBvWmWBLawUhGw/
	 Q1XXxYV8o4QLUpWgUo0njFPi1EXoDf6e/aOF5B+vtz8Wa1MWruy+KZ/O0gbZfpkXdm1qL
	 tdlt7+PrFaJG812V5x2mDXIYWDL5jzQFkmAEpNfkWOqxlg7KwGLaMPLgya9/702OoP/ic
	 ZmuMXQnYL6sQoNeAuopfNNkL0l7OtqHhdkQINlkYRATJGB6Eae6UiXSbmzXcNWttntA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YRHU3R/iFHqENP/5s/lWNy+VMuLhRKuT11xRtt5y5fo=;
	b=SXO9aCUa6JwIjI2GUJAMbW5G6y+yNqwC8kG4Vlwhz275LTD7dVnFs2PYh3NEYoZe8P01
	 apfqODpOBFl81xn3/zH5GFzXthKcRMVf745SFZhh1flvLBEPlgSE54mR9tR6Kj/EUsnnd
	 lFDp0KtnvAazaEU7NXmWIlso9Eyw7z6AnN9Ya2tFURYezlv5gpB0D5c1RYGN8bB/Sv6Ue
	 t7ZHbTZv5pCn42tSw5LkLQYtLCKnVdZcpNA+gIDhBJru7VjpbdNSZsEmOl2++287Up8uV
	 9qnUmw1ZlduxNVc+dFp9ZK7p98Nt0oE2aoC8xw/lgFCXzc3RKm9o6UqX59cUDEyffug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AldO+RRe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9A2606A329;
	Wed, 28 Oct 2026 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AldO+RRe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254951F031E3;
	Wed, 28 Oct 2026 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212404;
	bh=YRHU3R/iFHqENP/5s/lWNy+VMuLhRKuT11xRtt5y5fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AldO+RReIQV+J3W8bkxa6ydKnoBQOJgEYGxjLjjqzxDcULHowa61GH5FGYZHrqk9g
	 N0XRhb96cin/5GgoaRODmWLUaSPG6SN9TruBr6Bzxl0N2ShyVcy4Sz9wSpnU3a1CiW
	 1LJyR02CqHbeU5Yzp6gXRF5z+u0P+edXpP2DAiwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0141/1887] mm/kmemleak: simplify kmemleak_cond_resched() usage
Date: Wed, 28 Oct 2026 17:37:17 +0100
Message-ID: <20261028170502.443467623@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6061e740822530a4ef443548b19c4e0bc6342c7a ]

Patch series "mm/kmemleak: Simplify kmemleak_cond_resched() & fix UAF", v2.

It was found that a KASAN use-after-free error was reported in the
kmemleak_scan() function.  After further examination, it is believe that
even though a reference is taken from the current object, it does not
prevent the object pointed to by the next pointer from going away after a
cond_resched().

To fix that, additional flags are added to make sure that the current
object won't be removed from the object_list during the duration of the
cond_resched() to ensure the validity of the next pointer.

While making the change, I also simplify the current usage of
kmemleak_cond_resched() to make it easier to understand.

This patch (of 2):

The presence of a pinned argument and the 64k loop count make
kmemleak_cond_resched() a bit more complex to read.  The pinned argument
is used only by first kmemleak_scan() loop.

Simplify the usage of kmemleak_cond_resched() by removing the pinned
argument and always do a get_object()/put_object() sequence.  In addition,
the 64k loop is removed by using need_resched() to decide if
kmemleak_cond_resched() should be called.

Link: https://lkml.kernel.org/r/20230119040111.350923-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20230119040111.350923-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 48 ++++++++++++------------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d3c9a63d7a9d5..fa01854e32b09 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1466,22 +1466,17 @@ static void scan_gray_list(void)
 /*
  * Conditionally call resched() in a object iteration loop while making sure
  * that the given object won't go away without RCU read lock by performing a
- * get_object() if !pinned.
- *
- * Return: false if can't do a cond_resched() due to get_object() failure
- *	   true otherwise
+ * get_object() if necessaary.
  */
-static bool kmemleak_cond_resched(struct kmemleak_object *object, bool pinned)
+static void kmemleak_cond_resched(struct kmemleak_object *object)
 {
-	if (!pinned && !get_object(object))
-		return false;
+	if (!get_object(object))
+		return;	/* Try next object */
 
 	rcu_read_unlock();
 	cond_resched();
 	rcu_read_lock();
-	if (!pinned)
-		put_object(object);
-	return true;
+	put_object(object);
 }
 
 /*
@@ -1495,15 +1490,12 @@ static void kmemleak_scan(void)
 	struct zone *zone;
 	int __maybe_unused i;
 	int new_leaks = 0;
-	int loop_cnt = 0;
 
 	jiffies_last_scan = jiffies;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		bool obj_pinned = false;
-
 		raw_spin_lock_irq(&object->lock);
 #ifdef DEBUG
 		/*
@@ -1529,19 +1521,13 @@ static void kmemleak_scan(void)
 
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
-		if (color_gray(object) && get_object(object)) {
+		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
-			obj_pinned = true;
-		}
 
 		raw_spin_unlock_irq(&object->lock);
 
-		/*
-		 * Do a cond_resched() every 64k objects to avoid soft lockup.
-		 */
-		if (!(++loop_cnt & 0xffff) &&
-		    !kmemleak_cond_resched(object, obj_pinned))
-			loop_cnt--; /* Try again on next object */
+		if (need_resched())
+			kmemleak_cond_resched(object);
 	}
 	rcu_read_unlock();
 
@@ -1608,14 +1594,9 @@ static void kmemleak_scan(void)
 	 * scan and color them gray until the next scan.
 	 */
 	rcu_read_lock();
-	loop_cnt = 0;
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		/*
-		 * Do a cond_resched() every 64k objects to avoid soft lockup.
-		 */
-		if (!(++loop_cnt & 0xffff) &&
-		    !kmemleak_cond_resched(object, false))
-			loop_cnt--;	/* Try again on next object */
+		if (need_resched())
+			kmemleak_cond_resched(object);
 
 		/*
 		 * This is racy but we can save the overhead of lock/unlock
@@ -1650,14 +1631,9 @@ static void kmemleak_scan(void)
 	 * Scanning result reporting.
 	 */
 	rcu_read_lock();
-	loop_cnt = 0;
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		/*
-		 * Do a cond_resched() every 64k objects to avoid soft lockup.
-		 */
-		if (!(++loop_cnt & 0xffff) &&
-		    !kmemleak_cond_resched(object, false))
-			loop_cnt--;	/* Try again on next object */
+		if (need_resched())
+			kmemleak_cond_resched(object);
 
 		/*
 		 * This is racy but we can save the overhead of lock/unlock
-- 
2.53.0



