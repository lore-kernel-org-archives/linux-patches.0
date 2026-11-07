Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065328;
	b=zeivInWfaPFsexHW/y8ZG8HJ0oQm6vNM9rXp6QjVh+bBu8RRNj4Y7lHwRM9QGmDRvXJw
	 S87eixoSn6ExUdmvhvBdjXXS9cImdcCjSHkPaYjH23n7QhpRYeWGviFnWZ69OLhF/gXMt
	 10wShDm4GQ3z1co5iN9i8KIbraruQg7Szu03uQ258CIt5VImAxv9467O9m70vKkmxrTFD
	 hupyAXD5BwngxioaY/weIr0tAPLEH4SOhOgwf3YpLEBX3tuvFQ3XOTcLyL4HNDC6T3T33
	 5GQYynSQIA/pet7+L8rGn+yt3PreP7Lqb6eO/lP0x0v518Ao3b2hD2SiOS00/anm9lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbqFHIyFgYmBjgfQOnAIpeTKm4ZsZIVyJ6ijjijnQaw=;
	b=EnhHHfKIaP1wQGQGDK+ZMRaguoJG69wlUU+muPNcbOVU36qydJDIvEAWTD+NA0Pr8rLy
	 hwjRNcPhJcFB2D+TVE0dv1KGw6L/dUmKUCgyri8cdndCWiRl8zPGBXidm2dPScpbzcF3k
	 z5rUeiwIQQVsqYOn+O2uVW36PPZlP/vlHISDG1eiULwyhscdn6BM6s6GpSZAAO8q7wSHY
	 OQe+7RLAyKZ4bgR7EZ30dHxD5YWD+L71NPgXMFpbu10508uYcFkRDZbeTqIimUpniuBFF
	 5JWVlTxpffiCOvcTL+vnVN1x/E7vk7HfMicFOqONW6lOXoF+4VErEJwORtPMGnEor4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaAWlYmp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D61606A32D;
	Sat,  7 Nov 2026 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaAWlYmp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4901F0089F;
	Sat,  7 Nov 2026 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065327;
	bh=FbqFHIyFgYmBjgfQOnAIpeTKm4ZsZIVyJ6ijjijnQaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaAWlYmpYj+ZJWA/jbuW0+C7X3R1d8+YM8B4DqxjWOYMhEFejTTiaK8FRxB9At3XF
	 21vhU9rzUnLVMxWgIXvF1V4SDfvgVpcagP7nUGZSC6yn0QrPZBcdiGMIWavbGOPjAt
	 WmiuECQ73H57wMf23VsOUzJWS/BQhTDTl6GuXERM=
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
Subject: [PATCH 7.3 1069/1257] mm/hugetlb: dont clear the resv_map of a VMA whose lock is held
Date: Sat,  7 Nov 2026 08:56:05 -0500
Message-ID: <20261107135008.797016003@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 061bdd61f2ad9..fb7205c703b3f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7473,6 +7473,15 @@ void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
  */
 void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 {
-	if (is_vm_hugetlb_page(vma))
-		clear_vma_resv_huge_pages(vma);
+	if (!is_vm_hugetlb_page(vma))
+		return;
+
+	/*
+	 * Rmap walks might still find this VMA and take the lock
+	 * inside the reservation map for __vma_private_lock(). Don't clear
+	 * the reservation map while that is possible.
+	 */
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+	clear_vma_resv_huge_pages(vma);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 }
-- 
2.53.0



