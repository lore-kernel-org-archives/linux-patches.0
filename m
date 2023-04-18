Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCC8C944
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3Km/vnh/sBC4DQYO69Q00ljyDReo/R1BeGSdOPULOKw=; b=1L14NJ+lXlSRxbmu5FayimPVss
	bavZ6XsrainBIv/5bbMp3rBuUpTS3nQl+23Ul819ig5kO7uZAjLFcxDNOL0tNvLePvbwUuCG3pPTR
	4b1IIK8sejumG/QXJ1HuwBqTUUV/NaxX/YGGbqDkbk0zRph/UfJ6IlC8kk9s4IZE5fTfrdlTponOK
	qOX7dWJyeft5qvMgd1rlX2Npl/Y0nyX4gWgL2NZo56NopoNeGgdfOVJQzHFpwbx/dFYbYGuh+tp7Z
	FbccCeJ2adPHUoMzGKF4bY/db598SuCcpN0MslTePYUdyT+VFw/8RbXQEQJiKsWikTVsJ89d/IDLS
	h1pGV9KQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1posk5-003MpZ-21;
	Tue, 18 Apr 2023 21:20:01 +0000
Date: Tue, 18 Apr 2023 14:20:01 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org,
	linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 5/6] shmem: update documentation
Message-ID: <ZD8JgfphE+HWCGve@bombadil.infradead.org>
References: <20230309230545.2930737-1-mcgrof@kernel.org>
 <20230309230545.2930737-6-mcgrof@kernel.org>
 <a4afef5c-27e4-5e67-9771-374132db61f8@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4afef5c-27e4-5e67-9771-374132db61f8@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 17, 2023 at 10:29:59PM -0700, Hugh Dickins wrote:
> On Thu, 9 Mar 2023, Luis Chamberlain wrote:
> 
> > Update the docs to reflect a bit better why some folks prefer tmpfs
> > over ramfs and clarify a bit more about the difference between brd
> > ramdisks.
> > 
> > While at it, add THP docs for tmpfs, both the mount options and the
> > sysfs file.
> 
> Okay: the original canonical reference for THP options on tmpfs has
> been Documentation/admin-guide/mm/transhuge.rst.  You're right that
> they would be helpful here too: IIRC (but I might well be confusing
> with our Google tree) we used to have them documented in both places,
> but grew tired of keeping the two in synch.  You're volunteering to
> do so! so please check now that they tell the same story.

Hehe. Sure, we should just make one point to the other. Which one should
be the authoritive source?

> But nowadays, "man 5 tmpfs" is much more important (and that might
> give you a hint for what needs to be done after this series goes into
> 6.4-rc - and I wonder if there are tmpfs manpage updates needed from
> Christian for idmapped too? or already taken care of?).

Sure, what's the man page git tree to use? I can do that once these
documents are settled as well. I'll send fixes.

> There's a little detail we do need you to remove, indicated below.
> 
> > +======  ============================================================
> > +huge=0  never: disables huge pages for the mount
> > +huge=1  always: enables huge pages for the mount
> > +huge=2  within_size: only allocate huge pages if the page will be
> > +        fully within i_size, also respect fadvise()/madvise() hints.
> > +huge=3  advise: only allocate huge pages if requested with
> > +        fadvise()/madvise()
> 
> You're taking the source too literally there.  Minor point is that there
> is no fadvise() for this, to date anyway.  Major point is: have you tried
> mounting tmpfs with huge=0 etc?  I did propose "huge=0" and "huge=1" years
> ago, but those "never" went in, it's "always" been the named options.
> Please remove those misleading numbers, it's "huge=never" etc.

Will do.

> > +==  ============================================================
> > +-1  deny: disables huge on shm_mnt and all mounts, for
> > +    emergency use
> > +-2  force: enables huge on shm_mnt and all mounts, w/o needing
> > +    option, for testing
> 
> Likewise here, please delete the invalid "-1" and "-2" notations,
> -1 and -2 are just #defines for use in the kernel source.

ok!

> And the description above is not quite accurate: it is very hard to
> describe shmem_enabled, partly because it combines two different things.
> It's partly the "huge=" mount option for any "internal mount", those
> things like SysV SHM and memfd and i915 and shared-anonymous: the shmem
> which has no user-visible mount to hold the option.  But also these
> "deny" and "force" overrides affecting *all* internal and visible mounts.

I see thanks.

  Luis
