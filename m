Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E64017FE1
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 14:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1697CC433C8;
	Wed, 21 Jun 2023 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687356001;
	bh=w05c+8v2cS+NGq2QmmfdxxgrwN8kxVIk9z62+wPPCYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i69IJXkCenodNyhXC9AY0jMR0Dz8fv8z/fizaL+0TnNmO7FI8lKDxacqtFqzAcVAu
	 X0Nx2PBli/giOFdJ2Ja7ReW+ptBruJKCm32GcFyyPLIWvTbAf4st/dNIHtSble4B5i
	 y9L9VgGhwJdbeD3BV3OK0muxOpspc+GBd9GOmags=
Date: Wed, 21 Jun 2023 15:59:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/107] 5.15.118-rc1 review
Message-ID: <2023062150-expansive-polygon-7b5f@gregkh>
References: <20230619102141.541044823@linuxfoundation.org>
 <f7bf3aa8-f1b8-a1b5-8e51-46d51d002633@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7bf3aa8-f1b8-a1b5-8e51-46d51d002633@linuxfoundation.org>

On Tue, Jun 20, 2023 at 03:04:12PM -0600, Shuah Khan wrote:
> On 6/19/23 04:29, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.118 release.
> > There are 107 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.118-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and boots, but doesn't get to login prompt. Keeps running
> into NMIs and watchdog detects had lockups.
> 
> I am starting bisect and will keep you updated.

Very odd, let me know what you find, thanks!

greg k-h
