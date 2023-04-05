Received: from outbound-smtp55.blacknight.com (outbound-smtp55.blacknight.com [46.22.136.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01A229A9
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 14:55:22 +0000 (UTC)
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
	by outbound-smtp55.blacknight.com (Postfix) with ESMTPS id F2525FAE47
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 15:50:12 +0100 (IST)
Received: (qmail 1459 invoked from network); 5 Apr 2023 14:50:12 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.21.103])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 5 Apr 2023 14:50:12 -0000
Date: Wed, 5 Apr 2023 15:50:10 +0100
From: Mel Gorman <mgorman@techsingularity.net>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
	Alexander Halbuer <halbuer@sra.uni-hannover.de>
Subject: Re: [PATCH] mm, page_alloc: use check_pages_enabled static key to
 check tail pages
Message-ID: <20230405145010.lrrc4gnxtaqjlnil@techsingularity.net>
References: <20230405142840.11068-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20230405142840.11068-1-vbabka@suse.cz>

On Wed, Apr 05, 2023 at 04:28:40PM +0200, Vlastimil Babka wrote:
> Commit 700d2e9a36b9 ("mm, page_alloc: reduce page alloc/free sanity
> checks") has introduced a new static key check_pages_enabled to control
> when struct pages are sanity checked during allocation and freeing. Mel
> Gorman suggested that free_tail_pages_check() could use this static key
> as well, instead of relying on CONFIG_DEBUG_VM. That makes sense, so do
> that. Also rename the function to free_tail_page_prepare() because it
> works on a single tail page and has a struct page preparation component
> as well as the optional checking component.
> Also remove some unnecessary unlikely() within static_branch_unlikely()
> statements that Mel pointed out for commit 700d2e9a36b9.
> 
> Suggested-by: Mel Gorman <mgorman@techsingularity.net>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
