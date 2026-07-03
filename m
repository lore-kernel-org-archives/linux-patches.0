Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8693655EA
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 06:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783058901; cv=none; b=myCRfIdwCKMSAFenOTYRgx/+9jjBlO6JBz1pom2FUj0PJCK8Il+7/s/09mJ+6/1bbw39gqlgslQrJB51sY/FzzjlTvihiERiLRIuj/gw+cEiHQ/movlXG+c4nJTaCBdj7ysEANg3o0HTmoNR7tYoN+iHexWoHtZl2M2lxvJdiV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783058901; c=relaxed/simple;
	bh=dx9w94AhTWx/gq9vAv9aqaRW52yBBm73UOM5KjQ2DWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b0eglUoKx3SpZFI2yze2fqkoidmTz0lXosZ6AUQPJk3atUaj2syG/RpqSrHbRdc1xRgAcw8zNZ8FBaB3+TQBiJDUDoXkysrzqIPKpQYyb7/xWpEcFBQw/iwit2Q3Q3hxulgWqDchUBQyGV0FdA2VDBh3N/25ZV8XzD12Cqzw3Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=e/57qUuI; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="e/57qUuI"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id fPS0wbSJvjgwefX4VwSKgf; Fri, 03 Jul 2026 06:08:19 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fX4UwZn8booyIfX4Uwgc48; Fri, 03 Jul 2026 06:08:19 +0000
X-Authority-Analysis: v=2.4 cv=AZ6xH2XG c=1 sm=1 tr=0 ts=6a4751d3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=Fowlm8kEtbx0O9ktuRkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ap2WA2OS9VyfySBBrFn208zBSGOqORd1QUPMQwh1n5A=; b=e/57qUuIL6xA1I+Ku/KaTXEjFS
	2vJSnyVtO0HOTzPl4FYrsixkycA/x9tll3DsXAwpJPAiIQWFrpQLVHNEx1fqBrCXWY+CCL1Y/a7o0
	fjvU9C6HwbjJJPLqXjaX7T00rQZJIOgAgIHiVbDSA5w59r28QHgv4tQBpHp7DnpACGFrJgEdiaO0m
	erj3W7Gc3V1x6QH+s99qxcEIAgXKp3eudXyxEBwPIrLH9274uBnnaOUnAbTxJkBpHoK1y1pbvVjXi
	jXPjbtcOh1U7kyHR7uFjKfRfvLn9esKgqbPs3DKuCn/IB/C34PrNzC0JNN0p4MnVPipvZ3wM4prMe
	yspxLoSA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51120 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wfX4T-00000000q57-42oD;
	Fri, 03 Jul 2026 00:08:18 -0600
Message-ID: <c99b489f-c5b3-410a-a2bf-cc9816bcffc7@w6rz.net>
Date: Thu, 2 Jul 2026 23:08:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155118.667618796@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1wfX4T-00000000q57-42oD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51120
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDYG9s8kIzQbcr8UOhLFl0wCf+S9NaTRr7NaqSb01gH1XCtOjSKP/vA0capklPEhp3pSRBmBDc0h2KOs5X7KcWAghAtId03pXDj5k3Cb38hXFNiFxNIF
 d+i9bGygH2jDp9HmDAovoY+N66v8PmG/FXjovAlR21hEoHvJJfyXJ0LFp0skQ9Um4l9bucmlO80GiQ==

On 7/2/26 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The build fails on RISC-V with:

In file included from mm/kfence/core.c:36:
./arch/riscv/include/asm/kfence.h: In function 'kfence_protect_page':
./arch/riscv/include/asm/kfence.h:25:17: error: implicit declaration of function 'mark_new_valid_map' [-Wimplicit-function-declaration]
    25 |                 mark_new_valid_map();
       |                 ^~~~~~~~~~~~~~~~~~

This is caused by commit "riscv: kfence: Call mark_new_valid_map() for kfence_unprotect()" e4cd475b84f3803fbaff874d5db89e1028bff4cb

As already reported by https://lore.kernel.org/stable/6c5c0723-66c6-4f9f-8021-2562efc95c6e@iscas.ac.cn/, upstream commit "riscv: mm: 
Extract helper mark_new_valid_map()" 9ee25d0a70ff4494b4e1d266b962d0a574ef318a solves the issue. This commit cherry picks successfully.

