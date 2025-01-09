Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD66E2163AF;
	Thu,  9 Jan 2025 11:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736421090; cv=none; b=OBoVNLoaaTGdIXhrjo4m6MTwkhe1GRDoxsZayDI9so2+Q6ba2B7I5hnK0Ao/O2aswL801ghkCvKUElr9GIASw17DtxE0/VNU56+2Dp6v7DQWcNW62M3MY8oNF9ibxZymtSBPxZEvIbS5l671S3H3thzbeteCBKqna27JzKL2ud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736421090; c=relaxed/simple;
	bh=g2mrLiwGez/7VNoBp7dSY2O9AvTdlI9GNQWbuVkSXBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rviL8kw0+lj7tk2d8wfOmdixXcOGflntfNNWStK2yVHATxzbWuELLyOqa/gZRMZSZAN60tTBEHGCMSqVGkGnfUUkSU5zOe6iWlrI/+9YPx9rcThFNZ6ke9qAX7gc8zLaoFwsxIS6q151ACVNyjLqfrtcIlrmKCvcLd705ZgSqFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dsuxg/Wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dsuxg/Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0D0C4CED2;
	Thu,  9 Jan 2025 11:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736421090;
	bh=g2mrLiwGez/7VNoBp7dSY2O9AvTdlI9GNQWbuVkSXBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dsuxg/WdErBNNTrmyKjfRXrjx5xqYrm61t6r26t4+mtatYc1Hyv10IOhYxsgqdQ7l
	 6Vzlz8/IA6VKmT77tvsf8sKBLNKUXlhQWRfYC6dWwxJX0+vMbk7cNYh3TF9lF3/tyn
	 tEooCuhsWcy30kX8EuknXgjJ2kxitKO44vACcryg=
Date: Thu, 9 Jan 2025 12:11:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
Message-ID: <2025010916-preorder-sway-50ad@gregkh>
References: <20250106151138.451846855@linuxfoundation.org>
 <d74b5262-cc20-40d3-89eb-69029965bdcb@collabora.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d74b5262-cc20-40d3-89eb-69029965bdcb@collabora.com>

On Wed, Jan 08, 2025 at 05:44:48PM +0500, Muhammad Usama Anjum wrote:
> On 1/6/25 8:15 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.176 release.
> > There are 168 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> OVERVIEW
> 
>         Builds: 34 passed, 5 failed
> 
>     Boot tests: 70 passed, 0 failed
> 
>     CI systems: broonie, maestro
> 
> REVISION
> 
>     Commit
>         name: v5.15.175-169-gbcfd1339c90c
>         hash: bcfd1339c90c53211978065747daad99e1149916
>     Checked out from
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> 
> 
> BUILDS
> 
>     Failures
>       -x86_64 (cros://chromeos-5.15/x86_64/chromeos-amd-stoneyridge.flavour.config)
>       Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0f6d423acf18d27370ec
>       Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function); did you mean ‘IFF_MASTER’?
>       -x86_64 (cros://chromeos-5.15/x86_64/chromeos-intel-pineview.flavour.config)
>       Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0f72423acf18d27370ff
>       Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function); did you mean ‘IFF_MASTER’?
>       -i386 (defconfig)
>       Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0fe6423acf18d27375ac
>       Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function)
>       -x86_64 (x86_64_defconfig)
>       Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0fdb423acf18d273753b
>       Build error: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.c:1948:78: error: ‘OTG_MASTER’ undeclared (first use in this function)
>       -i386 (i386_defconfig+allmodconfig)
>       Build detail: https://kcidb.kernelci.org/d/build/build?orgId=1&var-id=maestro:677c0fbd423acf18d27372f5
>       Build error: LD [M]  fs/xfs/xfs.o
>       CI system: maestro

Offending commit now dropped, thanks!

