Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDED1C3F
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 05:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7084BC433C8;
	Fri, 30 Jun 2023 05:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688102313;
	bh=VNj8VKDu2zaozgcFJLTIq3ErZ8I2Nt5WMw7P4iC/eb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HdU6O5IxJwu8K/zv3OV7fPfovbpdX2qTdBA5B1ajt+IHkYLRAKP90DMuJjhDCsuKE
	 4RkRVl5pWjoO+8HX2g3qNUzKdbtiPhEu+cJPCW570Tv3MHwvzL48RS9wL7wxqbaqXI
	 YZqLnDTFX7yMwzEPcMaXiIZB6B9sZ41eUxQHxRLQ=
Date: Fri, 30 Jun 2023 07:18:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 00/30] 6.1.37-rc1 review
Message-ID: <2023063056-waviness-unearth-08aa@gregkh>
References: <20230629184151.651069086@linuxfoundation.org>
 <CAEUSe7-xC90CGpJjQD4w10ea=nXMiGhsFouhaa8fVK5W-WJJJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7-xC90CGpJjQD4w10ea=nXMiGhsFouhaa8fVK5W-WJJJQ@mail.gmail.com>

On Thu, Jun 29, 2023 at 04:25:40PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 29 Jun 2023 at 12:46, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 6.1.37 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 01 Jul 2023 18:41:39 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.37-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Early report of failures.
> 
> SPARC and PA-RISC both fail to build (GCC-8 and GCC-11).
> 
> For SPARC:
> * allnoconfig
> * defconfig
> * tinyconfig
> 
> -----8<-----
> /builds/linux/arch/sparc/mm/fault_32.c: In function 'force_user_fault':
> /builds/linux/arch/sparc/mm/fault_32.c:312:49: error: 'regs'
> undeclared (first use in this function)
>   312 |         vma = lock_mm_and_find_vma(mm, address, regs);
>       |                                                 ^~~~
> /builds/linux/arch/sparc/mm/fault_32.c:312:49: note: each undeclared
> identifier is reported only once for each function it appears in
> make[4]: *** [/builds/linux/scripts/Makefile.build:250:
> arch/sparc/mm/fault_32.o] Error 1
> make[4]: Target 'arch/sparc/mm/' not remade because of errors.
> ----->8-----
> 
> For PA-RISC:
> * allnoconfig
> * tinyconfig
> 
> -----8<-----
> /builds/linux/arch/parisc/mm/fault.c: In function 'do_page_fault':
> /builds/linux/arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared
> (first use in this function)
>   292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
>       |                      ^~~~
> /builds/linux/arch/parisc/mm/fault.c:292:22: note: each undeclared
> identifier is reported only once for each function it appears in
> make[4]: *** [/builds/linux/scripts/Makefile.build:250:
> arch/parisc/mm/fault.o] Error 1
> make[4]: Target 'arch/parisc/mm/' not remade because of errors.
> ----->8-----

These issues are also in Linus's tree right now, right?  Or are they
unique to the -rc releases right now?

thanks,

greg k-h
