Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166ED378D71
	for <patches@lists.linux.dev>; Fri, 29 May 2026 05:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033508; cv=none; b=ITkC2GQkMjc3gOMB4c2+qPUXic81d57FiFrk0t2qyRs8dg7T8KbnvNRIIS8Oom/LurYC4sFmyrIfVUBKq7xjLwH9Z90hKQjWT/8lInphbQRqr8sVXjbB4bQRxpI07XiS1sVoBBgSHTu0kDwWay1O770+ABU+4/pfSAQbpY29AOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033508; c=relaxed/simple;
	bh=3vZnpljo1rAuuCndW22pq1DZJ5ou7eRmjdXPhYUgGDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=imn5XiigUNhTweypoWKOeXvTi4dRsJt+fI5we+cLzFHStYJ/MB9g9ChEW23MQl2EAx3HI3aoLNF+TE65BrlhLwTbqCWWZL/AiLjUE9WGkL40eoEDpAWSch/K8cUSCQ65E9F+Syz18F/G2g/pOTt4slgbq45jZHzOHkUxFnEfmjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=gHRNCULD; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="gHRNCULD"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id SoPQw6MiUMFEgSq1qwwVYx; Fri, 29 May 2026 05:45:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Sq1qwzdTHWBahSq1qwDWjO; Fri, 29 May 2026 05:45:06 +0000
X-Authority-Analysis: v=2.4 cv=Y9D4sgeN c=1 sm=1 tr=0 ts=6a1927e2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=o1yzyhV8/AqTTsT9AOhBTjiVzBPyO/jTJOwQNdu9ynY=; b=gHRNCULDUx1u7rA0Dew4Esjtxh
	p4r66kwEItixJPIYfK3R8bC9ID/Rs6O2UOL6PKFi0AlpVc4c+MZ1NzUtvQ66vT3TG/cotiBCyhWyT
	YRrEViuFAS8z+6TI+LQCS9lV/cZVd5N9jpaK8h7y+6ct9g+ENSlLsUehSJnvRs88baekyJZQFUW2u
	AtZ49Z0sL1038XhwV8fH8ZbD77VagvjTY5rhWJiD1ufEjZB9rvZE7lFK95dZr1M/mw3iKJkHlYibF
	HVyiOJfxlDHdSwxgWAmXuAXOY2WG8IiOALPh2UOUCCwdrXgqUrlfUpzcCHk8Tr9CRb4LDwmjBCwVz
	LiCZoTBQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:43752 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wSq1p-0000000430o-1wbr;
	Thu, 28 May 2026 23:45:05 -0600
Message-ID: <4e78fed3-3e93-49dd-8cc3-1f3949fbb4e7@w6rz.net>
Date: Thu, 28 May 2026 22:45:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194928.941004471@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
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
X-Exim-ID: 1wSq1p-0000000430o-1wbr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:43752
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLI56lrKudx/HZeFGgSRet/HzYqzmGOVGTvgRGvp+izUw6YqRUf2LUaEC3ddm6uLfLdLY+Eey7lC1qvrtmNORTXakMO+BcTl8aDKV9Z+VordicRdW0gd
 heIA+WGElNVy3/+vRxPkriGY+qs2tvDmjJLN9qzuadTVfLKwp0H25enjBP/2PleGpiNZcW/AweGg3g==

On 5/28/26 12:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.142 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:48:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.142-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

