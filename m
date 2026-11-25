Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619472;
	b=oq/XGQZtzho1X86UN2SuGcRG9O3fd9PHRdPMdn9B2/I0wAYM327QBFOHcbNRfpCqwJje
	 pL+g5aOJDp9jOEhJ69pruLLGMUgYRfqpxWueQopHB2GGPyraZoao18Bm6PMs4aKCQqPpK
	 uCZdSCvnNRQoTkPu1aPzOWKdgpjVzBhsKuG/U5K+deVM7LaYiG3gXFbTZXPpEMA4rfeIu
	 IgHnSqd/ctjc04JMROerdD/g9T/whDz9wMslStEjv7aZjbQIDs6A8qOw1UtbXzo/IbX6y
	 m3p+0HJdb33tkfLI8BVd0cY1ZqyREG5nosOajsiBps4XM4oNoeOdhkxPIu7sOEcZzog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o40aF3/0dy0eV5RKe2pBnT3bf+lJeBqAcSOSyM0LNVI=;
	b=zBx24QQDmYWJAe/Q0UATLz59Y95OiMblio0CKtQJ1VUQQ+yPtei4kZrB9rBsk2mBoxtM
	 LVYfsldBo9fJxZS4BvKj/qGtbOBYxM0A4QTJOcC1SztzdNJPe2jFw+ZDJEJGQ7eQn+Z62
	 Qc7aDLdVSqtVuGBvlJGrd4/xXtpUmR4XLPd5yBUaRoboTrdQrZEEIgADCr9f5rSeUSZeQ
	 WhoUdkxq3kw4xF0pZjjDuhGngz6pr3LCYja3pggKkhWX6dnBiYchet+2YyZt+B8zrruYF
	 goU/GkMRI/i0vdBXZt/SIJIHIaj3bGqbRX846F+yQqIN4IAilOOdxBpI+UMYXn1hZMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrqLJvI4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654CF606A31E;
	Wed, 25 Nov 2026 15:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrqLJvI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C961F000C4;
	Wed, 25 Nov 2026 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619472;
	bh=o40aF3/0dy0eV5RKe2pBnT3bf+lJeBqAcSOSyM0LNVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrqLJvI48varkUgeWTsUSNTRwCSAS9zwynxxytg0Ra+Le3pYbsdrxb7w4P1+VgOSl
	 7TVO0HuohZzbFIx4LyxKRkYDPSGlFXiubJOBM3n1/2txEkFGakPCK7NEYnIz2ROPCn
	 orgREoUVQHToKW8z8GxYgU7rbyvZTTb5uq4/RAVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.3 0608/1005] mm/page_alloc: clear ->private of deferred free pages
Date: Wed, 25 Nov 2026 15:32:26 +0100
Message-ID: <20261125143835.987542928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

commit aae6b83fe47ed8bff9195efbe1d191ec52e5436e upstream.

free_pages_nolock() and free_frozen_pages_nolock() put the page on
zone->trylock_free_pages if they get neither the pcp lock nor zone->lock.
add_page_to_zone_llist() keeps the order of the page in page->private.
The next free_one_page() which does get zone->lock passes these pages to
split_large_buddy() with ->private still set.

__free_one_page() writes ->private of the head of the resulting free page
only. If the deferred page is merged with its lower buddy, it becomes a
tail of that free page and keeps the order in ->private.

All other free pages which are not the head of a buddy have a ->private
of zero, and since commit 819bfbd47e49 ("mm/page_alloc: remove
set_page_private() in prep_compound_tail()") the allocator relies on it.
When the stale page is allocated again as a tail of a larger page:

 - prep_compound_tail() hits VM_WARN_ON_ONCE(tail->private);
 - with the page checks enabled, __free_pages_prepare() reports
   "BUG: Bad page state", "nonzero private", and leaks the whole page;
 - without them the value is seen by whoever uses that page next, e.g. as
   folio->private of a folio which is split off a large folio.

Only pages of an order above zero are affected. Those can be freed
through _nolock() by the stack depot (order 2) and by SLUB (a new slab
which cannot be added to the partial list by kmalloc_nolock()).

Clear ->private when the page is taken off the list.

Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://patch.msgid.link/20261103-pgalloc-ai-hotfixes-v2-1-e0d2890ab74f@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1580,6 +1580,8 @@ static void free_one_page(struct zone *z
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
 			unsigned int p_order = p->private;
 
+			/* It may end up as a tail of the merged free page. */
+			p->private = 0;
 			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
 			__count_vm_events(PGFREE, 1 << p_order);
 		}


