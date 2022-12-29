Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9631FAF
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 16:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66131C433EF;
	Thu, 29 Dec 2022 16:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672333010;
	bh=ViY2BQZiltKQ4jvkmjytVNSOGiM2TZgrElzKyBr36hI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=il2VIfqB0ez0Rmb8rH8N8IDk4hm1ko30z46bpjv8Rg9GUkfXEeZbMhhL0NBzyw7Be
	 7Qj1a23+u68ocrKbH/Ulo2wwMFN0I6kYWMu/XOTRpxNRVIEQ3u6lQv4s7uJViJ/x5a
	 tL4qJBgqrQLGzDWbiLoPjYCfo1fzvPmJxjm6pZF0Xp03wjAU++P3v+j2EixzHLhPIs
	 ZpdJKbaT2VXdDAh+vEiXbFxquISfD4ySjIz7qZSZlXW9xToM2UbhVO7YrLzaZf113s
	 hNIvwVnW+IyikoDTK2Y3arQLyAT9eDZpN3ab145lcY1npyZCoyOwclqfjScbTRbtHq
	 oLfLjOEte7dvw==
Date: Thu, 29 Dec 2022 09:56:47 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, andrii@kernel.org,
	dave.stevenson@raspberrypi.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Message-ID: <Y63Gz7Jpms95bz15@dev-arch.thelio-3990X>
References: <20221228144256.536395940@linuxfoundation.org>
 <Y62m85tYWONgSWmm@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y62m85tYWONgSWmm@duo.ucw.cz>

On Thu, Dec 29, 2022 at 03:40:51PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.15.86 release.
> > There are 731 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> These are just kCFI annotations. I don't believe we need them in 5.10
> (and 5.15).

The original CFI implementation exists in 5.15 and the problem described
in those patches should still trigger with that implementation just like
kCFI, so they should likely still go to 5.15. However, they were
AUTOSEL'd and we have not had any reports of problems that are solved
with these patches (although that is likely because nobody who is using
this hardware has tried running a CONFIG_CFI_CLANG kernel), so I do not
really care if they are applied or not.

> > Nathan Chancellor <nathan@kernel.org>
> >     net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
> > Nathan Chancellor <nathan@kernel.org>
> >     drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
> > Nathan Chancellor <nathan@kernel.org>
> >     drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Cheers,
Nathan
