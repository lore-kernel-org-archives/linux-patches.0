Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A488F68
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GjHBl1+/CwPHKTVR/f8ORsKmJRUSdIW+S2uB+MujBiI=; b=wZESZkica5ceEZQ6YDd2YCeaJ6
	+cw182OK6Ct7BeOeJ0COz5RCw4qLOpeMKU/V8lTZL+maVaJWEyRde8LuRji4y58dSl1RW4X+svdyq
	hH8mjmArSAuGPs3XX0uGcmmxHKFYxOU1MBdqVAN3KuTvq31tu6XG9Pox+fzRzVl/VW1Rgx4bj++rs
	wXZ8cnkaOPrHuiNBfH9fsu4NVZAM62/icFFLAzhTKzr4ZWKTw1My0PGfpXJj5cprO/lYQHOoy/6Gx
	l2Bd7Ekav8n/vvdnR0i8EiCvpcvbOa+8zNe1/mOtS85NxRMJjUzXX6QSh57Kh8zDhyj5Wx2QZ7Rgm
	GLXRP1lg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1msUwb-000aw3-T2; Wed, 01 Dec 2021 19:07:06 +0000
Date: Wed, 1 Dec 2021 19:07:05 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	iommu@lists.linux-foundation.org,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 29/33] iommu: Use put_pages_list
Message-ID: <YafH2YT+uxn/y4sV@casper.infradead.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-30-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-30-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:06PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> page->freelist is for the use of slab.  We already have the ability
> to free a list of pages in the core mm, but it requires the use of a
> list_head and for the pages to be chained together through page->lru.
> Switch the iommu code over to using put_pages_list().

FYI, this is going to have conflicts with
https://lore.kernel.org/lkml/cover.1637671820.git.robin.murphy@arm.com/

I'm not sure what the appropriate resolution is going to be here;
maybe hold back part of this patch series to the following merge
window to give the iommu people time to merge their own patches?
