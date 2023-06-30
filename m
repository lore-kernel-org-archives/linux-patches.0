Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45E95240
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5394C433C8;
	Fri, 30 Jun 2023 06:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688106492;
	bh=Bi17cT6QoK7w71H2ZRGDKU6Rdu/zSgePXPQhfko9J8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Op4YO4XvQomo8SNJDAxBwXEwCGYGWevNc15VeB2aO9HLmoBecGSfE20gWbPMdLpcO
	 wymprc0KVy7u0RjEELYWV6za4d23z/DxsiIitw7VASJ7wJg2LcgPtg5moLT2vCTUv9
	 qA+mq5zDxRhd5SWBq2Selty5MNFU49W7wutXq4Mc=
Date: Fri, 30 Jun 2023 08:28:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, linux-parisc <linux-parisc@vger.kernel.org>,
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
Message-ID: <2023063043-feminine-clasp-1d11@gregkh>
References: <20230629184151.888604958@linuxfoundation.org>
 <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>

On Fri, Jun 30, 2023 at 11:00:51AM +0530, Naresh Kamboju wrote:
> On Fri, 30 Jun 2023 at 00:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.4.1 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 01 Jul 2023 18:41:39 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> 
> Following build regression noticed on Linux stable-rc 6.4 and also noticed on
> Linux mainline master.
> 
> Regressions found on Parisc and Sparc build failed:
>  - build/gcc-11-defconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Parisc Build log:
> =============
> arch/parisc/mm/fault.c: In function 'do_page_fault':
> arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared (first use in
> this function)
>   292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
>       |                      ^~~~
> arch/parisc/mm/fault.c:292:22: note: each undeclared identifier is
> reported only once for each function it appears in

This is now fixed in Linus's tree with ea3f8272876f ("parisc: fix
expand_stack() conversion"), so I'll queue it up and push out
yet-another-rc...

thanks,

greg k-h
