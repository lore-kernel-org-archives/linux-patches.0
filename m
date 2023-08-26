Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00386F9D5
	for <patches@lists.linux.dev>; Sat, 26 Aug 2023 15:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490D7C433C8;
	Sat, 26 Aug 2023 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693064941;
	bh=cyldISG9CgG+prslJEU2swFaz2IVHWHkfUssWaglIbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkO7D9m31dVgW09P317TX6bbwjJd2vbdbkSwPnTNx7cr4VxB00Rt/NcKZes/qaKhM
	 vD+Mu4rBjle5llFO3J2v55TbtaLL48ebNt/KDj3KEtQXX3rZKngJiZNr6dTGWI66W8
	 Ogbnh6rDfWHusT2q/S8SkXlTflydq7tahmO4qj+Y=
Date: Sat, 26 Aug 2023 17:48:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
Message-ID: <2023082627-tabasco-concave-1366@gregkh>
References: <20230813211718.757428827@linuxfoundation.org>
 <b392e1a8-b987-4993-bd45-035db9415a6e@roeck-us.net>
 <2023081631-uproar-tapered-2221@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023081631-uproar-tapered-2221@gregkh>

On Wed, Aug 16, 2023 at 06:26:47PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 14, 2023 at 07:04:57AM -0700, Guenter Roeck wrote:
> > On Sun, Aug 13, 2023 at 11:17:25PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.46 release.
> > > There are 149 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> > > Anything received after that time might be too late.
> > 
> > Booting with f2fs root file systems still crashes in this release
> > candidate. Would it make sense to mark f2fs as broken in v6.1.y ?
> 
> Ick, yeah, let me dig into this next week and figure out what went
> wrong...

I've now pushed out 6.1.49-rc1 with the last 3 f2fs patches reverted,
and a single objtool fix.  Hopefully that should resolve this issue, if
not, please let me know.

thanks,

greg k-h
