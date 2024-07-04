Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C541AAE30;
	Thu,  4 Jul 2024 09:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720085339; cv=none; b=HzNbUJkeUTjT34SCzbneZZpCKbqU38OQxKQO+IdSkk1tITtTKQ1mvMM/h1A2l4TLcagzrDNRhrcgNQwH1FkImeebBGw3jVZ6Cu9MbG3kB38pvkJ1bhsaql4oitr4A2/MrvVr1rB7IAUKaa98zIDVZJJqohR/PBxg+vByQY7fbnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720085339; c=relaxed/simple;
	bh=RAU682pllQ3Qwzdcw44X5tDRqFgQveq+4ErPH8vDthE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JzglVGb6OM4KvQOw5Tdbz7k7EYSXEOumpLDeMhmdCJaiWCW8OGp10CJ1wqGz78D9glGGdc3/IRWFitmFNtb+V5TXvaxgBP2VJa6Cj6hOC/ZGdaZsCZUVe3ZH69skIoBzCZujMFW1XoLcbq7zzX24wtUseiXW8agRs4BxZIivJoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsErD0F2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsErD0F2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1619AC3277B;
	Thu,  4 Jul 2024 09:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720085338;
	bh=RAU682pllQ3Qwzdcw44X5tDRqFgQveq+4ErPH8vDthE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WsErD0F2Dnok9dLeG96r/JEVtpzxttD4/6V0yWRtJlXN+DW3lv4/CDub/JMnjSsxS
	 U4QAbF7C09QoJ7fdWOiToWRxwNJutAKNs8HMCcOPtHOuBg8kTMBQBXZ1xGjk41HOWf
	 Qu7HKyyDH7uPS4ncn1pSruXHz/LMPMp5RHtE+eSY=
Date: Thu, 4 Jul 2024 11:25:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, shuah <shuah@kernel.org>,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
	rwarsow@gmx.de, Conor Dooley <conor@kernel.org>,
	Allen <allen.lkml@gmail.com>, Mark Brown <broonie@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Rich Felker <dalias@libc.org>
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
Message-ID: <2024070402-gallows-schematic-ce53@gregkh>
References: <20240703102841.492044697@linuxfoundation.org>
 <CA+G9fYvAkELSdWF1EYyjS=d_jvCJD0O=aPnZFHUGnhYy6c1VCg@mail.gmail.com>
 <72ddde27-e2e2-4a46-a2ab-4d20a7a9424f@app.fastmail.com>
 <c497d1abee4bf37663488c3a80e042a25303c0c4.camel@physik.fu-berlin.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c497d1abee4bf37663488c3a80e042a25303c0c4.camel@physik.fu-berlin.de>

On Wed, Jul 03, 2024 at 08:42:42PM +0200, John Paul Adrian Glaubitz wrote:
> Hi Arnd,
> 
> On Wed, 2024-07-03 at 20:34 +0200, Arnd Bergmann wrote:
> > Rich and Adrian, let me know if you would submit a
> > tested backport stable@vger.kernel.org yourself, if you
> > want help backporting my patch, or if we should just
> > leave the existing state in the LTS kernels.
> 
> I think it's safe to keep the existing state in the old LTS kernels
> as most SH users will be on the latest kernel anyway.

Thanks, I'll drop it from these older kernels now.

greg k-h
