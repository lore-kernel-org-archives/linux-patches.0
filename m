Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D462F49
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 10:32:19 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0A9B920658;
	Fri, 10 Mar 2023 10:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678444336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0XRtKZ/CBnBdFwvCLJ4UaehJA7uc5hjJpqNCel0wLs=;
	b=ny6yHHgxBFiJbE3G6TRbuILZouc1FfvSrZIoIEn8Em8pxQKwBpTC/0Qle6cFe4FXhysYz0
	NMbFaFWjtUXlnAK/ccshrkhJGiBFdHDuievEiUw86Gbdf2AFa3ZsMybWtSlZHH8oy6Sp9i
	ZpGBiiSbCNgZ8F9agBUQAkhYLWCxENQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678444336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0XRtKZ/CBnBdFwvCLJ4UaehJA7uc5hjJpqNCel0wLs=;
	b=c9nJ0FccGPUvt1DKTqxoLPfWREATBKJgPjNehuttmFBezZCtQpnvtyFJ63HgnPkQ7+m1up
	9RsCY1fVGVJsrCAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B11A6139F9;
	Fri, 10 Mar 2023 10:32:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id aCmUKi8HC2SsXQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 10 Mar 2023 10:32:15 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 7/7] mm/slab: document kfree() as allowed for kmem_cache_alloc() objects
Date: Fri, 10 Mar 2023 11:32:09 +0100
Message-Id: <20230310103210.22372-8-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to free objects in situations when they can
come from either kmalloc() or kmem_cache_alloc(), and also allow
kfree_rcu() for freeing objects from kmem_cache_alloc().

For the SLAB and SLUB allocators this was always possible so with SLOB
gone, we can document it as supported.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
---
 Documentation/core-api/memory-allocation.rst | 15 +++++++++++----
 include/linux/rcupdate.h                     |  6 ++++--
 mm/slab_common.c                             |  5 +----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 5954ddf6ee13..f9e8d352ed67 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -170,7 +170,14 @@ should be used if a part of the cache might be copied to the userspace.
 After the cache is created kmem_cache_alloc() and its convenience
 wrappers can allocate memory from that cache.
 
-When the allocated memory is no longer needed it must be freed. You can
-use kvfree() for the memory allocated with `kmalloc`, `vmalloc` and
-`kvmalloc`. The slab caches should be freed with kmem_cache_free(). And
-don't forget to destroy the cache with kmem_cache_destroy().
+When the allocated memory is no longer needed it must be freed. Objects
+allocated by `kmalloc` can be freed by `kfree` or `kvfree`.
+Objects allocated by `kmem_cache_alloc` can be freed with `kmem_cache_free`
+or also by `kfree` or `kvfree`, which can be more convenient as it does
+not require the kmem_cache pointed.
+The rules for _bulk and _rcu flavors of freeing functions are analogical.
+
+Memory allocated by `vmalloc` can be freed with `vfree` or `kvfree`.
+Memory allocated by `kvmalloc` can be freed with `kvfree`.
+Caches created by `kmem_cache_create` should be freed with
+`kmem_cache_destroy` only after freeing all the allocated objects first.
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 094321c17e48..dcd2cf1e8326 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -976,8 +976,10 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * either fall back to use of call_rcu() or rearrange the structure to
  * position the rcu_head structure into the first 4096 bytes.
  *
- * Note that the allowable offset might decrease in the future, for example,
- * to allow something like kmem_cache_free_rcu().
+ * The object to be freed can be allocated either by kmalloc() or
+ * kmem_cache_alloc().
+ *
+ * Note that the allowable offset might decrease in the future.
  *
  * The BUILD_BUG_ON check must not involve any function calls, hence the
  * checks are done in macros here.
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1522693295f5..607249785c07 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -989,12 +989,9 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
 
 /**
  * kfree - free previously allocated memory
- * @object: pointer returned by kmalloc.
+ * @object: pointer returned by kmalloc() or kmem_cache_alloc()
  *
  * If @object is NULL, no operation is performed.
- *
- * Don't free memory not originally allocated by kmalloc()
- * or you will run into trouble.
  */
 void kfree(const void *object)
 {
-- 
2.39.2

