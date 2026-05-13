Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272883E9C37;
	Wed, 13 May 2026 11:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778673544; cv=none; b=As89dsvYtOswJ+Ouaraj8EUYngOEQ5GBSL3w00+y6Q7L/wjYHnl0bIIIXUNmEfi9i/DElL5VEGPnz4q/MQixF7CATR1icLidis258c+/A1QaHLFzV/c3hKeUsFrKNxxLsQC8XBsjOmQhpynRb+jINo1NEvEBLzG8aLPDdpVh1eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778673544; c=relaxed/simple;
	bh=QpEWKfj3nMfFvqO5zXCktumS2/fclPjU/a7tt4xrXs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3PIr3zNxB3f6MnjFTgzDg8J/VmWlln+4ZL5tg4yROBPs85OSyLpWCApWysXp+Swa9G7+E0nlDQpZJ5Q469KvGJ6573o/a7WERTTEawY9X5UnEUT22kfvvCb2QKhXPkHMLSM4iTLRKv5D78c7J7rEHc7pPcGFHd4Q6YOu0/+Y2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEUklbUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEUklbUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A36C2BCB7;
	Wed, 13 May 2026 11:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778673543;
	bh=QpEWKfj3nMfFvqO5zXCktumS2/fclPjU/a7tt4xrXs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CEUklbUi172woDjaC+PElREJ5ZsqAymL0hhIsyk7NL1m/6U6P8FSuA9zBleebcZ17
	 43IGZv0GPi1tVNtfyrINpNfqT1jh5Be+vLcSEGNP2ShtJL86EOK5Ahav3yJP5I4JIT
	 X4i3zZPqBs2oQPo7veHsnH64GLfa6YjJogqffruI=
Date: Wed, 13 May 2026 13:59:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrea Righi <arighi@nvidia.com>
Cc: Peter Schneider <pschneider1968@googlemail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7.0 000/307] 7.0.7-rc1 review
Message-ID: <2026051300-coyness-ride-0bf1@gregkh>
References: <20260512173940.117428952@linuxfoundation.org>
 <90116a48-a75d-48c9-b09f-97f541c0031c@googlemail.com>
 <agQUuUpJ2fu1JfVG@gpd4>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agQUuUpJ2fu1JfVG@gpd4>

On Wed, May 13, 2026 at 08:05:45AM +0200, Andrea Righi wrote:
> Hello,
> 
> On Wed, May 13, 2026 at 01:31:00AM +0200, Peter Schneider wrote:
> > Hi Greg,
> > 
> > Am 12.05.2026 um 19:36 schrieb Greg Kroah-Hartman:
> > > This is the start of the stable review cycle for the 7.0.7 release.
> > > There are 307 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Trying to build 7.0.7-rc1, I get this build error.
> > 
> > In file included from kernel/sched/build_policy.c:62:
> > kernel/sched/ext.c: In function ‘bypass_lb_cpu’:
> > kernel/sched/ext.c:4019:35: error: ‘donor_rq’ undeclared (first use in this function); did you mean ‘donee_rq’?
> >  4019 |                 if (task_rq(p) != donor_rq)
> >       |                                   ^~~~~~~~
> >       |                                   donee_rq
> > kernel/sched/ext.c:4019:35: note: each undeclared identifier is reported only once for each function it appears in
> > make[4]: *** [scripts/Makefile.build:289: kernel/sched/build_policy.o] Fehler 1
> > make[3]: *** [scripts/Makefile.build:548: kernel/sched] Fehler 2
> > make[2]: *** [scripts/Makefile.build:548: kernel] Fehler 2
> > make[1]: *** [/usr/src/linux-stable-rc/Makefile:2108: .] Fehler 2
> > make: *** [Makefile:248: __sub-make] Fehler 2
> > root@linus:/usr/src/linux-stable-rc#
> > 
> > The offending line seems to be part of eb5b997dadc517 (sched_ext: Skip tasks with stale task_rq in bypass_lb_cpu())
> > Adding Tejun and Andrea to CC.
> 
> The upstream commit (da2d81b4118a) was written on top of ff06f727a941
> ("sched_ext: Move bypass_dsq into scx_sched_pcpu"), which renamed @rq to
> @donor_rq (among other things). That refactor is not in 7.0.y and it's not
> stable material.
> 
> I think The minimal fix is to rename donor_rq -> rq in the backported hunk, in
> 7.0.y the function still takes struct rq *rq directly, and that is the donor rq.
> 
> Greg, can you fold the following into the queued patch? Do you prefer a
> separate/updated patch?
> 
> Thanks,
> -Andrea
> 
>  kernel/sched/ext.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
> index 3cb8025b433e0..2bb7c7a902679 100644
> --- a/kernel/sched/ext.c
> +++ b/kernel/sched/ext.c
> @@ -4013,10 +4013,10 @@ static u32 bypass_lb_cpu(struct scx_sched *sch, struct rq *rq,
>  		/*
>  		 * If an earlier pass placed @p on @donor_dsq from a different
>  		 * CPU and the donee hasn't consumed it yet, @p is still on the
> -		 * previous CPU and task_rq(@p) != @donor_rq. @p can't be moved
> +		 * previous CPU and task_rq(@p) != @rq. @p can't be moved
>  		 * without its rq locked. Skip.
>  		 */
> -		if (task_rq(p) != donor_rq)
> +		if (task_rq(p) != rq)
>  			continue;
>  
>  		donee = cpumask_any_and_distribute(donee_mask, p->cpus_ptr);
> 

A whole new patch please.

thanks,

greg k-h
