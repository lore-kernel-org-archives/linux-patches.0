Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D4763D;
	Fri, 13 Dec 2024 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734085056; cv=none; b=XcjJJ6H782p2gdvQdHtzX2Sa97EiaFalqHRIHH61fMKvG1Zu4kZMs/eulrcAStNJfLzM8Q3gqhyLuXRr+FpD/sFfFo7EUXJ0NldtzwJ2VNfjN2Q5joTgDG6si7hFxpwfPF7wnKo+NS6SJW9bMQ+8hPcu+K5r0z9J6Gg6LF4Uk5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734085056; c=relaxed/simple;
	bh=5lq0wsWnANBbji6qT4ZsoK4LwoV3lp4vZOGyUhzDZh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fa4Sfo+JEhTfm95RwA2oyin4O4cpjgt8Q+thwKjsYBini5Ws92qq6E551rpBU2zPG7AMwOaMJBbssXnpqbFx/Pea3InbXf0yUbheO9MwDxj+i7tZ3j9UdJ1ePdbDD19I+UV2aP0Mp1JmYQ3S/U+bwlENciGJutwJojmD8Q7HTZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3KueZlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3KueZlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDB5C4CED0;
	Fri, 13 Dec 2024 10:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734085055;
	bh=5lq0wsWnANBbji6qT4ZsoK4LwoV3lp4vZOGyUhzDZh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K3KueZljrecBB2qCd3lvymxT5GJV0oIh2KD7TSQh1f/tB8gUjaIR94e8ioH4g427I
	 xQpMgDLP56KFK1xJ3V/T5NrzrerpGAhD9cJ/0jiVceA6nwvMHLBCGN9EX2O3XHLG+3
	 IdZbSCFsvT9aTZ4AddrYqsBLEYRTu8L3mZivBgy4=
Date: Fri, 13 Dec 2024 11:17:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
Message-ID: <2024121321-corset-smuggling-e72d@gregkh>
References: <20241212144244.601729511@linuxfoundation.org>
 <8e388173-5e39-4b7f-be7c-f471c9639d3b@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e388173-5e39-4b7f-be7c-f471c9639d3b@nvidia.com>

On Fri, Dec 13, 2024 at 10:09:52AM +0000, Jon Hunter wrote:
> 
> On 12/12/2024 14:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.66 release.
> > There are 356 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.66-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> No new regressions for Tegra ...
> 
> Test results for stable-v6.6:
>     10 builds:	10 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     116 tests:	115 pass, 1 fail
> 
> Linux version:	6.6.66-rc1-gae86bb742fa8
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
> 
> 
> Tegra186 tests are failing randomly but there is a fix now in the mainline
> ...
> 
> 4c49f38e20a5 ("net: stmmac: fix TSO DMA API usage causing oops")
> 
> Let me know if you want me to send a separate request to include in this in
> stable.

Please do, so it doesn't get lost.

thanks,

greg k-h
