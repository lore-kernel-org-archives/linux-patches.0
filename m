Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D429F18DB34
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 08:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741248339; cv=none; b=J4ngkVFEflPY2S0ohicPOTVgf1PJPrlp0vHIhPHSFdsxZ6GQK0MCJCPmU1l/act4R2tMl1y9AzBr6eID4gGbwGhMKp4kFSN5BcvDuPo9o5K73q2pAtSJrd7zrpprbNg7pQMFXFGthm9gZO+NeNpjJYr9k1sqKyLI3oA2lfD59uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741248339; c=relaxed/simple;
	bh=3gcfCCr6l24ivpvQlk391NzLvFPi5y1fCxi8TyEKrww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3UXOW1lmNKuIoUJGnmex3VZAzHE3cM+k0nPK95Q83MTF6IPhppPvsDW7LChitE7GFEbyjMLpAr4ZhHhGWGOBZml+h3G3idKcZg1T6C1ddNt7GP3T9dYx/+lZ6p1cUI0Grcf0wF/bESMk8jXq09ZchiXY1zv0HpMEv9tinTURy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=l0/gMuPk; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="l0/gMuPk"
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
	by cmsmtp with ESMTPS
	id q2dOtPYhTzZPaq6D3tYzff; Thu, 06 Mar 2025 08:04:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id q6D1thyUrhQfUq6D2twiuZ; Thu, 06 Mar 2025 08:04:00 +0000
X-Authority-Analysis: v=2.4 cv=Negt1HD4 c=1 sm=1 tr=0 ts=67c956f0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sg/im66AJ1V/3dMTdrBKDezc3dDs1Bt81PPQWmSRqm0=; b=l0/gMuPkc8FLqBa0bYAsQ7H3Ny
	9swjmQOw1LvnqEYGFFddRdGW4a6m6WeKYGXfHHYVeZBcIjs1OXY+rEFwgl7ehMYfqkyUxe1x5e9Io
	nF0GlSh6JJfxzU+OoiM1Yfk9zvYhR3klRVRdN/gXr66lKp+u6nOJrVGPXaR3HUDurvS07UgbFhJ/L
	NDS2cHXkkW0tfMkyHWy6YDs6/LjE5dU1n+wtB1EtANQHuMP1aZmd7CYUUyhA9ar04TDjhEExSUn0a
	WpzSTnKYpnbiXrvNeKS85JRuH8WEgYosW6vFvRD86mLsGEn9kTKTIJEaBbbffIrYbuWnzAJuEtZPa
	CXy9qQ7g==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:37698 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1tq6Cz-00000002vQO-3YIM;
	Thu, 06 Mar 2025 01:03:57 -0700
Message-ID: <0040d67a-fcef-4b34-a0a7-258e55f95174@w6rz.net>
Date: Thu, 6 Mar 2025 00:03:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250305174505.268725418@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1tq6Cz-00000002vQO-3YIM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:37698
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLignFyKoRq4LWYDz4Amk09rgNsokZFYIdnwCJdjm/5Ryd5yyT3GB9Mw40O+oA0LBvXww/Ume2YDpMt/VLuDGSNka3FobhQFayihrciOCvSuDf6qGQfN
 S35j8o7gFCxE4ZyNievmlKRse3XpqpjNVhfYyKEj8EHhnIwYAXnk0YK+NCOyNb9VaBW+q1ZvYf+yuw==

On 3/5/25 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

