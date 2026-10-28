Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217043;
	b=ZdkSJkce8zvs9RjDG2ShVhtk8cbYoVIFOEzcFZ3pIwPAId7OG2u4LlU4/9xk0uS285+L
	 aGjjnRXYUQfLi1nceHZ7HxgMPxJ8YiEBMMylwSe6JtgiEreagGdUL9wuyKaZgYdl2LdLc
	 cZm3DyGUuF9an2244oI36a8t5/OI7ttOc4K1e+E5WfYMagFkVJGOIaC6/oByzWUSDJUex
	 +VYBFMXs/83ykGkCXhxfWtJdaX/Ik2vhT8VJp8YdBd5XlyBRjEKXgVXHcwAY1kUl5Kl5A
	 wa+pYWcna/fPNmBXPhKdff+VTTcizRwBMbvZCDYlEMKFx/vJfGSW4Iymtlhc+/d25xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ywwflKlOrccohneGkvnrU49Xqng8vivzryiNn+8I1ic=;
	b=LTXgrN0ZOpqG7D2sk8d74UCMHETmlOxne+D0cW96w66S20pElUR8kvSyjXnRD4X2iC1X
	 NiQCEtEqmTb9FF4J1JkQC0yV+pu4BwJksHar9aw5m+50C2b/cUvBwKRz/1qfsSnsSLCIU
	 I59M1ygMVEDgGBBLffMdxDN95w0fefkqL6KALF763AMkNIQYxYCcUJMnqdQHbHGI05n/3
	 FEbldwoQGlw2vCFI7MW3XAK+aKKunsXPgq7dxD+5xxKYLr1ZQx8zQ9glcDNz6YqM1/x0A
	 /QKDCPZoS3BHpTq5bI/27UvqBmEwh9B/3MZHIHivjynqFM2SJSpssNJzFcGrE4nD6yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2blZgetd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1990C606A31A;
	Wed, 28 Oct 2026 19:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2blZgetd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F281F031E7;
	Wed, 28 Oct 2026 19:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217043;
	bh=ywwflKlOrccohneGkvnrU49Xqng8vivzryiNn+8I1ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2blZgetdm/dp/H2dwoWHzaeDwjb02SyawDFMzq05iIMky41H+vcOLTYLY5VUrqyK6
	 BYWLPIWwpbs6FFPO3Rbc1Vlk5Y1ajNDneMjkVRZdB76uGiV0ZmQsDGBdTuaxoLWubZ
	 E1nMZptJF11JMkzszs0QfK1rIwrqGasIRnv14eIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Dev Jain <dev.jain@arm.com>,
	Kairui Song <ryncsn@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1767/1887] mm/huge_memory: initialise workingset state before folio split
Date: Wed, 28 Oct 2026 18:04:23 +0100
Message-ID: <20261028170539.666427556@linuxfoundation.org>
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

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit aca1f2d5de17e138bc6c4859126b77e516b82541 ]

xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
__folio_split() leaves the xa_state's xa_lru unset.  That lets a live,
memcg-charged xa_node exist without being linked into the mapping's
shadow_nodes list_lru; when reclaim later walks the list_lru it trips
VM_WARN_ON(!css_is_dying()).

Use mapping_set_update() to install both the workingset update callback
and the shadow_nodes list_lru on the xa_state.

Link: https://lore.kernel.org/20260725101419.3938406-1-matt@readmodwrite.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c9584bdd1ffca..339f2986f2c6a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2750,6 +2750,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 			goto out;
 		}
 
+		mapping_set_update(&xas, mapping);
+
 		xas_split_alloc(&xas, folio, folio_order(folio), gfp);
 		if (xas_error(&xas)) {
 			ret = xas_error(&xas);
-- 
2.53.0



