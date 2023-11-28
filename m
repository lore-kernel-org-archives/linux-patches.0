Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3195A36AFA;
	Tue, 28 Nov 2023 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZOMah1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28907C433C7;
	Tue, 28 Nov 2023 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701164549;
	bh=627q44W1qJcE+w9twZSTRgNexUXO+hbOxcbJHEcVMVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZOMah1HP59j0I3EJ8ZFCH2fDTAPAOGCdPr6sF8ib8sxqlRqeuHcVJQyn1Tw4Xbbc
	 BqkKNdRoQFdcOT+aRMhp8M3/5xcW8l2uYVtaMmqAbxAoDUJa6CJfRDd38EPvVYoNle
	 SpbUTij04mP60wCpt1JFEyYLasP2PKwpbnVMMc6w=
Date: Tue, 28 Nov 2023 09:42:27 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, linux-tegra@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/187] 5.10.202-rc3 review
Message-ID: <2023112845-mushily-thermos-770e@gregkh>
References: <20231126154335.643804657@linuxfoundation.org>
 <fc421b26-ed60-48fa-a2f4-0fafcb44e91c@drhqmail201.nvidia.com>
 <6e45696d-fe6b-4570-8ca7-481de78a983f@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e45696d-fe6b-4570-8ca7-481de78a983f@nvidia.com>

On Mon, Nov 27, 2023 at 11:37:17PM +0000, Jon Hunter wrote:
> 
> On 27/11/2023 23:27, Jon Hunter wrote:
> > On Sun, 26 Nov 2023 15:46:55 +0000, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.202 release.
> > > There are 187 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.202-rc3.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v5.10:
> >      10 builds:	10 pass, 0 fail
> >      26 boots:	26 pass, 0 fail
> >      68 tests:	67 pass, 1 fail
> > 
> > Linux version:	5.10.202-rc3-g80dc4301c91e
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> >                  tegra20-ventana, tegra210-p2371-2180,
> >                  tegra210-p3450-0000, tegra30-cardhu-a04
> > 
> > Test failures:	tegra194-p2972-0000: boot.py
> 
> 
> After commit the commit "gpio: Don't fiddle with irqchips marked as
> immutable" added, we observe the following warnings and is causing a test to
> fail ...
> 
>  WARNING KERN gpio gpiochip0: (max77620-gpio): not an immutable chip, please
> consider fixing it!
>  WARNING KERN gpio gpiochip1: (tegra194-gpio): not an immutable chip, please
> consider fixing it!
>  WARNING KERN gpio gpiochip2: (tegra194-gpio-aon): not an immutable chip,
> please consider fixing it!
> 
> The following upstream changes fix these ...
> 
> 7d1aa08aff06 gpio: tegra: Convert to immutable irq chip
> bba00555ede7 gpio: tegra186: Make the irqchip immutable
> 7f42aa7b008c gpio: max77620: Make the irqchip immutable
> 
> There are quite a few other drivers that were updated in a similar way, so
> the above only fix the ones we observe on Tegra.

Ick, those patches snuck back in again, and they aren't even needed in
these branches as I fixed up the real fix that they were dependencies of.
I'll go drop them from 5.10.y and 5.15.y now, thanks!

greg k-h
