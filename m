Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C83B185C
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 07:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+xoloHvgkvnUwe+7/mW4SGlzimEaFuLJW1cg0sgwA58=; b=DjYX9YfvtOFYsLi2tr8jvgeYc0
	xWYqoPI1MrDacRMh6Pm4KaJs2gHpJ/wy4G02uqxMSMs/CM5G6r3RQaAf4WPjK9/caYmZpBr7RzcV+
	MomD4y0ZyP43q6qy80wes0rvLXilUmDaVZhqwQRqySsyN8YD0PFcrWu1iG/iOuROX9VXWJ2zPMRyC
	rsceboL9zWFzjT9+nUOhskUitKzIPA3SlreHvnwsocTUmWMTexgmVVzKRwl0kEB+2VYz5PJbaJSxJ
	cL/lMy5nWX+e14Xv2PvoNDBb9j4Ikclt485t/MeuwMZsSi79eRpIb+IU27fSPe/Pr4eRzeyB8/FGH
	xIQrC0sA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1phQay-00Gy5R-32;
	Wed, 29 Mar 2023 07:51:48 +0000
Date: Wed, 29 Mar 2023 00:51:48 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de, song@kernel.org,
	rppt@kernel.org, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
Message-ID: <ZCPuFLDgU5fBFtug@bombadil.infradead.org>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
 <20230329053149.3976378-5-mcgrof@kernel.org>
 <20230329072112.GG4253@hirez.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329072112.GG4253@hirez.programming.kicks-ass.net>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Mar 29, 2023 at 09:21:12AM +0200, Peter Zijlstra wrote:
> On Tue, Mar 28, 2023 at 10:31:46PM -0700, Luis Chamberlain wrote:
> > While I looked at re-using the old kernel/kmod.c (now kernel/module/kmod.c)
> > concurrency delimiter methodology for another place in the kernel Linus
> > noted that this could be simply replaced with a sempahore [0].
> > 
> > So add that so we we don't re-invent the wheel and make it obvious to use.
> > 
> > [0] https://lore.kernel.org/all/CAHk-=whkj6=wyi201JXkw9iT_eTUTsSx+Yb9d4OgmZFjDJA18g@mail.gmail.com/
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  include/linux/semaphore.h | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
> > index 6694d0019a68..2ecdffdb9814 100644
> > --- a/include/linux/semaphore.h
> > +++ b/include/linux/semaphore.h
> > @@ -28,6 +28,9 @@ struct semaphore {
> >  #define DEFINE_SEMAPHORE(name)	\
> >  	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
> >  
> > +#define CONCURRENCY_LIMITER(name, n) \
> > +	struct semaphore name = __SEMAPHORE_INITIALIZER(name, n)
> > +
> 
> Why should this live in semaphore.h?

I have no preference, but sharing seems to have been better. Do you
have any recommendations?

  Luis
