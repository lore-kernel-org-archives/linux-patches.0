Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AF03A5E7D;
	Sat, 17 Oct 2026 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258612; cv=none; b=knLCXDvSZr7UNAvrFpSfQSVa2t0t15jH6O3WIaQy9k4bFWHrC1YMmfP3oKFHYTZHl9/t2MeF1hQGR4SgTcaALC0jJBAGDpXjDEeaghq0PFFlBMtJbxar6kvSiJubeeqirpsqDcrkcgdFOyHcaI7moUlO/hHoWgPmzIclQXZKsT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258612; c=relaxed/simple;
	bh=fUpDSqWDytLPcl/FcCFNAX7D/mTdxojuO8j7WLjH+0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dng+cs8ugYv7YvfqFBlI7MwnZMqoliiXmZQaX/uJRm2lIgjMcG7sJUFV2edp97f7Qdfgw09ENjbVk3k3YIHNRNPMzzaUUcQ2LiNcFKRoeJqYNmOqKFQB0T5I+tmdDp0JnZYktphFB+sbYqlg31YQXSsLlkI605Bzd3grpZdvzWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTK1SYps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTK1SYps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04091F000C4;
	Sat, 17 Oct 2026 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258611;
	bh=dcU0A4RniKOJd1VB+6hcMXNTey417rBhCQL6Zc7ln3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTK1SYpscGHYImHJ4NQSowPr6S9USQGU/pg0DMm7KW1DrGzkcxF930Q4DCqlUY9uP
	 EOm2nQfv7xIdqZDtd/sOqCpBjuxczHSGmuZoQiCButYmiaBNfF2mopNg9h9F8+kJh1
	 oVdGIjZC7PV0BN8qo35UIVUWyoDHLTIV/p7Hx1JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0943/1674] mm: list_lru: Update kernel documentation to follow the requirements
Date: Sat, 17 Oct 2026 17:53:35 +0200
Message-ID: <20261017160455.339919347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7679e14098c9c3c8118a7130d6e1e9cfe2565c04 ]

kernel-doc is not happy about documentation in list_lru.h:

list_lru.h:90: warning: Function parameter or member 'lru' not described in 'list_lru_add'
list_lru.h:90: warning: Excess function parameter 'list_lru' description in 'list_lru_add'
list_lru.h:90: warning: No description found for return value of 'list_lru_add'
list_lru.h:103: warning: Function parameter or member 'lru' not described in 'list_lru_del'
list_lru.h:103: warning: Excess function parameter 'list_lru' description in 'list_lru_del'
list_lru.h:103: warning: No description found for return value of 'list_lru_del'
list_lru.h:116: warning: No description found for return value of 'list_lru_count_one'
list_lru.h:168: warning: No description found for return value of 'list_lru_walk_one'
list_lru.h:185: warning: No description found for return value of 'list_lru_walk_one_irq'

Fix the documentation accordingly.

While at it, fix the references to the parameters in functions
inside the long descriptions, on which the above script is not
complaining (yet?).

Link: https://lkml.kernel.org/r/20231123172320.2434780-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 22150a7d401d ("gfs2: Fix slab-use-after-free in qd_put")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/list_lru.h | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index b35968ee9fb50..db86ad78d428a 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -73,7 +73,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 
 /**
  * list_lru_add: add an element to the lru list's tail
- * @list_lru: the lru pointer
+ * @lru: the lru pointer
  * @item: the item to be added.
  *
  * If the element is already part of a list, this function returns doing
@@ -83,22 +83,22 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
  * the caller organize itself in a way that elements can be in more than
  * one type of list, it is up to the caller to fully remove the item from
  * the previous list (with list_lru_del() for instance) before moving it
- * to @list_lru
+ * to @lru.
  *
- * Return value: true if the list was updated, false otherwise
+ * Return: true if the list was updated, false otherwise
  */
 bool list_lru_add(struct list_lru *lru, struct list_head *item);
 
 /**
  * list_lru_del: delete an element to the lru list
- * @list_lru: the lru pointer
+ * @lru: the lru pointer
  * @item: the item to be deleted.
  *
- * This function works analogously as list_lru_add in terms of list
+ * This function works analogously as list_lru_add() in terms of list
  * manipulation. The comments about an element already pertaining to
- * a list are also valid for list_lru_del.
+ * a list are also valid for list_lru_del().
  *
- * Return value: true if the list was updated, false otherwise
+ * Return: true if the list was updated, false otherwise
  */
 bool list_lru_del(struct list_lru *lru, struct list_head *item);
 
@@ -108,9 +108,11 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item);
  * @nid: the node id to count from.
  * @memcg: the cgroup to count from.
  *
- * Always return a non-negative number, 0 for empty lists. There is no
- * guarantee that the list is not updated while the count is being computed.
- * Callers that want such a guarantee need to provide an outer lock.
+ * There is no guarantee that the list is not updated while the count is being
+ * computed. Callers that want such a guarantee need to provide an outer lock.
+ *
+ * Return: 0 for empty lists, otherwise the number of objects
+ * currently held by @lru.
  */
 unsigned long list_lru_count_one(struct list_lru *lru,
 				 int nid, struct mem_cgroup *memcg);
@@ -141,7 +143,7 @@ typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
 		struct list_lru_one *list, spinlock_t *lock, void *cb_arg);
 
 /**
- * list_lru_walk_one: walk a list_lru, isolating and disposing freeable items.
+ * list_lru_walk_one: walk a @lru, isolating and disposing freeable items.
  * @lru: the lru pointer.
  * @nid: the node id to scan from.
  * @memcg: the cgroup to scan from.
@@ -150,24 +152,24 @@ typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
  * @cb_arg: opaque type that will be passed to @isolate
  * @nr_to_walk: how many items to scan.
  *
- * This function will scan all elements in a particular list_lru, calling the
+ * This function will scan all elements in a particular @lru, calling the
  * @isolate callback for each of those items, along with the current list
  * spinlock and a caller-provided opaque. The @isolate callback can choose to
  * drop the lock internally, but *must* return with the lock held. The callback
- * will return an enum lru_status telling the list_lru infrastructure what to
+ * will return an enum lru_status telling the @lru infrastructure what to
  * do with the object being scanned.
  *
- * Please note that nr_to_walk does not mean how many objects will be freed,
+ * Please note that @nr_to_walk does not mean how many objects will be freed,
  * just how many objects will be scanned.
  *
- * Return value: the number of objects effectively removed from the LRU.
+ * Return: the number of objects effectively removed from the LRU.
  */
 unsigned long list_lru_walk_one(struct list_lru *lru,
 				int nid, struct mem_cgroup *memcg,
 				list_lru_walk_cb isolate, void *cb_arg,
 				unsigned long *nr_to_walk);
 /**
- * list_lru_walk_one_irq: walk a list_lru, isolating and disposing freeable items.
+ * list_lru_walk_one_irq: walk a @lru, isolating and disposing freeable items.
  * @lru: the lru pointer.
  * @nid: the node id to scan from.
  * @memcg: the cgroup to scan from.
@@ -176,7 +178,7 @@ unsigned long list_lru_walk_one(struct list_lru *lru,
  * @cb_arg: opaque type that will be passed to @isolate
  * @nr_to_walk: how many items to scan.
  *
- * Same as @list_lru_walk_one except that the spinlock is acquired with
+ * Same as list_lru_walk_one() except that the spinlock is acquired with
  * spin_lock_irq().
  */
 unsigned long list_lru_walk_one_irq(struct list_lru *lru,
-- 
2.53.0



