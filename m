Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC0E1A08C5;
	Thu, 10 Oct 2024 10:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728555415; cv=none; b=DCAFQj/N74+lmj8Ip0Mvhc7PmbLCaG/Ho9BJs/vUCTgh3PR89QK8P85xD/3iQoiVIvhsUbdOskkaXO3uKnrFVCAIJZn+jd1OMMxKR+Zoq6FIlqFedoTHn4VLG80byVEMPF+J4MjkQ+upk98jxK0bHDY18ZqhzL082FsoM7eY3LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728555415; c=relaxed/simple;
	bh=Fme7l61BXKKj579X5IywxISXdh4Ffu2sgMDrsdWnSLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C29W9T/mhKPTZtW/0ZgtQp7wLNQvibpsiRKH0syxhs5O70cjMvPubJNEBlHgmLOh6WdjZ8ZTWKpT0AUR3NscfEZEDHbL/4KEcZRh+1gNBWZ9wLsbcVBJoBd1qfKm0fEog9QNMnSy65p1DnXqceXW8Z1ClXnLEjah6UwaqxGSOT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjaLXhYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjaLXhYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47326C4CEC6;
	Thu, 10 Oct 2024 10:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728555415;
	bh=Fme7l61BXKKj579X5IywxISXdh4Ffu2sgMDrsdWnSLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BjaLXhYgqtCJRrQdeqlRt6pERs7rTFhHPbKKbYwnDUjSI4gCPB9z8qI6wjtHSj+PK
	 yvgQ+u8JOMwymFGneaTSq3336rfvemAi/riDvRSUpRez88/ceF/tkT9B4rfEnawnRV
	 pV9vcI/QRKGNFWm1uRzWCjKn1/vBN7Un5adUhQY4=
Date: Thu, 10 Oct 2024 12:16:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
Message-ID: <2024101041-germinate-shuffling-9e19@gregkh>
References: <20241008115629.309157387@linuxfoundation.org>
 <894e27c0-c1e8-476d-ae16-11ab65853d1f@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <894e27c0-c1e8-476d-ae16-11ab65853d1f@oracle.com>

On Tue, Oct 08, 2024 at 08:28:57PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 08/10/24 17:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.55 release.
> > There are 386 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> > Anything received after that time might be too late.
> > 
> ...
> 
> 
> > Ian Rogers <irogers@google.com>
> >      perf callchain: Fix stitch LBR memory leaks
> > 
> 
> This patch is causing build failures for tools/perf/
> 
> util/machine.c: In function 'save_lbr_cursor_node':
> util/machine.c:2540:9: error: implicit declaration of function
> 'map_symbol__exit'; did you mean 'symbol__exit'?
> [-Werror=implicit-function-declaration]
>  2540 |         map_symbol__exit(&lbr_stitch->prev_lbr_cursor[idx].ms);
>       |         ^~~~~~~~~~~~~~~~
>       |         symbol__exit
> ...
> 
> util/thread.c: In function 'thread__free_stitch_list':
> util/thread.c:481:17: error: implicit declaration of function
> 'map_symbol__exit'; did you mean 'symbol__exit'?
> [-Werror=implicit-function-declaration]
>   481 |                 map_symbol__exit(&pos->cursor.ms);
>       |                 ^~~~~~~~~~~~~~~~
>       |                 symbol__exit
> 

Argh, I missed this, let me go revert it in another release now...
