Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214405;
	b=V55PmdOgdF02Wkfr+FedeAqrE8N2C5HVKbBHcQ91SI8CZEzH3tN7UUlh3FldPi6jZO14
	 F/UJU9vEIpjjehOrD4FHOhvUNdk/VXKfnPY5xPwg/MBn0GTrGaD1RB48zoIyf2rAiZx6M
	 sKUMIjTLaoT7oOwMJ+0IumVi546ljhJ0xNyIIBvKOxJwZG7B/6FkT3n/73B0KquWdfnSD
	 3+4IgwHVZcIxVbWrocliDizw0jEDaB4cDXH65bVmhDUxzwEMUintpAEbzW2FXY8TsXBmr
	 NiBkUO6KbpTpCkUHihpZ4h+nGo6AgFYMFe7i97n0MpBYD9n/yXeYNH29k8nfGSQ+6Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UyKGFmlc6yWt3fGcA3xx1oFfLnhTYlOzbjTlKQ2zxWM=;
	b=3q0MtyZBglehrMsMNG1rgCECs+WPcgOZnsJT6XTk6AnYozX/qek0AFM/074ixzNdF1R2
	 aKLWnENbtYIKk4J+gIj/b856jk9V4ouRcyR8zmcdm3HXAnBrEp3QzoZH2ZBtO4LIm7CWG
	 auMABmq9AO/u2OWu1XT6AhZHa/XR0q6TnJWJqt4yYkc9NCeWTTf0jGilv1xPkFarHuh6J
	 g1KFo2gPF0GiTBQePqDkWcCeJeZ7xGzydM0aeM2RHpTy0IAt0El10JUla1fUwQR2gawhw
	 RbPlmZTrr9nNgvBA1eeQefT9ez+arcLm3w3hHTYTieaAo1qY1zmqe7THTfoqosimKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7Sxn+Ks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127EC606A32C;
	Wed, 28 Oct 2026 19:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7Sxn+Ks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6020A1F01825;
	Wed, 28 Oct 2026 19:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214404;
	bh=UyKGFmlc6yWt3fGcA3xx1oFfLnhTYlOzbjTlKQ2zxWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7Sxn+KsaDquZQXp1wpS5OaxNY/bbZf5vQKW7a6fxT1R2XrfL9JR41DTIQaUgqgn8
	 pxb6yGvdDRJZr4tMnZW61Z3ckRW9UGAUkKu4gpLXdvNu/2xY9o/K276TWQT28dOLY0
	 TcpCnXTAeMx/a0kcswAjOzJm/W5Km6Dtuqnavr9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0846/1887] mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()
Date: Wed, 28 Oct 2026 17:49:02 +0100
Message-ID: <20261028170518.678610358@linuxfoundation.org>
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

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit 79357cd06d41d0f5a11b17d7c86176e395d10ef2 ]

kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask and
always allocate memory using the hardcoded GFP_KERNEL flag.  This makes
them inconsistent with vmalloc(), which was recently extended to support
GFP_NOFS and GFP_NOIO allocations.

Page table allocations performed during shadow population also ignore the
external gfp_mask.  To preserve the intended semantics of GFP_NOFS and
GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
memalloc scope.

xfs calls vmalloc with GFP_NOFS, so this bug could lead to deadlock.

There was a report here
https://lkml.kernel.org/r/686ea951.050a0220.385921.0016.GAE@google.com

This patch:
 - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
 - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
 - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
   around apply_to_page_range();
 - Updates vmalloc.c and percpu allocator call sites accordingly.

Link: https://lkml.kernel.org/r/20250831121058.92971-1-urezki@gmail.com
Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kasan.h |  6 +++---
 mm/kasan/shadow.c     | 31 ++++++++++++++++++++++++-------
 mm/vmalloc.c          |  4 ++--
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 5614d9da7a9e8..b290621c4ee34 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -387,7 +387,7 @@ static inline void kasan_init_hw_tags(void) { }
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
 void kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end);
@@ -398,7 +398,7 @@ static inline void kasan_populate_early_vm_area_shadow(void *start,
 						       unsigned long size)
 { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
@@ -443,7 +443,7 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
 static inline void kasan_populate_early_vm_area_shadow(void *start,
 						       unsigned long size) { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 9dc041fd4f0f7..c651f3266e064 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -302,13 +302,13 @@ static void ___free_pages_bulk(struct page **pages, int nr_pages)
 	}
 }
 
-static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
+static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask)
 {
 	unsigned long nr_populated, nr_total = nr_pages;
 	struct page **page_array = pages;
 
 	while (nr_pages) {
-		nr_populated = alloc_pages_bulk_array(GFP_KERNEL, nr_pages, pages);
+		nr_populated = alloc_pages_bulk_array(gfp_mask, nr_pages, pages);
 		if (!nr_populated) {
 			___free_pages_bulk(page_array, nr_total - nr_pages);
 			return -ENOMEM;
@@ -320,25 +320,42 @@ static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
 	return 0;
 }
 
-static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
+static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
 {
 	unsigned long nr_pages, nr_total = PFN_UP(end - start);
 	struct vmalloc_populate_data data;
+	unsigned int flags;
 	int ret = 0;
 
-	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
 	if (!data.pages)
 		return -ENOMEM;
 
 	while (nr_total) {
 		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
-		ret = ___alloc_pages_bulk(data.pages, nr_pages);
+		ret = ___alloc_pages_bulk(data.pages, nr_pages, gfp_mask);
 		if (ret)
 			break;
 
 		data.start = start;
+
+		/*
+		 * page tables allocations ignore external gfp mask, enforce it
+		 * by the scope API
+		 */
+		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+			flags = memalloc_nofs_save();
+		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+			flags = memalloc_noio_save();
+
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
+
+		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+			memalloc_nofs_restore(flags);
+		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+			memalloc_noio_restore(flags);
+
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
 			break;
@@ -352,7 +369,7 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 	return ret;
 }
 
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, shadow_end;
 	int ret;
@@ -381,7 +398,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = __kasan_populate_vmalloc(shadow_start, shadow_end);
+	ret = __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_mask);
 	if (ret)
 		return ret;
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6c8a9b748db17..32d172fa3e6cf 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1708,7 +1708,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	BUG_ON(va->va_start < vstart);
 	BUG_ON(va->va_end > vend);
 
-	ret = kasan_populate_vmalloc(addr, size);
+	ret = kasan_populate_vmalloc(addr, size, gfp_mask);
 	if (ret) {
 		free_vmap_area(va);
 		return ERR_PTR(ret);
@@ -3997,7 +3997,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 	/* populate the kasan shadow space */
 	for (area = 0; area < nr_vms; area++) {
-		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area]))
+		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
 			goto err_free_shadow;
 	}
 
-- 
2.53.0



