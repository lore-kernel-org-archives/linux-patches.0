Received: from out28-60.mail.aliyun.com (out28-60.mail.aliyun.com [115.124.28.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF51CC171
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 23:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727997768; cv=none; b=RuUiD2Ch9LDvaBlZKqBBGZFgyHXEiQmGlXwkxoa0oMi1GABqFGAd/034dZD+irtZOPU31boaSmsQQDTAnXt/E2mm5ujEOTjIpIbw9nDroUusr7QxyxxB3AHLEjYiO5NQP0TnczHYHJse11EFnrTjUZ9FiOmy7Fpdtq7/+EG0xNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727997768; c=relaxed/simple;
	bh=RwLY74sC5RdaY6GgDi2FqtfjJxp8v3vkGtL37IuU3hQ=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=J71CHkXu8o2P8Xl491WPylmYiHkNTALL+QbIx/+nwlNYs/bTGsXx8SOLocjHk6kC4Vat9bbT3fjr07DM0hIIVk4erE2xyJZR5GRYPXrqddJ+MJuOQtJe3L5gyh38fC262QKym9Eop+gvMhUO5CdGxT4SLNq9OU2J1M0Woh218IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.ZYfSjLp_1727997442)
          by smtp.aliyun-inc.com;
          Fri, 04 Oct 2024 07:17:23 +0800
Date: Fri, 04 Oct 2024 07:17:24 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org,
 akpm@linux-foundation.org,
 linux@roeck-us.net,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 pavel@denx.de,
 jonathanh@nvidia.com,
 f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net,
 rwarsow@gmx.de,
 conor@kernel.org,
 allen.lkml@gmail.com,
 broonie@kernel.org
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
References: <20241003103209.857606770@linuxfoundation.org>
Message-Id: <20241004071723.69AD.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.07 [en]

Hi,

> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

A new waring is report by 'make bzImage' in 6.6.54-rc2, 
but that is not reported in 6.6.53 and 6.12-rc1.

arch/x86/tools/insn_decoder_test: warning: Found an x86 instruction decoder bug, please report this.
arch/x86/tools/insn_decoder_test: warning: ffffffff8103c4d5:    c4 03 81 48 cf e9       vpermil2ps $0x9,%xmm15,%xmm14,%xmm15,%xmm9
arch/x86/tools/insn_decoder_test: warning: objdump says 6 bytes, but insn_get_length() says 0
arch/x86/tools/insn_decoder_test: warning: Decoded and checked 6968668 instructions with 1 failures

the root cause is yet not clear.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2024/10/04


