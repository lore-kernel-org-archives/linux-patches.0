Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435E43E92B3
	for <patches@lists.linux.dev>; Tue,  5 May 2026 07:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777968000; cv=none; b=ZcevHQZgnP1JXTm40PW/oToyoE8mEGkm30oISIP3NhR8ls4/aCnVpCqemAP483mLLi0mgRJaiCh3pQpgf53CehVJTp/Lgqad6uOEO+u68GbfpFSZGnTmwyLwtgPrNXwQQ4zI55Wb56tvLu5QXCMO+cQnqXeS5TYIypFtR8pd6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777968000; c=relaxed/simple;
	bh=Ko+Tudot+u+TGt906YzlNZFIa69RYgI0llqG4BoDYp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPnouye+VqJ/aFQjBb3gqiqmW2yYqr64ZqWgAjKTjsoacZadLuP6TEN7UHFR3hLW0g8s69nnaVgYyyRhn3r9/virSVeph1Sb5l4ByU/TYFeWGM6OxmyZZJOYvuN32Q8rojbQQ84JiXQ49AhbjAJ8hQnyzxliNZfrTvNhSRsSzS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=jK37OGvh; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="jK37OGvh"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id K0OZwFjh0rDqVKAhBwv024; Tue, 05 May 2026 07:59:57 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id KAhAwCbeo2utbKAhBwoDBm; Tue, 05 May 2026 07:59:57 +0000
X-Authority-Analysis: v=2.4 cv=K+IiHzWI c=1 sm=1 tr=0 ts=69f9a37d
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
	bh=RYUwYdCyT875PMlSm3aEDxE870qgCLG+bj1PVaqAJGc=; b=jK37OGvhzKjo6lEbNmhnX8hvHx
	1ssYSs1GBhBPTmQbXnrjmHTMb0ytUoFdcUN4hS7gOwsWY9bjLAJlX3nqs9Ltx5cc4Bl5MlzcTnSo2
	AzqnXQfkxJBacX+ANJUS6Y95FLHp3/OnojiaXb1vLM9cSrkkpYua5C8uE1cs8HPzKmFJ7WyPLkyB0
	LShMXZ/Ed33tEuE0p+jjuWzlkoD1Eeo/IzDAJ725hmXeYgQSre6OCMIqxSSZDjk41nez53xUdSLPw
	mvYuUiPGYO6sYoTIfHvdj9OQ3EyjeMZAnZ6dr83/mCY2PHtockGQ3zZcT9B6r6Weydc1qG7CurO3E
	6l1vVZAQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51796 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wKAhA-00000002FW4-13eE;
	Tue, 05 May 2026 01:59:56 -0600
Message-ID: <ad154e2d-8671-4c91-93fd-d8f42c9a4c99@w6rz.net>
Date: Tue, 5 May 2026 00:59:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135142.814938198@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
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
X-Exim-ID: 1wKAhA-00000002FW4-13eE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51796
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDKbFcnDMAVniZ+Cm3Wq8yfNZVBDf6jiTaBDe7OknSS0IKNPNB9+VvqNrnG0OmCp4MZZJohE/+fixmRPq2qxg1Cqx2WOm3xTbsE/PeWgnQrTPBdTRcLN
 hiiaJQQMghqKsMD8lqEbw8udJZudVFmcuiiYU4VFJ9emTm0EMmGfL2rzC2tZmtMAWhq3TeSgzlgr4A==

On 5/4/26 06:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

