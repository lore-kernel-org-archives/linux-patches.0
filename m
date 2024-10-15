Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43AD189BB2;
	Tue, 15 Oct 2024 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728991130; cv=none; b=oZN4zuh21bmRGKw45bWrDyDRC6ux/861CeAyxyi52YjX1lIMQvEtbGBgbqNBim5C9Yfx4iFLlOssWZnJsRYW5LOPg7XnUp+C3P6PNY/pOl5e/8sDBTOlztDKniOLwkTjGgemoTVBcL35laHvFzIWvwHuCBGtBgQFzNfZfCZSf0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728991130; c=relaxed/simple;
	bh=EyRdnKDrpI2eSuN2dmCRgj03lZauVTOpfHb1YbGzfqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F4Cx3Chg6W7UGD7gPLzRDVBXto/TgpQlbIMpDoQ4CKTkQqrQnSnedcVLoMFyX7GYhwuzrcVl8Qog2YrFu9v2Ck6W79spC7kHH8MXm/30TaXlhMOTErmBTllvxX12C0rVY7w8EU5uZM8yIGeOYwoW8kgQzwgJI/jMtA3BF74arxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzI7vKE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzI7vKE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D34DC4CEC6;
	Tue, 15 Oct 2024 11:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728991130;
	bh=EyRdnKDrpI2eSuN2dmCRgj03lZauVTOpfHb1YbGzfqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HzI7vKE54gJRXvtuQIsooZasYS1s+MeJFpiI3yly8V9lLZPknOdl/PHO+OH1vYWui
	 id0Fglh7vPZGlIXzK2wyiP0T2g86VkuGpFMXze7zce0S3irw7k3OY54CLGFIkojdpn
	 RfaadlUluJH7/wrYu/TsyaBumj3wZOWNDc5K7sZ4=
Date: Tue, 15 Oct 2024 13:18:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
Message-ID: <2024101532-evolve-only-5844@gregkh>
References: <20241014141217.941104064@linuxfoundation.org>
 <3ab1938a-6f6a-4664-9991-d196e684974d@nvidia.com>
 <6a357a0c-2cbf-4205-955b-5f2866ba7829@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a357a0c-2cbf-4205-955b-5f2866ba7829@nvidia.com>

On Tue, Oct 15, 2024 at 06:50:43AM +0100, Jon Hunter wrote:
> 
> On 15/10/2024 06:31, Jon Hunter wrote:
> > Hi Greg,
> > 
> > On 14/10/2024 15:09, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.113 release.
> > > There are 798 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > 
> > ...
> > 
> > > Oleksij Rempel <linux@rempel-privat.de>
> > >      clk: imx6ul: add ethernet refclock mux support
> > 
> > 
> > I am seeing the following build issue for ARM multi_v7_defconfig and
> > bisect is point to the commit ...
> 
> To be clear, I meant the 'above' commit.

Thanks, let me go drop this (and the other ones around it) and push out
some -rc2 releases.

greg k-h
