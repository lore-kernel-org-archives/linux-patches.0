Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F851D2785;
	Tue, 17 Dec 2024 09:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734426447; cv=none; b=jLqedSIag7WRySWMoDQjgkWNFsu7jUajDT1p7YrliNg0HrWysIJmyh7YNPV/csiopom7DLGXkzM7HoM9vJHBdEKShirc/8jJMkX0RTGTGEypvmVaN6FJnahpHnsk32XHUkfaeMYYV6jwklL/vUc4JHCUVIObXL94N12YyzgcsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734426447; c=relaxed/simple;
	bh=0RF5A13pvyKAxMPgnXqbj2ND7p7tKn756lGXwe+mNMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTprqgySHEUp0W/hV0zHqo2NBL3HjJNPrNr1rG5j3ORxJw2j6XeeEHhaQ9IhZHEivh0ESe/Wz04ozqA55JeYmn9dHAg2oW7EVF2lcNUgMZz1+ANDbE7A5bzbyVYe/ZzYqYIdLRYz01052nYfr9BTbHB4RaFer+uQ5ttjoWmxFSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQi1Oikk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQi1Oikk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5E3C4CED3;
	Tue, 17 Dec 2024 09:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734426447;
	bh=0RF5A13pvyKAxMPgnXqbj2ND7p7tKn756lGXwe+mNMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cQi1OikkisuTnAwwYCxEWWe7zh8tSn0530oZWf/JTAy885NooLGbrNSJrI8EIeL7l
	 lyrOlXmzJScWxir64MchfrTZrbkjAOaM3AVkbBvrwTmlFY+NA+cXrljGTsp7fzCcZU
	 vr9uHfdw1Hdv1ROuwiycJf6yaR2/oKNof7UxFyfQ=
Date: Tue, 17 Dec 2024 10:07:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
Message-ID: <2024121712-mastiff-catnap-4891@gregkh>
References: <20241212144311.432886635@linuxfoundation.org>
 <436a575b-4ec0-43a2-b4e9-7eb00d9bbbeb@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <436a575b-4ec0-43a2-b4e9-7eb00d9bbbeb@roeck-us.net>

On Sun, Dec 15, 2024 at 07:24:40AM -0800, Guenter Roeck wrote:
> On 12/12/24 06:53, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.174 release.
> > There are 565 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> > 
> 
> All parisc builds fail.
> 
> In file included from include/linux/pci-dma-compat.h:8,
>                  from include/linux/pci.h:2477:
> include/linux/dma-mapping.h:546:47: error: macro "cache_line_size" passed 1 arguments, but takes just 0
>   546 | static inline int dma_get_cache_alignment(void)
>       |                                               ^
> arch/parisc/include/asm/cache.h:31: note: macro "cache_line_size" defined here
>    31 | #define cache_line_size()       dcache_stride
>       |
> include/linux/dma-mapping.h:547:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
>   547 | {
> 
> There are also lots of warnings.
> 
> ./include/linux/slab.h:208: warning: "ARCH_KMALLOC_MINALIGN" redefined
>   208 | #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
> 
> ./arch/parisc/include/asm/cache.h:28: note: this is the location of the previous definition
>    28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires 16-byte alignment */
> 
> Bisect log attached. Reverting the offending patch fixes the build error and the warnings.
> 
> Guenter
> 
> ---
> # bad: [963e654022cc32d72c184b4ab86a76226b3e3b8d] Linux 5.15.174
> # good: [0a51d2d4527b43c5e467ffa6897deefeaf499358] Linux 5.15.173
> git bisect start 'HEAD' 'v5.15.173'
> # good: [16aa78edf6dd33d13320a0802322cade7a9e587b] net: hsr: fix hsr_init_sk() vs network/transport headers.
> git bisect good 16aa78edf6dd33d13320a0802322cade7a9e587b
> # bad: [c20f91bd939553be347196ecf4ab7b69dff19193] ethtool: Fix wrong mod state in case of verbose and no_mask bitset
> git bisect bad c20f91bd939553be347196ecf4ab7b69dff19193
> # bad: [f5872a2a84ec889d0a8f264d3ed0936670860479] rpmsg: glink: Propagate TX failures in intentless mode as well
> git bisect bad f5872a2a84ec889d0a8f264d3ed0936670860479
> # bad: [1d1e618c170643dfb07ebd1f6cab64278bfa06eb] exfat: fix uninit-value in __exfat_get_dentry_set
> git bisect bad 1d1e618c170643dfb07ebd1f6cab64278bfa06eb
> # bad: [13327d78229f954995a8535b369d4aa7f1d721dc] Revert "drivers: clk: zynqmp: update divider round rate logic"
> git bisect bad 13327d78229f954995a8535b369d4aa7f1d721dc
> # good: [098480edee1b64b6e811e0bf101b32cd11e71582] misc: apds990x: Fix missing pm_runtime_disable()
> git bisect good 098480edee1b64b6e811e0bf101b32cd11e71582
> # bad: [dadac97f066a67334268132c1e2d0fd599fbcbec] parisc: fix a possible DMA corruption
> git bisect bad dadac97f066a67334268132c1e2d0fd599fbcbec
> # good: [3c7355690f375bcfa3639aea7daa801789a85532] ALSA: hda/realtek: Update ALC256 depop procedure
> git bisect good 3c7355690f375bcfa3639aea7daa801789a85532
> # good: [487b128f07b82294bd0847c2c462dfcf1de9660a] apparmor: fix 'Do simple duplicate message elimination'
> git bisect good 487b128f07b82294bd0847c2c462dfcf1de9660a
> # first bad commit: [dadac97f066a67334268132c1e2d0fd599fbcbec] parisc: fix a possible DMA corruption

Offending commit now reverted, thanks!

greg k-h
