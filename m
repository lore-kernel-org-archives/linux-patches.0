Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC3037C916
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 06:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783060771; cv=none; b=UynhvD0n/X/dndHyc3JQqNG8Vo0RipaknGKZcuXOiTHIJZRJtNvoNQcrRnaJoZBC+n4ACFp/LC3y1by6Ps46mUKFBFf4RMtATUTlQytzGe9GX/mlE4Eb/a2Hc6BbolXZoCPLr7aKJorwZuGwoGstCn9oLD5MhcI5fnzAbvw0+OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783060771; c=relaxed/simple;
	bh=rZttTXantzVbA7dDTgj9IHAkqPvYdee7H46RodZ69Vw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMLXQV5pFczzo2U3Lrly03719Mp/XNznjfmVpFSe6CUe0QEDFxgbk3ut8XC62BfiIjZcFqdo8HzzVxwa+9eryenBANmPckttdE0qjG5KSdjizsI955O4CPhybMCliQSmTQ6Ip+dhowJ0D6jM8QLuAlu8uGoJixMKWKh5zwLMqwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Ozu+XgVX; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Ozu+XgVX"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id fUx3w6YR2lPo5fXYgwLQxT; Fri, 03 Jul 2026 06:39:30 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fXYfwgy7JXiyOfXYfwllgF; Fri, 03 Jul 2026 06:39:29 +0000
X-Authority-Analysis: v=2.4 cv=P7w6hjAu c=1 sm=1 tr=0 ts=6a475921
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=QUYbzp3p0A3I4yDEf8UA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Qm3jAqhFTU5awF42jojmA+0HBa7FiyO8dCPytBgqYW4=; b=Ozu+XgVXHRm/PavTAu1melAZlB
	Ue5rTq0I3Wxznima4fKQdHO0RTz+dRYNnxSNw6mn0Uv8G3mFh26CrjHZwCCz+CvILUEey3b2hltZg
	XeIUvTyXrGNXIWQSjGzHBVPgq/gKgamxR/SItbjLVZbIHdZsa46C3Dw9SZ7H8XWtwjThY6Puq3YiI
	g2zGKyobRJ9kF64rXDmZkI4RvknS9WZeUZ79jpri9ktIbqTh0EmT7FFyNfgBCrpIiKY5hWa1UuN4y
	wAP0X5IzLbI7Z19taPOOadq+ZbhHNPu5m53LyaXtI5Xtwx8O8HU+iTsd0R2VKFAlkET21z4lIMqJo
	c7dBl7AQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37594 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wfXYe-0000000195A-3hZn;
	Fri, 03 Jul 2026 00:39:28 -0600
Message-ID: <c68d412d-3abd-4b83-995e-ce3641646da0@w6rz.net>
Date: Thu, 2 Jul 2026 23:39:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155112.163984240@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
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
X-Exim-ID: 1wfXYe-0000000195A-3hZn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37594
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJsl8UyRwLxe3s+s8duupMe5uwNcwV9A7bjH64d9GpeA+Nrtm39EE+k6FKn+fMiZcx+5RS8JHn5wmtBsoNJ/n8knNR6bUmafTBddfcjHRDkrqZw+OQRk
 B7v1YfBltECDudRc+IHyf/YrdZ7On/puhTU0b0UXYvjONG1aViC4UBXNeHD1mk7UslrZ02qXtmZReA==

On 7/2/26 09:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.177 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

