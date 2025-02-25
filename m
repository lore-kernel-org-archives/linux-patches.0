Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263F2561B3;
	Tue, 25 Feb 2025 06:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740466060; cv=none; b=OtWS8AVTXykRUn0s7FQjKZmoL+ygiV6VEURWz6iZxUVDlm/9NQSj+cQv6tXNSiZcNV21pbSAqgTt8TxBhAiC9eeFHG9bOxp2+LJfL5m4DHtRXXA2FdH6nbwpDRy7DuRyU2PVJ/Yrf/0zs3jGn1Jn9e8tOFVtdopD4c+7leuXUmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740466060; c=relaxed/simple;
	bh=JN+Y7+xRhOboVTT+XYkqz5hY7pcjKTvSAZbIFpwW5j4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dj0LMuAtfsJxIyjKmeuM+UZYq/tLCKDNtsIAmK5PqU5sreDPVvQpxVqEm+44sfztGYKSN12VNkA8Uk4SmHS7jksN6cCxOlWcsXQI7v6jYiJlurkmkSixCxFNUWWJmY9x/z0X8wewevt2TPoF8wPQpXA2B437hPrnpKlIlCY20Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWoNVFA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWoNVFA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE2EC4CEDD;
	Tue, 25 Feb 2025 06:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740466059;
	bh=JN+Y7+xRhOboVTT+XYkqz5hY7pcjKTvSAZbIFpwW5j4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aWoNVFA0sVELW4tytwqVeZvp/8wr3GVpPpUGhtI/owQ2u6fJ1EvHmBm/O5t6esUBJ
	 6Y79Jf4EtyIToLDDI+7NCRf1Og8wxtTiEdZZfpRGgpqzbs6tk/VNTugJZgQIXoA5nE
	 378kp0wfXSTFVb0+bvPWbBJEVr/fuojR/Zee7jsY=
Date: Tue, 25 Feb 2025 07:46:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 000/154] 6.12.17-rc1 review
Message-ID: <2025022516-bauble-renter-d88b@gregkh>
References: <20250224142607.058226288@linuxfoundation.org>
 <a89ebd7b-4cbb-4427-9fcf-76a3737454c2@rnnvmail205.nvidia.com>
 <3e5b29cd-b9c1-4509-8362-a4465e11a9f3@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e5b29cd-b9c1-4509-8362-a4465e11a9f3@nvidia.com>

On Tue, Feb 25, 2025 at 12:06:32AM +0000, Jon Hunter wrote:
> 
> On 25/02/2025 00:03, Jon Hunter wrote:
> > On Mon, 24 Feb 2025 15:33:19 +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.12.17 release.
> > > There are 154 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.12:
> >      10 builds:	10 pass, 0 fail
> >      32 boots:	26 pass, 6 fail
> >      72 tests:	64 pass, 8 fail
> > 
> > Linux version:	6.12.17-rc1-g497e403c6ee0
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> >                  tegra20-ventana, tegra210-p2371-2180,
> >                  tegra210-p3450-0000, tegra30-cardhu-a04
> > 
> > Boot failures:	tegra124-jetson-tk1, tegra210-p2371-2180,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra20-ventana: devices
> >                  tegra20-ventana: tegra-audio-boot-sanity.sh
> >                  tegra210-p3450-0000: devices
> >                  tegra210-p3450-0000: mmc-dd-urandom.sh
> 
> 
> I am seeing some gpio related failures ...
> 
> [    2.524869] gpiochip_add_data_with_key: GPIOs 0..255 (tegra-gpio) failed to register, -22
> [    2.533066] tegra-gpio 6000d000.gpio: probe with driver tegra-gpio failed with error -22
> 
> So I am wondering if this is the same issue Mark reported?

Probably, I'll go drop this and push out a -rc2

thanks,

greg k-h
