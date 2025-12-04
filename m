Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF362FC010;
	Thu,  4 Dec 2025 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764866071; cv=none; b=sXCtZLNBGUUURmsbVXp62PL01C6A1/pCpMNV/Dlye911yhaFE2Rvrxics9+fXNtgJy2EVTRBRXYxm4uhZ1VQWC2DxNBxsWqovo/hLko0ND37+ASaFtJJsR0QiAaLKE14I2j0W7oz9geY8FFFO0vB4YTCoDWS2gzhxdInn1Z+PtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764866071; c=relaxed/simple;
	bh=38BE4UeZOm8s40CNSyasMUAwHYSUYKpGeUgm9sWx/Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwX0SC7dPeOiCppxtOhLutQ94cIynheBJ+86/cjuQD/4UGWL87qpvU7Ojhr23swHoj1VS+7vwgbdaRvMEfDQOTXBANuFGgC7q+vKBDMKfw1tU5+8N5IAIMc9Wrcppo/cvGzJJuaFcL7HYXdPF1F9c1b+RFXmyY0aUZeS8/Scvx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NE/dNtps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NE/dNtps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C66C4CEFB;
	Thu,  4 Dec 2025 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764866070;
	bh=38BE4UeZOm8s40CNSyasMUAwHYSUYKpGeUgm9sWx/Fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NE/dNtpsNGqU7POhVNup6SiLoVDZbyp0CgupmTbNkEuSppaNK2sGfEwvEMI3m1ggD
	 NgUZiuh8frZ7w4iS6FqU7c6xiMT8tjGtoyEmMQsr+6Zf8VV5Gq2UgFOdQinAdSjkbH
	 xIfMzAqK0BLaAe332HxMvqj1L/B2ouKPUhj/LJp8=
Date: Thu, 4 Dec 2025 17:34:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
Message-ID: <2025120420-gravy-parsnip-20c9@gregkh>
References: <20251203152414.082328008@linuxfoundation.org>
 <71a92d82-e941-4afe-a712-0a4d4c80ddfd@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71a92d82-e941-4afe-a712-0a4d4c80ddfd@nvidia.com>

On Wed, Dec 03, 2025 at 07:40:35PM +0000, Jon Hunter wrote:
> 
> On 03/12/2025 15:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.197 release.
> > There are 392 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > 
> > Vlastimil Babka <vbabka@suse.cz>
> >      mm/mempool: fix poisoning order>0 pages with HIGHMEM
> 
> 
> The above commit is causing the following build error ...
> 
> mm/mempool.c: In function ‘check_element’:
> mm/mempool.c:68:17: error: ‘for’ loop initial declarations are only allowed in C99 or C11 mode
>    68 |                 for (int i = 0; i < (1 << order); i++) {
>       |                 ^~~
> mm/mempool.c:68:17: note: use option ‘-std=c99’, ‘-std=gnu99’, ‘-std=c11’ or ‘-std=gnu11’ to compile your code
> mm/mempool.c: In function ‘poison_element’:
> mm/mempool.c:101:17: error: ‘for’ loop initial declarations are only allowed in C99 or C11 mode
>   101 |                 for (int i = 0; i < (1 << order); i++) {
>       |                 ^~~
> make[1]: *** [scripts/Makefile.build:289: mm/mempool.o] Error 1

Now dropped, thanks.

greg k-h
