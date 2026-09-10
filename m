Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E673939D0;
	Thu, 10 Sep 2026 06:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020860; cv=none; b=TGDyVS57uJ0420uhuVZ0OKk2oT7DfTHGbk55IPUeqPLeupfe9/tJo12vQG2ke2NbC4XZXhij5yHWBP6U+o1zcK3jroR7/PQGsIObB2pah22Fv/aP10WgUFR/06OgNxkIlUwfMkmlzyBaNCBYR+DOgiqbuNkSLjf10rZ4A3R31PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020860; c=relaxed/simple;
	bh=YM/4wRuX2Qi1LMqYbx8rCMSmKVcmkIT9KGYnnRgEaO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGp2oKSVovAghmX/xG0brT6iteC46prqNM6dxZ3n8iqqplgyq1FniuhoJIJs2k/z4/jjyg7OXLvE4S+NZ+hOVxHhghl9YvIjThoZmNAnFXeRPWgjPLrebNX2R3DfhNMUzXMPtbgx16PI2dWKnaGVi57IsOIKtJ2KkKg3R9wcWT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdK46Fqa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdK46Fqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959841F000FF;
	Thu, 10 Sep 2026 06:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789020848;
	bh=jXw4N5ytxD4UI37+p86OA4FEbqP4b9fZyLZr1WfZy7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BdK46FqaKe+s7ek8N6movVbNnNnE03TCAFe/eKcPHUfdb+ikavG3gW7PojaEcs2pd
	 hyCg6yETiyvUZ5ys5r0PCOvIz5UuCMGou73TKJS6AILYji6aK4uGZGD27zS3ZC4MK4
	 rm4h+FLqVcuxULDnlISaqnH1aM8E0tvrKs4KBJPQ=
Date: Thu, 10 Sep 2026 08:12:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
Message-ID: <2026091059-smudgy-boogieman-5af3@gregkh>
References: <20260909134237.773280130@linuxfoundation.org>
 <e976263f-5382-4e32-a3a6-5639c4d56abf@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e976263f-5382-4e32-a3a6-5639c4d56abf@nvidia.com>

On Thu, Sep 10, 2026 at 06:18:02AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 09/09/2026 14:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.51 release.
> > There are 583 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.51-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> > Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> >      ASoC: tegra210_i2s: sort the register default table
> > 
> > Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> >      ASoC: tegra210_i2s: sort the Tegra264 register default table
> > 
> > Jon Hunter <jonathanh@nvidia.com>
> >      ASoC: tegra: Fix the MIXER enable default value
> > 
> > Jon Hunter <jonathanh@nvidia.com>
> >      ASoC: tegra: Sort ADMAIF register defaults
> > 
> > Jon Hunter <jonathanh@nvidia.com>
> >      ASoC: tegra: Sort MBDRC register defaults
> > 
> > Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> >      ASoC: tegra210_mixer: sort the register default table
> 
> 
> These are causing some audio regressions for Tegra ...
> 
> Test results for next:
>     builds:	11 pass, 0 fail
>     boots:	26 pass, 0 fail, aborted 1
>     tests:	139 pass, 15 fail, aborted 1
> 
> Linux version:	6.18.51-rc1-g4cfd5b1359b0
> Boards tested:	tegra20-ventana
>                 tegra30-cardhu-a04
>                 tegra124-jetson-tk1
>                 tegra210-p2371-2180
>                 tegra210-p3450-0000
>                 tegra186-p2771-0000
>                 tegra186-p3509-0000+p3636-0001
>                 tegra194-p2972-0000
>                 tegra194-p3509-0000+p3668-0000
>                 tegra234-p3737-0000+p3701-0000
>                 tegra234-p3768-0000+p3767-0005
> 
> Test failures:	tegra186-p2771-0000: tegra-audio-loopback-testsuite.sh
>                 tegra186-p2771-0000: tegra-audio-mixer-testsuite.sh
>                 tegra194-p2972-0000: tegra-audio-loopback-testsuite.sh
>                 tegra194-p2972-0000: tegra-audio-loopback-testsuite.sh (rt565x loopback)
>                 tegra194-p2972-0000: tegra-audio-mixer-testsuite.sh
>                 tegra194-p3509-0000+p3668-0000: tegra-audio-loopback-testsuite.sh
>                 tegra194-p3509-0000+p3668-0000: tegra-audio-mixer-testsuite.sh
>                 tegra210-p2371-2180: tegra-audio-loopback-testsuite.sh
>                 tegra210-p2371-2180: tegra-audio-mixer-testsuite.sh
>                 tegra210-p3450-0000: tegra-audio-loopback-testsuite.sh
>                 tegra210-p3450-0000: tegra-audio-mixer-testsuite.sh
> 
> This tells me that there is some other dependency missing.
> My intention was to only backport these for v7.2 because
> audio is broken in that release for Tegra. Sorry if I screwed
> up an fixes tags here.
> 
> I see this is pulling in a bunch of other related patches, but
> I am not sure if these should be pulled in either. Adding Peter
> if he has any comments.

All of them had specific Fixes: tags on them, which I followed, are they
incorrect?

I can drop all of the "sort the register table" patches if you want from
all branches, just let me know.

thanks,

greg k-h
