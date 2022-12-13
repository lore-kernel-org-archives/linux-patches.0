Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40F2748C
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 18:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F9FC433D2;
	Tue, 13 Dec 2022 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670954869;
	bh=7nIhFvx45XTCphvvUSpM+7j2P/I9wE89cs+unNBEsiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZM+9+W6Zef2IIByoKIihgPBXIFq+HsSuSK4fpOsWcYIX+37gdy31leW68o/9+NWam
	 ffMBdhijtoED2p3BtqRq+2uDkFQd1HKTOxaJdF51FfWSfjFql2sy210Nm4ROGXjc9q
	 KLik/0LY9X6f1FRMawE1rsvFhs1B63F1dqnENG1I=
Date: Tue, 13 Dec 2022 19:07:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5i/c2tNslzs86Gj@kroah.com>
References: <20221212130924.863767275@linuxfoundation.org>
 <Y5hqsggURI1Me1ik@debian>
 <CADVatmPM4Q5A9jVO6-ixhqa2HWh4rWPKNpfwy75u69My=3Xhjw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPM4Q5A9jVO6-ixhqa2HWh4rWPKNpfwy75u69My=3Xhjw@mail.gmail.com>

On Tue, Dec 13, 2022 at 03:31:35PM +0000, Sudip Mukherjee wrote:
> On Tue, 13 Dec 2022 at 12:06, Sudip Mukherjee (Codethink)
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.159 release.
> > > There are 106 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> > > Anything received after that time might be too late.
> >
> > Build test (gcc version 11.3.1 20221127):
> > mips: 63 configs -> no failure
> > arm: 104 configs -> no failure
> > arm64: 3 configs -> no failure
> > x86_64: 4 configs -> no failure
> > alpha allmodconfig -> no failure
> > powerpc allmodconfig -> no failure
> > riscv allmodconfig -> no failure
> > s390 allmodconfig -> no failure
> > xtensa allmodconfig -> no failure
> >
> > Boot test:
> > x86_64: Booted on my test laptop. No regression.
> > x86_64: Booted on qemu. No regression. [1]
> >
> > arm64: Booted on rpi4b (4GB model).
> > Regression noticed:
> > Failed to start Network Manager
> >
> > Will try a bisect and find which commit caused it.
> 
> Bisect pointed to 60aefe77fb48 ("net: broadcom: Add
> PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835")

Should be fixed in -rc2.

thanks,

greg k-h
