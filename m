Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028662;
	b=eiJjAUain3A0HRmOQGWPz0wt+03j84vWA1yH3wcjT3STqc5H0HVmkflm6oV36WXDEsdQ
	 57nv1PEKyNoAM8cbtV5bGI+dZ43emBv5CYo22YTpkXTf5wpJyfbLA8QueOjLSOLQ2z20b
	 WXn5GSf6YP4exOIFvACMc/Y51o9EZySzCTP6Zl7CqGta0YVPe8nYnt7D/4I0fXSsMouZi
	 ziztyEXYSLR6FVtx9BC8p+ozceIe4WVvMDSuKwOvVw5JDwUAqwIMgWEj5bW3Wpjvx+z7q
	 FLMQ2VPi25WvYdCZ+yuTj32oi5mPFmgQCCTBKLxRqDU7jqoHXgSQ0Oji2J3A9BL/7Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NlFgDspWDpyBnhjkBPaNcUEyIGhOy8roogBNZqtSvDc=;
	b=otSMpkbQAoFFRqd2d/8z7/QkoBFU58/Z2GviYvXepWVLKFw8ot7ojRZHg00kq8OdcN6/
	 DelmLmeoF4D5Ac84HfVK9n3DSEpnIivUw2yPtTuw5LNWlIqMKPLqw/rJEz4AvebznQWkD
	 Greg4ebav9og7I3qWXzqDu+dawtWjht/Y8Nnl56N5MkYl6FDKn4mMK8A/m4GTo56Wdm6m
	 +m7NoiZAQ3jsuDdxi0v7rvUCQYU8f4T2h6pn29RcFbtiy8o0KsdZF4+gS9MoOj8zK/LJ9
	 LAdNG02PexKUqHZwEfTI3reehpO9Oj+rfWwN3yQ9HwzAeS74DIGTjp4OGlUyDtNZN1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6fhvwKm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89CC606A31C;
	Wed, 18 Nov 2026 19:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6fhvwKm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5571F000C4;
	Wed, 18 Nov 2026 19:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028662;
	bh=NlFgDspWDpyBnhjkBPaNcUEyIGhOy8roogBNZqtSvDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6fhvwKmCp1Omg99FQPjO1/iIvEaGp/AQLoiISWH8YdmhxSYXPogPVHP7T61V/qX4
	 tF3tl3ojOj7bzkkp46SMnruWS+f+xaIYW9iLtsdqMyWc8o/0xroholokjwtMb9n2Jr
	 NM8fMYN2Dp2CI4asEAPCFW5EpMNDRRubMKxEjVCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Sharma <adi.sharma@zohomail.in>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0076/1756] mm/memory: update stale locking comments for fault handlers
Date: Wed, 18 Nov 2026 15:36:43 +0100
Message-ID: <20261118150011.326777047@linuxfoundation.org>
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

From: Aditya Sharma <adi.sharma@zohomail.in>

[ Upstream commit 214f9ab72ce6e16120c20ad670389656f059e685 ]

Update the comments for wp_page_copy(), do_wp_page(), do_swap_page(),
do_anonymous_page(), __do_fault(), do_fault(), handle_pte_fault(),
__handle_mm_fault(), and handle_mm_fault() to concisely clarify that they
can be entered holding either the mmap_lock or the VMA lock, and that the
lock may be released upon returning VM_FAULT_RETRY.

Additionally, make the following corrections:
- In do_anonymous_page(), correct the outdated claim that the function
  is entered with the PTE "mapped but not yet locked". Since
  handle_pte_fault() unmaps the empty PTE before routing to
  do_pte_missing(), the comment now correctly states it is entered
  with the PTE unmapped and unlocked.
- In __do_fault(), update the stale reference from __lock_page_retry()
  to __folio_lock_or_retry().

Link: https://lore.kernel.org/20260424092217.263648-1-adi.sharma@zohomail.in
Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f681d4580d5c ("mm: fix address wraparound when scanning large folio PTEs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 55 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4e6c893b18b38..d7f74ee122328 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3322,8 +3322,8 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
  *
- * Called with mmap_lock locked and the old page referenced, but
- * without the ptl held.
+ * Called with either the VMA lock or the mmap_lock held (see FAULT_FLAG_VMA_LOCK)
+ * and the old page referenced, but without the ptl held.
  *
  * High level logic flow:
  *
@@ -3657,9 +3657,9 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
  * though the page will change only once the write actually happens. This
  * avoids a few races, and potentially makes it more efficient.
  *
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), with pte both mapped and locked.
- * We return with mmap_lock still held, but pte unmapped and unlocked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK) and pte both mapped and locked. We return with
+ * the same lock still held, but pte unmapped and unlocked.
  */
 static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	__releases(vmf->ptl)
@@ -4199,12 +4199,12 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
  *
- * We return with the mmap_lock locked or unlocked in the same cases
- * as does filemap_fault().
+ * When returning, the lock may have been released in the same cases
+ * as done by filemap_fault().
  */
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
@@ -4737,9 +4737,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_lock still held, but pte unmapped and unlocked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK), and pte unmapped and unlocked.
+ * We return with the lock still held, but pte unmapped and unlocked.
+ * If VM_FAULT_RETRY is returned, the lock may have been released.
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
@@ -4857,9 +4858,10 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 }
 
 /*
- * The mmap_lock must have been held on entry, and may have been
- * released depending on flags and vma->vm_ops->fault() return value.
- * See filemap_fault() and __lock_page_retry().
+ * Either the VMA lock or the mmap_lock must have been held on entry
+ * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
+ * flags and vma->vm_ops->fault() return value.
+ * See filemap_fault() and __folio_lock_or_retry().
  */
 static vm_fault_t __do_fault(struct vm_fault *vmf)
 {
@@ -5423,11 +5425,11 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults).
- * The mmap_lock may have been released depending on flags and our
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK).
+ * The lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
- * If mmap_lock is released, vma may become invalid (for example
+ * If the lock is released, vma may become invalid (for example
  * by other thread calling munmap()).
  */
 static vm_fault_t do_fault(struct vm_fault *vmf)
@@ -5755,10 +5757,11 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
  * with external mmu caches can use to update those (ie the Sparc or
  * PowerPC hashed page tables that act as extended TLBs).
  *
- * We enter with non-exclusive mmap_lock (to exclude vma changes, but allow
- * concurrent faults).
+ * On entry, we hold either the VMA lock or the mmap_lock
+ * (see FAULT_FLAG_VMA_LOCK).
  *
- * The mmap_lock may have been released depending on flags and our return value.
+ * The mmap_lock or VMA lock may have been released depending on flags
+ * and our return value.
  * See filemap_fault() and __folio_lock_or_retry().
  */
 static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
@@ -5841,8 +5844,8 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 
 /*
  * On entry, we hold either the VMA lock or the mmap_lock
- * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
- * the result, the mmap_lock is not held on exit.  See filemap_fault()
+ * (see FAULT_FLAG_VMA_LOCK).  If VM_FAULT_RETRY is set in
+ * the result, the lock is not held on exit.  See filemap_fault()
  * and __folio_lock_or_retry().
  */
 static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
@@ -6072,9 +6075,9 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
 
 /*
  * By the time we get here, we already hold either the VMA lock or the
- * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
+ * mmap_lock (see FAULT_FLAG_VMA_LOCK).
  *
- * The mmap_lock may have been released depending on flags and our
+ * The lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
  */
 vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
-- 
2.53.0



