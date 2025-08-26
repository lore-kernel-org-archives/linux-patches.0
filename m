Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B8A2D7391
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 18:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756231438; cv=none; b=eUimTFlr3Cj9VKKxH8nddzDt5+kpiaW9j5vmNes2bzZHQBLUi6Aa1+yLsDG7UK3O6DfBLMN9q+WTyXFsG2xeFskgH1LB6V9RnXFXoIhYeE0Ps950bXOm9kqEXKqKJ90jWtHt1ephbXdD+lT1KqJ9aPQ9X6lfMExICpsrGXNDI6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756231438; c=relaxed/simple;
	bh=bfzh2QX9aI79kIf9vMnLClOeFShsKjbWgXfp42ADjGw=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=BZkwNe+bdxQ/LXexWR1/UeozYUtoeabISqgdDbghL1+0yMWmSlNXFD8hasPzjr5HM9rmq1DKNhU0ZQ1+NBFr/VDL/ZbOpv5sAAPR8SA6hdDtdgVFH8C/Facsi0bYPBTge5vhUC2RAJBUXLFPY77wsS0iNvliMqpt/upYlYwo+QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=beBf5nn0; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="beBf5nn0"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id C78399A292F
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1756231425; h=date:message-id:subject:from:to;
	bh=bfzh2QX9aI79kIf9vMnLClOeFShsKjbWgXfp42ADjGw=;
	b=beBf5nn09Gq625Sub1q4RSBEqMejGmN0xpoUFxbXzOdFiIWgN9VedM4tJP/38mFtGFiX+v0I9zI
	2aTW8ZoXIVY6m7g8ahDl3FtwWJX468SHXTSaz60rGquYDZRK/L619QuACZt9A/GphY9Hk+nM6sMCK
	trxvuyz2mJpNsoVeapHPZJNdr+lXV12X9WvPqZdvfyVHcZYlEQ+xG3NC9MzjedaYYxdlllaz/CAEG
	HkWQF3OhsWeSd1On1aaR9dNuoCAHtiPqr7jeDwaA7f4NHPu3VGSGNmehd9OS7EZ9Nt3LPIFGUXwtE
	tiMKwHTarwoxL+SkaTo9nDfFyxQUBMfVEDHQ==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Tue, 26 Aug 2025 20:03:43 +0200
Message-Id: <DCCK2XXZJSYN.30GFYJ0SQZ2QG@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250826110937.289866482@linuxfoundation.org>
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Tue Aug 26, 2025 at 1:04 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.4-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Builded on all Alpine architectures (aarch64, armv7,
loongarch64, ppc64le, riscv64, s390x, x86, x86_64) and boot-tested on
x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
