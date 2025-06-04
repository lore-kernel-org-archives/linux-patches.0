Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3C313D24D;
	Wed,  4 Jun 2025 09:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749031141; cv=none; b=V8CKY3+uMOdL0Wt0pjvOzUddahKkRjtYJ7hpsmzI94ZRv/itHNLMBDxqcd1Jj6Z6ap4DC3l2oJXd1t/YuW4gOYXemtNTJ0B+AFKvZuOJ2YTm9MJ8Gu80llzzI9lQyel1lqKF62vbrp3a5bXJS6qWz6KLwTWV085ocfnb9nsLUHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749031141; c=relaxed/simple;
	bh=CqCmbrbXobJgc1ymA9/kKEL8N3CEYCC7UPRgK9vYaoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBPNhut90BzP4z9FfFaYi6aKFAoGnHAt1GziRFfxoy24WvFSuUeNS1kGYZcP/ZSFvsOtJgo2NnX0YZbmXcRihKWEmaMpAeW2lezkI3r7rfPglbIkjBzTx3AonICVcZnAFdSvETimwSeWepvIkEQHqainAFujvmHzIsw9v73KmXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GF9aA4Tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GF9aA4Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A071C4CEE7;
	Wed,  4 Jun 2025 09:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749031140;
	bh=CqCmbrbXobJgc1ymA9/kKEL8N3CEYCC7UPRgK9vYaoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GF9aA4TbIZJFMyVVDGQL3bsBKLwjB13kEJh2YOjr/VtsqKnhID7qPC+gVYoQ5gm47
	 SvLAtiEvMBpXUJd1EUeckKoTUmAgZd70ZpvxYUVNvIvG4xYMX9esHHrsXSTetjzCoY
	 3Av3FNqciKp3cEaPuk49+/o7Tjsvx8TMuS7BhNwc=
Date: Wed, 4 Jun 2025 11:58:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
Message-ID: <2025060446-chewer-dill-080e@gregkh>
References: <20250602134238.271281478@linuxfoundation.org>
 <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>

On Wed, Jun 04, 2025 at 02:41:11AM -0700, Jon Hunter wrote:
> On Mon, 02 Jun 2025 15:47:17 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.32 release.
> > There are 55 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.12:
>     10 builds:	10 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     116 tests:	115 pass, 1 fail
> 
> Linux version:	6.12.32-rc1-gce2ebbe0294c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh

Any hints as to what is causing the failure?

thanks,

greg k-h
