Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE56121D5AF;
	Mon,  7 Apr 2025 20:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744059381; cv=none; b=uTLEejTUOuepknueLLnJwyFkAWTjMTIpWpBEsX5RO8daCyhUvBhRNeLGcQrAYiA43gwaWyCQ4xIlfx0a7HOpD80DGQ0UkK2BtMdNs91WvRVXIzguIJJhOuwawLUVXZqwg15yfWwgfWQftvqNW9O7ve6Xgq1tJFRx59mibVOP0tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744059381; c=relaxed/simple;
	bh=RO7w2J6nAsfI/DwvkstqI7+SgGlQhV7BLLe0jHCLBy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajjF81C2gdkVoPQOB+CEl1D8mUDjscUbB5ujNE0zvS4I3KQ6ayzgC7o0OfFEzRbGogrYV5SAImstz5n6nBYSscN2oaXtCi6SGzQs/7gWmKu2BLm8e0MPzlOtmt/w13m/0jL7+e4ivsY+Qm2s7m8EImizUcJPpBKu93LxelN2z8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uvk33lDi; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uvk33lDi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QnrWz52DdRgvqwK1WLvja1IK58llQGZZoh3Yy09j65w=; b=uvk33lDiVmEiX3Vp0yZtD2zb+O
	u9xMm1aOBGGvQuD535znuOw7TfMj7VtMDLJRlqzBBHzt9LCWktI09BuIRv+IcKBtrZ7ut3ZL19Qhx
	4Fun5d4CUsU7ZjA7opKlh0Ctiu2WYit2Kqj34/BxqKLAVaLuvaFSn8ZChr+di7w+CL3nEl81rU/94
	Zc9kNNiiN5iareMTUpefV81hby1gYApNyn+sAh2mnX7lzD8xTkcwz2M8U+rF6+wsEkRWSphbuTCto
	JqycVCem5Rqq+TMK6DD1HLCohp66z8x9bmstUIZhF3AdMCuR+o3exCLw0MZyRBFuZhI9/yU75ST9L
	I13aC5sA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1tVt-0000000DhOr-3XX9;
	Mon, 07 Apr 2025 20:56:14 +0000
Date: Mon, 7 Apr 2025 21:56:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page
 allocator
Message-ID: <Z_Q77Xi-_zeSYyrJ@casper.infradead.org>
References: <20250407200508.121357-3-vbabka@suse.cz>
 <20250407200508.121357-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407200508.121357-4-vbabka@suse.cz>

On Mon, Apr 07, 2025 at 10:05:10PM +0200, Vlastimil Babka wrote:
> Extra reviewers would be welcome, including/not limited the people I
> Cc'd based on my recollection and get_maintainers --git
> Also if I missed any related file please lmk. Thanks.

I appreciate the offer.  I feel entirely unqualified to review patches
to the page allocator, although I'll probably end up touching it quite
a lot when we move to separately allocated folios.
