Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5503064B2
	for <patches@lists.linux.dev>; Sat, 25 Apr 2026 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777147197; cv=none; b=HuO8/OqT5IBxQBYjRql6oYCp8U4H0TT5cXoUj66lwvXcnLQLIUwGlLtnr0I3lXPh+R/xY7CQQ92KZsVqDe3to7jnCXC6+EhNCd36lu4N1n8/7R9MLGN+o9XPQJxNa9TOLd8mp5pSW1NCJYesV7TZSuJ9CHMN9ZnjsZaXWGv8vZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777147197; c=relaxed/simple;
	bh=iGsavtdKRgIZfNmOUakOHyuvmn/RVqrUGOd0iX/MdLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UUENvKMzNwlybWQP1mZKGD8FAyGaDeGEf50FHPAhrEFqBqR0fgczHLcGUIdji0AbMoiOGv4rJycnvvY3cvcHrHCLL26fhGrOfpV0qRuZOVtHqpwArAVZ+VgLvUtykf82aoO1i5EYeqB/iumpt3tzQ9jtiMG6IEW6SwTkoGqaQ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=BbMsFtcz; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="BbMsFtcz"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id GhgwwhlZo4RkpGjAMwxs2r; Sat, 25 Apr 2026 19:59:50 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id GjALwWoporaqeGjALwxd8i; Sat, 25 Apr 2026 19:59:49 +0000
X-Authority-Analysis: v=2.4 cv=UNPdHDfy c=1 sm=1 tr=0 ts=69ed1d35
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IazGElZjTO9uzks2aeUuxkJjL8vaXXLIHyLxf4k4mLI=; b=BbMsFtczpwI4+P9bmhNnxBqeX0
	yEWMboT28+r6r6QyiD5RePJgDavLNUe9+E/PttgAkr/+DFdfURfB2FCpe1wpQzM2b3R4/z+TIWKT3
	q+F31ph6Jc5qfm3Bb2Bp5M45zomOEiCzP8LvDZH4WXK7xVH2r4ahkVqqgoREVmqsibt8n6T/uO7zN
	5kVK9vjDmPlGU0yHtXGbchnBVMBcr2Vccfd/0OIkD1QyAtNW/LiSYrSN6IByfKwOxdMf42ZBYoaYm
	1xDhIlPYmVcrv9B2BPdimMLt8mKMu6U2obprWy8V+ijIAhtR45N3w1GcpKBTJuAFEE3DdN4NTlgpn
	NAH9XmvA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:40242 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wGjAK-00000002MoS-3eXB;
	Sat, 25 Apr 2026 13:59:48 -0600
Message-ID: <ff776985-86d7-488f-85d9-9059aa2ad0aa@w6rz.net>
Date: Sat, 25 Apr 2026 12:59:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260424132430.006424517@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
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
X-Exim-ID: 1wGjAK-00000002MoS-3eXB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:40242
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOlR6y1h9xcgK/w6NG6iESDhljOzy7SbpwmKG2TDDZXlzYhygjmBY3sxV9TXzIniZLwcIr6OZRA22MOtA3pPK1n5sxyq3CpaZLeAxAtMz0P5GNPBFLYw
 44Uis25uqfAJ3OmlmTl5UlRCmczA3lPnozpEjDp9KuEmu7l6KitZSJR7/jlQcXSlSxZNFZLmlTspgw==

On 4/24/26 06:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

