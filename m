Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DA718FDBE
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 05:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773379196; cv=none; b=LEFQmYwVAyWTSKeOKrElxdyN+xfVKKmf/naITAjIOaFiH8DQp9QycZLAt95Nx0FRZ6qEWHrPkkU7fRFlsXIEZKBBv8/S2a8DugioMkQBvjSB4HlKPdXLZnrquLLcYIZgVEiu208VHPwuKhoG7FgWU2rAsKBZli3J7cJRP6g/aI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773379196; c=relaxed/simple;
	bh=Kk0SsqYMwx9we7vQ7aHZu9mWXqZFwqX6c3wSFfNm0OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SDrpcAfN65z/5NdV1hUXJcEqcULsYmdUe5fttXNNpPPL2yZqRqj2oBFqotf344Aq7OayaHe2YVvpnN/xuW2rbtS93FW6IGXoq/zmdOLMbHrugAoBNX8O9JBepEOyEIUW41MoMtwAKQMHGlwJ10LE0QfAnPSkViMuQmXMs8gZenI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=br07meef; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="br07meef"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id 0mCUwyRGkaPqL0uw8w8rVz; Fri, 13 Mar 2026 05:19:48 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0uw6wmWUFjAxu0uw7wrEnm; Fri, 13 Mar 2026 05:19:47 +0000
X-Authority-Analysis: v=2.4 cv=EoDSrTcA c=1 sm=1 tr=0 ts=69b39e74
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jYkfGw5DFORCzhv5XTrXBO9kx2z2QBmz0Kvo8fTo4kQ=; b=br07meefO+BUPeTbhR2k5WvvmD
	QsAlZXpheKBMUkw0VznifQ9uosjzrvGCPltNAIVjj8YhAueV29otz8b24y/HU8f5hfF1ZW3lJdVr2
	0vIUUPl81GWAW2L8lsDfxucpglWjR5TtImhp99MHdGJgwIoiXdg0ah6Dynda6BE7sDmcf6LuNuhhc
	3PQOeQL6g7IKzUrq8r1RM1cgy7jdCxSY/G1vsjP27grVfPLGPYwD/XR7ulBZWgJvhO1bfz78dzRFk
	Sq2jvpq0H2xXZO5PT2f7Qf6+MKqrMtLhokHKJBaVCWPHFqtZwfPSwB9npMbL2yCit35wbkMZ1ZOLv
	eBGQXECw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:41924 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w0uw6-00000003D9U-1SNq;
	Thu, 12 Mar 2026 23:19:46 -0600
Message-ID: <f852d4d1-d919-4b00-a40f-5019ab00bd4d@w6rz.net>
Date: Thu, 12 Mar 2026 22:19:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260312200321.671986598@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
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
X-Exim-ID: 1w0uw6-00000003D9U-1SNq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:41924
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKOjxsepBQhViS2MYQQ3Gsosg8ox66LZvrFJOWM/SCV/JHrmq9XCswo4JHNhZAjfVdVb9TL206m+YmGpFyWS8kg1zwGxG7R9UHXakggD1j72jkOO7dEw
 SKrskbNlJ9/i2ziUuDkAHbaMceOEtwGa3nRrtiyATr6rClLgYvzYXvFw8tQVRMTIIh+64flWMC/8vQ==

On 3/12/26 13:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.8 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Mar 2026 20:03:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

