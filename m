Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7541426B
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 10:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIrcs0lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127D4C433C8;
	Fri,  6 Oct 2023 10:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696587178;
	bh=5EsPB5exUzDSp/zAgvqbx2CniTkzicOjf46c+7+WITE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EIrcs0lTEIfYgc+vHhjNSyLZdIZndHXdeloDkkAVJHH1oWsxWfggKbcgh5+NvMind
	 L+vqXUw6eSPV904cvLjBIl/IxrXR6PcwlMb3RHwSAOHyeHEfWiZcav8t8jF8ngL8QC
	 VGxYFuFYpyZIur+qFb5Bkx3BttuI/8271HrVtlOk=
Date: Fri, 6 Oct 2023 12:12:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Message-ID: <2023100648-lizard-briskly-f6ac@gregkh>
References: <20231004175217.404851126@linuxfoundation.org>
 <20231005081746.D7B7.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005081746.D7B7.409509F4@e16-tech.com>

On Thu, Oct 05, 2023 at 08:17:48AM +0800, Wang Yugui wrote:
> Hi,
> 
> > This is the start of the stable review cycle for the 6.1.56 release.
> > There are 259 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.56-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> 
> This 6.1.56-rc1 failed to build on rhel7 with dev-tool-set 8, but 6.1.55 works.
> 
> Build error message:
> gcc: fatal error: no input files
> make[3]: *** [pmu-events/Build:33: pmu-events/pmu-events.o] Error 1
> 
> After the revert of 'perf-build-update-build-rule-for-generated-files.patch'
> the build works again.

Offending patch dropped, thanks.

greg k-h
