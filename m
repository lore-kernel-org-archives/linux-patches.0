Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.89.44.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794752675;
	b=rxt7sAdj9unHSccL8Gq4vIDP5cmcgKZN2LeB3H4rnxOnIYbsWW9K0L/i03PcIcI6guIi
	 nSrnDx0N8HD5OGAck5DUoWy3HQE2hozl4S9rxJkLOxHHzRlYmy6Qsz3fbXfA3AHw39iQ5
	 Op1rQeQ+DzKjjb2893SKdgV6fq9qIaXsBNpwjjGakMujCCdOw3/fpxuwS+vr9oILiZKpU
	 hpABBem50n1DZnwoKwrMDsZEqut2ByCPncrSXVyW99jC26aEXHED+zRcyKh+x0bkazC8d
	 QkSA1+t07WoOGUHFJDVXpes18qF2m4HgEy1GKdmePYsPVA+myvfLw+Ycj0z3NNKorjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794752675;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=BrhTUW8fO+vcw4Vv2AeL7c2TqR5hb5priFcmIXtft+s=;
	b=K3tG9WVQNa7Zaf68V9SG6ddKZ2X6I0pWKYIs9twIUONc0UNcw785NglYmYj2/4JV+/HQ
	 HFa7SD8w50kCvQHJpAUBUwsiq2eOpJGSmQN6ZgLevv6uSTg/sbIR/hTgYoHh5wCYGSP4j
	 cJFzJfbHB0b9R4GlDyZRE4IN01bALfB5Th3Wzeld/JlXuCHhJjvGFZw+RqkW0BuG4lnaH
	 7wuzfE4tF1hjgsHL9Sfgm9WUfA9v/t7N/Y+/M6WxVZn7AfbD8sHLILq2f9aCeWIMkofsS
	 +swSR4ekNlv0+YO0nNc0rPbDpFBEkOKeE8/6K54MNDuvQknMZgxJDA7e/pgAek3oESg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b="TnBj0/n3";
	arc=none smtp.remote-ip=35.89.44.37
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3754606A8A7
	for <patches@lists.linux.dev>; Sun, 15 Nov 2026 14:24:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3754606A8A7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=TnBj0/n3
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id SUwJxMXb7VK9USb9mxqSVJ; Sun, 15 Nov 2026 14:24:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Sb9lx6UPOFhzrSb9mxr8Re; Sun, 15 Nov 2026 14:24:34 +0000
X-Authority-Analysis: v=2.4 cv=JY+8rVKV c=1 sm=1 tr=0 ts=6af9c0a2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=1ZHqKQNBhTtskWZSVtoA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BrhTUW8fO+vcw4Vv2AeL7c2TqR5hb5priFcmIXtft+s=; b=TnBj0/n3PFhFHXX/5t3jqzs3dE
	oaDXxr/SgZ3AtgEjxkPBG7QNlPUOC3cf6+bfpSW7Uq0X6OhprYk/1kuTdtRb26Hkr+/pDcgj6Fxq/
	QbwrbSlEW6it7ilfEC4xNNFVRl1wIxrdeeqsRqYv071mDtifUF/hp8wsb1tn7PIEuzezxJVyKgKMV
	14pTg6VUNA8UD/pK9DDdq/1A989nFIwfRwlIQJfuDDy/Hl2hPIK0wGxRoulCVNIG+fILO4GKrRgnV
	C2/pEM1w1wm7c8H27f735POYAEWKcdXgnv9xs65xCHHsmNUzWeAgypH8YT7jw7l1bX1MT3jKqDM1/
	Fj87iXkg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37292 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xSb9l-00000003Sp9-0GqD;
	Sun, 15 Nov 2026 07:24:33 -0700
Message-ID: <f5817ba1-8048-46ec-837e-b502ed10cf2f@w6rz.net>
Date: Sun, 15 Nov 2026 06:24:31 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261113153811.177190860@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
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
X-Exim-ID: 1xSb9l-00000003Sp9-0GqD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37292
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAlz5w8pm2p3Xc1xlf+gKIZj5n9f0C+fVymAQmndPNlE8AM2wxiv3K+dM0k3MNTPZULdTwTNUT+UeZMmP8r7jiGiGMVxJrS+1YMpRQv79nJelcuqHX7W
 uIHYSEwJLK6vo3ZdsjRSbAQXH/b4y95kipC/y8Rg3xHXgZkTBkcks9p58zVbi8JJbQvtXjYgDbweIw==

On 11/13/26 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.118 release.
> There are 670 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

