Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622907;
	b=Z4uOzbbPTgOWvH/sHLE3wOzc5h2ZWch+NcT4uSCeYW36bHlbQBi6iVE8/Wl0vKXUCDhj
	 KNupH+goafw82n48xrLq6IaPJhgFUMMssKkA4DVjY2ssgGd0YTdzmWdIqos+B+r035TRl
	 yqqEJ2Yvuj7Q3Chl1onbeEi+1kCeMsdd1O+0gozhd/v0fUV/SWimKQ+ZmdgZ1mdrpS+Qy
	 DgAFllQNnXSLGYCLLLDzYQ+E4FCe4cMxsCEZBDs5+Kbba6Ocvx/GU0EItalp8ctQaSPbF
	 JB0c/tWd2Aufzt3nfSdeVunj/hXxTof6qkm9yZsmkso+t7R+cHEMcxTZ2v/6judIcXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7WCTsA9ctwEHtnM/XSGw8BX2X0s9E4ZaQ/CDpjafUA=;
	b=hL4YeiajPuPK0NWijihe3rIc3CWx4vs6wAwXV2q8DkgUcxb/9Q6EHb9CS3mZ0i6x3gUt
	 EEDunOoKJ1Ystd6gnDtIqrZO06kPeeL3XA7NNsviiZvjyAnQ2iSY2g07C5AbcrDx+I7eP
	 AUO9N/cxk74JnLoGVnmZT1P9cN616xHVZWXOe8rrcwxg58cZ55k3B4YljSez7Kqsw0POT
	 W5JeNGqbhKxZzzn+sRJP8ko9GGOxlmIQB6Y9/cQ0IqjownMUOb+lqlJBqG3vxpRbwmb4N
	 EeI8c+dKePbO3bYXujTPZn5bDBSEvypO0mXh4l/stnFnUZiuv7EcPpNS4ZC2b/hl3Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jdTgldky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D34F606A32C;
	Wed, 25 Nov 2026 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jdTgldky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18251F000E0;
	Wed, 25 Nov 2026 16:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622906;
	bh=n7WCTsA9ctwEHtnM/XSGw8BX2X0s9E4ZaQ/CDpjafUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdTgldkyGGHqIs9lTbwPZXyX/0/GP878aHuHndsQyml5uRnWA61rxVhQ2MgSpAP7f
	 0p9u1HhkqOCj6xK0bNNW2AMcPSN5gdlVNEqk68zy4hwsWROUaw6o1K3XBvuD2wvsDO
	 7dcC+O7M8q2l+CDZn3f5KOcoqPmNWVUJFDryD6nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 686/990] mm/page_alloc: clear ->private of deferred free pages
Date: Wed, 25 Nov 2026 15:34:13 +0100
Message-ID: <20261125143838.156353528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -1608,6 +1608,8 @@ static void free_one_page(struct zone *z
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
 			unsigned int p_order = p->private;
 
+			/* It may end up as a tail of the merged free page. */
+			p->private = 0;
 			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
 			__count_vm_events(PGFREE, 1 << p_order);
 		}


