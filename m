Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB8136C582
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 09:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035763; cv=none; b=ZgYqMsEPba7x8En4ZZxw9E6zHAhUmDWjiherfhMytj5pqiLsVRAVte4bqkuheX0IXoa/IVd8Nlyg2z2TEuJ1MBpmhgm//lrSvCL5G+r94ZRu7aQwCqe3X4z7ndJVM4SW4XoVKnABXkZ6wqdA+SygnZLlOlOIvFTfpg2N0VqJ/iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035763; c=relaxed/simple;
	bh=60vS2sOqyczXeildRX1gg9bbkIwsHX7Jju0Cy6KNS1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TYcAoq006IfYFZOC617V4Nmg/c6QLnB+5+yjmIiePWSiXdGph7xUXhoQAnHI5emsQRZwrlpyK4BzRPG4EOIcqU8+3qb77ORsBF9IhLBcS53onJsjiVEZKr3uvC0z/eB1nMoLBPlhnnax6yLSXe99BXVEBAtGm2xqGPO/BMUeIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=uzr8hbfP; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="uzr8hbfP"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id 7aaXwciXE4Rkp7rt3wV1dO; Wed, 01 Apr 2026 09:29:21 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7rt2wrjniYA8x7rt3wvC8C; Wed, 01 Apr 2026 09:29:21 +0000
X-Authority-Analysis: v=2.4 cv=VJfdn8PX c=1 sm=1 tr=0 ts=69cce571
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=FHuNozLtWGT0fbKrETUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X68ssfcK7nVIPFjbfb4/xKnS6kYn3CebrUQCtIH9PsU=; b=uzr8hbfP/Y9DjJmTzShqhrmseA
	jp3vOCGFNeWEykLStosLDfhY+BXZLieLydc5a7m8Lpb2jvZXRSU+DYxnTlWeEYfHWkcXU7AERiKYK
	du4J9VRq8Gctr4aABP6F1toTSI4pqxBwv6owMXWx6uooXWdndtIW+rk/DSlELhWAutbvHQKfMKOaD
	THtoB5ieIALX2muBuDXxQWcok7MClVQe6xYovWMYvXCDzgy+AWxawBNtl/dqvwk1VhW6y7zYzsn1A
	LQkqs2tUIhHFJmLJvBmtRuDpUnvmFCM7gZPTFQmWd4gcE25omd1V1AwX2NNwYOQJZnWWUkttNVsQh
	9FhbJW1w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:44294 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w7rt2-00000001iDu-0vnv;
	Wed, 01 Apr 2026 03:29:20 -0600
Message-ID: <f8cadade-73a3-4bde-832c-f472463779d3@w6rz.net>
Date: Wed, 1 Apr 2026 02:29:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161741.651718120@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
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
X-Exim-ID: 1w7rt2-00000001iDu-0vnv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:44294
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAxvfrJvRxNQ6pRX1Qg1xpvgSo5YwKsOg+kLuovp4PU0rWpuyZlbOcZKFKV7o9IQgNcBOFisGPh72mIFeeGJpnHSweJe60eeNgvMbOUruwubcrLWwK4t
 zJmn/JEyLaIYNidHOlXUH1gAfhnXZjPanKMawDa0vPWbEXzLcZWkiP7e0WsPOUB4bRj9rc7zeA3ijg==

On 3/31/26 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

