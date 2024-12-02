Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D1E1FECAA;
	Mon,  2 Dec 2024 13:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733144541; cv=none; b=E+g/eozfx0HKY5DlsFES7hZp7Qr9ZtijuH5MKwnfSlS1W7nUmKckB11+MEoKIdhnAX6pLaqN04J5Cft4M+1zIqVGBCZSQ6BrxzM8ba/w7Tv35clZiNSX1hhK5bWYglxdLvnCCMWPxGe26Yi/W2S/XGYxiusWS0te+dMH5jDSodw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733144541; c=relaxed/simple;
	bh=Zs/rD6jzJ/nV0ysK8vRSIb8oO75WOyFspYTWwSHRkt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrsRVULduynXeqF+AMgK0bov+7DRmykvszQ8F3NMeUHMyxzaXlqo8yOmXBT/OnSrM9Ro+QUmjhIkgnt75Ul5zPGhStDMMQC3h0+I26veHXmqM+vggRwGclyMHk0/IIZ2HMn3ewltE9YEvh/8oIooDMXUpgmPniRGcWAdfaF/Y5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNXbx2Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNXbx2Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA21C4CED1;
	Mon,  2 Dec 2024 13:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733144540;
	bh=Zs/rD6jzJ/nV0ysK8vRSIb8oO75WOyFspYTWwSHRkt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qNXbx2GuQxnxDcN74QHvJaZnn2fuS+fG+cTpznQjPBTuVTQm/muHItjMaPBAYc6sA
	 h7VlVeVQZgr59HlVAmO37q4IM7AUfr0ewhRKLpKAg2rd8x3+o+FeAv7FG5gVo3Hrkt
	 Q4zJPsxtm3hYkTWMKs2goh8jaeTGfAGosXHuIK24=
Date: Mon, 2 Dec 2024 14:02:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Message-ID: <2024120206-dreamy-wilder-ec77@gregkh>
References: <20241120125809.623237564@linuxfoundation.org>
 <eda70745-0ea2-43bd-bee3-8905e3a1d3cc@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eda70745-0ea2-43bd-bee3-8905e3a1d3cc@roeck-us.net>

On Sat, Nov 23, 2024 at 07:47:09AM -0800, Guenter Roeck wrote:
> On 11/20/24 04:57, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.119 release.
> > There are 73 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >      Linux 6.1.119-rc1
> > 
> > Michal Luczaj <mhal@rbox.co>
> >      net: Make copy_safe_from_sockptr() match documentation
> > 
> > Eli Billauer <eli.billauer@gmail.com>
> >      char: xillybus: Fix trivial bug with mutex
> > 
> > Mikulas Patocka <mpatocka@redhat.com>
> >      parisc: fix a possible DMA corruption
> > 
> 
> This results in:
> 
> include/linux/slab.h:229: warning: "ARCH_KMALLOC_MINALIGN" redefined
>   229 | #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
>       |
> In file included from include/linux/cache.h:6,
>                  from include/linux/mmzone.h:12,
>                  from include/linux/gfp.h:7,
>                  from include/linux/mm.h:7:
> arch/parisc/include/asm/cache.h:28: note: this is the location of the previous definition
>    28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires 16-byte alignment */
> 
> because commit 4ab5f8ec7d71a ("mm/slab: decouple ARCH_KMALLOC_MINALIGN
> from ARCH_DMA_MINALIGN") was not applied as well.
> 
> Then there is
> 
> include/linux/dma-mapping.h:546:47: error: macro "cache_line_size" passed 1 arguments, but takes just 0
>   546 | static inline int dma_get_cache_alignment(void)
>       |                                               ^
> arch/parisc/include/asm/cache.h:31: note: macro "cache_line_size" defined here
>    31 | #define cache_line_size()       dcache_stride
>       |
> include/linux/dma-mapping.h:547:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
> 
> because commit 8c57da28dc3df ("dma: allow dma_get_cache_alignment()
> to be overridden by the arch code") is missing as well.
> 
> Those two patches fix the compile errors. I have not tested if the resulting
> images boot.

Thanks, I'll go queue them up now.

greg k-h
