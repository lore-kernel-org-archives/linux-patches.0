Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C0719DF40
	for <patches@lists.linux.dev>; Sun, 16 Feb 2025 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.248.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739750281; cv=none; b=Tex9znj3SxSxCDU6o50jZfU+6NP4X61b+yYMwUh6nhzSog2YNCm079RbDIExE2x+GgdIRO8TSiAH8xEFyvrosaDs/ek3bUX7RvF9EZze/43fylkv5iUMQPKQwq1uiguf7CTYS2mmU3/8ldEesrFfy1pP/v3H8O8AQg2SwciB9L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739750281; c=relaxed/simple;
	bh=RvMyz69Q5a1HwyeTHOUFJKWZ23Du+1ViAhQqi4WE9X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qZJnVtRxml29kiyFKloLoJ+wt9J4ILgzflSrNhZ3gooXnef2nu6vLeyy7M/DXFM+zGZkJe+qri0mCoagvqOA0zpI+GISzSEEVc6hQCOy77LixAm2zbbOhpWwazNspWDVLsQQZmSKKGzjhyi3xX1XxsU95CPir37w6mqwwa5c2W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=BYJTIAYP; arc=none smtp.client-ip=159.100.248.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="BYJTIAYP"
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.157])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 168D2260EB
	for <patches@lists.linux.dev>; Sun, 16 Feb 2025 23:57:58 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay3.mymailcheap.com (Postfix) with ESMTPS id B8B2F3EA8A;
	Sun, 16 Feb 2025 23:57:49 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 6182F4023E;
	Sun, 16 Feb 2025 23:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1739750269; bh=RvMyz69Q5a1HwyeTHOUFJKWZ23Du+1ViAhQqi4WE9X8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BYJTIAYPkG+5mPQal7AKQJlQ0t0QDjtxp/w+OPwiLxmU2/ZraRrj+ID3Oy9WLNn9p
	 aZw1Uok8dOW6s4eiflXpQRnTtQMBLcVlyxqCdqgl8VWGdbUgdLZpo1s+I09BnLoIh9
	 RDsoSOrVmiHWKdVMk22qOhwpeJ+dBL6APKbBzltE=
Received: from [198.18.0.1] (unknown [58.32.17.244])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id C863940657;
	Sun, 16 Feb 2025 23:57:44 +0000 (UTC)
Message-ID: <270c8038-dfb2-4b09-87ba-023b353c67df@aosc.io>
Date: Mon, 17 Feb 2025 07:57:42 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250215075701.840225877@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20250215075701.840225877@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: nf1.mymailcheap.com
X-Rspamd-Queue-Id: 6182F4023E
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.41 / 10.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	BAYES_SPAM(0.00)[20.06%];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	RCVD_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	SPFBL_URIBL_EMAIL_FAIL(0.00)[kexybiscuit.aosc.io:server fail];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,nvidia.com,gmail.com,sladewatkins.net,gmx.de,microsoft.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]

On 2/15/2025 3:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 418 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 17 Feb 2025 07:52:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

All tests passed.

amd64       (kernel arch: x86)
   building passed, smoke testing passed on 9 test systems
arm64       (kernel arch: arm64)
   building passed, smoke testing passed on 2 test systems
loongarch64 (kernel arch: loongarch)
   building passed, smoke testing passed on 2 test systems
loongson3   (kernel arch: mips)
   building passed, smoke testing passed on 1 test system
ppc64el     (kernel arch: powerpc)
   building passed
riscv64     (kernel arch: riscv)
   building passed

Tested-by: Kexy Biscuit <kexybiscuit@aosc.io>

https://github.com/AOSC-Dev/aosc-os-abbs/pull/9699

-- 
Best Regards,
Kexy Biscuit
