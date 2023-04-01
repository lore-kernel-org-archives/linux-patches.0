Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840363C39
	for <patches@lists.linux.dev>; Sat,  1 Apr 2023 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C6H0rrg5NJ+2lYtireHy454h3AJn13XdmPAVV6vVWgc=; b=ZSuCN07jL/SIC0g2Rz9ooxcdD6
	7iZ/vnk7Mti73k29bOGwlhJ5oWBMDXG1LfFuNj9fLpPiZuLOm+iWxg61udPit5t0hiMfTj6zINR6i
	hesQgmNVyNfEO7faG0JWXneIzIF6frMRFJIdM+FiU99G2U9+pdo0DeBDgkzsyEyV7K/u3fCe/amVD
	UEjXaFMvszAtcuGmDZVPm8vXa3/qMROqjmUThR2VrwijEuSnrC747j3AHfzaXn0BoJY9d5Ke3fBIj
	0RkejF+HrdCNAMO2k+5+FtMv/JuufdUJbyjbBFNRUwtjg3pvbq1XRH2IvntMlkRoXF+ZuH5ertCe2
	eIelZXmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1picwj-00CW7k-5l; Sat, 01 Apr 2023 15:15:13 +0000
Date: Sat, 1 Apr 2023 16:15:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] mm: remove all the slab allocators
Message-ID: <ZChKgQ35wLEpcQ0i@casper.infradead.org>
References: <20230401094658.11146-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401094658.11146-1-vbabka@suse.cz>

On Sat, Apr 01, 2023 at 11:46:58AM +0200, Vlastimil Babka wrote:
> As the SLOB removal is on track and the SLAB removal is planned, I have
> realized - why should we stop there and not remove also SLUB? What's a
> slab allocator good for in 2023? The RAM sizes are getting larger and
> the modules cheaper [1]. The object constructor trick was perhaps
> interesting in 1994, but not with contemporary CPUs. So all the slab
> allocator does today is just adding an unnecessary layer of complexity
> over the page allocator.

Acked-by: Poisson D'Avril (Oracle) <willy@infradead.org>
