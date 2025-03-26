Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5991A76BC;
	Wed, 26 Mar 2025 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743003592; cv=none; b=trhabaG62ywpUJQegnmjmr837/s1028pZhSG2CCDQzvqlWXV1u2wnR6GZQL15k772eHL9AAe0YHOowEcZJlBMRp7+3NKi03Wtxc6k3+oK+exnVrszKFes/Dlook7fQNAWWaJzlP0/1sfNO1m2z7spI9Nnur815fJVvp76QMhmjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743003592; c=relaxed/simple;
	bh=MioeGIezwwdGYv/pB4JH5XaSr/E6sfesoiSMxsiaI7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2a3McOzbzyZi+YS4wAsVzC3E5EyXhBK8v6s48zAjjQd1gC43x44pq/kR4xoeA+TuLqzoOKS1rZ+xktAbX7Iz7oOsAWXZ1bHO4JmRDy2LEWQ0a7il0MucBsLyNW1GquGsnXo/7ImpEo5Gxo86M6uGv01y06xWs2knZOzuaWJobc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neqyJbrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neqyJbrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E111C4CEE2;
	Wed, 26 Mar 2025 15:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743003591;
	bh=MioeGIezwwdGYv/pB4JH5XaSr/E6sfesoiSMxsiaI7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=neqyJbrfYHpRRtikUQc6ND36EToMki3dXmsIEPOUq7zObSZO2C0/mEJanoYyZPYph
	 DUxtJPCShPRg9EL/BSeQW5cSnzMwINmHP5c5/xojB3xfjUK+pvMOnX0atwjYmihZoj
	 34cSvKArPntqapxlCGQDxL29DIlHJf9GlzWayKsk=
Date: Wed, 26 Mar 2025 11:38:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dragan Simic <dsimic@manjaro.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Heiko Stuebner <heiko@sntech.de>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>,
	Diederik de Haas <didi.debian@cknow.org>
Subject: Re: [PATCH 6.6 00/77] 6.6.85-rc1 review
Message-ID: <2025032656-closure-exile-38fe@gregkh>
References: <20250325122144.259256924@linuxfoundation.org>
 <CA+G9fYvWau1nC8wmpWkxG8gWPaRMP9pbkh2eNsAZoUMeRPgzqA@mail.gmail.com>
 <a823454af9915fe3acfcb66fd84dc826@manjaro.org>
 <751cf2c6-c692-4595-98e9-fa3ae4dfd10a@oracle.com>
 <0001e7e020145983055d154488f5c460@manjaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0001e7e020145983055d154488f5c460@manjaro.org>

On Wed, Mar 26, 2025 at 04:56:18AM +0100, Dragan Simic wrote:
> Hello Harshit and Greg,
> 
> On 2025-03-26 03:33, Harshit Mogalapalli wrote:
> > On 25/03/25 21:37, Dragan Simic wrote:
> > > On 2025-03-25 16:07, Naresh Kamboju wrote:
> > ...
> > > > Build regression: arm64 dtb rockchip non-existent node or label
> > > > "vcca_0v9"
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > 
> > > > ## Build log
> > > > arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> > > > (phandle_references):
> > > > /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
> > > > 
> > > >   also defined at arch/arm64/boot/dts/rockchip/rk3399-
> > > > rockpro64.dtsi:659.8-669.3
> > ...
> > > 
> > > This is caused by another patch from the original series failing
> > > to apply due to some bulk regulator renaming.  I'll send backported
> > > version of that patch soon, which should make everything fine.
> > 
> > On ARM configs, we do see the same issue that Naresh reported.
> > 
> > arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> > (phandle_references): /pcie@f8000000: Reference to non-existent node
> > or label "vcca_0v9"
> >  also defined at
> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> > ERROR: Input tree has errors, aborting (use -f to force output)
> > make[3]: *** [scripts/Makefile.lib:423:
> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64-v2.dtb] Error 2
> > make[3]: *** Waiting for unfinished jobs....
> > arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> > (phandle_references): /pcie@f8000000: Reference to non-existent node
> > or label "vcca_0v9"
> >  also defined at
> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
> > ERROR: Input tree has errors, aborting (use -f to force output)
> > make[3]: *** [scripts/Makefile.lib:423:
> > arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtb] Error 2
> > make[2]: *** [scripts/Makefile.build:480: arch/arm64/boot/dts/rockchip]
> > Error 2
> > make[2]: *** Waiting for unfinished jobs....
> > 
> > Caused by commit: 1e4bd0ec5a47 ("arm64: dts: rockchip: Add missing
> > PCIe supplies to RockPro64 board dtsi") -- PATCH 42/77 of this series.
> > 
> > We see same problem with 6.12.21-rc1 as well.
> > 
> > Notes:
> > -----
> > I think Dragan was referring to upstream commit: bd1c959f37f3 ("arm64:
> > dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi") which
> > will fix this problem but fails to apply due to regulator renaming in
> > commit: 5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames
> > to preferred form") which is not in stable kernels(6.6.y and 6.12.y)
> 
> Exactly, the direct dependency is the commit bd1c959f37f3 ("arm64:
> dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi"),
> for which I haven't sent the backported version yet.
> 
> As Diederik pointed it out already in a separate message [*] from
> a couple of days ago, it might be the best to include the commit
> 5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames to
> preferred form") into stable kernels as well.
> 
> Obviously, including the commit 5c96e6330197 pretty much goes
> against the rules of stable kernels, but it would save a lot of
> time and effort in the future.
> 
> [*] https://lore.kernel.org/stable/D8ONE4WEF7A2.1OE1YY8J34MM3@cknow.org/

As that's a big change, and no one seems to be sending it to me for
inclusion, I'll just go drop the patch that broke the builds for now and
wait for someone to send working ones later.

thanks,

greg k-h
