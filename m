Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C821C05
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 01:08:40 +0000 (UTC)
Date: Wed, 23 Nov 2022 17:08:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1669252113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HbGKRpnmQ412qgzjYpg5qAefunJk3cmUerajjIaJjns=;
	b=i293Z+eNKoC7A7TGvOYCGKnkEZnA8XUTscB7PnvZQ/+kDgqxcKXRGARFMehN60cyDmpMy/
	VKH4YPhmRJi2FmfnPtR7Ci6Yb3cL0y9fsUKdQeLcoNV3oHN5Rp5qzVhMPgcbxLkAofJXTq
	/vA1DQNNPQdC85s07wVF/DxxlL5SUZ0=
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
Subject: Re: [PATCH 02/12] mm, slub: add CONFIG_SLUB_TINY
Message-ID: <Y37EDVJekrtaxSow@P9FQF9L96D.corp.robot.car>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-3-vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 21, 2022 at 06:11:52PM +0100, Vlastimil Babka wrote:
> For tiny systems that have used SLOB until now, SLUB might be
> impractical due to its higher memory usage. To help with that, introduce
> an option CONFIG_SLUB_TINY that modifies SLUB to use less memory.
> This is done by sacrificing scalability, security and debugging
> features, therefore not recommended for any system with more than 16MB
> RAM.
> 
> This commit introduces the option and uses it to set other related
> options in a way that reduces memory usage.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
