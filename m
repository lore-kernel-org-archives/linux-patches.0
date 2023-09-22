Received: from out-207.mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEC248854
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 23:00:39 +0000 (UTC)
Date: Fri, 22 Sep 2023 16:00:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695423637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xnLthAI2KKZwUYazrEPUSMFwID0MKjI3FCNZtFBM4m4=;
	b=E35HnXox4DMrYu3DkYtdgmp0uOW7ubbbmSyrum1CRnX+YpPXnGRoXIqr21W5ok6+a5jcR5
	KJdYqD8of5GS6tMtn3L1CKtyBVVxIrjiG8nUcORjD1mPjNYsdtJSFSZOomwvYiNfPOr+XR
	Rqo+dUaRoJrsrQX0lusdx455KWZkuxg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <ZQ4cjqQLhgX1pOVX@P9FQF9L96D.corp.robot.car>
References: <20230917191040.964416434@linuxfoundation.org>
 <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>
 <101987a1-b1ab-429d-af03-b6bdf6216474@linux.microsoft.com>
 <ZQrSXh+riB7NnZuE@dhcp22.suse.cz>
 <4eb47d6a-b127-4aad-af30-896c3b9505b4@linux.microsoft.com>
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 20, 2023 at 03:47:37PM +0200, Michal Hocko wrote:
> On Wed 20-09-23 15:25:23, Jeremi Piotrowski wrote:
> > On 9/20/2023 1:07 PM, Michal Hocko wrote:
> [...]
> > > I mean, normally I would be just fine reverting this API change because
> > > it is disruptive but the only way to have the file available and not
> > > break somebody is to revert 58056f77502f ("memcg, kmem: further
> > > deprecate kmem.limit_in_bytes") as well. Or to ignore any value written
> > > there but that sounds rather dubious. Although one could argue this
> > > would mimic nokmem kernel option.
> > > 
> > 
> > I just want to make sure we don't introduce yet another new behavior in this legacy
> > system. I have not seen breakage due to 58056f77502f. Mimicing nokmem sounds good but
> > does this mean "don't enforce limits" (that should be fine) or "ignore writes to the limit"
> > (=don't event store the written limit). The latter might have unintended consequences.
> 
> Yes it would mean that the limit is never enforced. Bad as it is the
> thing is that the hard limit on kernel memory is broken by design and
> unfixable.  This causes all sorts of unexpected kernel allocation
> failures that this is simply unsafe to use.
> 
> All that being said I can see the following options
> 1) keep the current upstream status and not export the file
> 2) revert both 58056f77502f and 86327e8eb94 and make it clear
>    that kmem.limit_in_bytes is unsupported so failures or misbehavior
>    as a result of the limit being hit are likely not going to be
>    investigated or fixed.
> 3) reverting like in 2) but never inforce the limit (so basically nokmem
>    semantic)

Since it's a part of cgroup v1 interface, which is in a frozen state as a whole,
and there is no significant (performance, code complexity) benefit of
additionally deprecating kmem.limit_in_bytes, I vote for 2).
1) is also an option.

Thanks!
