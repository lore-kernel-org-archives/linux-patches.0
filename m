Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FBC19538D;
	Tue, 22 Oct 2024 08:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729587398; cv=none; b=KnE3vOYPLkm9G+fgznA/aTPCPwX4Zb6WGGzywNELHFEAneAmiWm7ruUncVEOXU1Kvqw7sBtfIzzQIiF4bvEJvodumXxhkVLJs/lGL9ZMr8KE/MM2FlmpMUis5Nuk0JPSvWCN68cvqJbHOztFpvqbleUwlmMV3vMGK7oRkhAxrKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729587398; c=relaxed/simple;
	bh=zB0+4Vy0VmPNc0+MJ6brmbAywsozm+5gHvzdG4soTVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3xsQjuSwrWm/NPuU2amQgZ6qH7sxMA3wZYJzlw2NcrjOlhmGXzaMBfWba93C2InpANWS/o+R0r+yxg9WbZecjzeoUODJbNokM8pEtRc8BRQyZW5jV6sWl/S4NVqoiVjcvcRPKqdnN/YOPFHZ07svekPA58baWfr4KTrKrVzIjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQXpsH9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQXpsH9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19D5C4CEC3;
	Tue, 22 Oct 2024 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729587398;
	bh=zB0+4Vy0VmPNc0+MJ6brmbAywsozm+5gHvzdG4soTVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AQXpsH9fe6uN9eY7nE9LhZL2MZH/GmAJIwtUM4QPj842ESYWAcDEdILIqsdC/V4QO
	 ezdwQcYCwqQdIXZJWv5kTeL3axPfAZW6GGkHpUp3ri+ct2KEdjZqb+VfpEeUDeBQCe
	 jd1DgVFE2X3wWb0SXAcQ67JkhifCXHBtq9Qw+z7I=
Date: Tue, 22 Oct 2024 10:56:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
Message-ID: <2024102216-buckskin-swimmable-a99d@gregkh>
References: <20241021102249.791942892@linuxfoundation.org>
 <CA+G9fYtXZfLYbFFpj25GqFRbX5mVQvLSoafM1pT7Xff6HRMeaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtXZfLYbFFpj25GqFRbX5mVQvLSoafM1pT7Xff6HRMeaA@mail.gmail.com>

On Tue, Oct 22, 2024 at 01:38:59AM +0530, Naresh Kamboju wrote:
> On Mon, 21 Oct 2024 at 16:11, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.114 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The arm allmodconfig build failed due to following warnings / errors with
> toolchain clang-19.
> For all other 32-bit arch builds it is noticed as a warning.
> 
> * arm, build
>   - clang-19-allmodconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build warning / error:
> -----------
> fs/udf/namei.c:747:12: error: stack frame size (1560) exceeds limit
> (1280) in 'udf_rename' [-Werror,-Wframe-larger-than]
>   747 | static int udf_rename(struct user_namespace *mnt_userns,
> struct inode *old_dir,
>       |            ^
> 1 error generated.

Odd that this isn't seen in newer kernels, any chance you can bisect?

thanks,

greg k-h
