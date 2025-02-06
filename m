Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CAD23644D;
	Thu,  6 Feb 2025 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738853269; cv=none; b=Y4xk+3bqFAumSPhdCNFogfsSQtsrpkRSIVLnFBh9iT0UDw7PHW/dfogmZi5N6x0nJxDsKhhexU3Np/OWf46jgWYFAltrBeeHF+p0N/d5jJrKhmIciCu0aQAViaC29TdjxSWyYYY2L/MfxbQizZ1kbfdywLWYtVkCjG+OAGeoahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738853269; c=relaxed/simple;
	bh=VTlP4KHV1V4htbOn/9RNsNcO9aW0BjPcmbTnZc/UU3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lo8jxtQWH5BrwRuVXKS2sQk94Pm5IKK2Zwvc/hZ4d31dwmMUeNlvpXEmEB2N7e5gjUcA8xUVlsus2qsbqBuEuL7p7n3Hodmj/oUKh+vdG+MiJtS6e5XJelVifqc2m/e5xo81H9a36fWdjGVMrLCD54tZe2JnOyVr9ls/do2ZBiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RM0hMjSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RM0hMjSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136C6C4CEDF;
	Thu,  6 Feb 2025 14:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738853268;
	bh=VTlP4KHV1V4htbOn/9RNsNcO9aW0BjPcmbTnZc/UU3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RM0hMjStqvb4Lcd5iQCw7dWfqBReopEwkhgHh/5bBlQz7J8pLnynQZEbTEz7GH9mt
	 MTbvS+n4IdLqQgr6g9h5xpCnwzL31ai4/9hrCDD811GLG3Xwj7AT6cenow7Hi2Sda1
	 Jm1+Kv1HJTTOq/OOpd0eoIJa69Qbr79NI8iRrUvc=
Date: Thu, 6 Feb 2025 15:47:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
Message-ID: <2025020627-mug-sustained-b3fb@gregkh>
References: <20250205134455.220373560@linuxfoundation.org>
 <ea698e1c-02a8-47f8-a66c-b7e649dd417f@rnnvmail205.nvidia.com>
 <b7363e74-2207-4cab-a573-bc552b901f4e@nvidia.com>
 <8ab5ab07-fb63-4235-bdb1-f4acbe86f8bc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ab5ab07-fb63-4235-bdb1-f4acbe86f8bc@nvidia.com>

On Thu, Feb 06, 2025 at 12:04:14PM +0000, Jon Hunter wrote:
> 
> On 06/02/2025 11:41, Jon Hunter wrote:
> > Hi Greg,
> > 
> > On 06/02/2025 11:37, Jon Hunter wrote:
> > > On Wed, 05 Feb 2025 14:35:55 +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.12.13 release.
> > > > There are 590 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/
> > > > patch-6.12.13-rc1.gz
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > > > stable-rc.git linux-6.12.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Failures detected for Tegra ...
> > > 
> > > Test results for stable-v6.12:
> > >      10 builds:    10 pass, 0 fail
> > >      26 boots:    26 pass, 0 fail
> > >      116 tests:    115 pass, 1 fail
> > > 
> > > Linux version:    6.12.13-rc1-g9ca4cdc5e984
> > > Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
> > >                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> > >                  tegra20-ventana, tegra210-p2371-2180,
> > >                  tegra210-p3450-0000, tegra30-cardhu-a04
> > > 
> > > Test failures:    tegra194-p2972-0000: pm-system-suspend.sh
> > 
> > 
> > I am seeing a suspend regression on both 6.12.y and 6.13.y and bisect is
> > pointing to the following commit ...
> > 
> > # first bad commit: [ca20473b60926b94fdf58f971ccda43e866c32d1] PM:
> > sleep: core: Synchronize runtime PM status of parents and children
> 
> And 6.6.y too!

Thanks, let me drop it from all stable queues now and I'll push out some
-rc2 releases.

greg k-h
