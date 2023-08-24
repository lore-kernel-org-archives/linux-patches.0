Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620EC288E6
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 13:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFECC433C7;
	Thu, 24 Aug 2023 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692884158;
	bh=FoeW5Vf0WqDwd9w8w9n1OLSBxvLkKSrUFjawAzxgK5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wO6K+J4gYSmVIxvG6AJs8XWztSAYYUx6KQlp04BrJNZZr50PFkHGPYaiuKgByK+hr
	 ZnZFVK6yk+oQHLDfGQh+uUl3vm8vFVWVeVf5Hj0Astq+d2hzxFMjmSEy54+dBheQso
	 RdCozM1P21Cs3h2gvuYXQV0+cvVz271OM+5Zqu0g=
Date: Thu, 24 Aug 2023 15:35:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <2023082401-arrange-bulk-d42a@gregkh>
References: <20230821194122.695845670@linuxfoundation.org>
 <991b93d2-9fde-4233-97d5-1133a9360d02@roeck-us.net>
 <2023082309-veggie-unwoven-a7df@gregkh>
 <CA+G9fYvwxuVpSn24YvtdNXaofg2JtZDREatOpDsKTVJX+nFN3Q@mail.gmail.com>
 <2d8a5f48-6c50-4c12-8a3d-23e621c6b722@roeck-us.net>
 <2023082325-expansion-revoke-1f3a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023082325-expansion-revoke-1f3a@gregkh>

On Wed, Aug 23, 2023 at 05:50:42PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 23, 2023 at 06:30:13AM -0700, Guenter Roeck wrote:
> > On Wed, Aug 23, 2023 at 01:47:39PM +0530, Naresh Kamboju wrote:
> > > On Wed, 23 Aug 2023 at 12:33, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Aug 22, 2023 at 05:49:54PM -0700, Guenter Roeck wrote:
> > > > > On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 6.1.47 release.
> > > > > > There are 194 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > >
> > > > > Build results:
> > > > >       total: 157 pass: 156 fail: 1
> > > > > Failed builds:
> > > > >       m68k:sun3_defconfig
> > > > > Qemu test results:
> > > > >       total: 521 pass: 519 fail: 2
> > > > > Failed tests:
> > > > >       arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:f2fs
> > > > >       arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:f2fs
> > > > >
> > > > > The m68k build failure is
> > > > >
> > > > > Inconsistent kallsyms data
> > > > > Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> > > > >
> > > > > I already have KALLSYMS_EXTRA_PASS=1 enabled, so that doesn't help.
> > > > > Nothing to worry about. The f2fs crashes are still seen. They
> > > > > also happen for other architectures, so it is not just an arm problem.
> > > > > I'll probably just disable all f2fs testing going forward. If so I'll
> > > > > send a note clarifying that the lack of reported test failures doesn't
> > > > > mean that it works.
> > > >
> > > > I'll look into this later this week, next week to resolve the f2fs
> > > > stuff.  I wanted to get to the other known bug fixes first.
> > > >
> > > > > For x86 I get the same runtime warning as everyone else.
> > > >
> > > > Yeah, this is troubling...
> > > >
> > > > Is it clang only?  I'll dig into this today...
> > > 
> > > It is seen with gcc-13 and clang-17 with few extra configs.
> > > We are not booting defconfig.
> > > 
> > > The Kconfigs are enabled with KFENCE.
> > > 
> > I have KFENCE enabled as well, so it may well be that this triggers
> > the warning. I don't see it in 6.4.y or upstream, though.
> 
> Ok, let me rip out all the x86 and objtool patches from this release,
> get it out the door with the good things in there that everyone else
> needs, and then we can focus on this mess...
> 
> Maybe I'll just backport _all_ objtool changes to sync things up better,
> last time I tried that it was a maze of twisty passages, all coated in
> assembly...

I got lost in the maze again today, ick.

Anyway, I give up.  I'm just going to push out a -rc1 with just these
changes in it today, and if people are upset about the runtime warning,
then they can provide a working backport of this objtool patch.

Ideally, the CPU vendor who is causing this mess will do that, as it's
their issue we are spending all of this time on, not Linux's issue.

Also, oddly, I can not reproduce this problem here on my hardware at
all.  Maybe because it's an AMD processor?  If so, makes sense, as the
SRSO issue is only for Intel chips.

thanks,

greg k-h
