Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065331;
	b=3jOLTo5hyID+0Uo2jSS0UqOmz6VjKHBUqM78EFfuzV6MOiLUaSNvlmFJGahs9+GRmY4U
	 0H+rBKOMscRgMCn7QYXc+O7DkjA5n+kDNlXCx0GscJwDLYNSi4gJE1gKdBi/z6Pvm00iK
	 DRgSycr7XPspYKUTlG6VS62Xh6dmekzuW3ZsqB8K0BI3ZZqv4EpHdZpd30gg3qQa0AVKF
	 YO8bAwQMgaZKcaFbzNjj7bJ/OK974qbEz1B/DAYEisD32dqqGx0fhXIrb2esjHja2PvCi
	 z6rcfCCHMbUPtMN+IZBnAK8UNJ+IFIGzuaozZyX2QBvYnF7iPPr+S0XYmtt9iZ4UeRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etGxw9x8XA51TRJGLX7L+Yxnwmbvu7qvoae20cfbeZQ=;
	b=egwSmY3K9giBBsUQD2A1wf8MdAhISKvu+lFtbvK4vaHm+fGrPBK4Nv1k4L92LbYNITmu
	 xJTAnmgLcDsW6yMTHmqav1JO8FlJ4N6ZdlqZpYpDqBK44RKJwKbH3fBAeKdiVO0R208Pa
	 Ih6d0qKWpCd+F1+t05uLg38s70l6AUiNSuz3K8nRVJIP1wOhyzNUJzMBUAFonxUrS7C5N
	 OtZiCwm0Tv0uhgv7+20km4xkghdM9PwCfep/caiyPhvJdoCucdiiBv0wTOB5mzt962pJq
	 2rAZxvzLUySSt2hfBZ9789bLJhcyZ/H8jrQ8mP/MCws80vLe27X6C+WC4nFd5QHLwEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0UroC8H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033A6606A326;
	Sat,  7 Nov 2026 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0UroC8H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5821F0089F;
	Sat,  7 Nov 2026 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065330;
	bh=etGxw9x8XA51TRJGLX7L+Yxnwmbvu7qvoae20cfbeZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0UroC8HuxpHekGE3Xq7gtJbAVJG+AbGpHD6G5l+MsD1YvWNxh8dAK2ezOHfE3cZC
	 RE5cIITzaD47OliOzIwe79vmLLnX/F+6laFwOeKgPeROIaw1llw9z14+PmRqQXqjiH
	 q1HkgOUBKI8/4ZIe+amjT2xTePn67acTyvvpelkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1071/1257] mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
Date: Sat,  7 Nov 2026 08:56:07 -0500
Message-ID: <20261107135008.851768339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 811777d82038d4fd3f5d3bf986f682df463b6f21 ]

The whole uffd handling when a VMA is unregistered from UFFD is shaky:
there are still some scenarios where we might have stale uffd PTE bits
in VMAs no longer registered for UFFD, which confuses other code.

Let's just tolerate that for now and simply clear the PTE bit. Add a
TODO to really clean up any uffd leftovers when unregistering a VMA from
userfaultfd.

The handling is now more similar to what we have in handle_pte_fault().

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-7-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 81e6c98d21a4e..5757466923cc2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6133,16 +6133,20 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * NUMA hinting), so let normal hugetlb fault handling proceed.
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
-	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
+	    huge_pte_uffd(vmf.orig_pte)) {
 		spinlock_t *ptl;
 		pte_t pte;
 
 		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
-		if (!userfaultfd_rwp_async(vma))
+		if (userfaultfd_rwp(vma) && !userfaultfd_rwp_async(vma))
 			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
 
 		ptl = huge_pte_lock(h, mm, vmf.pte);
 		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
 			unsigned int shift = huge_page_shift(h);
 
-- 
2.53.0



