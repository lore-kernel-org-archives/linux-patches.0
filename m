Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C642CAA
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AEA481FD5E;
	Wed,  1 Dec 2021 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlONebzexGrYMZ7OSGV00RiEHdfpIHjndvDpoQ5LM2o=;
	b=MgW2HY9fMfPpQ6TYFgN9i5TYoKf+dFL/zPGlpCb8+PZAC7huEBhFKvnsrffQOlsifQJGyX
	v29Ba7n5UWEJJ/cNU3y5iPs2V7r6wiq6ADBuY+8eGnOlJtX2gzdwrCQ7KSuzdg2geJe68x
	VG/+MHJVyBYG363Jj0Az3+tVg+Q/GBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlONebzexGrYMZ7OSGV00RiEHdfpIHjndvDpoQ5LM2o=;
	b=zPxI5+c1PfeAOm5W2kyNtISmEuBFo1eHD+X60ZK/qg4w/jRPoZD31ucBBzcX753ISM06ti
	QOb0MqDOS9ZlSgBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8967A14050;
	Wed,  1 Dec 2021 18:15:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id kPwGIbO7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:15 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 03/33] mm/slub: Make object_err() static
Date: Wed,  1 Dec 2021 19:14:40 +0100
Message-Id: <20211201181510.18784-4-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2588; h=from:subject; bh=1YNMkrdr4iZ4u/uTXiqVZG/ZLq/rPPXfPpjKYYT48lM=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7tjKJiMgqK1X1dx9+2vIZx/Mqa9rKloHuJgj+Fu AKsGryyJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7YwAKCRDgIcpz8YmpED3/CA CmVq7mpa/9tMt3ziN4PL9jwf88geovb9PtNlj4AHjLiUlrRYsVe8CjDNA71t9sr9JhGFYYbfldGTe4 zZYYipVKvk9jOauJ4S1NhGG6+np80uvzXA8RfLT60d7T1eIPcOslZKFQJVQ3MwwViAglSrwX0aZ4wc ZrdzSR12yuxTPDABdIhMseCJ7Wez5HtoV0cybU1HOwHxL6LzIRirr48M6pKq1SKZuoFu6au5y9rRYM YutS8p2o+wLYfwH0gVZ8VRyOtBSDZ6eyFttouyEy+KH7rDR/NDK0ilanUuvVyEvmKhKxvqoWoJQiOm 3lLklpg/8rt6B8jh/b1C2hrHcW1gbK
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

There are no callers outside of mm/slub.c anymore.

Move freelist_corrupted() that calls object_err() to avoid a need for forward
declaration.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slub_def.h |  3 ---
 mm/slub.c                | 30 +++++++++++++++---------------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 0fa751b946fa..1ef68d4de9c0 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -156,9 +156,6 @@ static inline void sysfs_slab_release(struct kmem_cache *s)
 }
 #endif
 
-void object_err(struct kmem_cache *s, struct page *page,
-		u8 *object, char *reason);
-
 void *fixup_red_left(struct kmem_cache *s, void *p);
 
 static inline void *nearest_obj(struct kmem_cache *cache, struct page *page,
diff --git a/mm/slub.c b/mm/slub.c
index a8626825a829..98bf50c1c145 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -822,20 +822,6 @@ static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 	va_end(args);
 }
 
-static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
-			       void **freelist, void *nextfree)
-{
-	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
-	    !check_valid_pointer(s, page, nextfree) && freelist) {
-		object_err(s, page, *freelist, "Freechain corrupt");
-		*freelist = NULL;
-		slab_fix(s, "Isolate corrupted freechain");
-		return true;
-	}
-
-	return false;
-}
-
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
@@ -875,7 +861,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	dump_stack();
 }
 
-void object_err(struct kmem_cache *s, struct page *page,
+static void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
 	if (slab_add_kunit_errors())
@@ -886,6 +872,20 @@ void object_err(struct kmem_cache *s, struct page *page,
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void **freelist, void *nextfree)
+{
+	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
+	    !check_valid_pointer(s, page, nextfree) && freelist) {
+		object_err(s, page, *freelist, "Freechain corrupt");
+		*freelist = NULL;
+		slab_fix(s, "Isolate corrupted freechain");
+		return true;
+	}
+
+	return false;
+}
+
 static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,
 			const char *fmt, ...)
 {
-- 
2.33.1

