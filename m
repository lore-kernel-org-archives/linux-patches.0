Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFBD2CA4
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 485451F3A0;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kFo3sK6wIXsa/1oDIf9GoaZp3ONq6k59G8QliQtJU8k=;
	b=EN52JW7Cqz3L9VMQ7CNeab2ppHpc0t7G+H3hq6EyAz5s6T0HMG7fEhiYpixa3UcdwVXIoa
	O1HgpsxIDIsrG1Ntt2bCKHnUnrkXefrsOom2uFFNWWg4kcV3kGEezhcnzF5bA0mlXhbQK9
	hQQpNrIsa9L+X6DltFUFICPNelirI9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kFo3sK6wIXsa/1oDIf9GoaZp3ONq6k59G8QliQtJU8k=;
	b=3EL9SKL/nVhHf7glo5MCABr2gbdEqexLm8a8NxOFnK/y6YYlL84oqPmEWWa+jV83UlH/p/
	FU4/eW/et442beAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E1BB139EE;
	Tue,  4 Jan 2022 00:10:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id +IadBo2Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <guro@fb.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 03/32] mm/slub: Make object_err() static
Date: Tue,  4 Jan 2022 01:10:17 +0100
Message-Id: <20220104001046.12263-4-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2631; h=from:subject; bh=5we38++RIBjtReHO3aL8SMdp8YnU+2Xt/EKlCKfJjNw=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BsjRUW4pZKXAoViFXuc2yds7vTnJcaRisJfgq8 FvNVnIqJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQbAAKCRDgIcpz8YmpENzrB/ 0b3CN3YC2nwXY53V9P2WVyAXJ8PtTYnUE8dFbgB7dmyq7lKuGYpRMdqsA32XjXUoocqVQhwSpkFBTg 4AS0i8sy+ntOM9sMLOLBai9E2VJsPXMmPNzFpGPlJfyuuhDFCVLedQSqdSJ5Lm+FwaBnJ1FjQbA2ky NPsIvXrK/lxSrAm8MwdTPjwn/IVThoe0XIWcxgy+vl56V6RSYdAfhhKBHIRCngDawzUMG4EOyz+5G+ b/XwLmWutlcTll3jUOtmNK4cdIfbawCndubtEwt6JhmBGw1jikIB3avszozUOvs7tctoT0f7cxlgJJ /G9UG1kj8wvnnLZZejOHkQqKHNIHi/
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

There are no callers outside of mm/slub.c anymore.

Move freelist_corrupted() that calls object_err() to avoid a need for
forward declaration.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
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
index abe7db581d68..2ccb1c71fc36 100644
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
2.34.1

