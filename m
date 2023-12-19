Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E67D134A3
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 08:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="l0q16aPe";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="S2k5tAzp"
Received: by nautica.notk.org (Postfix, from userid 108)
	id F1637C01A; Tue, 19 Dec 2023 09:20:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1702974018; bh=z/0FZrN0KqpDTOtDkKzEnxjxxsSs9NJtKvNMljVBU6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l0q16aPe6TxwGDpsaeqx1tl87nOSFxLbsPODrZdNd7spojiDVmhmyBn3+Qb1AzrT5
	 UGxnsdQsNCFPigGC9PAN8iYj1QIe+SWu7zHUa0Ng34ACH/D2u2e8JqJmR9L+aB6wd0
	 UYzZR7V+ApNawjFSizhnreENQJSFklw0hzbXPZYKiOxsS30x/UsQNR3A485zdtsnMy
	 yuinM1HRPL3AGRYhjYdPbJYN5fQQwqLgbHBiRgAClzi7os6nG5xbkXWIwldbGXlfMo
	 jKk/lcZKv0g2HEwylAjqJOkzl2T7n4Ur8f56NJbQgJLUugb1aPla8NkGDaFMrgvDnw
	 MoFJcFWUUy0QQ==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id 64155C009;
	Tue, 19 Dec 2023 09:20:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1702974017; bh=z/0FZrN0KqpDTOtDkKzEnxjxxsSs9NJtKvNMljVBU6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S2k5tAzpfmqBy5YsRNL/cI7AFAiOPa0MevxEEL0OZ8vSWBShaFKONeCMVYtUiiXzC
	 8StKuIgvxK3KFd8i4AhqSUHKF6voUCyzPvR3tOM8aXPIIkNpwci1v/nKRwhKUjiWsx
	 xcprPNMLL4G/Y1422LSQwwI499kOhIyP1OwaeU8HfR7kEIF1ltK06KIXVNqaVo3Vfy
	 7sjXnigpfi0rZr5xoKuEnayRAKzECxZq4M56WM66G+3/7nEe0H1jeCeWA9dwNHeQBC
	 45pqT/+X1HKa4Q5LYg6r4U3kyZr8D19Xd9jg9IocKb6x6X8GgHUDFzmM0vT0/POWTB
	 froJeqIZvMlBA==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id d050cb09;
	Tue, 19 Dec 2023 08:20:09 +0000 (UTC)
Date: Tue, 19 Dec 2023 17:19:54 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 00/60] 5.10.205-rc2 review
Message-ID: <ZYFSKmbQbvPhoFbm@codewreck.org>
References: <20231219074407.947984749@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231219074407.947984749@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Dec 19, 2023 at 08:53:19AM +0100:
> This is the start of the stable review cycle for the 5.10.205 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Dec 2023 07:43:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.205-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 163d4e782432 ("Linux 5.10.205-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>


Thanks for the rebase of the drm/mediatek spinlock patch!
-- 
Dominique
