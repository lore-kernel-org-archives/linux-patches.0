Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E4432BF32
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857248; cv=none; b=D9FtsOyiIl2ZDNrL33OUWITgMI8wk27X6wWPn+mCFOQQDM6dK8r1kPJ58RLLhdFUXL9XinXpG4YMmZ6HHEFNdrvBY9C+Q3gWxsTuzYtG4xmMni0JGFtCoyFpZ48nHAlL0nr/yLtpamUdN5x2Wm6WKcjo/ifRWsXADeLWvTPLFy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857248; c=relaxed/simple;
	bh=hm3iMf0+33S7vc286HevhmPqkcPFII87NwXwIVUdZMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VoN9pYdVk/JYn0swR3VPUb2Qf3CS2t28hHEGSfAmILJre5JIHMjuhCs4bC6gLe9JR8oFM5TwVQDHI4aoZftlmQjFZ6yB5i/QFfYw2Fx96XSYgJkCkYClAhxA0Gs+wceNAzoq5BLAYm9rX74rUneemKGwZqjc/4M/24vTXkU0/RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=FqjaSwIz; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="FqjaSwIz"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id R5vCvzx1TKjfoR9zRvxWhN; Thu, 04 Dec 2025 14:07:25 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id R9zQviinlcu11R9zQvCOqs; Thu, 04 Dec 2025 14:07:24 +0000
X-Authority-Analysis: v=2.4 cv=bKYWIO+Z c=1 sm=1 tr=0 ts=6931959c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sBCNlkS6UWxVZiUaAkd433hnAHFe+ILFalql2KHHBys=; b=FqjaSwIzFlyjiXdfTjtiIVu+Ww
	DnUqqjbGaGP9j9mc2f6bE9bFCbLlNjhqu1WyzsGTZpOrBScQsd/ufFjqFszsCGfv7mZkh/t3wxdHF
	rQco2bx85KMtwYhGO3TZ9uzi8+sn4p7xShNORHEZLU2erJgxaf4NI6OrvllatcgWUNw0yRUKmxukz
	bM+I7/aHUbjExg07+lqwXnG+ukHuTN8cbC4hh2snFC2muUxg/r7GiORv3DZ40WbzHQZJLUBQH2rVq
	Kt0p5nJtbP3Jg9+yXjH1YDyuAfJez4K8zzzL9Ab0WkkTirTKA1GYSA0i8l/2E2rhFwAGJk2/g4lOj
	Fuy42KOA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:41488 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vR9zQ-00000002w6v-0k0s;
	Thu, 04 Dec 2025 07:07:24 -0700
Message-ID: <39328e93-8ffc-41c3-9f63-4418f13e1157@w6rz.net>
Date: Thu, 4 Dec 2025 06:07:22 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152414.082328008@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vR9zQ-00000002w6v-0k0s
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:41488
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFVGVIfnKdkoDsbDcoJq6TBmtV9o9Z7T7RwQAQO9Hj0lMKrzBfgCzqpqKEtW88sDPclNgHpYsTNzIEfFSBQvTDYJi0uwHMbMiEdhLaetx7olP+wHIUZC
 4Jd3CyUr2Xa2BB0bWaf32ljoGAZgYjtuCQf9F51OisMlNBcbGGyOu0+1W+EbIcYDTCVWET5xniRbHA==

On 12/3/25 07:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

