Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022685;
	b=HnOP0mbwXZZ4j2HIPctv+9PkGckuX/4k/fZ7spnEQwOAdZ3I1L+2yBJB7MQo+Q8tOA0m
	 Ju/M4qZG95L4ScRUABM8svOMFUKRYimJ+2Klfu3Otgh6qHZdxpHwj1dB4hZulohhgOY5Z
	 RDneF6u/upU6xAUFI5R/oxDobZVOkwATPPqRVdhqBFuSVVOxUAMCc6+uMT4aDQNLEcN6j
	 6HGeK4GByMJA5Npj7VDFH9DRbkzIMKxTKwxnqWGsZGjgZfXSaJ/uCCtSoxWcffApH8YBj
	 duC3Rq1pWHnGJrSY3tEWWeWPKNSuGMsmL3qxgq2MoZiGtDJBQcbjv3M1N2k45xVBwnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dh+gNFQPxvF/sAu5mgLc0SvaY0nQdKDcGUUPuocp8Qo=;
	b=AXRD2lz0AJsaJCkBmPZP9uG7lqr6nXn23oMz8rsmbmQiSlJsZSlsiYpQCmyEwOqj0I5W
	 6P19ZWAR4KwJPKCRtnOS9QZbA8B+W8+4K+HebO8zVW0W+BcZlG8YTw+DX/E+b2RIrqhtc
	 t4s9OFXX9mRN65Bl+xyljEokxq8sCJByXJG5Uct5I4MxnDerj5LQGPpKxevUc36/lZYw9
	 lOrzB7ORnoFT8TOJHrhroG14YQrA7PRH8PrdHAaFIQ8udIlhQD8sSOdqHLV13U6bLeop7
	 XjroxdhjyjlqNGmfVGvKj2WrqnW0P7+drQd6SLnqmtluckXjLpY7VGasmKPHNUio5+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIFRX44G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB41606A32F;
	Wed, 18 Nov 2026 17:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIFRX44G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D491F000C4;
	Wed, 18 Nov 2026 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022685;
	bh=dh+gNFQPxvF/sAu5mgLc0SvaY0nQdKDcGUUPuocp8Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIFRX44GVLEo282+JXh06Esl64RsJGnHuuSd/gtMuR05vw8HchV4sFSSV7VeiLlB5
	 UNUAB2JvgnRR/SMnvCUy/nsZ3urZIkxZVdCm0eSpvWDLDAg/bLSZDl1KYs2w06zqJ1
	 q0cJqTjvkhagCzcSaqRMXSKBLNA6QrluVvmSwak0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0102/2151] mm/huge_memory: properly handle refcounted PUD mappings on fork
Date: Wed, 18 Nov 2026 15:30:37 +0100
Message-ID: <20261118150125.518819118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit d90bdc02e36ec08d8248ebc6cdc52e12043eb28c ]

copy_huge_pud() copies device-DAX entries without taking a folio reference
or updating mapcounts and the child's RSS.

For example, MADV_GUARD_INSTALL sets VM_MAYBE_GUARD on a device-DAX VMA,
forcing copy_page_range() to traverse the whole VMA on fork. Any remaining
huge PUDs are then copied without accounting for the new mappings.
Unmapping them in the child decrements accounting that was never added.

Use vm_normal_page_pud() to identify refcounted mappings. Take a folio
reference and add the child's PUD rmap and RSS accounting before installing
the copied entry. Pass src and dst VMAs consistently instead of src and
dst MM. Move the TODO.

Fixes: aed877c2b4257 ("device/dax: properly refcount device dax pages when mapping")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-11-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: changed vma_is_cow_mapping(src_vma) to is_cow_mapping(src_vma->vm_flags) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h |  5 ++---
 mm/huge_memory.c        | 27 +++++++++++++++++++--------
 mm/memory.c             |  4 +---
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b55a4a342f578..c6befc9fddf12 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -12,9 +12,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 void huge_pmd_set_accessed(struct vm_fault *vmf);
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma);
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eba9280ddb594..33c0d1bb0ee4d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1911,11 +1911,13 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 		update_mmu_cache_pud(vma, addr, pud);
 }
 
-int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-		  struct vm_area_struct *vma)
+int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
+		pud_t *dst_pud, pud_t *src_pud, unsigned long addr)
 {
+	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	struct mm_struct *src_mm = src_vma->vm_mm;
 	spinlock_t *dst_ptl, *src_ptl;
+	struct page *page;
 	pud_t pud;
 	int ret;
 
@@ -1928,11 +1930,20 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(!pud_trans_huge(pud)))
 		goto out_unlock;
 
-	/*
-	 * TODO: once we support anonymous pages, use
-	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
-	 */
-	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
+	page = vm_normal_page_pud(src_vma, addr, pud);
+	if (page) {
+		struct folio *folio = page_folio(page);
+
+		folio_get(folio);
+		/*
+		 * TODO: once we support anonymous pages, use
+		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
+		 */
+		folio_add_file_rmap_pud(folio, page, dst_vma);
+		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+
+	if (is_cow_mapping(src_vma->vm_flags) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
 	}
diff --git a/mm/memory.c b/mm/memory.c
index e8a5292c5a317..2dc764e898fac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1416,7 +1416,6 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 	       unsigned long end)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	struct mm_struct *src_mm = src_vma->vm_mm;
 	pud_t *src_pud, *dst_pud;
 	unsigned long next;
 
@@ -1430,8 +1429,7 @@ copy_pud_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 			int err;
 
 			VM_BUG_ON_VMA(next-addr != HPAGE_PUD_SIZE, src_vma);
-			err = copy_huge_pud(dst_mm, src_mm,
-					    dst_pud, src_pud, addr, src_vma);
+			err = copy_huge_pud(dst_vma, src_vma, dst_pud, src_pud, addr);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)
-- 
2.53.0



