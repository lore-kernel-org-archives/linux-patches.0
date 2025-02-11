Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FE71EC016;
	Tue, 11 Feb 2025 08:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739262881; cv=none; b=sh58WIClUG08fR007cpoFaBITOVeSkKjIz9/9nlX9LkdhRRTHyvrS/174ttx1tWpO/cS+hewc9yuZVo7Z8WouFlZscg6yxVZt0hIvQvrbtdM/OBtjSQWKHSs6yrDS9FCjMTBOOCGOkHgGaJoeAD5CIa+oXY31B1MLDDcRInAypM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739262881; c=relaxed/simple;
	bh=wDToOM1hlLokp7aJKzSY8hKy9R43xTUITT0mnAALLAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIoqAoRe8dJJc/qyBn/4UYDuLPS3py9xCcBDxD/ZM079O2d5lTS/37QfQ/sedUTjnhGn5jW5BFogJEhmbkARXeNB/Shu0A/Zow93HMc2YSaNq9GFR/Uec95PuxR0o0qkD2kEI0UDcEhgogpdsLT40q/IO03tLpQLFdVz8U0csRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU2frQLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU2frQLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62982C4CEDD;
	Tue, 11 Feb 2025 08:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739262881;
	bh=wDToOM1hlLokp7aJKzSY8hKy9R43xTUITT0mnAALLAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yU2frQLpLc4x3SFxu4Cui5Zn6M9PL3Bux1ZkatyR3JpSIg467kMzfIUDAz6J+yK+6
	 ZsBIXY8r8QCZuvtDwBwazH9rcp+1FWXQ+HTNYfHUnLvw/9y3RDhFc/1NbtZ9Rumh50
	 oEhsCCfhgpzSsxiZnJBtq8N8Mc3MBC0FJpCUQwy4=
Date: Tue, 11 Feb 2025 09:34:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
Message-ID: <2025021147-pacifier-richly-ce1e@gregkh>
References: <20250206155234.095034647@linuxfoundation.org>
 <cd10a924-ae65-4b02-aea2-e629947ca7a3@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd10a924-ae65-4b02-aea2-e629947ca7a3@roeck-us.net>

On Sun, Feb 09, 2025 at 07:19:33AM -0800, Guenter Roeck wrote:
> On 2/6/25 08:06, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.76 release.
> > There are 389 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> 
> > Hongbo Li <lihongbo22@huawei.com>
> >      hostfs: fix the host directory parse when mounting.
> 
> This patch results in:
> 
> Building um:defconfig ... failed
> --------------
> Error log:
> fs/hostfs/hostfs_kern.c:972:9: error: implicit declaration of function 'fsparam_string_empty'; did you mean 'fsparam_string'? [-Werror=implicit-function-declaration]
>   972 |         fsparam_string_empty("hostfs",          Opt_hostfs),
> 
> because fsparam_string_empty() is not declared globally in v6.6.y.
> 
> The patch declaring it is 7b30851a70645 ("fs_parser: move fsparam_string_empty()
> helper into header"). Applying that patch on top of 6.6.76 fixes the problem.
> 
> The problem only affects "um" builds since hostfs (CONFIG_HOSTFS) is only available
> and used there. Oddly enough, the patch breaks the build of this file instead of
> fixing the problem it claims to fix, and it looks like no one noticed.
> On top of that, "hostfs: convert hostfs to use the new mount API" was obviously
> not tested. It looks like a substantial change which would definitely warrant
> testing when backported.
> 
> That makes me wonder: Should I stop build testing "um" images in older kernels ?

No, it's good for testing and I'm pretty sure that Android still uses it
for their test infrastructure so it matters.  I'll go do some reverts
now and push out a new release with this fixed as it's now shown up on
the kernel.ci build reports as well.

thanks for pointing it out.

greg k-h
