Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B4963CC
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 10:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80583C433C7;
	Thu, 31 Aug 2023 10:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693477907;
	bh=sVe81tGYTuNTvaFqMkoqQUkGZ1NXIVLWBQR9O2Gk6Rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=baDUrZlgDgWjtX6I0OAcKNSaCRhbJF/Kak1bW/pAk39tLgra/orqDloD/7DHlGyb5
	 vLgbpK+TEXcMffmGC2yuwbgB2xfofvdeHR8CjdXim8jm6+1JmcGXm1zeJ979la8ep/
	 WO9k8OdtQkSZIaEBpJIFNafWHwOP4GQnktHhtRdc=
Date: Thu, 31 Aug 2023 12:31:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Manuel Lauss <manuel.lauss@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>, stable <stable@vger.kernel.org>,
	patches@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	Pavel Machek <pavel@denx.de>, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Message-ID: <2023083138-frustrate-race-9264@gregkh>
References: <20230828101149.146126827@linuxfoundation.org>
 <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>
 <2023083014-barley-upscale-518e@gregkh>
 <64374066-4086-3e92-8650-ab1563350f0c@roeck-us.net>
 <95baa835-9940-a257-cf96-93c543aa389f@gmail.com>
 <CAOLZvyEuj=93tpObwDgyAK01Jyz8NfXQzJfAX5=vVwG1wxo-cA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLZvyEuj=93tpObwDgyAK01Jyz8NfXQzJfAX5=vVwG1wxo-cA@mail.gmail.com>

On Wed, Aug 30, 2023 at 07:38:09PM +0200, Manuel Lauss wrote:
> Hello all,
> 
> Florian Fainelli <f.fainelli@gmail.com> schrieb am Mi., 30. Aug. 2023, 19:07:
> >
> > + Manuel,
> >
> > On 8/30/23 09:01, Guenter Roeck wrote:
> > > On 8/30/23 03:52, Greg Kroah-Hartman wrote:
> > >> On Mon, Aug 28, 2023 at 09:42:11AM -0700, Guenter Roeck wrote:
> > >>> On 8/28/23 03:13, Greg Kroah-Hartman wrote:
> > >>>> This is the start of the stable review cycle for the 5.10.193 release.
> > >>>> There are 84 patches in this series, all will be posted as a response
> > >>>> to this one.  If anyone has any issues with these being applied, please
> > >>>> let me know.
> > >>>>
> > >>>> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> > >>>> Anything received after that time might be too late.
> > >>>>
> > >>>
> > >>> FWIW, commit 619672bf2d04 ("MIPS: Alchemy: fix dbdma2") should be
> > >>> reverted
> > >>> v5.10.y since it doesn't fix anything but breaks the build for
> > >>> affected boards
> > >>> completely.
> > >>>
> > >>> arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
> > >>> arch/mips/alchemy/common/dbdma.c:632:14: error:
> > >>> 'dma_default_coherent' undeclared
> > >>>
> > >>> There is no 'dma_default_coherent' in v5.10.y.
> > >>
> > >> But that was added in 5.10.185, from back in June.  What changed to
> > >> suddenly cause this to fail now?
> > >>
> > >
> > > Nothing. I started to build this configuration and tracked down the
> > > problem after the build failure was reported by others. Sorry, I didn't
> > > initially realize that this is an old problem.
> >
> > We could back port 6d4e9a8efe3d59f31367d79e970c2f328da139a4 ("driver
> > core: lift dma_default_coherent into common code") but that won't work
> > too well on 4.14 or 4.19. I believe it would be simpler to adjust the
> > branches with this patch, Manuel does that work?
> 
> Please drop this patch from all stable releases. I didn't CC stable
> when I submitted it,
> and have no idea why it ended up there anyway.
> It was intended to fix a problem initially found in 5.18 (I think).

I'm going to revert it now, thanks!

greg k-h
