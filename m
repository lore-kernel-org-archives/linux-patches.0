Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3877F1FB3
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 10:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2384DC433C7;
	Wed, 30 Aug 2023 10:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693392743;
	bh=HkmR4WgVFZiZO7iDk5txTDhY7eZdDEzHI12HCpTFiQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M0d8l5h7KWzt9bGt0L3p2LA0kZwmhmUUpXZSByTmPw04dRaSd3QlsWjijShdZBXj/
	 oEgTvBfHz5EgRKEaj8PSLuy0jAz5rNl0d0VYv8sEt/YCxpwL3792qtiEB7d62+/3fu
	 hJsutYNiMM6UiykILQmssKzU4FzZdu6ZNpc64fH4=
Date: Wed, 30 Aug 2023 12:52:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Message-ID: <2023083014-barley-upscale-518e@gregkh>
References: <20230828101149.146126827@linuxfoundation.org>
 <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>

On Mon, Aug 28, 2023 at 09:42:11AM -0700, Guenter Roeck wrote:
> On 8/28/23 03:13, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.193 release.
> > There are 84 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> > Anything received after that time might be too late.
> > 
> 
> FWIW, commit 619672bf2d04 ("MIPS: Alchemy: fix dbdma2") should be reverted
> v5.10.y since it doesn't fix anything but breaks the build for affected boards
> completely.
> 
> arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
> arch/mips/alchemy/common/dbdma.c:632:14: error: 'dma_default_coherent' undeclared
> 
> There is no 'dma_default_coherent' in v5.10.y.

But that was added in 5.10.185, from back in June.  What changed to
suddenly cause this to fail now?

As this isn't a new regression, I'll hold off on fixing this here and
just do so in a future release.

thanks,

greg k-h
