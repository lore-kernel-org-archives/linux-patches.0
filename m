Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C72189BA6;
	Tue, 22 Oct 2024 08:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729587462; cv=none; b=VgSewj1nHSwuXtaRkkj0SOIr1G4bitQ7vjxiG2OPpsMO8UVT+9knZF6QQ4cNAAzb2yNxT2k182AwksH+moCS3VUjXlVePuytvf1X2sQ3esV3uQLisPdszAqKmheyoq03HAnE/CVP5oR0AfbhoJ8jHoZ9DYllgxVFwwNrKgphK4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729587462; c=relaxed/simple;
	bh=G/BQGOGd8bPwDOhRgmj31/4lYJRCrtzW558moKUuhPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kobXHCmGbI0i8MrUbb5DvDKw6j8QWka4YBSnXNOKcQdG902v3Ih1WGDLrjG/fs81JaDMQyltjMNLkYpePG+NBTgJTaPwMH5uk2jGM1LQEYyo/D5BI1MqgpmYoInL5P8jLrNC7c/RFGi8uzkMJWSzauWzXO8c2so9KjfvlI1nfjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AF+qjgEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AF+qjgEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65D4C4CEC3;
	Tue, 22 Oct 2024 08:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729587461;
	bh=G/BQGOGd8bPwDOhRgmj31/4lYJRCrtzW558moKUuhPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AF+qjgEVA/1LFIXRTlf+3l9eJlRn31s4cHltCjtQ9bLwW4+SkA9glj6uCj6++kfkH
	 8yA0hC8UFN6D5qAZYLDYf7SGo0xtUXPCW5XbIPrAQk60p1l/3hNB3PEbgOwHNGHfmp
	 dF+TsTBxAXmWv0TXBozKp3RPgZLSfovF8pSAiAWY=
Date: Tue, 22 Oct 2024 10:57:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
Message-ID: <2024102206-puzzling-demeaning-e190@gregkh>
References: <20241021102249.791942892@linuxfoundation.org>
 <fe528f18-a211-4cfb-9b5d-9930d685b231@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe528f18-a211-4cfb-9b5d-9930d685b231@gmail.com>

On Mon, Oct 21, 2024 at 11:24:26AM -0700, Florian Fainelli wrote:
> On 10/21/24 03:24, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.114 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> There is a new warning that got picked up on ARM 32-buit:
> 
> fs/udf/namei.c:878:1: warning: the frame size of 1152 bytes is larger than
> 1024 bytes [-Wframe-larger-than=]
> 
> I was not able to locate a fix upstream for this, but it does appear to come
> from ("udf: Convert udf_rename() to new directory iteration code").

Ah, thanks for tracking this down.  Odd that it's only showing up here
as these changes are all upstream, perhaps the stack size got increased
in a newer kernel to work around this issue?

thanks,

greg k-h
