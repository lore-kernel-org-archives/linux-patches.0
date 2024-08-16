Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FA213B593;
	Fri, 16 Aug 2024 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723801702; cv=none; b=gsCTld6dJWhMhuoUbMN7kh1b4oArgGTbEzlCTLjtLpGLxGTKQV5ozgvqKawehNy7ajZrRchunQhTtei7+XPXxAmUEWlqbem0hYh3gosL9KL1MIeJd9MmmuvYAlosxsUFRmVGV3zh8HNKXcfZY9YQWvhsKxcXZcfwPDyt2EJhhdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723801702; c=relaxed/simple;
	bh=a0uI29Rrg46AFPMyjA/f3FnswrQyuxSGeP9ofblJ61U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8fh49e+cHtVylJ2SUuKKPO48umUd8sG12KHm9a74BskrqhwEHj1KWhD1Mybz7I3wvZtlgvrNNjZFskdhcr2hDtqtks2inszCJH5osdNkS/dFbEbGFoeDz0yxU+GPMyZ54/NQG4T9EhgR2HiJN73xEIu2dycCRDiywy3e6qDZfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYmpYN9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYmpYN9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0062C32782;
	Fri, 16 Aug 2024 09:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723801701;
	bh=a0uI29Rrg46AFPMyjA/f3FnswrQyuxSGeP9ofblJ61U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SYmpYN9DN9WPHu7GpCHhVgyQlurMGL5MANDjELdjZL1RLER4I5YutkHhNdQFaQo+d
	 icVUPO2FMiBZU5I3tRRwjvDoUcq7+6zfH4anDw0r1fbA7FkufGOF+YwTXG/yTPI8VT
	 pJ8WX5ad1epE2m7vFfS/wk9pUyW2/iCk+d39P+u0=
Date: Fri, 16 Aug 2024 11:48:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Roxell <anders.roxell@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 5.15 000/484] 5.15.165-rc1 review
Message-ID: <2024081650-smashup-botch-95ea@gregkh>
References: <20240815131941.255804951@linuxfoundation.org>
 <CADYN=9LRUpKMbBebjkcy3qo3O_1UFevA=x90SGZQ7ja5FXHG3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9LRUpKMbBebjkcy3qo3O_1UFevA=x90SGZQ7ja5FXHG3w@mail.gmail.com>

On Fri, Aug 16, 2024 at 10:52:35AM +0200, Anders Roxell wrote:
> On Thu, 15 Aug 2024 at 15:40, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.165 release.
> > There are 484 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following S390 build failed on stable-rc 5.15.y with gcc-12 and clang due
> to following warnings and errors [1].
> 
> s390:
>   build:
>     * gcc-8-defconfig-fe40093d
>     * gcc-12-defconfig
>     * clang-18-defconfig
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Bisect point to 85cf9455e504 ("KVM: s390: pv: avoid stalls when making
> pages secure")
> as the problematic commit [ Upstream commit
> f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ].
> 
> Build log:
> ------
> arch/s390/kernel/uv.c: In function 'expected_folio_refs':
> arch/s390/kernel/uv.c:184:15: error: implicit declaration of function
> 'folio_mapcount'; did you mean 'total_mapcount'?
> [-Werror=implicit-function-declaration]
>   184 |         res = folio_mapcount(folio);
>       |               ^~~~~~~~~~~~~~
>       |               total_mapcount
> arch/s390/kernel/uv.c:185:13: error: implicit declaration of function
> 'folio_test_swapcache' [-Werror=implicit-function-declaration]
>   185 |         if (folio_test_swapcache(folio)) {
>       |             ^~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/uv.c:187:20: error: implicit declaration of function
> 'folio_mapping'; did you mean 'no_idmapping'?
> [-Werror=implicit-function-declaration]
>   187 |         } else if (folio_mapping(folio)) {
>       |                    ^~~~~~~~~~~~~
>       |                    no_idmapping
> arch/s390/kernel/uv.c:189:26: error: invalid use of undefined type
> 'struct folio'
>   189 |                 if (folio->private)
>       |                          ^~
> 

Oops, no folio support in 5.10.y or 5.15.y, I'll go drop these patches
and push out -rc2 releases, thanks for the report!

greg k-h
