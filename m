Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D19291C
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 18:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E517EC433D2;
	Wed, 21 Dec 2022 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671646823;
	bh=EaL1FZjLFJ4p/Kw6JDysbkFcTcClZFXC8wsmE4QUj1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=y0b/+0V0GXcWQHdrRu33PGYH0DmXMpXG6qg84EZ0JRauzqdfTqRtTNTcxbXu84JfZ
	 C5fmHMEPmZPZiTiBZyBEZW+ExFvfc2vGtyswlbyFyoZvrg9FMDMhwI35hpRKOtTxM4
	 HRMl1vc+5C6gujCacBy5T+06vipBA3t7u+wUTRjk=
Date: Wed, 21 Dec 2022 19:20:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6NOZEaDpod+9r/0@kroah.com>
References: <20221219182943.395169070@linuxfoundation.org>
 <20221220150049.GE3748047@roeck-us.net>
 <Y6HQfwEnw75iajYr@kroah.com>
 <20221220161135.GA1983195@roeck-us.net>
 <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>

On Wed, Dec 21, 2022 at 07:34:04AM +0100, Jiri Slaby wrote:
> On 20. 12. 22, 17:11, Guenter Roeck wrote:
> > You probably didn't see any reports on mainline because I didn't report
> > the issue there yet. There are so many failures in mainline that it is
> > a bit difficult to keep up.
> 
> Just heads up, these are breakages in 6.1 known to me:
> 
> an io_uring 32bit test crashes the kernel:
> https://lore.kernel.org/all/c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com/
> 
> Fixed in io_uring tree.
> 
> 
> bind() of previously bound port no longer fails:
> https://lore.kernel.org/all/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> 
> No fix available and revert close to impossible.
> 
> 
> 
> And most important, mremap() is broken in 6.1, so mostly everything fails in
> some random way:
> https://lore.kernel.org/all/20221216163227.24648-1-vbabka@suse.cz/T/#u
> 
> Fixed in -mm.
> 
> maybe it can help...

Thanks for the list, I'll keep an eye out for these...

greg k-h
