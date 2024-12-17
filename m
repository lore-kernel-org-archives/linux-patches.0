Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC9112C80C;
	Tue, 17 Dec 2024 09:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734428892; cv=none; b=h/KeWATvzixUKNNfKVkOrbZMdIavlVhoikiQyufHGsKBCO8g75L9RAuMcoVDhwdmF+ZtyVV6IYsTG0uvs3tzRYUCUsk66pOaG2txjEuEqi9+oLmoka0sEXUztkuqu0BJyd/3tsWs8cKHT9K4pkpg8mnUNrjansSL4zfAdAAfPHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734428892; c=relaxed/simple;
	bh=IK/9xyDrnlo+0jqWPtN3vD0Tkun74103r13QnCikifo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fsg6qBcX8wcG2HNqFtBrNm5pHUPLd1yu+UTXSpORY3KeacpY7GMDhFFiTz/FNtpJw9Q61CNPs71uSkWyoLcGOHKRb55K7RF4M8ToVC/NhJanv3sPuzb6v0yYwSUhvTuR98liFZvY4BNySvLwpGakNT7EBNdf1YMfelrvTxeIsLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQssds4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQssds4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7770C4CED3;
	Tue, 17 Dec 2024 09:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734428892;
	bh=IK/9xyDrnlo+0jqWPtN3vD0Tkun74103r13QnCikifo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GQssds4y6xwDoIMxdaTH7nXJXkJfZT/6FyeUEBXS9ePObnuUxgwQPFZgDXU9oXN5p
	 Yiu6MvPqrVNV/u9kGgBcPJArS/VV/Nuuo85cPJobE3ztPd4Wsy4pYp6tx6USg3Fr4g
	 YKXGW4eDwrNx5Su89xfBweLvrKUUOOQkS1HL9yRo=
Date: Tue, 17 Dec 2024 10:48:01 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/459] 5.10.231-rc1 review
Message-ID: <2024121753-ransack-monstrous-712b@gregkh>
References: <20241212144253.511169641@linuxfoundation.org>
 <68b0559e-47e8-4756-b3de-67d59242756e@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b0559e-47e8-4756-b3de-67d59242756e@roeck-us.net>

On Sun, Dec 15, 2024 at 07:15:24AM -0800, Guenter Roeck wrote:
> On 12/12/24 06:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.231 release.
> > There are 459 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 147 fail: 9
> Failed builds:
> 	m68k:allnoconfig
> 	m68k:tinyconfig
> 	m68k_nommu:m5272c3_defconfig
> 	m68k_nommu:m5307c3_defconfig
> 	m68k_nommu:m5249evb_defconfig
> 	m68k_nommu:m5407c3_defconfig
> 	m68k_nommu:m5475evb_defconfig
> 	mips:ar7_defconfig
> 	nds32:allmodconfig
> Qemu test results:
> 	total: 480 pass: 479 fail: 1
> Failed tests:
> 	m68k:mcf5208evb:m5208:m5208evb_defconfig:initrd
> 
> Some details below. Reverting
> 
> ef1db3d1d2bf clocksource/drivers:sp804: Make user selectable
> d08932bb6e38 clkdev: remove CONFIG_CLKDEV_LOOKUP
> 
> fixes the problem for m68k:tinyconfig and m68k:m5272c3_defconfig. I didn't check
> if it fixes the other failures, or if the revert affects anything else.

Now dropped, thanks.

greg k-h
