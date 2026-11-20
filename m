Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795144996;
	b=NU2CpJW9swIzjGeg3yH03OZmWfp64qiTLaxUhv/pv6dpFbGLXiumHqpoAc5SR4OtEU7N
	 x4qmZxfLSOxHrLQX6htMenuwPTo3lwFw+tIzHdafagPCewbBkJYzPTeMnMiMqwUQIW7g/
	 uuf2X/ipfNSpPZkICdVBznRtce8BgdLLioE73lyMi/Q7OqPhShadfy7hNUSVozMVNq+ds
	 yZIXb8aDmq5ZZoB3w+gewRBsT0ZIHvyV22XeZ5NNO0f81++Upx9ocAmpLZg2x7dygkm1c
	 Rrv2K9OeWw5+NtSqaBch4jEW2Xxg4bRh4xSSzunfp5bOdbRUvrbceAdhS/THOxV15aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795144996;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=QwSbqqhIeCd3lwJK3H6J77KqNCgiR19fVC1pv4z8yCg=;
	b=zDVOfw1aJPNYrVS4YGFNnyoU8JS3mOJtUvp7KECtxFBFC/ePfLbjIfAdUjBp+ssuTQvs
	 xL79JLo+56pYp5KNCBUsKlLmzqNQmz3wXXg1uqORM+ISSvSr9xTQmJaZtXutuIKwQmF2z
	 zHDE2iWzx4QChZ7OlKCB6es4JaYNbe/pxUxVpsgpGTF46zqnOvtgBVtnsUNYs7VySTrbL
	 1NGHf8RgaRLTJeGHEyhzScEqaFqEN6B7nq1aUrKWD2pBv+f9rzZVUpATjUjxIPC5Rg9VE
	 kymvczVOZ3TRY5onaWvbGtlrBJa4Wn/fr6bNm9fFi1cyhYkHR5OERFtrr7UpWcDfd8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=smRbKp0k;
	arc=none smtp.remote-ip=44.202.169.37
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F82606A326
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 03:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4F82606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=smRbKp0k
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id U9IXxfEeVV16IUFDXxRw4D; Fri, 20 Nov 2026 03:23:15 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id UFDWxvPnxuJrPUFDWxKQYx; Fri, 20 Nov 2026 03:23:14 +0000
X-Authority-Analysis: v=2.4 cv=WLZ/XmsR c=1 sm=1 tr=0 ts=6affbd22
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=j10-6H-SaoHoQRfmf2MA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QwSbqqhIeCd3lwJK3H6J77KqNCgiR19fVC1pv4z8yCg=; b=smRbKp0keZVyrUIkaO8OdNHX1v
	XgWJGX+DNL/p+oMeAx/RJTNgqTZxQFdjupg541c8Vmp+4rPu1Q3fpZ3vwDVq6RwfQk+fvNHxdgsp2
	+T1Z2lTzVu6Vaem6BNWD+LYB6yEGg+QO6Bm3i5v40nKPvZ2uqCMKcBsnJjyIKBD3kcDzcrK8nM+bD
	zfUpQpUHOvCWN6pkvzQkh8h/L2k7pSQNsqXImU9jQtGFTSWTHSNnFz8+PX2sHPFS0udl3BODyk/Uh
	d/BQfHllzkr+IPVjbuhipJvsw0m5HXPWRO65sGZiQgN9xA9zMiPn0hjVoJFS/aSfjvQOc7RVeXIdC
	+BC/qGKg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:55626 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xUFDV-0000000185z-2FvK;
	Thu, 19 Nov 2026 20:23:13 -0700
Message-ID: <508f60eb-3665-4aad-bb85-8180d4330898@w6rz.net>
Date: Thu, 19 Nov 2026 19:23:11 -0800
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
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150121.603863898@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
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
X-Exim-ID: 1xUFDV-0000000185z-2FvK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:55626
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAQkvKSnZhjyriNGhL5faV/VYnmuotThbHL4gTUIHv07XLrQ/7+4YedQKW7bFqUxFI06p6+Q6je5VUftdMs3Kb2rBee2pCBQlqbVKmseSZJ67dmvSs7V
 ZmWbWZN1+W6owlnYFtaDRmq8zAFup/bkdDhqYgEmfmMYeNYktU0nSMxj3zsaII3/pd5eIHT6YSD83g==

On 11/18/26 06:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

