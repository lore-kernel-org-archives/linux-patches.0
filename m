Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C723B38B6
	for <patches@lists.linux.dev>; Tue,  5 May 2026 08:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777968700; cv=none; b=OKDt+PHnXmZqpYxh9d7GWSlbmpEMS3KFqWChqYwuVlgKaA8OJlYzKE/5y9FnDKktlEf/Ar2qv+ior6DvEIWCc/gTXcEajjj0doY7G69XwU5PoouQsfdoeVLg8wlIFWjmwbQpSigOh9kWUeKIHylkVM24GfJVoGzxGt9hvhC35CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777968700; c=relaxed/simple;
	bh=aq+KwEL/+y9/ouidVpMfoHFIVPDOyh6Ey9EQ9qaqy2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hvxbRXnBT9MT8QzaQTRyuvaMO2+xhSRRsToyxuCWQtzxCh7oxHrFVZ1kM17l6xxInudDV3tlmE3gdeTSowKMeUhjot2C6ZTPqgUoibf9xjRq6dqhlp+lko2d/F6wNtlwbWcuCteRcejFd5NWgpliXkQhPSFmvJubp03ipCckUx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=HPsLWW5U; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="HPsLWW5U"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id KAUbwLx77nwj2KAsUwFEfe; Tue, 05 May 2026 08:11:38 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id KAsUw9tysWrBXKAsUw3vgG; Tue, 05 May 2026 08:11:38 +0000
X-Authority-Analysis: v=2.4 cv=ALkt6GG8 c=1 sm=1 tr=0 ts=69f9a63a
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
	bh=EbzoIr7s6J64ueU8/emE+XKZjH7FdhNxarvlzm7tfz8=; b=HPsLWW5U3HVDaD4tL23CJNn2vM
	GafUqPe8/EhqSmqbk70Xr0qucjA+koCEvNBVHhQ/gyUO0bvKtT4Sl4BFsjPHSNV5loedFo3OQqdZh
	UkP2poNNT1DR7Enw/SYtuPVjcrBk+ATUr1Nf535ZFmfeBoA65TYjaD8c+RuInNgnJ+bx1RuHSEwBU
	+tWDJcCsNVS+w1QH6NteqspDv2wqWVOOaXLCOthe/RX/Ektgl9al3eBGlDBKZUEjrPukn+lwyTwFA
	oaj2YM76ZZ+4EoiBMo7zAcYEO3hXHrKqxV7gk4X8LE9bPzWGIOJESZ4aGK0ZuRJIjZUQ4z5bB7DEu
	i8bphyNg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:55218 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wKAsT-00000002P3w-2uCu;
	Tue, 05 May 2026 02:11:37 -0600
Message-ID: <9a6eb1b7-3f17-4c31-9162-48578b135614@w6rz.net>
Date: Tue, 5 May 2026 01:11:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135130.169210693@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
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
X-Exim-ID: 1wKAsT-00000002P3w-2uCu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:55218
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIReHpzCqdJ6V6s0DezcrEq0veWtRS4yejyOeauEsbTd6ZWbgPAQnduCva9MHQ/u7fvuWtj1LXah525ld2ZRbNXzEwcjXslCYO37caFbIueVBD18b2ZP
 aIAlElMkjW+HGw2a2ndmoFaWgp5PsqVxX1HNKSHPe4Ob3AbfJrVe2vpsJuaNqG5+chr/8jAnVWW6Dg==

On 5/4/26 06:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2026 13:50:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

