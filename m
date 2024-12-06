Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3333B1B78E7;
	Fri,  6 Dec 2024 06:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733465269; cv=none; b=tmzNx5siMih5whNn3DRscYVXsSKDzdjbp20a7A07uJigIobkbFOMWqI4Juy1/Unfy8kNOaJfmQoicZo57t72oMU9tNJyc5S/8VarSG9WSs2Vd6K2EFuF1mrJo7uz5X0hzTUm/eZwJvVzmoHRUbdr6k2bcRfeUasvr+UFnHHlp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733465269; c=relaxed/simple;
	bh=bQTG4ROYlpWnNTZGt1f8lJv5nTc7ecS7XcpJ7b2lGCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUvQQfFfeTSd8YhyctJKxoV1b9piMW6W47GMLd84tixWAICJO4wM3VaL69AHXRvt5QeksBAhVGR80IteWthZtqkakQ5Z+p8eBKVy1Eeq7YkxI0vFCCs74wDvVnmpSSn0Kzw1spYvD++h42N0gtuwrYiJNjvtAK8Jj1u6xl8f/ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSs7cy/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSs7cy/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B44C4CED1;
	Fri,  6 Dec 2024 06:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733465268;
	bh=bQTG4ROYlpWnNTZGt1f8lJv5nTc7ecS7XcpJ7b2lGCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SSs7cy/azJLZmwU+NobQjIYR5WBA37D3ZFDEc9Xp0fi620u7V6ucA+XA9s0jqZx4F
	 oSK/GW0ZbVQb1aZxyq5UWhPqsB2sWQKzsPtJ+tIQEO6wUEsHA9R886165NHIPJ9Bii
	 +YUlWr66DKqZ0ojkMA80+NHuiAvF0RiVnzUlBtDQ=
Date: Fri, 6 Dec 2024 07:07:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
Message-ID: <2024120623-chloride-harvest-91fe@gregkh>
References: <20241203141923.524658091@linuxfoundation.org>
 <71fc98de-2f61-4530-8c03-dcd7fa3bf470@rnnvmail204.nvidia.com>
 <5a174c4b-fa2b-4180-af6b-ae50d76fef4d@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a174c4b-fa2b-4180-af6b-ae50d76fef4d@nvidia.com>

On Thu, Dec 05, 2024 at 02:40:28PM +0000, Jon Hunter wrote:
> 
> On 05/12/2024 14:38, Jon Hunter wrote:
> > On Tue, 03 Dec 2024 15:30:29 +0100, Greg Kroah-Hartman wrote:
> > > ------------------
> > > Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> > > is end-of-life.  It's been 6 years, everyone should have moved off of it
> > > by now.
> > > ------------------
> > > 
> > > This is the start of the stable review cycle for the 4.19.325 release.
> > > There are 138 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v4.19:
> >      10 builds:	6 pass, 4 fail
> >      12 boots:	12 pass, 0 fail
> >      21 tests:	21 pass, 0 fail
> > 
> > Linux version:	4.19.325-rc1-g1efbea5bef00
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra30-cardhu-a04
> > 
> > Builds failed:	aarch64+defconfig+jetson, arm+multi_v7
> 
> 
> This is the same build failure as reported here:
> 
> https://lore.kernel.org/stable/Z09KXnGlTJZBpA90@duo.ucw.cz/

Great, hopefully I fixed that up in the real release :)

thanks for testing this kernel all these years!

greg k-h
