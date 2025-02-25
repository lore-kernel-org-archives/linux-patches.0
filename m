Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA01C8625;
	Tue, 25 Feb 2025 10:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740479612; cv=none; b=McfNer5x4I4PJ+nXWMdhIGk2ZKWf7fwTq3lJCvw2WPZjUM97nxOhCiriKIQDv+VHP4/HWk96H6DQe5Q1tz4jBiqchdC3lC/616AFxD44/Y7VsG+4HyqT1/y6K8C0D9h+mgfmUPfvHsndjkVu6QK3AQiG9YLXKclnB2fXIQElg6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740479612; c=relaxed/simple;
	bh=NasLaFCTh8OVIdznOnAP+iiGwnp+cgpHZ9eZS5tukHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWGXOhe1YMGPDgJRtaX2YhbY+wafjO9zmWkijor7cNg4qetzN2hiYHA97wLuLLmfYq/8O9aD+yEK8XMCkQOzqBIm/r2z6Pt2P6U1DHJkcPYwB976lPs1gl9tMrcZ7cV4uyjt8qvfHhgFrmmOi5GkpeMqONiKwuvepFLfzHaWKOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtYJ9t6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtYJ9t6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B5FC4CEDD;
	Tue, 25 Feb 2025 10:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740479612;
	bh=NasLaFCTh8OVIdznOnAP+iiGwnp+cgpHZ9eZS5tukHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YtYJ9t6boa1zdSHm0JT0wqm4N0mW/bGXnuMbBC7tPuW8GN2vit4kDkNJRb7bDuIWR
	 jdmdBtNdB39ygnMHwgozRkEfh0oDrsIQqWLTPV8z0tizz6x53L01FDrtL4aGWkcZK2
	 NZZG2mNiKqlh0630ixm6GueFEc8UoMoVMCMKQdBw=
Date: Tue, 25 Feb 2025 11:32:22 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
Message-ID: <2025022514-malt-decade-1518@gregkh>
References: <20250225064750.953124108@linuxfoundation.org>
 <e8372ca2-1f23-447e-a8c9-7afc7a19bc74@rnnvmail204.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8372ca2-1f23-447e-a8c9-7afc7a19bc74@rnnvmail204.nvidia.com>

On Tue, Feb 25, 2025 at 01:30:08AM -0800, Jon Hunter wrote:
> On Tue, 25 Feb 2025 07:49:18 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.5 release.
> > There are 137 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.5-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v6.13:
>     10 builds:	10 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     116 tests:	116 pass, 0 fail
> 
> Linux version:	6.13.5-rc2-g1a0f764e17e3
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Wonderful, thanks for the quick testing!
