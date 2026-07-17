Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6C439C657
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 09:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784279697; cv=none; b=IQTE4U0fhjQCVsWDsWpamtH7fvWyX9HLP8Jl+3rzEZec5d6O88tAiheDOrTbfrbXPEFMkTXofxa3tOeDCf+yGzN4FK0FacFm92EN0dqy9qLXAfq7COOymX5Ws6BnlTX8dVkN2Ze/S7Nq+Z217BJGeys8rT64b1QGFZjMs6ttJLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784279697; c=relaxed/simple;
	bh=c/gPYmrcNlzxBAziQu1tkmrhMaOlxw22oYgu+kQwIG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dmxGkRFCAAplhHXw+c/subFY/J14UwyQ8zBpm5XOuteeYgo9BSg0tOnvUtofJuMyUwRYZd39/yikR6bnKKVykmsjOE/7MXq61zkzE9iOO10OcMrFi1VIbcdS2gPFxyCMjEJxFKMxljResWyZbRIxjU8JCDBt4euwOdZJq/X1qlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Ug1w094o; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Ug1w094o"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id kdUJwIoQQhJKMkeeiwlot5; Fri, 17 Jul 2026 09:14:52 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id keehwYXTp3bwfkeeiwxqq1; Fri, 17 Jul 2026 09:14:52 +0000
X-Authority-Analysis: v=2.4 cv=fv/cZE4f c=1 sm=1 tr=0 ts=6a59f28c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Nghn086io5pY4Qe7T5wA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zaQT8Gm/MC6+1FYK/6la982tDxME5INus6MoMP1fTWQ=; b=Ug1w094ofVMVxY4rLAjFGRBc43
	tNbXpHSevXnm1JvkzGL5WrHxsXNh0MD8yv7QoQvJggL/DcxZarnTILfI1wQPu4KYB2f8EG7k7pYk+
	4K7s1Br4B2+2P3JVxZwSo91Sc0WGAK0VkArWV6tD1lKTbvkNzYgBvoQu3zo/YU/8rI63Q1HIoKinu
	O+cDGebcRpDcYnpybexuKLofcSWTzDRNdM2LWryJ9Bo8hN0HDg4KKGYrd4ZBjyPjnlML0afbz/WeC
	eCxU6au9Em1Ogw8hTgHGoqnsGspdAvVQGgLgD0olFebRWAXGciNzGfKx6uKFbbx8Va3+fAgcw+N2s
	sdpg6dkg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51966 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wkeeh-0000000493f-1Rnq;
	Fri, 17 Jul 2026 03:14:51 -0600
Message-ID: <62331811-1dd6-4147-9c95-402173c895b8@w6rz.net>
Date: Fri, 17 Jul 2026 02:14:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260716133044.672218725@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
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
X-Exim-ID: 1wkeeh-0000000493f-1Rnq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51966
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAgdmEGc4E+1YWtzO1SxZew01YwUxcg3hvH96J+5gcLSm6bVf4Gl+bc7yuxuIiZXXQmIs7wzeSe1QMboP9XPg0xxl7BZqCGj5p6hJmPxLfOXPc1qgMVA
 giCO6epn1lNleXYwYiTdjXtN/q3mjVGbXRzkX2RHrO9tSqWTZWhXBSyX3FmYJDOkmXZiuYL33BLovg==

On 7/16/26 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

