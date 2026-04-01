Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9062537F00B
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 09:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775036100; cv=none; b=lt3pB4OGjVcXwmRtZB2IHH9DSBHuB7FxxZOLCmXm/WNBM5LdIZTN33fZK/DGycrQAy9QzrOQ0esrQI6OEpbayGhh3g4noBIFIMO7FlrUacLlQx4Q0x4JmjRB6YOWuxEXY/rz4wB8DwgD0NJkaQvzpQZppb9o4QowgkHNgiTa+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775036100; c=relaxed/simple;
	bh=IronJww/zKQESdu43sCkHjza5nzz6o91XswFyQQDs0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OiKvql/hjXJ2lqzzxi9qdEt5bJbUMZUMmW1RV8vw68jmV/AqTGoPUSdkhbHCyzIWiFVFvCASfT0zPDdBLVMSoonBkrGtS24GlWUH2iT/o1UHDh39Qneal0ttHycG+mhrevdAQICRi9/HbSHvxY+FD9wKXjDK/AorQRq8YdrySgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yZu0EsDH; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yZu0EsDH"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id 7ZIowcIWY4Rkp7rySwV3o7; Wed, 01 Apr 2026 09:34:56 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7ryRwrwLtYA8x7ryRwvNt0; Wed, 01 Apr 2026 09:34:56 +0000
X-Authority-Analysis: v=2.4 cv=VJfdn8PX c=1 sm=1 tr=0 ts=69cce6c0
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
	bh=MeJWq1L0K0hp8592OV0dTswEyADFMZIAhP3RKeDMfPA=; b=yZu0EsDHsPCa1y7a0XQXXiiBpi
	qouosD4bmjlmJJPipdKvmm17ogdVKApXbGcyOfpf+RSfYWeCWriAG4xVRLT+jUOjgPwoKFHc2w3zY
	i3+++VV5RZ7OIFA7sk+GSw87mxC40OSgQNFLYH8hMyoeEBK7i7Cjb1shGBP7imq6YNcfzmTl5+WCN
	oFRiPXg+02WDdI3rrJa8M8ifbhnD85whJiiYto8NzR2vJFU4lOpSbMOi9WUUmQz4xzVkTkbkeeXvD
	IRSRIfzga+ZTcA9q9XLzFZElUOiaGDQVtFAK1Z3Sz0/Z8gD+g43sBEuQXu0BYe0mtbUBRQEPJdgTe
	qZtPL7tA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37462 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w7ryR-00000001kCI-0ton;
	Wed, 01 Apr 2026 03:34:55 -0600
Message-ID: <32ff8132-40f9-465a-a7c2-3945d4d2314f@w6rz.net>
Date: Wed, 1 Apr 2026 02:34:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161729.779738837@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
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
X-Exim-ID: 1w7ryR-00000001kCI-0ton
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37462
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDRM+QQaTXpN1KooNGH7YWjiCuHcCOEmLAuybYCLUsNJ549c+WLWqZgOCEV1N1IdwLyimknH07F7OQhAyUys7WVMC+6B9obpU6TaD9fWr8k82Wg/FyGn
 hCByqSsedVm7VpIzLHzkbcHvx02tPXzf+mTmzTVkQErjoK3AVQqF+RPU/RQ++ekzkm/n3fi6PgCGzQ==

On 3/31/26 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

