Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADC7186B
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 10:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A153BC433C7;
	Wed, 30 Aug 2023 10:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693392798;
	bh=kXm9yQy52naWC/RvGvn4BFl6/EW0JPFepP0YEWTan7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NILBwXn0diTHmZ1KQ9Vs+pVGhOgr65/Hm4qpmEeBmI77O7PihYV6LFGKaG+n00Hk/
	 GCfxx2oMcI2rQiBV2zu+IPYIfdOqEWkmiKx48BkrRh4RqYblX3QKiL/TAonQNzkZmf
	 OftlAQxTQNAwwhdtvTuy60Kx5B7Hp6VvaV0EjnaI=
Date: Wed, 30 Aug 2023 12:53:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Message-ID: <2023083041-tingle-waltz-9a6b@gregkh>
References: <20230828101149.146126827@linuxfoundation.org>
 <a47b63cc-174f-4de7-987b-16a6264ce42d@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a47b63cc-174f-4de7-987b-16a6264ce42d@roeck-us.net>

On Mon, Aug 28, 2023 at 10:24:27AM -0700, Guenter Roeck wrote:
> On Mon, Aug 28, 2023 at 12:13:17PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.193 release.
> > There are 84 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> > Anything received after that time might be too late.
> > 
> 
> v5.10.y also needs commit 4ea6fa2cb921 ("mhi: pci_generic: Fix implicit
> conversion warning") to avoid
> 
> drivers/bus/mhi/host/pci_generic.c:276:25: warning: implicit conversion from 'unsigned long long' to 'dma_addr_t'
> 	(aka 'unsigned int') changes value from 18446744073709551615 to 4294967295 [-Wconstant-conversion]
> 
> which is seen since v5.10.192 when building images with clang.

Yeah, I ran into that in the Android merges.  That's not a regression in
this -rc cycle, so I'll queue it up in a future release.

thanks,

greg k-h
