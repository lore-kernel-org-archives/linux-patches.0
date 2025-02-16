Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AB0372
	for <patches@lists.linux.dev>; Mon, 17 Feb 2025 00:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.35.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739750667; cv=none; b=uJemfNkOlyl8VQlWXt5VrXsMB3lYKNmI0IZTnx26Mjspc5zsLaINxldCN2wR+nYEYJt7e1TDq/60RRvYdda/Ivydcq6nB3kr28vPcRq8q2jWw71WO7rAdBvyShdyPiXjE9be/OMFB5fRXQZomJJlbvbNcJNyqfLrwoirgn4FWwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739750667; c=relaxed/simple;
	bh=WcwwYqXch6QV/PhVm4Vn7dF66DiUSx5U7MGHrLCNvyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWJkftSf/O7herdPoHKmfnP5RKcEHcMZ5P5JLPRXtDwKWgp2CrF3bEUnX1ns34D3iNDrc1Ts0qCX0PlV+vEqwvg3jxMPIj0qlFzyLGfXNn715PD4PGE3ZXdlCsDHYgfc99w8K09ybevixw3sYeVWwOKtKPaRDyA+DGzNgcEIepc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=XG8sok2p; arc=none smtp.client-ip=51.81.35.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="XG8sok2p"
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 436B020495
	for <patches@lists.linux.dev>; Sun, 16 Feb 2025 23:57:27 +0000 (UTC)
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.102])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id B540A260F6
	for <patches@lists.linux.dev>; Sun, 16 Feb 2025 23:57:17 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay1.mymailcheap.com (Postfix) with ESMTPS id 9F97C3E939;
	Sun, 16 Feb 2025 23:57:09 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id A3B0F4023E;
	Sun, 16 Feb 2025 23:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1739750228; bh=WcwwYqXch6QV/PhVm4Vn7dF66DiUSx5U7MGHrLCNvyw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XG8sok2p80qBXIoQ91t+ESJlpumx2vB7wGIhARCY5ph8gw9ubH7pF54BJJ0TAO2M3
	 jSzrYOFW0u6P/hl157Ib8r0El2aoU1o8N2aP/qdPGQY8tyhbdWf3LxhhHVxSaorFqd
	 fkwVReZmINsF3ytVyalzDAJo54ia5xvTsssc6Zak=
Received: from [198.18.0.1] (unknown [58.32.17.244])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 6D5E04086E;
	Sun, 16 Feb 2025 23:57:03 +0000 (UTC)
Message-ID: <2327a312-8b1a-4fde-9fa5-1aec5498bfdb@aosc.io>
Date: Mon, 17 Feb 2025 07:57:00 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250215075925.888236411@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: nf1.mymailcheap.com
X-Rspamd-Queue-Id: A3B0F4023E
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

On 2/15/2025 4:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 17 Feb 2025 07:57:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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

https://github.com/AOSC-Dev/aosc-os-abbs/pull/9696

-- 
Best Regards,
Kexy Biscuit
