Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B724F6AA3
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 18:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E086FC433EF;
	Mon, 30 Jan 2023 18:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675102496;
	bh=oX+bzUXLmw7EG3moYPRfQi8Pzz7mkEIFn66WKrGzm4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jm3zWolTLZYTVABD5Z9AxAZNV/CYQ4lE0nIMzdoor3tSYc2TX87dSe6xOQM6sqTxr
	 ueNqd+F79r/yi/F7v0BaEEonq5Uqxp287L1zq6r5KS7mPFhjbKHePjntmEgYP/6F0a
	 50Oh5B6pe23VdWAtU4t51q/+BRedQsQ05jWsvfRQ=
Date: Mon, 30 Jan 2023 19:14:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
Message-ID: <Y9gJHXshbV5vk9za@kroah.com>
References: <20230130134336.532886729@linuxfoundation.org>
 <Y9gDLmmAwaKZX9yw@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9gDLmmAwaKZX9yw@spud>

On Mon, Jan 30, 2023 at 05:49:34PM +0000, Conor Dooley wrote:
> On Mon, Jan 30, 2023 at 02:47:15PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.9 release.
> > There are 313 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Apart from the build issue that Guenter reported, things look fine on my
> hardware.
> 
> > Conor Dooley <conor.dooley@microchip.com>
> >     dt-bindings: riscv: fix single letter canonical order
> > 
> > Conor Dooley <conor.dooley@microchip.com>
> >     dt-bindings: riscv: fix underscore requirement for multi-letter extensions
> 
> I think the email for these came in over the weekend but I was busy
> unfortunately. Is dt-binding stuff like this usually backported?
> I suppose there's no harm in making sure that it is correct...

Yes, we add dt binding fixes all the time if they are relevant and
marked as fixes for problems.

thanks,

greg k-h
