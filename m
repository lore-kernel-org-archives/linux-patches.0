Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BC422172C;
	Thu,  1 May 2025 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746101321; cv=none; b=psmgUwBlxLToDe+MF2Vh+wf5GaK/yycblWgXUqyIHhnPfLZqdS6Xr2O+Yzljvji667MxfnGUbkeEVz+ObBavOnngbwm1Mb7Vxylaitkm+cm1agCPuwgKSpfhHR3e4j4eYsBTknmkAk673uTrMLzTY99pWkDwTv1JjK3SiX+Tk60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746101321; c=relaxed/simple;
	bh=u2MmEqJy/SJZoUoRB2qEBCQqBQSZGn/luJwgJregaE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDXelrE4YdAPN9sBRdFJyto2YuZD9w1N5Q5hXoEZpVly9F90rsKoo+uQKlbkfDpu+g+cRFCPOpFUWIDfRELrk+kzzT94BN3E16xlcaDBoEaPyPzwxY9PvIpLsqIevKssKIzZxHKHEtbB9gB7UY5zqi79bwWAyfvtUskgBHdzUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=in9IcdMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="in9IcdMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE69CC4CEE3;
	Thu,  1 May 2025 12:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746101320;
	bh=u2MmEqJy/SJZoUoRB2qEBCQqBQSZGn/luJwgJregaE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=in9IcdMpfhe1hDjD9Zf4yYrA/+389dvoDD6ReE7b/+uVxibs3RHTKfw5S3zRYS7X2
	 d+aC2epahwAN5Z0dF2CVZOb1EBY0bRiyKG3tV400CONg0UHAnda0oSaKx/cxjOK+qi
	 iZa21cIBUHzSfMQJOoZm/sKPeKGBnn2frIkUCM7M=
Date: Thu, 1 May 2025 14:08:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/368] 5.15.181-rc2 review
Message-ID: <2025050129-pantyhose-stereo-569f@gregkh>
References: <20250501081459.064070563@linuxfoundation.org>
 <76ee0569-5d39-4bb4-a3c2-f222ca17c0f7@rnnvmail203.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ee0569-5d39-4bb4-a3c2-f222ca17c0f7@rnnvmail203.nvidia.com>

On Thu, May 01, 2025 at 04:07:27AM -0700, Jon Hunter wrote:
> On Thu, 01 May 2025 10:18:10 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.181 release.
> > There are 368 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 03 May 2025 08:13:53 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.181-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.15:
>     10 builds:	10 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     101 tests:	101 pass, 0 fail
> 
> Linux version:	5.15.181-rc2-g85e697938eb0
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Great, thanks for the quick turn-around!
