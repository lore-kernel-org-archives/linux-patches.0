Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB88A1CAA75
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 10:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.248.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737629148; cv=none; b=Zhz+ofswgxYLHWhtNqJIjwqAYr9bb2AEwXDeuN/o+jxxFv88FhMRueHhqm0R1ziWKVRXNOLmXA98H+SRb3Su6maYReggeqEsJDeZn3gRHYPIn9dXEsmKW6Gdd3rBCAVy6hg2jEfCKO/CiuFsWlkCbxgFUyATNkQHisa1viHSPPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737629148; c=relaxed/simple;
	bh=t6r5R30HmKhEBwCKmDzhZUZM/A05ztud4qCW0TZtgt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3e6g/vXO0KT9+WbFStx8k66zmlvAFcY+DbmA5gq3MA3hb47/sCnX4G+6xMZhAZYUJZR6ocyv3dZm7kBfXUIW9YVfhMR5pNxoEQVwcV7QLZwN7yoQ6bpXW9KFoR9R0AVMFVAT3pyCByNjKxh+FDZ7Y/RgJ1oBBrOZ8E4xKPn+1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=ri+pBhTJ; arc=none smtp.client-ip=159.100.248.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="ri+pBhTJ"
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.157])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 7C3B2260F7
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 10:45:38 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay3.mymailcheap.com (Postfix) with ESMTPS id 651323E8F3;
	Thu, 23 Jan 2025 10:45:31 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 7BD36400B0;
	Thu, 23 Jan 2025 10:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1737629129; bh=t6r5R30HmKhEBwCKmDzhZUZM/A05ztud4qCW0TZtgt8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ri+pBhTJmgMhM0dxbXeZMio2sSJ82iPl7iam7E88zrRTPlYJ8EB3w4WPhgbhAU4vx
	 NwX00cN1HFe6sVgrFnY++UeKJiA0dtdULUjngxdjttbXnyn1pULYvD7eVA/RG+AMko
	 NPRRW1Kvp8yu2SSvZnB5l7H9ewfHGQXdc0D+pTbY=
Received: from [198.18.0.1] (unknown [58.32.41.254])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id C568B43B9C;
	Thu, 23 Jan 2025 10:45:18 +0000 (UTC)
Message-ID: <efbf6aac-17c5-4af6-b898-d0d10ed34b3d@aosc.io>
Date: Thu, 23 Jan 2025 18:45:09 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250122093007.141759421@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7BD36400B0
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

On 1/22/2025 5:30 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
Building passed on amd64, arm64, loongarch64, mips64el, ppc64el, and 
riscv64. Smoke testing passed on 9 amd64, 2 arm64, 2 loongarch64 and 1 
mips64el test systems.

Tested-by: Kexy Biscuit <kexybiscuit@aosc.io>

https://github.com/AOSC-Dev/aosc-os-abbs/pull/9406
-- 
Best Regards,
Kexy Biscuit
