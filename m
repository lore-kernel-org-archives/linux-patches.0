Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD58C29B781
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784716390; cv=none; b=A/6Cb09DwNwvDyeEtoefYWUxOe+oRzZQ7hWIBp9j6xduDjawxXGx/ccaQuPe6Rkqvs5DRjlzF7uirKOWE+kadvkfiGF92WTzN0VmTsZ/meu5dOI23H/OVzDsB/e3mEc3gIWqNWpbR2WuHrQvhbnlad7AgVhbAC48EbPMsTXf3Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784716390; c=relaxed/simple;
	bh=WN9aLp1TP0t2XPKbPFiGXcd/HXtnN/J0CaFlbS1Rq4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YFP5eX66GbV4ntruonJi2ZMLeVSGqOul0brRsytfv78NbbaiCrrXYaiGcTyi+67LcN+ukhh61EDQ2CpeoTtMdUCQekzyyZZjjcpNZUMcEM6sJByjE6yJuxBcw+VM1uFwItwYbZUclkiCb13JilerKZadvoM1UHh3d8TKlPy8JiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=bL7rG3LR; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="bL7rG3LR"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id mDp4wETsSQ4O6mUG5w3SMV; Wed, 22 Jul 2026 10:33:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mUG4wIK3lOYlBmUG4wFeJj; Wed, 22 Jul 2026 10:33:01 +0000
X-Authority-Analysis: v=2.4 cv=FLYbx/os c=1 sm=1 tr=0 ts=6a609c5d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ipcSOhPNF3U-EMDU-H8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HaK3oytKQBKhtZwlt7AJ3CmWOT8w8xYsg/jHOb5cU/Y=; b=bL7rG3LRCH8V0mNkGP0OAZ0HJK
	DP4wwcp3nipOki4NzazE0Xl/3Ebf+1JOZpDqOxRmuQ5gZUbU1JAeU5u7hsjgsHFtVEPQ/1JaNBukC
	wm/vdeRojJODZH074Ifvk0Gq4enNEQeLnsFEQAyouA7s/eOT0xkQl5dj/r90PJkgBMb2Xeg5kqtC3
	Cy3eurypTmKeIXVz2GB0CY9hk9bReLk+8XVTQEkRaIWNks2A5ryJvoZXJ11MNahUtjIYpzJU4IUhB
	8KHuoCgxUHxB6A3F8th2VIlbyg630n9TZNyY5pk6LmJWrIi31SYK5sbfiI7qgV9+z29beXu5M6KG/
	t3mS2UOA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:47008 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wmUG4-000000011So-0hMp;
	Wed, 22 Jul 2026 04:33:00 -0600
Message-ID: <6cd9d704-3b98-4c12-b5f9-2005681f97e9@w6rz.net>
Date: Wed, 22 Jul 2026 03:32:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152552.646164743@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1wmUG4-000000011So-0hMp
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:47008
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFUfYk/7e7LbS6e9m9hOfrUN0s4+4HDrDWDJsDbXwkXPleX0JIrL3l3zwZfz+j4ZRm10rW5fXFlwH+uKK6ISnMH4fPB8Wd2C++DY3m9D0bfpvnBMDp/6
 s5l9LIEd0L0iFW2g3nxDdQS4/E/v5nqOrHiYpSGzzXMiYTMyLQSRMT3t0BwJtxE/v1Ka9f8CeTN1wA==

On 7/21/26 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2077 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

