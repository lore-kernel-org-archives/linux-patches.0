Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CA04C89;
	Sat, 15 Jun 2024 11:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718449534; cv=none; b=TCA1tJ6tY5y413HJ8usas/wUOH3Soy4hJYTNUtSQAi+JVvsiDDJPzNKFieQRcaauD8dBDuFjyA7EDG811hCO+Qnwe8xx68gRLfRdGJ+rYeU56wXzGBMkQYO2L0M7vID+0NRu1UJyjtCVWd5F1o2GHTJlMqJm5nKwZTTwJxbMQyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718449534; c=relaxed/simple;
	bh=NjSnYApBpEKzg1wldrFL9dWzvZbRrn57tl7B4H9Z03w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEQn4d/9ssIp0zhnh1KbzlUbWwoY7HJfOEK09r4CienfKoA/yccls9r8A/DHgqhpNl9jk+FIpC/87LGGJInZIbraO992bwp7T+hDVPHipNJ4RtkMKqra12S8VxEg/BPovLrlFnE3/azZFvA9JzkC/a3kjXKdBBH/hnQ1yt2mRjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ti8/Jm2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ti8/Jm2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A107C116B1;
	Sat, 15 Jun 2024 11:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718449534;
	bh=NjSnYApBpEKzg1wldrFL9dWzvZbRrn57tl7B4H9Z03w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ti8/Jm2elfxQ4YSSbQOlPs6IiFCgDi7tVX5EgxfdTlS3NN6S6U4If7CW0t0FlrrnT
	 wGuIsbZF8kpohZiS0QtEDPSZsxSmb/gawsavcn4vXzUXEzmLGbZ1y9+pKHaqo3gEtn
	 CVB4Q4ZASoh4LtYugQeoSdgoHYskA9fQ0bVB+wPE=
Date: Sat, 15 Jun 2024 13:05:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	Kamalesh Babulal <kamalesh.babulal@oracle.com>, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	acme@redhat.com, namhyung@kernel.org, gpavithrasha@gmail.com,
	irogers@google.com, Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
Message-ID: <2024061530-dress-powdery-c464@gregkh>
References: <20240613113302.116811394@linuxfoundation.org>
 <b6548098-de01-4ee1-87c8-6036cb1e3073@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6548098-de01-4ee1-87c8-6036cb1e3073@oracle.com>

On Fri, Jun 14, 2024 at 02:10:26PM +0530, Harshit Mogalapalli wrote:
> Hello Greg and Sasha,
> 
> On 13/06/24 16:59, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.161 release.
> > There are 402 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> perf build breaks on 5.15.161:(and on 5.4.278, 5.10.219)
> 
> 
> In file included from util/cache.h:7,
>                  from builtin-annotate.c:13:
> util/../ui/ui.h:5:10: fatal error: ../util/mutex.h: No such file or
> directory
>     5 | #include "../util/mutex.h"
>       |          ^~~~~~~~~~~~~~~~~
> compilation terminated.
> make[3]: *** [/home/linux-stable-rc/tools/build/Makefile.build:97:
> builtin-annotate.o] Error 1
> make[2]: *** [Makefile.perf:658: perf-in.o] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> 
> 
> From the git log:
> 
> commit 83185fafbd143274c0313897fd8fda41aecffc93
> Author: Ian Rogers <irogers@google.com>
> Date:   Fri Aug 26 09:42:33 2022 -0700
> 
>     perf ui: Update use of pthread mutex
> 
>     [ Upstream commit 82aff6cc070417f26f9b02b26e63c17ff43b4044 ]
> 
>     Switch to the use of mutex wrappers that provide better error checking.
> 
> 
> I think building perf while adding perf patches would help us prevent from
> running into this issue. cd tools/perf/ ; make -j$(nproc) all

Maybe, but I can't seem to build perf at all for quite a while, so I
doubt that anyone really cares here, right?

> We can choose one of the three ways to solve this :
> 
> 1. Drop this patch and resolve conflicts in the next patch by keeping
> pthread_mutex_*, but this might not help future backports.

Let me just drop all of the perf patches for now from 5.15 and then I'll
take some tested backports if really needed.

Otherwise, why not just use perf from the latest 6.9 tree?

> 2. Add another dependency patch which introduces header file in util folder,
> that is also not clean backport due to a missing commit, but I have tried
> preparing a backport. I am not sure if that is a preferred way but with the
> backport inserted before: commit 83185fafbd143274c0313897fd8fda41aecffc93
> (between PATCH 224 and 225 in this series). Attached the backport. [
> 0001-perf-mutex-Wrapped-usage-of-mutex-and-cond.patch ]
> 
> 3. Clean cherry-pick way: instead of resolving conflict add one more
> prerequisite patch:
> just before commit 83185fafbd14 in 5.15.y: Cherry-pick:
> 	a. git cherry-pick -s 92ec3cc94c2c  // list_sort.h addition
> 	b. git cherry-pick -s e57d897703c3  // mutex.h addition
> 
> tools/perf builds with option 2/3, tested it.
> 
> For 5.10.y: Option 2 and 3 works.

I'll just drop this from 5.10 and 5.15.

> For 5.4.y we need other way to fix this.

Again, do you really want to use the 5.4 version of perf?

thanks,

greg k-h
