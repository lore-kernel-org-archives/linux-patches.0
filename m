Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2542E5434;
	Tue,  8 Jul 2025 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751996086; cv=none; b=qhJynI4/sgnVEm0iHjkVQFRLCtiYcYbnRWeLwfUFi6PS8XVIOSiUMusPOA1dy0fQKIPZlxAsSmkP1QYkzqcOagUletwU2FEUabN2xZXGNMkK8Pv5bry42u4O4eKfGAfIp1GYYqqyR6lxKNmjd1s0BKS6tlqVNRIAZrqbjg0r9Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751996086; c=relaxed/simple;
	bh=O1mTjwTh8tYUNOxmmvKTVdXoJHNyJf5rnO5qzxhcGwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpV/IbBqtbBvGlv8SAlIMZFvIkqLVeJrombPIdn4lp1isNhT4A0iLr9145fHWPMcD33qD2f+haDX2bBboMFUe/ewlexoYafKIPdvZ5R1hS0ZZy1TsM0I1cDImXbcYwvTeu2kiGtfZSWYQ+1L6/8IN60q7BZdcr/DRCruYogXXOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTEWDkOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTEWDkOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA37DC4CEED;
	Tue,  8 Jul 2025 17:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751996086;
	bh=O1mTjwTh8tYUNOxmmvKTVdXoJHNyJf5rnO5qzxhcGwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JTEWDkOg1wburMNhD0gDFLcBzjYxUZvO8XLgT+cmtwV4d7oFm2+YhHTwsCT0ZnurS
	 LPEmixvtG5M4fLQ6rVZIv3kmgl45RgDwg4RA9bkcarz6g00C4rpLwUu2Sxd48q21E0
	 6kSm13vQZR6gnOBlZbsjiPRSPa5Etpnk1UJgoKjQ=
Date: Tue, 8 Jul 2025 19:34:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
Message-ID: <2025070820-recital-subgroup-502f@gregkh>
References: <20250708162231.503362020@linuxfoundation.org>
 <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>

On Tue, Jul 08, 2025 at 10:20:01AM -0700, Florian Fainelli wrote:
> On 7/8/25 09:20, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.187 release.
> > There are 160 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.187-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> The ARM 32-bit kernel fails to build with:
> 
> /local/users/fainelli/buildroot/output/arm/host/bin/arm-linux-ld:
> drivers/base/cpu.o: in function `.LANCHOR2':
> cpu.c:(.data+0xbc): undefined reference to `cpu_show_tsa'
> host-make[2]: *** [Makefile:1246: vmlinux] Error 1
> 
> This is caused by:
> 
> commit 5799df885785024821d09c334612c00992aa4c4b
> Author: Borislav Petkov (AMD) <bp@alien8.de>
> Date:   Wed Sep 11 10:53:08 2024 +0200
> 
>     x86/bugs: Add a Transient Scheduler Attacks mitigation
> 
>     Commit d8010d4ba43e9f790925375a7de100604a5e2dba upstream.
> 
>     Add the required features detection glue to bugs.c et all in order to
>     support the TSA mitigation.
> 
>     Co-developed-by: Kim Phillips <kim.phillips@amd.com>
>     Signed-off-by: Kim Phillips <kim.phillips@amd.com>
>     Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
>     Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I don't see this in Linus' tree but it's not clear yet why that is not
> happening there.

I see it in Linus's tree, you might want to do a sync :)
