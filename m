Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B2121B9CD;
	Thu, 19 Jun 2025 04:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750306016; cv=none; b=PCFmiTVXCbnCeAy1VYOm+2Ymh60PUsnlCcsrePtvEEgwFbI6XItt+CcdATt1cEq0MmwKy115rRKgLU/w8Je9R49+utDWsZ/69Nm5xQ1sEScX8Sa0zquSmFnklYj9ZmeosfCEKFUm6Cn8NYDnXsLo12zXfZp0kkWLIeYwPn/vfVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750306016; c=relaxed/simple;
	bh=b6bc0zXKnZojzEphzM6HI2U0YpO6B8F6FFI2NxadMHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlXUXLQP/UHx5S3vbeN1wIx80FyMbkfYjsPuvVIILcq7U3/Tm0n11eE7kpw4wT0MK2kC5rxr/7d+wPqPYTtNac/y77nE+fjUN3wOCrfCHiX1f6paG/oZP6WGe1/u5oWPoF5H/ThzDk8pOlaEtEoV+zBDnTJPU1Q48913lcZf1gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSuN1J0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSuN1J0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA99C4CEEA;
	Thu, 19 Jun 2025 04:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750306016;
	bh=b6bc0zXKnZojzEphzM6HI2U0YpO6B8F6FFI2NxadMHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sSuN1J0x8jQRv19z7S/gk7RwR+q5fbOg/9+PfQxV/Hu5YFx1lMM7KCVzKtc9aNLnP
	 UkQpq1lr32ga9nNtdjFhRweBRbiEE2TFcdWjhr+peMPZT0a2Ql+p0hGkYhrKwfwr01
	 qKCiWi/CbTlsOrCf6gokPS1Ng/k23HaWhNCArH04=
Date: Thu, 19 Jun 2025 06:06:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Justin Forbes <jforbes@fedoraproject.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025061921-trousers-moustache-ee5b@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <aFNphCnmG57JMriZ@fedora64.linuxtx.org>
 <2025061924-shaky-reunite-7847@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025061924-shaky-reunite-7847@gregkh>

On Thu, Jun 19, 2025 at 06:05:18AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 18, 2025 at 07:36:04PM -0600, Justin Forbes wrote:
> > On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.15.3 release.
> > > There are 780 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > After dropping
> > revert-mm-execmem-unify-early-execmem_cache-behaviour.patch:
> 
> So does that mean that Linus's tree is also broken as it has this change
> in it?

Ah, I see what I did, I took only the revert, but not the patches
pervious to this change.  Ugh, my fault, I'll drop this now and add it
back after the next -rc release is out, thanks.

greg k-h
