Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102C72DEA7B;
	Wed, 20 Aug 2025 11:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755688460; cv=none; b=RqBbTscC3Ae+feO9gzlfanD2i+wUbSYuJZiJP6kwo23kU9bEf/M+HTf5d+2sQAXL4TBvQL4HzV2aCNZa9XAgmivtivwg+Jhjr4xE4JxfN8Sa8cAQPFKaO4eWeAUaqjiWFJdhiCxt8MkMsBkmKUlD00oVnmFRhOkw+w85Ax2X15k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755688460; c=relaxed/simple;
	bh=domlvknXf6H9GM1nbTdso2P9smF7bjT/RaPPqep1Kec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gmvGXlBZ+04WOKxRCYEpXZhG4oK9ZOCN71F4vPe9hoZmP7q+Rk+d51GeL8RyBT/Agb3ylkiw/XE+/Yq3sg1LXJLPhRpIRy5+Y4p/TpjSre9+0Thx5YfsvLYE9ByOp+OFX+GTiD9DwxKgYHPCJsXTLrj5jw+FERraxSbi4Z33LIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5p4klIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5p4klIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF89C4CEEB;
	Wed, 20 Aug 2025 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755688457;
	bh=domlvknXf6H9GM1nbTdso2P9smF7bjT/RaPPqep1Kec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f5p4klIMAiBQnJOeLsMGLEZncdsLEiCUuDFyugcBHdCgRs8ka7kRTm3b9lsLV5eS8
	 RVxwVeigtUNh7cYVVpTIYP8L7KtiqPw/SEUX1sN7Y1qDVGCvgZAS9ujwkjNtCrSIMX
	 bAkqZlEUxHUrEa8/xgY0hlehfvk3DRcC7k0jla0Q=
Date: Wed, 20 Aug 2025 13:14:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
Message-ID: <2025082058-imprint-capital-e12c@gregkh>
References: <20250819122834.836683687@linuxfoundation.org>
 <bb8ebf36-fb7c-470c-89e7-e6607460c973@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb8ebf36-fb7c-470c-89e7-e6607460c973@sirena.org.uk>

On Wed, Aug 20, 2025 at 11:57:57AM +0100, Mark Brown wrote:
> On Tue, Aug 19, 2025 at 02:31:36PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.11 release.
> > There are 509 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I'm still seeing failures in the LTP epoll04 test which bisect to
> "eventpoll: Fix semi-unbounded recursion":
> 
> # bad: [cf068471031d89c4d7ce04f477ba69a043736a58] Linux 6.15.11-rc2
> # good: [cb1830ee48ef7b444b20dd66493b0719ababd2b1] Linux 6.15.10
> git bisect start 'cf068471031d89c4d7ce04f477ba69a043736a58' 'cb1830ee48ef7b444b20dd66493b0719ababd2b1'
> # test job: [cf068471031d89c4d7ce04f477ba69a043736a58] https://lava.sirena.org.uk/scheduler/job/1696008
> # bad: [cf068471031d89c4d7ce04f477ba69a043736a58] Linux 6.15.11-rc2
> git bisect bad cf068471031d89c4d7ce04f477ba69a043736a58
> # test job: [ed147e6b0b6f77ab37b64cae52c324bb4d30ffd6] https://lava.sirena.org.uk/scheduler/job/1696635
> # bad: [ed147e6b0b6f77ab37b64cae52c324bb4d30ffd6] wifi: mt76: mt7915: mcu: re-init MCU before loading FW patch
> git bisect bad ed147e6b0b6f77ab37b64cae52c324bb4d30ffd6
> # test job: [f228799b3622c5e7dee0ca367ede5c5116dd2749] https://lava.sirena.org.uk/scheduler/job/1697068
> # bad: [f228799b3622c5e7dee0ca367ede5c5116dd2749] usb: typec: tcpm/tcpci_maxim: fix irq wake usage
> git bisect bad f228799b3622c5e7dee0ca367ede5c5116dd2749
> # test job: [379a9a450eccaea2781063475865a759609c42d7] https://lava.sirena.org.uk/scheduler/job/1697316
> # bad: [379a9a450eccaea2781063475865a759609c42d7] net: ti: icssg-prueth: Fix emac link speed handling
> git bisect bad 379a9a450eccaea2781063475865a759609c42d7
> # test job: [22919356643e8d2fae162c80fd41d3a18b699ba1] https://lava.sirena.org.uk/scheduler/job/1697640
> # good: [22919356643e8d2fae162c80fd41d3a18b699ba1] NFSD: detect mismatch of file handle and delegation stateid in OPEN op
> git bisect good 22919356643e8d2fae162c80fd41d3a18b699ba1
> # test job: [289acd66730cee0a50eadea70d09c796eb985fb3] https://lava.sirena.org.uk/scheduler/job/1697768
> # bad: [289acd66730cee0a50eadea70d09c796eb985fb3] ACPI: processor: perflib: Fix initial _PPC limit application
> git bisect bad 289acd66730cee0a50eadea70d09c796eb985fb3
> # test job: [acda7f7119d35afceb774736a2dee8453745403e] https://lava.sirena.org.uk/scheduler/job/1697900
> # good: [acda7f7119d35afceb774736a2dee8453745403e] sunvdc: Balance device refcount in vdc_port_mpgroup_check
> git bisect good acda7f7119d35afceb774736a2dee8453745403e
> # test job: [9a521a568272528a4bf9a9bed5a4ead00045c7e6] https://lava.sirena.org.uk/scheduler/job/1698135
> # good: [9a521a568272528a4bf9a9bed5a4ead00045c7e6] fscrypt: Don't use problematic non-inline crypto engines
> git bisect good 9a521a568272528a4bf9a9bed5a4ead00045c7e6
> # test job: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] https://lava.sirena.org.uk/scheduler/job/1698312
> # bad: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] eventpoll: Fix semi-unbounded recursion
> git bisect bad 3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3
> # test job: [222c3853173605105bf3a4dda135a655ef894fc0] https://lava.sirena.org.uk/scheduler/job/1698459
> # good: [222c3853173605105bf3a4dda135a655ef894fc0] fs: Prevent file descriptor table allocations exceeding INT_MAX
> git bisect good 222c3853173605105bf3a4dda135a655ef894fc0
> # first bad commit: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] eventpoll: Fix semi-unbounded recursion

I thought the LTP test was going to be fixed, what happened to that?

thanks,

greg k-h
