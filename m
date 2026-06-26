Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EDE279329
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 05:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450335; cv=none; b=BeMv6cL9NZvCDU3+RUoCpGlVIKIzhxYT76OazmmTAkPblWYUU8AHko0W/c1V9RgZq0Y0Nm9uKVn181IJZdNgS+3GCm/wowbmL5kG4YlySwTH+IN859c+r3DJoFuQSIfveKShN0u782bWrMZ6TvBi9bLLVEVI6cWiyXS/8zqU2EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450335; c=relaxed/simple;
	bh=EG5UKOOunmeV3w7eVWIr/shhqozg+yQzJavn6VHNoBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KyOMmrDlqCC8eghQfRJIA01kG1ked0Hgrw1WOvX/x2UlGYcUFhH2Hxjj6oxp/UZd1/xyUDnbNWCYJLZkNU/XkIjthCC9iYnpPqzNQR5LMBGSwzSZholPYRTxmf960DiGq2FKF8zlizbyuJ+wXRZ1R4DRTeiHcEuEiaZRm/D6PrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=2OzjHbTA; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="2OzjHbTA"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id cuj8wa2iePpWVcykvwcZkF; Fri, 26 Jun 2026 05:05:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id cykvwjNK60kACcykvwFE73; Fri, 26 Jun 2026 05:05:33 +0000
X-Authority-Analysis: v=2.4 cv=HZMUTjE8 c=1 sm=1 tr=0 ts=6a3e089d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Lc18GGwJt_UjcvvaV1cA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UzszWBrklejaix9Evr1LwCv+gHSS3Ct24gjh/uTmXT0=; b=2OzjHbTA7NpSCaiC1HU4y++cim
	hcMhqQ6EZT0jYa4pvkOLgkGlHfpEg3uUJaDJuCFHAI9TnXq7xRpD37LFElX/lfQCaJysNr9x+lWJ0
	E05Ik1jSu2lqI0Ty3NPdS7bXlPdrYKcmtwRuA2zgIPgfAiZf6z5tkpePBV/sfbRC/GglkgUaylhIv
	9/Aq4q1Q+skptP52K5u80bHLPrXD3sxmxOyXkl1UuBSuyGljdb9O/Qwci+J5KeX5PQ0fpkGrE1grq
	Yy3syNPPhLYNT76MwTBe1lXJtDJ2GGdAtocE9zDH2dnPA/Nsw4Poag6qi81/9yGe0pslxGO9khyej
	vJFZWPpQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:39782 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wcyku-00000003kgq-3rFq;
	Thu, 25 Jun 2026 23:05:32 -0600
Message-ID: <c9f729c9-4004-4df9-87b6-74e98e08d42b@w6rz.net>
Date: Thu, 25 Jun 2026 22:05:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260625125637.527552689@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
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
X-Exim-ID: 1wcyku-00000003kgq-3rFq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:39782
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGVt7hCqlRD+w1h3qtQl/JNRHn6PLXvCRJANyTyoZ1VtbTuvKzJ3nvGzh+NYQwp41VFoY/qUtAOABpgBhXyEkAXjfQ3x4ehuJcrllmwSsf6i2seNb/u2
 Oxh9E4u8UAQvLvT0wqwekAvhQWjfw0WzlOu7Z5C+EHe4A/5i4rlFJhD22XG+1hgDsjcMEnO8oq0VRQ==

On 6/25/26 06:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

