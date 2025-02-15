Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7365B1991B8;
	Sat, 15 Feb 2025 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739638026; cv=none; b=pjNiLzmF0FJDNyGHfjVN1EnuXGNs5NPwaMk1bH2Etl5PZreO28Im4VZ+DxKk2WzXrFYIIGiH8xUEGLLzYcWwRi/I45jPekmjTe2Zf46UJRwQXgPvA6TzKlsG88svx0dBiAotUFRTvyKeAuq6xwhFD4SJBZoZT2JuUtOSa9os00s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739638026; c=relaxed/simple;
	bh=fsemyYviayrMqmaEoMnLdr7Sih/TjQ/sv8vBN4HPuzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU99SAn/6b/WJAecOANWHvvqrQs5TbINkIfFgLdU4REvML0a43DsWoKY3GCtbTPUyb7LJFk02rA36DDnzQr/iGHRJ3VDJBv5S3obLBxqQ6IGmZrKFN8CEmPuuZ7VlgcK1fsOqKQ8qF3atLWJLJWiFaD7XOpssm5+6sCn3wxQMGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDn+1umM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDn+1umM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FA3C4CEDF;
	Sat, 15 Feb 2025 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739638025;
	bh=fsemyYviayrMqmaEoMnLdr7Sih/TjQ/sv8vBN4HPuzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FDn+1umMmbgVRQ+3DehicQe/rM+qPLKgLyyiX6YZGr27hZ3MlGX8L4RWYTxI72Lml
	 EtnVWRJnS/qMu2+UwVlJL0bMTirR9b2d6cX7CdfTFpjN6jxToliHRpTYJDISgvASZf
	 m94z0iF80Qvu1Wj4nPmb4DgdEGXoxsSSeeExz5hg=
Date: Sat, 15 Feb 2025 17:47:01 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
Message-ID: <2025021557-fame-reliance-74ca@gregkh>
References: <20250215075925.888236411@linuxfoundation.org>
 <89b2547b-f351-4029-a5cf-b54690996b6c@rnnvmail204.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89b2547b-f351-4029-a5cf-b54690996b6c@rnnvmail204.nvidia.com>

On Sat, Feb 15, 2025 at 08:22:11AM -0800, Jon Hunter wrote:
> On Sat, 15 Feb 2025 09:00:06 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.3 release.
> > There are 442 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 17 Feb 2025 07:57:54 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc3.gz
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
> Linux version:	6.13.3-rc3-gf10c3f62c5fd
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Finally, thanks!
