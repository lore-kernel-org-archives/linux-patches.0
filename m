Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031797;
	b=r11INJLXwemARWZR4/lA1NaUbe8x9JDkSFJx/uew0lRaQHZDxmIE167arxu+iUaFCQVx
	 XqPiEikW3kSK96OlGpFLMohvCBs08g25ATkr4iGbskwF41npENKRuzek7R36Ie1mk8jBe
	 C8ORGFwYTkPxN/LMsQYJGZ+PSnARybrbwe4J46rOftAOSrRMimI/qgPdW7P628ritA8Mp
	 cEREa1bCae6zYU9PKRHKrtSkiA064TbxuAYpc88yq+Z/OROrIevv8VDf0YE3dUJOT9o17
	 N3RTx5h6l3ydJIXT/5AY67jCS0xfy2E+10dZ+T0qF+JN62NlInBeAgljgA143YrzlDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dFVihI9OOahQGJaf4toG79HYa6f8TK4q8d3/Xxih3bA=;
	b=3Uyubw9SJjy+LGC79Ia8VnzOuh9gCxW5tWrlYXJyN8/5P0XenJSMKN+hMYQW53+nteWG
	 d5cFmdisQ2sjjhH2LrrzTmueyLXd1KghL9T4vrlTijntDn2gecvr0X+7zegMVQDE6KFyl
	 VKMD8M6UL4qASkcmXYReRjSIlcUhsQ5RlrwP8sK6VkG280IXH4LOTl5boma1vBs0YpyAh
	 29Ll7DWA4rIfaHNclgvezXcBaJi1BUqoCQp3FtbyEhwWu7RAqh5a478VI88GmDbXL5U9f
	 EfsDdVViodEI+Jpdyhnl3JTifgi7bmWYXI4Q8haOjiOyskOm6vi1NICLUNhmXlJR58Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4sgvyQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC214606A325;
	Wed, 18 Nov 2026 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4sgvyQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AC11F000C4;
	Wed, 18 Nov 2026 19:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031797;
	bh=dFVihI9OOahQGJaf4toG79HYa6f8TK4q8d3/Xxih3bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4sgvyQLseNl1osZU+HrthIz37+1l7PYeMEPzwAKdsS2xaKKK6bCYPIT5380lOWrG
	 GnEbt2d/Bvq6CQYusPrJdKY7oukkfSStOSGEYCJhKBz26uhAd/k3y/U6yzYYqX46N5
	 my7G46ZpoBYfCF+XUIUQhQaczJqOIysLt2MDE1nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1184/1756] mm, slab: add kerneldocs for common SLAB_ flags
Date: Wed, 18 Nov 2026 15:55:11 +0100
Message-ID: <20261118150057.040490094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit b6da940130579769a42605b2c7f529b6f14ef1f8 ]

We have many SLAB_ flags but many are used only internally, by kunit
tests or debugging subsystems cooperating with slab, or are set
according to slab_debug boot parameter.

Create kerneldocs for the commonly used flags that may be passed to
kmem_cache_create(). SLAB_TYPESAFE_BY_RCU already had a detailed
description, so turn it to a kerneldoc. Add some details for
SLAB_ACCOUNT, SLAB_RECLAIM_ACCOUNT and SLAB_HWCACHE_ALIGN. Reference
them from the __kmem_cache_create_args() kerneldoc.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: 655668f0caf3 ("mm/slab: Mark the kmem_buckets_create() context as a Context: section")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/slab.h | 62 ++++++++++++++++++++++++++++++--------------
 mm/slab_common.c     | 14 +++++++++-
 2 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7b58cc1844303..e21a6fb06e9f0 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -78,7 +78,17 @@ enum _slab_flag_bits {
 #define SLAB_POISON		__SLAB_FLAG_BIT(_SLAB_POISON)
 /* Indicate a kmalloc slab */
 #define SLAB_KMALLOC		__SLAB_FLAG_BIT(_SLAB_KMALLOC)
-/* Align objs on cache lines */
+/**
+ * define SLAB_HWCACHE_ALIGN - Align objects on cache line boundaries.
+ *
+ * Sufficiently large objects are aligned on cache line boundary. For object
+ * size smaller than a half of cache line size, the alignment is on the half of
+ * cache line size. In general, if object size is smaller than 1/2^n of cache
+ * line size, the alignment is adjusted to 1/2^n.
+ *
+ * If explicit alignment is also requested by the respective
+ * &struct kmem_cache_args field, the greater of both is alignments is applied.
+ */
 #define SLAB_HWCACHE_ALIGN	__SLAB_FLAG_BIT(_SLAB_HWCACHE_ALIGN)
 /* Use GFP_DMA memory */
 #define SLAB_CACHE_DMA		__SLAB_FLAG_BIT(_SLAB_CACHE_DMA)
@@ -88,8 +98,8 @@ enum _slab_flag_bits {
 #define SLAB_STORE_USER		__SLAB_FLAG_BIT(_SLAB_STORE_USER)
 /* Panic if kmem_cache_create() fails */
 #define SLAB_PANIC		__SLAB_FLAG_BIT(_SLAB_PANIC)
-/*
- * SLAB_TYPESAFE_BY_RCU - **WARNING** READ THIS!
+/**
+ * define SLAB_TYPESAFE_BY_RCU - **WARNING** READ THIS!
  *
  * This delays freeing the SLAB page by a grace period, it does _NOT_
  * delay object freeing. This means that if you do kmem_cache_free()
@@ -100,20 +110,22 @@ enum _slab_flag_bits {
  * stays valid, the trick to using this is relying on an independent
  * object validation pass. Something like:
  *
- * begin:
- *  rcu_read_lock();
- *  obj = lockless_lookup(key);
- *  if (obj) {
- *    if (!try_get_ref(obj)) // might fail for free objects
- *      rcu_read_unlock();
- *      goto begin;
- *
- *    if (obj->key != key) { // not the object we expected
- *      put_ref(obj);
- *      rcu_read_unlock();
- *      goto begin;
- *    }
- *  }
+ * ::
+ *
+ *  begin:
+ *   rcu_read_lock();
+ *   obj = lockless_lookup(key);
+ *   if (obj) {
+ *     if (!try_get_ref(obj)) // might fail for free objects
+ *       rcu_read_unlock();
+ *       goto begin;
+ *
+ *     if (obj->key != key) { // not the object we expected
+ *       put_ref(obj);
+ *       rcu_read_unlock();
+ *       goto begin;
+ *     }
+ *   }
  *  rcu_read_unlock();
  *
  * This is useful if we need to approach a kernel structure obliquely,
@@ -147,7 +159,6 @@ enum _slab_flag_bits {
  *
  * Note that SLAB_TYPESAFE_BY_RCU was originally named SLAB_DESTROY_BY_RCU.
  */
-/* Defer freeing slabs to RCU */
 #define SLAB_TYPESAFE_BY_RCU	__SLAB_FLAG_BIT(_SLAB_TYPESAFE_BY_RCU)
 /* Trace allocations and frees */
 #define SLAB_TRACE		__SLAB_FLAG_BIT(_SLAB_TRACE)
@@ -180,7 +191,12 @@ enum _slab_flag_bits {
 #else
 # define SLAB_FAILSLAB		__SLAB_FLAG_UNUSED
 #endif
-/* Account to memcg */
+/**
+ * define SLAB_ACCOUNT - Account allocations to memcg.
+ *
+ * All object allocations from this cache will be memcg accounted, regardless of
+ * __GFP_ACCOUNT being or not being passed to individual allocations.
+ */
 #ifdef CONFIG_MEMCG
 # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
 #else
@@ -207,7 +223,13 @@ enum _slab_flag_bits {
 #endif
 
 /* The following flags affect the page allocator grouping pages by mobility */
-/* Objects are reclaimable */
+/**
+ * define SLAB_RECLAIM_ACCOUNT - Objects are reclaimable.
+ *
+ * Use this flag for caches that have an associated shrinker. As a result, slab
+ * pages are allocated with __GFP_RECLAIMABLE, which affects grouping pages by
+ * mobility, and are accounted in SReclaimable counter in /proc/meminfo
+ */
 #ifndef CONFIG_SLUB_TINY
 #define SLAB_RECLAIM_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_RECLAIM_ACCOUNT)
 #else
diff --git a/mm/slab_common.c b/mm/slab_common.c
index f8e81c1602d98..88f1c07fa13ff 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -285,11 +285,23 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * @object_size: The size of objects to be created in this cache.
  * @args: Additional arguments for the cache creation (see
  *        &struct kmem_cache_args).
- * @flags: See %SLAB_* flags for an explanation of individual @flags.
+ * @flags: See the desriptions of individual flags. The common ones are listed
+ *         in the description below.
  *
  * Not to be called directly, use the kmem_cache_create() wrapper with the same
  * parameters.
  *
+ * Commonly used @flags:
+ *
+ * &SLAB_ACCOUNT - Account allocations to memcg.
+ *
+ * &SLAB_HWCACHE_ALIGN - Align objects on cache line boundaries.
+ *
+ * &SLAB_RECLAIM_ACCOUNT - Objects are reclaimable.
+ *
+ * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
+ * by a grace period - see the full description before using.
+ *
  * Context: Cannot be called within a interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
-- 
2.53.0



