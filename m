Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065332;
	b=QRtlSPQN6rg4dKiFqlfc22Vlz4jayobwMLCSlfa7rtx+VbCpIsZvVBICWlsNK3RuJThU
	 B/I5xCkeiFf/5JPpbB2U6fpyXvv+DlOl9ZnL3rs+2p5gM1ddkjRiN5ksO4oaiDHOzIjzO
	 aavgP6M7V5MyZ1AJ7sOZvUg5tkedqSnZxR6i3tDwwS/dNl3lyskRkp+FRQy2W72zm2aEC
	 d/3uNlN0QPRKd+BStSYqhAVJaAK5TbVOptqBY9T4glDYheug0K6AiJZwqm2ZRHlbgkCjk
	 azPLVh69HbIxbg1OHFkhfpa1J5rj74zTSHZkttGkK5U3ZIIhUKb3AxxjMJCjNo7uycA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sovWPRveeK0CgirOhlpYdaUR+pjqnr3yeS+WsK6HW1I=;
	b=je8jwUn5tcP8uoTNTI9dRsY41piBxZcVjKBZV4u7LpLUhhK01q9rE1ErvLcDeKFBgZRY
	 Sghen41Tt6z2ASRyyz/UbAy2+vhsMWQoAEWgfn8RVNA0IYWMWuRkXUW9tBRoHT75D4C/q
	 1JQeFIo/2GdlulbQxFwaxM6XhASKPo7BPEF8sMA+zD5FSn0LzrQxrAGCjlQmC3bjwR2sL
	 EYvYp0Wzx5JkMyiSfce7BOMG6wjOFpICxrm/S3g9VS8Ob2Jx7BTyp732Y0sE7nt/oBkvA
	 qvEmTjuI+NGyjVWgwZymTUPwLAbITudN1LM9afuvaTT4Rp74VWCTxuRQitVCywrrbHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYFPFCgx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E42C606A32D;
	Sat,  7 Nov 2026 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYFPFCgx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC101F0089F;
	Sat,  7 Nov 2026 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065332;
	bh=sovWPRveeK0CgirOhlpYdaUR+pjqnr3yeS+WsK6HW1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYFPFCgxEA92ITqsqFes8I3JBI6ubrPqod5vC8l8qF7f5DGqVkpfSBMXbwi3NzmuT
	 JQE1iVHn9louXiFkGWB/7fRPwMn2lxJEZDE+8/3rpytr4y3Trt36Q+nfOT42mds+4s
	 WoFMyD0AsKdzRY6TZNIB+DyZu/fIUrHleFQ6jseQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
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
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1072/1257] mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
Date: Sat,  7 Nov 2026 08:56:08 -0500
Message-ID: <20261107135008.877864897@linuxfoundation.org>
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

[ Upstream commit c37e9d9411a12240a60ca3796d3cbb496e6258a2 ]

UFFD PTE bit handling is a bit like swiss cheese, in particular with
recently added RWP mode. Having uffd-wp markers outside uffd-wp VMAs
already confused this code in the past and resulted in uffd-pte bits
confusing other code later.

Let's play safe and just ignore these markers in hugetlb_no_page(), not
silently propagating the uffd-wp PTE bit.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-8-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5757466923cc2..2dad6b366cd7b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5945,8 +5945,11 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
+	 *
+	 * TODO: fix all cases where uffd-wp markers remain in VMAs that are no
+	 * longer registered with uffd.
 	 */
-	if (unlikely(pte_is_uffd_wp_marker(vmf->orig_pte)))
+	if (unlikely(userfaultfd_wp(vma) && pte_is_uffd_wp_marker(vmf->orig_pte)))
 		new_pte = huge_pte_mkuffd(new_pte);
 	set_huge_pte_at(mm, vmf->address, vmf->pte, new_pte, huge_page_size(h));
 
-- 
2.53.0



