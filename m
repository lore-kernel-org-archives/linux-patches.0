Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0B828642C
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 09:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752054241; cv=none; b=Pxjc7xTWyfuazgsoCLOao1VT29oz38Ts+gox4/wNBTa1QHp5CaDFL2aMTMveTp9CHkfxICJVk63j+UIzK8G245RNkTZs49wB3jO0gU2Q6xiGhjK4BisXHPxl9yV3BhSE1m1MoWWGtrj3ivK4iAc/x82AX4zSSVLFTD1VFMCVvB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752054241; c=relaxed/simple;
	bh=eX2dNpSdAR4tigb9OpnXR/7Hbwg+2ej9WoBDoNN7g+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hoxp8IIJbx7q/g+xWaOQvIqtc0tHXVSMWgMF4Wd242A27hZFp2cakif8txwBYARfrxs2A3sWeEf9Tx9EMeUuZ2jiByEqXfpeJUrQ2GM0ZqLeceGy6S8WPwHzyE7kk/BjM/B7YuJHZ4pGDwckb8hSao7GGoy1i4EF2CLS4cYkG20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dyCBiPy2; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dyCBiPy2"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id Yx19uY34vMETlZRLEuhI3n; Wed, 09 Jul 2025 09:43:52 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZRLDu3fhBVUGgZRLDuigGo; Wed, 09 Jul 2025 09:43:52 +0000
X-Authority-Analysis: v=2.4 cv=KrNL23WN c=1 sm=1 tr=0 ts=686e39d8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/L8kNVwOhLL5sBonuSb7cFKewPiPvCuB3EtyAlUtIfc=; b=dyCBiPy2+AVFnplXvEOYTlRDgV
	m7SqOqEZ2tXbodrrFhHTwK3OsXZ8BPWoGRsJxPAz9PJ57pmJFv7sT8ApqdNJVK3nqnZTx21Zdcmfd
	EzDgOzIsTlxI5fEBqsZs5dRNc/kehHB04nN7nGR1sXiqBrTo6lbQ7SihKwB/miHHZmiFuB9VUsLfG
	i/vulOS2TRgViqiJZ+7+nqLxBqnGg2LYHf5UxU9rMJdVr29ZlBVfg2QAluIorLwbUb55r5VEJBg9S
	QeRmlk1ZjuyU9Yu9qPo4z40cWR38oL3nVpznWS3Bd3JCVk8uEOdvw6GQD/kZDhWPQxEod5rcSSo0j
	VkfgJKrg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39944 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uZRLA-00000003KWw-43gY;
	Wed, 09 Jul 2025 03:43:49 -0600
Message-ID: <83b0e196-a22f-4447-80fe-34b10f02b152@w6rz.net>
Date: Wed, 9 Jul 2025 02:43:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/232] 6.12.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708162241.426806072@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
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
X-Exim-ID: 1uZRLA-00000003KWw-43gY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:39944
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMJHDU6x23xDfUNEvWUUyoN8CS60F41MrCeEceynYZEQeGgFT+iq+1ZeFV9M4Ty8z9U8/ICd/sWiY95SxNs2T2t8M62/3S4uSvBW3QiF3jk8YqkWEjUL
 tpA1I6MTM4mA7DTrQ79JvnRTiKcqwnKaHkU5cXMIpMvntqNkzkYmnxLaVIU8XrJ4k9E3tppB8p6y4Q==

On 7/8/25 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.37 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

