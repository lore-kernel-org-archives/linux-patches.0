Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D321ADC90
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.35.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738416226; cv=none; b=C19Un6Qzpo1kT0f87H+Ei+Y5sJBMB9DlJfGYBCg1ho1rrCAUknu2kTGhj1UvzxqjVcjjiwWolLxIPs6XDksJ8V+BHSi9w6/bC24MHQ0uSdZ62QIe9MrJL+zV9pORlXCFb3BgmC2Ic7x0BV9xbz7/25fiZMIfOi/F5GYhAAqu8f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738416226; c=relaxed/simple;
	bh=qg3JWgb8jfYqQ1zE36+8TDcc/fTOFfe5iIhr8KkdCU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kNb6ncgmMJ7DN3YW8Cc/UIx89a7BdCnAfBtzbYOMWGaivul2a+RiDM1zX6rPwyaNbXc7ck4Y+RY6tCarSDXfrj/S76e8YdlUxnGGyXzvKr7JFtXoszWHA59DPsbdb+EjGUwnoiV6kLCZa0VVtOAgo4SIYBe2YlzY9JzruCMe2eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=yEwBgxBk; arc=none smtp.client-ip=51.81.35.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="yEwBgxBk"
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	by relay-us1.mymailcheap.com (Postfix) with ESMTPS id D401D20489
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 13:18:14 +0000 (UTC)
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [149.56.97.132])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 8DB0620063
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 13:18:05 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay1.mymailcheap.com (Postfix) with ESMTPS id 14D853E92F;
	Sat,  1 Feb 2025 13:17:58 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 689A240073;
	Sat,  1 Feb 2025 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1738415876; bh=qg3JWgb8jfYqQ1zE36+8TDcc/fTOFfe5iIhr8KkdCU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=yEwBgxBkDlB+X1LARvaXCfCbmQox9uLtgi0frB6U0ArFv5CvH5xrCzVPFzhHaNVG5
	 RDNlbO0gpcmg1j1uN4pIj8GozCNQbMOF4u6bDTSn8rzs63e/w4Up8+9JGE9qevccUL
	 dkN90Ar38l8wo9T40H6FdXOu7UsASaBT9Mc3gfgg=
Received: from [198.18.0.1] (unknown [58.32.25.108])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 9484C4016C;
	Sat,  1 Feb 2025 13:17:22 +0000 (UTC)
Message-ID: <905e60c6-28ef-4984-be45-7e081bf3f418@aosc.io>
Date: Sat, 1 Feb 2025 21:17:12 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130133456.914329400@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 689A240073
X-Rspamd-Server: nf2.mymailcheap.com
X-Spamd-Result: default: False [1.41 / 10.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_ONE(0.00)[1];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	SPFBL_URIBL_EMAIL_FAIL(0.00)[kexybiscuit.aosc.io:server fail];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,nvidia.com,gmail.com,sladewatkins.net,gmx.de,microsoft.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 1/30/2025 9:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Building passed on amd64, arm64, loongarch64, mips64el, ppc64el, and 
riscv64. Smoke testing passed on 3 amd64, 2 arm64, and 2 loongarch64 
test systems.

Tested-by: Kexy Biscuit <kexybiscuit@aosc.io>

https://github.com/AOSC-Dev/aosc-os-abbs/pull/9522
-- 
Best Regards,
Kexy Biscuit
