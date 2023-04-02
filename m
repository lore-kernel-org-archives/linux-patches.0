Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8267617E2
	for <patches@lists.linux.dev>; Sun,  2 Apr 2023 11:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ejIxfkJdvGi4VhuEM+uIPq/ME4Gwyhn3SUJxOyVKLaA=; b=jvoSyuRl6lHbAAAK+auNjlOwCA
	DRVle1xLadbl+WdFHAhI4Sq/CeDhKGMUHxFeHUHvjTzZImykgjTP1/mgFKSjBUVklaLoQ8DYrmerI
	Z23x4AVbIWmM8mSO6xI7ngse8vvtwxYOici2o6elhSdP5+kIJSl1wetqhNjn14HYyC3Kh/Ngjogs1
	EOHjN4Z+wsx0p6Eg6GUjCuMxGGPPdca8RZqQW/55aNmnhL4wzsiLDYlGy9QTi/7bxsc32tLIP0Oud
	0q0ai9+N7lyX54wZgJAVtFPRSyQUPXVaoBFMWDa0zMENu5PjsnEEbBrNurpFlPJhDdZHHIVBXf9jh
	PmLlRN6A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pivVK-00DDBb-El; Sun, 02 Apr 2023 11:04:10 +0000
Date: Sun, 2 Apr 2023 12:04:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: =?utf-8?B?6YOt6L6J?= <guohui@uniontech.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] mm: remove all the slab allocators
Message-ID: <ZClhKouKa5e6/jha@casper.infradead.org>
References: <20230401094658.11146-1-vbabka@suse.cz>
 <D9446192D1350A06+edeebc7d-b55d-571e-ef25-98ecb9d2662b@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D9446192D1350A06+edeebc7d-b55d-571e-ef25-98ecb9d2662b@uniontech.com>

On Sun, Apr 02, 2023 at 05:09:14PM +0800, 郭辉 wrote:
> On 4/1/23 5:46 PM, Vlastimil Babka wrote:
> > As the SLOB removal is on track and the SLAB removal is planned, I have
> > realized - why should we stop there and not remove also SLUB? What's a
> > slab allocator good for in 2023? The RAM sizes are getting larger and
> > the modules cheaper [1]. The object constructor trick was perhaps
> > interesting in 1994, but not with contemporary CPUs. So all the slab
> > allocator does today is just adding an unnecessary layer of complexity
> > over the page allocator.
> 
> The slab allocator is very core and very important to the Linux kernel.
> After the patch is merged into the mainline, it will have a very profound
> impact on the development of the Linux kernel.

https://en.wikipedia.org/wiki/April_Fools%27_Day
