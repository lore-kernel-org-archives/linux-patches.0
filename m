Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB291C05
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 01:12:50 +0000 (UTC)
Date: Wed, 23 Nov 2022 17:12:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1669252368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NpmFzLv+gEbQLyUlhdmYGz0CPkD7MAW1WUDE2g6iLGg=;
	b=d5f8L4vmn+d5G6A4DKG3TcKRbyBR1WjmXW5h9SztC2KEWhqnFeg6+qOfdhCDeZKrky+EcY
	/g8AsIx41YBX2zoB2JnJv/dbCxCP3CUBjXYX0MoPzK8eSUTeFZ0svptDsrGXu4XDp7XxZs
	uJcxliu4reC1sCSTcVoAimbaeUkp1vI=
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
Subject: Re: [PATCH 04/12] mm, slub: retain no free slabs on partial list
 with CONFIG_SLUB_TINY
Message-ID: <Y37FDBXARS0me3u7@P9FQF9L96D.corp.robot.car>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-5-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-5-vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 21, 2022 at 06:11:54PM +0100, Vlastimil Babka wrote:
> SLUB will leave a number of slabs on the partial list even if they are
> empty, to avoid some slab freeing and reallocation. The goal of
> CONFIG_SLUB_TINY is to minimize memory overhead, so set the limits to 0
> for immediate slab page freeing.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
