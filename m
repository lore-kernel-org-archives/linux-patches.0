Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0491AC435;
	Wed, 31 Jul 2024 10:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722420001; cv=none; b=icbdhZDW3oCG/DLOILUjIUK/OXRdoaB+t8Yv+XDjJ0b9bucewOjwJx7ZqHIILfnRB4mTt1PoqvSErL/c4Xeiat3ZK77+NA4cDmkmnkKWGcp5vlc1opwKcbJJ8MJAT0MmhMYKIIkQyuavX/DxbfKzHA+/od4gOf/yby5ohfQJo4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722420001; c=relaxed/simple;
	bh=69Tb12UDljRbThfwE1e2RmATSoMojTi+I8YmZVZ0pYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzsJwH2qfoGVJHCI3AhNV7jSPsZmtzVWbDYuVCaEI2Ov6CJJp1dUk5YwMP2lx09F2i57akx9fu98B3bimk/8NVLU7W7wM+eCX1RHaFfeYNJxXZ0+3FLZ835NO5rJi7nZsDhdBVSWMVERNrqGquIUgtwByhtFWC0N2j9LjqHDuGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KP7Pcj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KP7Pcj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B108C116B1;
	Wed, 31 Jul 2024 10:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722420000;
	bh=69Tb12UDljRbThfwE1e2RmATSoMojTi+I8YmZVZ0pYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0KP7Pcj4SXO7bQ/WNThVAh62TarYGUccK/rDz7oOFA8nViVwgkynoLD4O0a/GRqY9
	 5fYcnNDUHbG+rkLB/N/IhevWxYB//0yqPu9k034zEKCAgA9SreeMhVa4iBDGZpTIK4
	 gTyWWw8bC8IWIlv3IFyR3ADi7khmov8KF3sEDoD0=
Date: Wed, 31 Jul 2024 11:59:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Thomas Richter <tmricht@linux.ibm.com>, linux-s390@vger.kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 6.1 000/441] 6.1.103-rc2 review
Message-ID: <2024073151-subsidy-scotch-04bb@gregkh>
References: <20240731073151.415444841@linuxfoundation.org>
 <CA+G9fYsGYtFhoSZbv_s=3TCSYis-pSPDJ3LJwxbtv1_9+Q61JQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsGYtFhoSZbv_s=3TCSYis-pSPDJ3LJwxbtv1_9+Q61JQ@mail.gmail.com>

On Wed, Jul 31, 2024 at 03:07:28PM +0530, Naresh Kamboju wrote:
> On Wed, 31 Jul 2024 at 13:34, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.103 release.
> > There are 441 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 02 Aug 2024 07:30:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> On the 6.1.103-rc2 (and 6.1.103-rc1 ) s390 builds failed with gcc and
> clang due to
> following warnings / errors.
> 
> * s390, build
>   - clang-18-defconfig
>   - clang-nightly-defconfig
>   - gcc-13-defconfig
>   - gcc-8-defconfig-fe40093d
> 
> Build log:
> --------
> arch/s390/kernel/perf_cpum_cf.c: In function 'cfdiag_diffctr':
> arch/s390/kernel/perf_cpum_cf.c:226:22: error: implicit declaration of
> function 'cpum_cf_read_setsize'; did you mean 'cpum_cf_ctrset_size'?
> [-Werror=implicit-function-declaration]
>   226 |                 if (!cpum_cf_read_setsize(i))
>       |                      ^~~~~~~~~~~~~~~~~~~~
>       |                      cpum_cf_ctrset_size
> cc1: some warnings being treated as errors
> 
> commit log:
> --------
>   s390/cpum_cf: Fix endless loop in CF_DIAG event stop
>   [ Upstream commit e6ce1f12d777f6ee22b20e10ae6a771e7e6f44f5 ]s

Thanks, now dropped.

greg k-h
