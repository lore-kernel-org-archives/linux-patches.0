Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028705;
	b=1zX7LLXGul8SyuKggh9ZzEcNTD15rfbe7/rI1AT0DqNqEzb33vChMt/tW/Ql36HGCto3
	 hoaVRLoUT6Wed8Crm3ANL9o1XV8Wr6ty3mTU5WFzq+HWX71DTFEPh3wwI+L6zTI8p+kUJ
	 +FdLpKEL0B0r4F/tZowh+SH+DLZ34/Ilx2x3W93tBcU74riYyts5Us8aUU41CwB9R/u3t
	 xpmwVSXCZbZFwSMORr3rR8yrg2A4H56jnpLApzsMOi+9cSyMr0CA6/nP3pol2MhtGYJZt
	 liK4IKT0DoZ79Giau/G8DX5xSubEKgxKhqmqWDXdk14vaPcUoz6uZQX/Y5ZpYTIkFWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WadVoLWM95yKHeP11lteZlQh4PJbCRAhJpom/CN6Z9A=;
	b=CaYXF6I0hxa18Aggzreu8q9RLrgYMGBVLDrtw7hsqdJvQ5vkxoFkPvog4YKF0GM1o/GV
	 MGUb/O7TeblZ7X/vSzEaRQBb3puJiSelMkq5/WtFhbm8Cc6G8iwCFHXgqxqgH3/LqMbkd
	 LWxK3wwQs4iA4eOrxt7sfwZbxFabVE+O3fSP47Wdf05/6c41LT9YUNguIKl30hK0YwZWW
	 vIixoRPX7b++iX72OYaFyrkbc8ih1KRXrtJHwbIyBwNjJ8dSST6xA9QmGwvM9MRNFww1Q
	 Mzxag/3M8gJNC2ucBP5ysVwX7KKrrzdbAoLvHRCQJ5qul0ZW1GvikeCb0UGgwqj7Kfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uycLz0Ln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06304606A325;
	Wed, 18 Nov 2026 19:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uycLz0Ln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236FF1F000C4;
	Wed, 18 Nov 2026 19:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028704;
	bh=WadVoLWM95yKHeP11lteZlQh4PJbCRAhJpom/CN6Z9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uycLz0LneNGoaeyiYcCutNjzuCYzQRBIxt5uJLi0fydHlHKbnUOYcnsOuGhkPR/K5
	 V68KU9fTmZStVcOw2/XPlgFjqd7zajYsYHfrAD2lQVyyo00UCCMYn8l0rbSv+TOAFZ
	 znHtISi1HE+QE7qaZJHhqXUnk2KxLamVZE/pF2KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <mason@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0090/1756] mm/hugetlb: dont clear the resv_map of a VMA whose lock is held
Date: Wed, 18 Nov 2026 15:36:57 +0100
Message-ID: <20261118150011.835527087@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit d42032c0fe3ca007986c1229128775af0340fbec ]

Since commit bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private
VMAs") the lock of a private hugetlb VMA that owns a reservation is the
rw_sema of its resv_map.  The hugetlb_vma_*lock*() helpers find it through
vma->vm_private_data, anew for every lock and every unlock.

At the end of mremap() the old VMA has to let go of the resv_map, which
now belongs to the new VMA: clear_vma_resv_huge_pages() stores NULL into
vm_private_data.  mremap() holds mmap_lock for writing and has write
locked the VMA, which keeps away everybody who comes through the mm.  It
does not keep away those who find the VMA through the file.  For hole
punch and truncation hugetlb_vmdelete_list() does

	hugetlb_vma_trylock_write(vma);		locks resv_map->rw_sema
	unmap_hugepage_range(vma, ...);
						vm_private_data = NULL
	hugetlb_vma_unlock_write(vma);		no resv_map: does nothing

and the rw_sema stays write locked for ever:

  WARNING: lock held when returning to user space!
  mremap_punch/116 is leaving the kernel with locks still held!
  locks held by mremap_punch/116: 1, last CPU#1:
   #0: (&resv_map->rw_sema){+.+.}-{4:4}, at:
                                       hugetlb_vmdelete_list+0x46/0x160

The next fault in the new VMA sleeps in hugetlb_vma_lock_read(),
uninterruptibly, and it holds its entry of hugetlb_fault_mutex_table[].
That table is global, so a fault of any other process on a page that
hashes to the same entry sleeps uninterruptibly as well.

All those who take the lock of a private VMA without taking the mmap/vma
lock are affected: rmap walks. So hold i_mmap_rwsem around the clearing
of the resv_map.

No change of behaviour, other than that mremap() of a hugetlb VMA takes
i_mmap_rwsem once more.

Original fix generated by an LLM and sent in private by Josef.

[david: avoid local variable, move and refine comment, description cleanups+simplifications]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-5-42796911043b@kernel.org
Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: applied the change around the existing clear_vma_resv_huge_pages() call in move_vma() because fixup_hugetlb_reservations() is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 3d5c2f69fdbfd..6731efdcd21bc 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -812,7 +812,14 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	}
 
 	if (is_vm_hugetlb_page(vma)) {
+		/*
+		 * Rmap walks might still find this VMA and take the lock
+		 * inside the reservation map for __vma_private_lock(). Don't clear
+		 * the reservation map while that is possible.
+		 */
+		i_mmap_lock_write(vma->vm_file->f_mapping);
 		clear_vma_resv_huge_pages(vma);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
 	}
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
-- 
2.53.0



