Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C98963C3
	for <patches@lists.linux.dev>; Fri, 11 Aug 2023 10:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236C3C433C7;
	Fri, 11 Aug 2023 10:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691748305;
	bh=S+D3mzGhZ7WrusRlU/dEJf4r8+kJ8neVZRDfQ8Db7E0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DBzebsmcS/1rdhgOjaafoWHNa6e25g9KvhodiXQIszFcXfaqC7KnZ7pCTaxKChqyN
	 CuJ3UW3Htro7ci169Ab+pOVgIiU6bb5GRaUndAXS3co+kKg+7GL1R5tvB+qrlOi0RF
	 I673OXH7fxVysFqH+Y7UdivXMzkzhWF5LpeU1xFA=
Date: Fri, 11 Aug 2023 12:05:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
Message-ID: <2023081124-resupply-tidings-740f@gregkh>
References: <20230809103633.485906560@linuxfoundation.org>
 <681f8e2c-df72-4a54-bef8-803ac0bc69f6@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681f8e2c-df72-4a54-bef8-803ac0bc69f6@roeck-us.net>

On Thu, Aug 10, 2023 at 09:06:01AM -0700, Guenter Roeck wrote:
> On Wed, Aug 09, 2023 at 12:40:36PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.126 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 160 pass: 157 fail: 3
> Failed builds:
> 	arm:allmodconfig
> 	arm64:defconfig
> 	arm64:allmodconfig
> Qemu test results:
> 	total: 501 pass: 423 fail: 78
> Failed tests:
> 	<most arm>
> 	<all arm64/arm64be>
> 
> As already reported, plus:
> 
> Error log:
> drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c:176:20: error: 'drm_plane_helper_destroy' undeclared here

Offending commit now dropped, Sasha's dep-bot went a little crazy there,
and this wasn't needed, sorry for not catching that sooner.

> for arm:multi_v7_defconfig
> 
> Side note: I am surprised about successful arm64 tests/builds
> since arm64:defconfig fails to build with obvious code errors.
> 
> drivers/firmware/arm_scmi/smc.c:39:13: error: duplicate member 'irq'
> 
> drivers/firmware/arm_scmi/smc.c: In function 'smc_chan_setup':
> drivers/firmware/arm_scmi/smc.c:118:34: error: 'irq' undeclared

Should now be fixed, thanks.

greg k-h
