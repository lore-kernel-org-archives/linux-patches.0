Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B691C05
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 01:16:23 +0000 (UTC)
Date: Wed, 23 Nov 2022 17:16:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1669252582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X10ndcuj6qHWzQmi4w31+6lj2UzJf4XjRKHTMNK22xA=;
	b=e0Q3wb/H+DLIDd0sI4f0wcZ9ndVg9eOU4za2VvlRXG1glYig38lDN8jYW9chPpHFfsYm/Q
	LgRQJORtMKohoWvwd+/13AI8ddbb7/bQBGZoY7kzeXMdywfPYrubPq9VeyAsIMhRw9eNWq
	H+Z8YvM+em1ArcUWSfnyzQntsE+CRdk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] mm, slub: lower the default slub_max_order with
 CONFIG_SLUB_TINY
Message-ID: <Y37F4R2Wkw04qzgY@P9FQF9L96D.corp.robot.car>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-6-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-6-vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 21, 2022 at 06:11:55PM +0100, Vlastimil Babka wrote:
> With CONFIG_SLUB_TINY we want to minimize memory overhead. By lowering
> the default slub_max_order we can make slab allocations use smaller
> pages. However depending on object sizes, order-0 might not be the best
> due to increased fragmentation. When testing on a 8MB RAM k210 system by
> Damien Le Moal [1], slub_max_order=1 had the best results, so use that
> as the default for CONFIG_SLUB_TINY.
> 
> [1] https://lore.kernel.org/all/6a1883c4-4c3f-545a-90e8-2cd805bcf4ae@opensource.wdc.com/
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
