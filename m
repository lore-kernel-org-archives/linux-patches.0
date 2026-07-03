Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB78341050;
	Fri,  3 Jul 2026 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783063598; cv=none; b=Zg1nYXisTV8R+CmS2o0DACP/2Xtzj7OlxzR3u6CP4D04rt72kR2jOJ4d8BPz6DQ2/3ELIvoEbQ6kaCG5RNSAehMeB6Dk3th4TfWtSB/ZGV3r9DvHd1yWJH2rKDU32moj9YAhHSoDhwZ8ZXXZSaLtY35tVxmwBvl9Nl/EBHtBTuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783063598; c=relaxed/simple;
	bh=xow6gdwmn0HGwAowFYrjRNzrN8XjLyuOdRbqLdNdksg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kle1dyLp1i+0cAszQjThG8XBrW3BBS4KKYybEVmnUpgjM2PrxRgd+/QbQuoMFX+MUGL1l6T8usqyzKGL1V3/zlJurExERnTWsjoqD3FyZVmNXMgWJMTk2QBqlm7PRs8ugoZV2P+CfZWqbF4E4UU7+0iXLTtp/U2H6+6zUJ1visk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJoRQ7jY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJoRQ7jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FBE1F000E9;
	Fri,  3 Jul 2026 07:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783063597;
	bh=/hVxcLjPvaqYRAmtNr6TcaZklem7bduaw01D0+L+yHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eJoRQ7jY2CrVmO75B0xT3OLlo3GsDeKmgN93HLheDKcfmVyCEyDk3Wf0pBg+XNTKb
	 M5Cq70qVz4Vur8mqkbiplE38Mytp3OMSZ+pkLISmSDyxFZCKOMCNCJ/PTBWHhXlH+b
	 mtYkWYmDq6Ovh7R9vaCpdkXP5OBMlFnJCOfcezUY=
Date: Fri, 3 Jul 2026 09:26:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
Message-ID: <2026070333-upstart-unguided-872a@gregkh>
References: <20260702155112.964534952@linuxfoundation.org>
 <45619dda-652a-450a-bc91-6bcdc3e6edeb@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45619dda-652a-450a-bc91-6bcdc3e6edeb@w6rz.net>

On Thu, Jul 02, 2026 at 10:41:41PM -0700, Ron Economos wrote:
> On 7/2/26 09:19, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 7.1.3 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> The build is broken on RISC-V with:
> 
> In file included from mm/kfence/core.c:36:
> ./arch/riscv/include/asm/kfence.h: In function 'kfence_protect_page':
> ./arch/riscv/include/asm/kfence.h:25:17: error: implicit declaration of function 'mark_new_valid_map' [-Wimplicit-function-declaration]
>    25 |                 mark_new_valid_map();
>       |                 ^~~~~~~~~~~~~~~~~~
> 
> This is caused by commit "riscv: kfence: Call mark_new_valid_map() for kfence_unprotect()" 66fcdb7f71b9d3d32828130cf5895adea059016d
> 
> As already reported by https://lore.kernel.org/stable/6c5c0723-66c6-4f9f-8021-2562efc95c6e@iscas.ac.cn/,
> upstream commit "riscv: mm: Extract helper mark_new_valid_map()"
> 9ee25d0a70ff4494b4e1d266b962d0a574ef318a solves the issue. This commit
> cherry picks successfully.

Let me go do this and push out some -rc2 releases, thanks!

greg k-h
