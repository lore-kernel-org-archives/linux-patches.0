Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2282189BB2;
	Tue, 15 Oct 2024 11:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728991319; cv=none; b=aBv6anOMCtQohOhgNoPK9c2zjG4kR5dTVxgk9NZ4CWNwHS+VWs4tnrVnpgecumHboOpZTdxA+AdJ9CDn48LzXuW6FiLqXH6/0ehfH/eyza8lcPYKbCkxjxqhwfXo+eMJXuesvHWSvLuEo77eW1e6MgEd2ctM9nD6Ifr7bfmSJrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728991319; c=relaxed/simple;
	bh=PtTIjxN1lR8CGrmN5XgBPw4sWJeWRl4pcJLmofxbsBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5ZSaDA8wn6rJoVkIeCVkN48lujJPjiNFNwgEfNvwYQMwRRWl7AMZXi5zEcSnCCfeACeEYojytEPtFEHEbLfsPTXToj8uY6I97WrjAvI6b7tF2gQzJrt9PHpQ9rkLBW6esqIEuDFmc2FEajjTOhZ8kUVQmNGJFshwhnhS2uAMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2FKjgY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2FKjgY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9DBC4CEC6;
	Tue, 15 Oct 2024 11:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728991319;
	bh=PtTIjxN1lR8CGrmN5XgBPw4sWJeWRl4pcJLmofxbsBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t2FKjgY0QZ3QppNWbQCLVfb4lgZ+uVkWhEgTMSaFUGGjs37SzSe0Fh2szN/AMjwl3
	 e4lp7rF/98mNCe7Smr1w4Cr+9fii77LstjCelW+igKB6u8Yxr5oxDpRCnxwJWXTMCo
	 wNdzNJktP+GMtH6yj/t0cbH7IerAoVTe8VYY5SbQ=
Date: Tue, 15 Oct 2024 13:21:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
Message-ID: <2024101542-uncouple-ferment-6d08@gregkh>
References: <20241014141044.974962104@linuxfoundation.org>
 <1d31b7f5-6843-406e-98d6-6344e39966e9@rnnvmail202.nvidia.com>
 <fd1b56c0-2136-48ea-b3c2-5b2cbdc20994@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd1b56c0-2136-48ea-b3c2-5b2cbdc20994@nvidia.com>

On Tue, Oct 15, 2024 at 06:55:42AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 15/10/2024 06:52, Jon Hunter wrote:
> > On Mon, 14 Oct 2024 16:17:43 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.11.4 release.
> > > There are 214 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.11:
> >      10 builds:	10 pass, 0 fail
> >      26 boots:	26 pass, 0 fail
> >      116 tests:	115 pass, 1 fail
> > 
> > Linux version:	6.11.4-rc1-ga491a66f8da4
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> >                  tegra20-ventana, tegra210-p2371-2180,
> >                  tegra210-p3450-0000, tegra30-cardhu-a04
> > 
> > Test failures:	tegra194-p2972-0000: boot.py
> 
> 
> I am seeing the following kernel warning with this updated on the above
> board ...
> 
>  ERR KERN ucsi_ccg 2-0008: con1: failed to get status
>  ERR KERN ucsi_ccg 2-0008: con2: failed to get status
> 
> 
> If I revert the following change I don't see these warnings ...
> 
> Heikki Krogerus <heikki.krogerus@linux.intel.com>
>     usb: typec: ucsi: Don't truncate the reads
> 
> 
> Please note that I am not seeing these warnings on mainline/next with this
> board.

Odd, I'll go drop this now, thanks for reporting it!

greg k-h
