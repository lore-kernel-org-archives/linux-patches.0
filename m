Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9FF1B5AA
	for <patches@lists.linux.dev>; Wed, 18 Sep 2024 10:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.241.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726653680; cv=none; b=O8ALxNn4VI4QXbBnCnld0ynnzvPVGEpoCeH7qX1b82b8fkSN2rNrObCQaSKU2BGXqTrO6l3VXKz9Q1/XEagQtLxZPnhJwff/hIsp4BVzQzsXTU+LCcOwbWM9tljaYjwP5bEjrn415PgsYn9umM8UPryhuzzDQrPkUCPYbcCGC1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726653680; c=relaxed/simple;
	bh=Z3UM2w+t+c4vDw6AMzenAuCA4hgGUdJJwHwnYpIPhfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q37Ss++bM5vghH5pgcfAL54X5ZSxyHhVTRHfIJLQlo2Pa1ZcSv2SmelZA+djaerafY/U+23xc8xnBG4X65rd74iHr7Kv+LK9YzKsJGsqtg8doQSZ/Od/i3dzTf0ROnlqQtjFNUfrahVF9Y8u6Uq0fIaxor+ubMmYC8uL5DWtpWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=fia+ftqE; arc=none smtp.client-ip=159.100.241.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="fia+ftqE"
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.66.162])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 89DBB2000E
	for <patches@lists.linux.dev>; Wed, 18 Sep 2024 10:01:10 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 39FAE3E8AF;
	Wed, 18 Sep 2024 12:01:03 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id EC27D4075C;
	Wed, 18 Sep 2024 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1726653661; bh=Z3UM2w+t+c4vDw6AMzenAuCA4hgGUdJJwHwnYpIPhfw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fia+ftqEbP5Xv/sDWX59ftQYN7MJqcO6cy0ezCM3YKQYyI47nVcw1VJWWt3S2fhJM
	 hPez8gfPcmnlb9Z7DSt1WVZ0Ep2t+Kqagq3CBy59DUB41Cg0SMCaMFUptaMrcakBLr
	 u+M4qWq7bSFRFwx2i/ZBXunX1L9H7O7ODChFLo1M=
Received: from [198.18.0.1] (unknown [58.32.24.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 60C924141B;
	Wed, 18 Sep 2024 10:00:57 +0000 (UTC)
Message-ID: <7a924389-c10b-4f01-be94-28c96c28879a@aosc.io>
Date: Wed, 18 Sep 2024 18:00:54 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.10 000/121] 6.10.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240916114228.914815055@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: nf1.mymailcheap.com
X-Rspamd-Queue-Id: EC27D4075C
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.29 / 10.00];
	SUSPICIOUS_RECIPS(1.50)[];
	BAYES_HAM(-0.12)[66.67%];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	RCVD_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,nvidia.com,gmail.com,sladewatkins.net,gmx.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[]

On 9/16/2024 7:42 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Building passed on amd64, arm64, loongarch64, ppc64el, and riscv64. 
Smoke testing passed on 9 amd64 and 1 arm64 test systems.

Tested-by: Kexy Biscuit <kexybiscuit@aosc.io>

https://github.com/AOSC-Dev/aosc-os-abbs/pull/8026
-- 
Best Regards,
Kexy Biscuit
