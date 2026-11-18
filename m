Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034620;
	b=e/Bfv0y6JPFVXgSemj/4dxeFKM0q0wZQx+RDWuasrQbhq7UWDleUJNoBko5BrXXmplw1
	 J3OmBmdEZQoicrEw6g6RB6u1RZUQ1djh1O9gm2kdY96HZYgx0Crtx6pHWUZkhnMWjZfcI
	 tIE0YS4ZtexXitGItesGfOOVL0qQTdpiKS1Q4jeXdzrq/I9jeEhtztkOkpN14GyexSMhJ
	 xnWBPPGUzfYZefMQnHrNP+/KikhAbgvWo81RoIov7XwKa/x/DwrxfGDaXhNTa3hexXhIe
	 T2aivkblr8lyEbi8V02GlRblhRgnq2wOMgSluxicFs7jFox8FsBBXiIo177ClHQmugA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dGCBs9+zV0WaLdAFCrigjrKZauCF9fzOlDWSQJiQ9NA=;
	b=T83DS1VvAEu9jBHLPi2bXLc0kjsILPohxSHbsfzjqNOL04T8+UbSDU9kCnFpv50GPa+P
	 uAEfW5aeLy1EkqmFfWvH9zkPvoIDZ7za1J0Ig+sJ3xWU3Yqj7uc4x131tXZovCPbW+g1k
	 DQ15tdUUb8iLU6dk7Fle0nxh5HJmOqNk22vqTsDYNzgVM/iKuqwz6z7yTBUZh9i8e2mGl
	 CbRsN27GIqODpZGJfReyAQNGr0LGiQegEbtNt1mRUqyJjbqdSvZcNm7kdq0u/jSY6Cq5D
	 fThlzqdsqtVUEttB8fB4ID0jIDqV68lhzsHtQ2Js1bBdvosXxYcfBiJonhqz00DCXng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6tHdr3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A2760A263C;
	Wed, 18 Nov 2026 20:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6tHdr3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B6C1F000C4;
	Wed, 18 Nov 2026 20:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034620;
	bh=dGCBs9+zV0WaLdAFCrigjrKZauCF9fzOlDWSQJiQ9NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6tHdr3H0mDqPfeXqmgO5ChlclLp42OCbT6pqw0H6OKv8eopON1Efwiqi58taUt14
	 1uco0WGTi3dALsjZuEZAXXoR6VGvWo70d/9VRM5N8jebJtNyrpviKZvPsj6cb/3YLw
	 QbUMo/OATCw78OlSfxq5IjoUdYyiMKCMKF7HQEYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@kernel.org>,
	Li Xiasong <lixiasong1@huawei.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0385/3318] mm/slub: fix missing debugfs entries for caches created before sysfs init
Date: Wed, 18 Nov 2026 15:16:47 +0100
Message-ID: <20261118150327.836895979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Xiasong <lixiasong1@huawei.com>

[ Upstream commit 7e98f856395618011c517f767fb80ac3fe90de2b ]

slab_debugfs_init() creates the slab debugfs root at device initcall
time, while slab_sysfs_init() moves slab_state to FULL at late initcall
time. SLAB_STORE_USER caches created in this window miss their debugfs
entries because do_kmem_cache_create() skips debugfs_slab_add() when
slab_state <= UP. This was observed with MPTCP's request_sock_subflow_v6
cache, whose slab debugfs directory was missing.

The affected window is:

  slab_debugfs_init()
    slab_debugfs_root = debugfs_create_dir(...)
    list_for_each_entry(s, &slab_caches, list)
      debugfs_slab_add(s)

  kmem_cache_create(..., SLAB_STORE_USER, ...)
    do_kmem_cache_create()
      if (slab_state <= UP)
        return without debugfs entries

  slab_sysfs_init()
    slab_state = FULL

Initialize the debugfs root and add debugfs entries while holding
slab_mutex, walking slab_caches exactly once and handling both sysfs
and debugfs entries in the same pass. This gives the sysfs and debugfs
initialization an explicit order and prevents caches from being
created between the debugfs scan and slab_state reaching FULL.

Gate the new slab_late_init() on either sysfs or debugfs being enabled,
with the slab_kset creation and alias_list processing factored into
helpers that have empty no-sysfs variants, as suggested by Vlastimil
Babka. On slab_kset_init() failure, slab_state stays below FULL so
kmem_cache_create() keeps taking the early-boot path, matching prior
behavior.

Guard debugfs_slab_release() against an uninitialized debugfs root,
since the root is now created later and a cache may be released before
it exists.

Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall")
Cc: stable@vger.kernel.org
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Link: https://patch.msgid.link/20260729101849.3734287-1-lixiasong1@huawei.com
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
[ sashal: Kept the existing sysfs_slab_alias() declaration and stub in the forward-declaration block and added the new slab_kset_init() and slab_sysfs_process_aliases() declarations and stubs after them. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 76 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index eeb0aa9e6ce8e..4ada836b8e972 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -318,16 +318,22 @@ enum track_item { TRACK_ALLOC, TRACK_FREE };
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
+static int __init slab_kset_init(void);
+static void __init slab_sysfs_process_aliases(void);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
+static inline int slab_kset_init(void) { return 0; }
+static inline void slab_sysfs_process_aliases(void) { }
 #endif
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
 static void debugfs_slab_add(struct kmem_cache *);
+static void __init slab_debugfs_root_init(void);
 #else
 static inline void debugfs_slab_add(struct kmem_cache *s) { }
+static inline void slab_debugfs_root_init(void) { }
 #endif
 
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
@@ -6279,28 +6285,20 @@ static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 	return 0;
 }
 
-static int __init slab_sysfs_init(void)
+static int __init slab_kset_init(void)
 {
-	struct kmem_cache *s;
-	int err;
-
-	mutex_lock(&slab_mutex);
-
 	slab_kset = kset_create_and_add("slab", NULL, kernel_kobj);
 	if (!slab_kset) {
-		mutex_unlock(&slab_mutex);
 		pr_err("Cannot register slab subsystem.\n");
 		return -ENOMEM;
 	}
 
-	slab_state = FULL;
+	return 0;
+}
 
-	list_for_each_entry(s, &slab_caches, list) {
-		err = sysfs_slab_add(s);
-		if (err)
-			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
-			       s->name);
-	}
+static void __init slab_sysfs_process_aliases(void)
+{
+	int err;
 
 	while (alias_list) {
 		struct saved_alias *al = alias_list;
@@ -6312,12 +6310,41 @@ static int __init slab_sysfs_init(void)
 			       al->name);
 		kfree(al);
 	}
+}
+#endif /* SLAB_SUPPORTS_SYSFS */
+
+#if defined(SLAB_SUPPORTS_SYSFS) || \
+	(defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS))
+static int __init slab_late_init(void)
+{
+	struct kmem_cache *s;
+	int err;
 
+	mutex_lock(&slab_mutex);
+
+	err = slab_kset_init();
+	if (err)
+		goto out;
+
+	slab_debugfs_root_init();
+	slab_state = FULL;
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (sysfs_slab_add(s))
+			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
+			       s->name);
+
+		if (s->flags & SLAB_STORE_USER)
+			debugfs_slab_add(s);
+	}
+
+	slab_sysfs_process_aliases();
+out:
 	mutex_unlock(&slab_mutex);
-	return 0;
+	return err;
 }
-late_initcall(slab_sysfs_init);
-#endif /* SLAB_SUPPORTS_SYSFS */
+late_initcall(slab_late_init);
+#endif
 
 #if defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS)
 static int slab_debugfs_show(struct seq_file *seq, void *v)
@@ -6515,23 +6542,16 @@ static void debugfs_slab_add(struct kmem_cache *s)
 
 void debugfs_slab_release(struct kmem_cache *s)
 {
+	if (unlikely(!slab_debugfs_root))
+		return;
+
 	debugfs_lookup_and_remove(s->name, slab_debugfs_root);
 }
 
-static int __init slab_debugfs_init(void)
+static void __init slab_debugfs_root_init(void)
 {
-	struct kmem_cache *s;
-
 	slab_debugfs_root = debugfs_create_dir("slab", NULL);
-
-	list_for_each_entry(s, &slab_caches, list)
-		if (s->flags & SLAB_STORE_USER)
-			debugfs_slab_add(s);
-
-	return 0;
-
 }
-__initcall(slab_debugfs_init);
 #endif
 /*
  * The /proc/slabinfo ABI
-- 
2.53.0



