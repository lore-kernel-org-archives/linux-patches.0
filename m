Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9395690
	for <patches@lists.linux.dev>; Fri, 11 Aug 2023 10:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772F7C433C7;
	Fri, 11 Aug 2023 10:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691748170;
	bh=xC6xCF59/vHm2/A7zKITsSRm+28kIsZel84TAs1GYMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C2DJEoSxuLHm55jwnTumHz0OvwCvqQIewzKbnDdcFuZNCwZYJD3jUfBO7pqnQXIfs
	 trSKKB/tDa09jsO+fp+11sh5l2UHCJ6E6NsmLF8mthbyJEQTnwTxwJ6/xCEqF4BzXS
	 zxcLW8+TRAtCGpn6nVkYrnyfdBk/xTOzUEsCResw=
Date: Fri, 11 Aug 2023 12:02:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
Message-ID: <2023081137-strive-cataract-d3d2@gregkh>
References: <20230809103633.485906560@linuxfoundation.org>
 <9a3b1ff6-d702-6b67-9d9b-5eb1f90b4e50@roeck-us.net>
 <3815ef44-4edd-8d53-14e3-043b26d025f4@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3815ef44-4edd-8d53-14e3-043b26d025f4@gmail.com>

On Thu, Aug 10, 2023 at 09:25:53AM -0700, Florian Fainelli wrote:
> On 8/10/23 03:24, Guenter Roeck wrote:
> > On 8/9/23 03:40, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.126 release.
> > > There are 92 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> > > Anything received after that time might be too late.
> > > 
> > Building arm:allmodconfig ... failed
> > --------------
> > Error log:
> > drivers/firmware/arm_scmi/smc.c:39:13: error: duplicate member 'irq'
> > 
> > drivers/firmware/arm_scmi/smc.c: In function 'smc_chan_setup':
> > drivers/firmware/arm_scmi/smc.c:118:34: error: 'irq' undeclared
> > 
> > Building arm64:defconfig ... failed
> > --------------
> > Error log:
> > 
> > drivers/firmware/arm_scmi/smc.c:39:13: error: duplicate member 'irq'
> > 
> > drivers/firmware/arm_scmi/smc.c: In function 'smc_chan_setup':
> > drivers/firmware/arm_scmi/smc.c:118:34: error: 'irq' undeclared
> > 
> > That is because commit d80e159dbdbb ("firmware: arm_scmi: Fix chan
> > free cleanup on SMC") is applied without its dependent commit(s).
> 
> Indeed, we discussed this here:
> https://lore.kernel.org/all/20230810084529.53thk6dmlejbma3t@bogus/

Offending commit should now be dropped, thanks.

greg k-h
