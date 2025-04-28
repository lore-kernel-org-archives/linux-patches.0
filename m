Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEC179E1;
	Mon, 28 Apr 2025 11:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745840221; cv=none; b=DqS3yqNZoraBkUivl4sQd4+zjUP8nmb8hLnr+Eaceo5rP6AWIY0EHfIZM1ZO+N+Dt8Xy6iqmei6RhyX96r9E8arZ/odQ5ln4NTx9cYk+nq5Tr4WSjD6U4OKeze9Ix6gK513t1MIEVKW/G8VcyO1B/dbWMoWou/e3BQFlyHivd90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745840221; c=relaxed/simple;
	bh=57fjuWWDFcZDGOCmNELuCdTnM3zJVq3peSEWS0pbQog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qY4e5aCMk80euiuR8IjIgdzsbzuCCDuzztki8wG4KQ1Bw3H+7EGkUDJpvpTdm+YHu2B3XvJ0a+zpafQBdQvdhsrUBF31Dp80sIJcwWpl2FfwP0hliGmWVldSZ4djaq6m7epgOOh5NySsDFTG+xXK3oGDqUDgCA7DvGPfcwGcRHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyMqtldt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyMqtldt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A9EC4CEE4;
	Mon, 28 Apr 2025 11:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745840220;
	bh=57fjuWWDFcZDGOCmNELuCdTnM3zJVq3peSEWS0pbQog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IyMqtldtwowTWnarBVYlD4ckuw37TPZAUv13wypq7vrWAi6IHPX3Lr1nMRkJHTsuC
	 hWpg3e7tjy/pwSXfnJwmO6zVwuOBLYbWTEQEqF+WotzPgeiTBmTUfSYrQTSVgiIh0J
	 dTy7VTH7JExL30Kbe+QdgR1kBMC7VZKlthxRYU6o=
Date: Mon, 28 Apr 2025 13:36:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
Message-ID: <2025042833-carefully-lapped-d05c@gregkh>
References: <20250423142617.120834124@linuxfoundation.org>
 <de718b6b-cbe1-4ccd-be70-794b60e91e0b@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de718b6b-cbe1-4ccd-be70-794b60e91e0b@roeck-us.net>

On Sat, Apr 26, 2025 at 07:33:51PM -0700, Guenter Roeck wrote:
> Hi Greg,
> 
> On 4/23/25 07:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.25 release.
> > There are 223 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> > Anything received after that time might be too late.
> > 
> ...
> > Nathan Chancellor <nathan@kernel.org>
> >      kbuild: Add '-fno-builtin-wcslen'
> > 
> 
> This patch was already in 6.12.24, and it is now twice in 6.12.y.
> 
> 3802df8552de kbuild: Add '-fno-builtin-wcslen'
> 9c03f6194e88 kbuild: Add '-fno-builtin-wcslen'
> 
> and
> 
> $ grep fno-builtin-wcslen Makefile
> KBUILD_CFLAGS += -fno-builtin-wcslen
> KBUILD_CFLAGS += -fno-builtin-wcslen
> 
> This is the second time this happened in the 6.12 series. The other sequence is
> 
> 61749c035911 Revert "vfio/platform: check the bounds of read/write syscalls"
> 61ba518195d6 vfio/platform: check the bounds of read/write syscalls
> a20fcaa230f7 vfio/platform: check the bounds of read/write syscalls
> 
> Would it be possible to avoid those duplicates ? It doesn't matter in
> the above cases, but we might not always be that lucky.

Sorry about that, it's not a normal thing, and yes, our scripts should
check it.  I'll work on adding it in the future, thanks.

greg k-h
