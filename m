Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5095663C3
	for <patches@lists.linux.dev>; Fri, 11 Aug 2023 10:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D75C433C8;
	Fri, 11 Aug 2023 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691748431;
	bh=aeqmuXXvDUIdbq4Oxc6siFyRT7b8XUQDtZFkCP8sRIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jCHyWTufNtkvCxeFDx1YL9GkeD9G/ebn8ihX34e/diDUo2+4RyXumT9DxTEom0IPU
	 qk9ctp0HneYfxjLrpaRG/Prf51wBTMoaF1qrSUgxq8rO9IGzWkc6oL9frLdIp0yGKk
	 VbqV8JatX7bYbQi+VzbgGrC6ESvyc9/CR8PkxzZk=
Date: Fri, 11 Aug 2023 12:07:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Message-ID: <2023081144-occultist-cytoplast-d7b5@gregkh>
References: <20230809103636.615294317@linuxfoundation.org>
 <a800f7e3-5a59-4dba-afc8-d3ae5f39b058@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a800f7e3-5a59-4dba-afc8-d3ae5f39b058@roeck-us.net>

On Thu, Aug 10, 2023 at 09:14:43AM -0700, Guenter Roeck wrote:
> On Wed, Aug 09, 2023 at 12:39:47PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.45 release.
> > There are 127 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 153 fail: 4
> Failed builds:
> 	loongarch:defconfig
> 	loongarch:allnoconfig
> 	loongarch:tinyconfig
> 	loongarch:allmodconfig
> Qemu test results:
> 	total: 521 pass: 513 fail: 8
> Failed tests:
> 	arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:rootfs
> 	arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:rootfs
> 	<all loongarch>
> 
> loongarch failures as already reported, introduced with v6.1.44.
> 
> The failed arm tests crash in f2fs (again - previously reported
> against the v6.1.43 release candidate).
> 
> [    6.685458] 8<--- cut here ---
> [    6.685593] Unable to handle kernel NULL pointer dereference at virtual address 00000034
> [    6.685725] [00000034] *pgd=00000000
> [    6.686010] Internal error: Oops: 5 [#1] SMP ARM
> [    6.686209] CPU: 0 PID: 194 Comm: seedrng Not tainted 6.1.45-rc1-00128-g02a4c6c322d1 #1
> [    6.686350] Hardware name: Generic DT based system
> [    6.686467] PC is at f2fs_issue_flush+0x160/0x210
> [    6.686821] LR is at f2fs_do_sync_file+0x7c8/0xaa8

Odd that you are the only one seeing this f2fs report, does no one else
use f2fs on 6.1 systems?

thanks,

greg k-h
