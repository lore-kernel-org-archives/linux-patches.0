Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827164;
	b=SdtotWhvsZZ6pSB0JzYAKD0BuZxbsXB+0nmPh/CuKGUrgi0IaqB/f+B+wrmTtldtDPxD
	 spe+kLwaH+q8b0FXNUIYEb5C9nBGaYScuSfeikkTAj4Q+10QPE7pQyCmmQxtdQ0EytkZs
	 IrOzG60RsgbxRMUplO2qw5cYpA7fUzi8Qy6+K4pQKLegjwloa3GWTWEkQSrPU7ukZcGn7
	 8J+mbVxWgrIkRwT63r3+ESbnsFp5iOnBszh8lcp8qbfcxJ0LJULta7U49Rdplp7sikjRz
	 6ZNIpSJKMkaGAaTkPw5oG7jVVSeSv84BYHs1niBgx5Chd6Mx6u2E5MHyxWigk490Tjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NsMo2N0zw8lwNflgfAJNcHY8WPwA0LxA8fh+v1MD+EI=;
	b=4XtQrMfSxiNmYPmtx2Mgmdeox8fEi+tUT3B7QSOnWuoSf/WVzghCrW7GpjNAbsb0N0hz
	 Th49fVlTY2QyAeqTLAKEDUpGY6m7dKizy5MNG0B3goaYbjo+oocVausSt7f9jdrncuufn
	 nUMCrSp7vkh0SKN5518utnRXV1m4vjCGew9JkHToynbi9d5gQz0wKcZRx422YRQDWUqqN
	 46kdAzx05agUIi9fg6Wqv46mOTUaQhpl8MfcETW3VdekG4Z+sRZoPFByVwzOP58lXGPC4
	 4YcNMHYouKZw6WiXBCiDYbcFori1VfdlrQWH1NKiaUXfalRsAKD0EH2e/GUtQnfK9Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgACP9OI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7E2606AB17;
	Wed,  4 Nov 2026 21:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgACP9OI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89F51F0093A;
	Wed,  4 Nov 2026 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827164;
	bh=NsMo2N0zw8lwNflgfAJNcHY8WPwA0LxA8fh+v1MD+EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VgACP9OIsDwmkuRve7z34CUrCxuxoSIh63nZhGWQJWmfp4zyWZyO7QsQvvyEMYJSD
	 rIJ6sk14k7aHSp6RHX3x2m6QXPQlKVbg3I3a4sZiboxCbXrr37u0KQqyiQ6l/TKdMc
	 0c3H1Sy7jkJDgXV5L8jSj+/zYAn7RQeNdtXsiYPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 234/547] mm/slab: sample slab_state once in kmem_cache_destroy()
Date: Wed,  4 Nov 2026 16:06:58 -0500
Message-ID: <20261104211044.810573887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

commit 088bfdc0d7947d623f4899b9011c866e4445074d upstream.

kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
has dropped slab_mutex and unlinked the cache, and for a
SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
before that test it sets slab_state to FULL but skips the unlinked cache,
which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
on a kobject that was never initialized:

  WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
  kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
  refcount_t: underflow; use-after-free.
  kobject_put+0x64/0x2c0
  sysfs_slab_release+0xc/0x20
  kmem_cache_destroy+0x104/0x1e0
  bioset_exit+0x13c/0x1e0
  disk_release+0x54/0x140
  put_disk+0x18/0x40
  floppy_async_init+0xbec/0xd10

slab_state >= FULL asks whether the cache has a kobject, which cache
creation skips while slab_state <= UP. UP is the state just below FULL,
so a false sample cannot skip a kobject_put() that was owed.

Seen on sparc64 at boot, where the asynchronous floppy init tears down
its bio slab while the late initcalls are running.

Sample slab_state once, under slab_mutex which slab_late_init() holds
when it sets FULL, and use the result for both the unlink and the
release.

The history of this problem dates back to v3.2:

  Commit 69cb8e6b7c29 ("slub: free slabs without holding locks") in
  v3.2 moved sysfs_slab_remove() outside slub_lock and introduced
  a race condition between kmem_cache_destroy() and slab_sysfs_init().

  Commit 945cf2b6199be ("mm/sl[aou]b: Extract a common function for
  kmem_cache_destroy") in v3.7 accidentally closed the race while
  extracting a common implementation for kmem_cache_destroy().

  Commit 5413dfba88d6 ("slub: drop mutex before deleting sysfs entry")
  in v3.8 re-opened the race by dropping slab_mutex around
  sysfs_slab_remove() in __kmem_cache_shutdown(), to avoid a lockdep
  splat between slab_mutex and the sysfs lock.

  Commit 657dc2f97220 ("slab: remove synchronous rcu_barrier() call in
  memcg cache release path") in v4.11 shifted from synchronous
  rcu_barrier() to asynchronous RCU work for SLAB_TYPESAFE_BY_RCU caches.
  That commit, again, accidentally closed the race by moving
  sysfs_slab_release() to shutdown_cache(), but only for
  !SLAB_TYPESAFE_BY_RCU caches because destruction of
  SLAB_TYPESAFE_BY_RCU caches is done in an RCU work.

  Commit 0495e337b703 ("mm/slab_common: Deleting kobject in
  kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock") in
  v6.0 re-introduced the race for !SLAB_TYPESAFE_BY_RCU caches.

Fixes: 69cb8e6b7c29 ("slub: free slabs without holding locks")
Fixes: 5413dfba88d6 ("slub: drop mutex before deleting sysfs entry")
Fixes: 0495e337b703 ("mm/slab_common: Deleting kobject in kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Link: https://patch.msgid.link/20261014150844.8536-1-kaloz@kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -515,10 +515,10 @@ EXPORT_SYMBOL(kmem_buckets_create);
  * and release of the kobject does not need slab_mutex or cpu_hotplug_lock
  * protection. So they are now done without holding those locks.
  */
-static void kmem_cache_release(struct kmem_cache *s)
+static void kmem_cache_release(struct kmem_cache *s, bool sysfs_ready)
 {
 	kfence_shutdown_cache(s);
-	if (__is_defined(SLAB_SUPPORTS_SYSFS) && slab_state >= FULL)
+	if (__is_defined(SLAB_SUPPORTS_SYSFS) && sysfs_ready)
 		sysfs_slab_release(s);
 	else
 		slab_kmem_cache_release(s);
@@ -533,6 +533,7 @@ void slab_kmem_cache_release(struct kmem
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	bool sysfs_ready;
 	int err;
 
 	if (unlikely(!s) || !kasan_check_byte(s))
@@ -580,10 +581,18 @@ void kmem_cache_destroy(struct kmem_cach
 
 	list_del(&s->list);
 
+	/*
+	 * slab_late_init() sets slab_state to FULL under slab_mutex and adds
+	 * sysfs entries only for caches still on the list. Sample the state
+	 * here, so that a cache unlinked before that point is not handed to
+	 * sysfs_slab_release() with an uninitialized kobject.
+	 */
+	sysfs_ready = slab_state >= FULL;
+
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
 
-	if (slab_state >= FULL)
+	if (sysfs_ready)
 		sysfs_slab_unlink(s);
 	debugfs_slab_release(s);
 
@@ -593,7 +602,7 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->flags & SLAB_TYPESAFE_BY_RCU)
 		rcu_barrier();
 
-	kmem_cache_release(s);
+	kmem_cache_release(s, sysfs_ready);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 


