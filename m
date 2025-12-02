Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C421B18BC3D;
	Tue,  2 Dec 2025 09:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764667267; cv=none; b=KU1huM5yWzfMExwCzYo4VjKcORTTEHS0M7ab90WfZySTwt95H3koJvr6eTHKqibsMl0/P18RuXAGEjaWLefkELRLap4L1pulgqkhl3I3dhmVTCIIKDoDK9kJxI0DR5ZBDQxHooHl7E6doXY+vWa2eg76MdXnnHZV4+Z5FljEC6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764667267; c=relaxed/simple;
	bh=64qmXtp2IQdZABWxSpV9i9oIYX72eAt2wy1aq+fFzM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FeWSx8FHtUFOYMEavCo3fKvj8EBIs1MuiNdaSHNVJmuJABvASQlnbzazjckfL+mNuSWt057OpbsYsThwO4+DXgbaHHIFp6BICm6rqE6S263L5IyWDLEPQwMou+S0DrZJrriSnmbAam8xBCM3jxeHz3vunUZ7KbnX56g8qzshxVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPJEqjWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPJEqjWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F633C16AAE;
	Tue,  2 Dec 2025 09:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764667267;
	bh=64qmXtp2IQdZABWxSpV9i9oIYX72eAt2wy1aq+fFzM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mPJEqjWeMDBpfi43XMoUXI+BkR04TSKKX5g5jsyt3fHfrdEIZFTn0lXXTAGetbhYF
	 xMndiZlzwpTfttW6LHkMm7j6NHoVks77y0sIrhDK2mUBo6CoWXYEjKTK1Qr3VwrzuG
	 lLI63/5X38vK+BkffWNtXC7NpGt4pyxqshaAlaiM=
Date: Tue, 2 Dec 2025 10:21:03 +0100
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
Subject: Re: [PATCH 5.4 000/187] 5.4.302-rc1 review
Message-ID: <2025120235-retrace-glaring-3754@gregkh>
References: <20251201112241.242614045@linuxfoundation.org>
 <ce689597-1f9f-496e-bcf5-ac3a06d8bf74@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce689597-1f9f-496e-bcf5-ac3a06d8bf74@nvidia.com>

On Tue, Dec 02, 2025 at 06:24:08AM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 01/12/2025 11:21, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.302 release.
> > There are 187 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Dec 2025 11:22:11 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> ...
> 
> > Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
> >      mm/mempool: replace kmap_atomic() with kmap_local_page()
> 
> 
> The above commit is causing the following build errors ...
> 
> kernel/mm/mempool.c: In function 'check_element':
> kernel/mm/mempool.c:69:17: error: 'for' loop initial declarations are only allowed in C99 or C11 mode
>    69 |                 for (int i = 0; i < (1 << order); i++) {
>       |                 ^~~
> kernel/mm/mempool.c:69:17: note: use option '-std=c99', '-std=gnu99', '-std=c11' or '-std=gnu11' to compile your code
> kernel/mm/mempool.c:71:38: error: implicit declaration of function 'kmap_local_page'; did you mean 'kmap_to_page'? [-Werror=implicit-function-declaration]
>    71 |                         void *addr = kmap_local_page(page + i);
>       |                                      ^~~~~~~~~~~~~~~
>       |                                      kmap_to_page
> kernel/mm/mempool.c:71:38: warning: initialization of 'void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
> kernel/mm/mempool.c:74:25: error: implicit declaration of function 'kunmap_local' [-Werror=implicit-function-declaration]
>    74 |                         kunmap_local(addr);
>       |                         ^~~~~~~~~~~~
> kernel/mm/mempool.c: In function 'poison_element':
> kernel/mm/mempool.c:103:17: error: 'for' loop initial declarations are only allowed in C99 or C11 mode
>   103 |                 for (int i = 0; i < (1 << order); i++) {
>       |                 ^~~
> kernel/mm/mempool.c:105:38: warning: initialization of 'void *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>   105 |                         void *addr = kmap_local_page(page + i);
>       |                                      ^~~~~~~~~~~~~~~
> 
> 
> I am seeing this with ARM builds using the tegra_defconfig.

Ah, odd I missed this, looks like it needs HIGHMEM enabled.  I'll go
drop 2 of these patches that cause this and will push out a -rc2, thanks
for testing!

greg k-h
