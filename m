Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623922;
	b=a8co3O1zgcqT1zPiCL5+LZ9LotUDcfd3IcZpzqyet5kQqPO25EqLReZjVFZvyYxj42m7
	 C8VDa16r6MesUek5vDQn7hOqehpYwu0z3GYXFXckNWYF7cN/P8PV0uN5kJe37b3nq9EUB
	 SaAPOYmbU4Blu6R4H6B5QKShmYGrGnhLhp0C14dIgJ0JQEa3x8KWNNp7GTS3TiUKLOs5z
	 YYXDgpWcO5YL72foZ//Mi6gVvMRJM83QyBWMkzb0i4whOmrP4jjMTD3Pq/cNF8tW6cR34
	 c9MDpdMY8vZrHrBht9fTeKAkTunxzedefRtk2GV2G9nLnFtyLMG8SLEG3umrwmmQxpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GXBOu65AC2brS+Q27Qu59hksFemwIIZAQKNcETyJlhs=;
	b=pHi/FlkXCnb48T4D0jmzRGLfdKzDNuSsDmhr+lNSx7YjR6W2jKDoz01SzSRTQPQfVfU/
	 jdysPZRYV6nQ7K9UWiRMK21uKu1mszZLZVd2Ixyz0NS4DpDM0gCrlbcdJEHYK0KNGyUCS
	 v5MH/YD/TJXezmU+dLJyytm0WYroMo6+AIbC6gA8ewFofbI6JP6xTDmDlCWE+84q5y29B
	 jNX6uLajdRUtjDFOufcDoH1Gk0G+xi8S1jh18eHk5V+Yr0gf72cwNUhnNxvTrmbFpzDft
	 fQOr6SThkoSqOQDHdf6Tj7rvkh947nCfUZd7AKGn+lPOzY4/YnS+aIELO/fqxlXvggQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkXlc4pP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD35606A321;
	Wed, 25 Nov 2026 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkXlc4pP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF391F000D1;
	Wed, 25 Nov 2026 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623922;
	bh=GXBOu65AC2brS+Q27Qu59hksFemwIIZAQKNcETyJlhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkXlc4pPgKpW1TCGGoOf5akzl+xxKhjsosxJnbFghOuQb5XBWyRMacIfHn0Wt3PD7
	 ypSFRVfU7+R9Jugbvrgq3vEDn4ub0+1fmacAzNaKv/uBU6Gu+jt3NqdzcTZQzdZiah
	 4TlTkqZbnK4eM782+BBgiL1Qzo0uOicvSb4AIPcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samarth Narang <samarth.colleges@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Bobby Powers <bobbypowers@gmail.com>,
	Brian Geffon <bgeffon@google.com>,
	Denis Plotnikov <dplotnikov@virtuozzo.com>,
	Doug Gilbert <dgilbert@interlog.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Martin Cracauer <cracauer@cons.org>,
	Marty McFadden <mcfadden8@llnl.gov>,
	Maya Gokhale <gokhale2@llnl.gov>,
	Pavel Emelyanov <xemul@openvz.org>,
	Rik van Riel <riel@surriel.com>,
	Shaohua Li <shli@fb.com>,
	James Houghton <jthoughton@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	SJ Park <sj@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Xu Xin <xu.xin@linux.dev>
Subject: [PATCH 6.12 028/816] mm/ksm: fix userfaultfd protection during merge and unmerge
Date: Wed, 25 Nov 2026 15:26:16 +0100
Message-ID: <20261125143849.866792418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

[ Upstream commit 990d6c2194a938a19a8cf94c6cfd75171345089b ]

KSM loses userfaultfd protection when replace_page() builds a new PTE from
vma->vm_page_prot.  Dropping its uffd bit lets a subsequent write go
through ordinary COW instead of userfaultfd write protection handling.
For RWP, a merged page also becomes readable without faulting.

Keeping the uffd bit and restoring PAGE_NONE fixes merging, but we also
have to handle unmerging.  An existing KSM page can be protected with RWP
before MADV_UNMERGEABLE, so unmerging already needs fixing independently
of preserving RWP during merging.

Unsharing replaces a shared page with a private one and should leave
userfaultfd protection in place, as do_wp_page() already does for write
protection.  Currently, an unshare fault reaches do_uffd_rwp() before it
can proceed to do_wp_page().

- With synchronous RWP, handle_userfault() returns VM_FAULT_SIGBUS.
  break_ksm() then reports success with a KSM page still merged.

- With asynchronous RWP, protection is cleared before unsharing.

Preserve the uffd bit when merging, and restore PAGE_NONE for RWP.  Let
FAULT_FLAG_UNSHARE skip RWP fault handling and keep PAGE_NONE on each
private copy as well.  Unsharing can then complete with RWP still armed
for a subsequent access.

Link: https://lore.kernel.org/20261026130054.91461-1-lance.yang@linux.dev
Link: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
Link: https://lore.kernel.org/all/20261020055518.36087-1-lance.yang@linux.dev/
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Samarth Narang <samarth.colleges@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Xu Xin <xu.xin@linux.dev>"
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shaohua Li <shli@fb.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 9a98aa97317a4..6d7b21636f549 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1413,6 +1413,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	if (pte_soft_dirty(orig_pte))
 		newpte = pte_mksoft_dirty(newpte);
 
+	/* Preserve uffd-wp when replacing the page. */
+	if (pte_uffd_wp(orig_pte))
+		newpte = pte_mkuffd_wp(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another
-- 
2.53.0



