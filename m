Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60383C552E
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 09:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035411; cv=none; b=XPz/UF5kQW/E2QXjzS0yVpxCznaGWiXvaGN4AeANkCWgQJXVEk5ijIDbltY8hMX3JJ92t62yEU5ZNjpqB152J1ddYnhs1kAkP6zg8hTXdKUPFI13qPeGo/J05YXjJBmnDS1mqF96T+OzEF6YbAPrxe1izxYsPOIYqSg+BJlnIdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035411; c=relaxed/simple;
	bh=UVqObbCcp2bVbTpTR9Z675RAJvhWSplzEugWcI8WhN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hn+EE4mnwDS/RmQhZ4V7FBdpYmfko/yNM0lNcO4kKEEAoItEJcxNBTB2xvroDIKNFBfkbJmt/0+Z8Sh4HClHXTRiemISePn6x8SpWVYWg3fHr1jv+ckqF8+hUoVR65Ks9LKIu1EiJnMATdeNGvWkDuthDewQ6u9wtA8A+FePErw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=jLBnyI2i; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="jLBnyI2i"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id 7q9Iwr82gObRf7rnHwg2d3; Wed, 01 Apr 2026 09:23:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7rnGwfXA9TFL77rnHw1UbV; Wed, 01 Apr 2026 09:23:23 +0000
X-Authority-Analysis: v=2.4 cv=euTfzppX c=1 sm=1 tr=0 ts=69cce40b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=bv7U9Q_nRvBbu2floT8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+H5K06M6xSCxVc44AGitxR3rM/8H4K4beymP4QejuXQ=; b=jLBnyI2i1y9SM1iYVFG+PGlaKL
	icHbem0kkS6IFAAKVsP1R55mwCeeRY7Vi1vqd58pS9DHjcrd0cBeWP/rwDY1VHB7zlDJ1DzPk3DbQ
	R6qEnjekjEzHGtW2A/L/LyXR0oy6l99+MiPoz+rSHR4J/8h9yZCkzA/YWPvZ3h9pKWdNOLULUlCrn
	HHECL8umVl+hK0kyEUzxFI1jZiNKHMNfSSoI18XS72KlnQnekeE6vi4fxGfzszOO43x9u+98yW/sk
	iY4EBJPZNYRgLmV3v/h4nDXsekYy67R45vhAKcxV1fmi4KFquEdYGXSJKgwBVxJ+klJWw2hNI53g3
	nsO4mPmg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:34566 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w7rnG-00000001eqx-1Kw3;
	Wed, 01 Apr 2026 03:23:22 -0600
Message-ID: <c62dc2fc-af80-4d8e-81e8-86e91912ef18@w6rz.net>
Date: Wed, 1 Apr 2026 02:23:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161753.468533260@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
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
X-Exim-ID: 1w7rnG-00000001eqx-1Kw3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:34566
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJJ797HvuH0y6xPdP3tLSPBTMS9GOu/upFDqidl3EUkbP6FOcXGyeM4hsuXDqwwYQqTQVh0c9D9VxJJU0PuzjWV1Y2dVnPJbL+o53EYxoLrpz54HArzp
 dnC672BnLraQt5zRXIQ4UvDDVE0WaV82Vrx4h7fe9OehH0OTwBt8OrqLyp4+aLXyp67aHrtkLWlxMA==

On 3/31/26 09:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

