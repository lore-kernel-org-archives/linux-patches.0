Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795772061;
	b=o9EvWaizZuR91cpwImqcIxjMer+ksp+m8C90O2MyZqWZmf+DaUUNbwSELPXi8lYz7SeD
	 8P806EuBoZhsWHhvCg9KWrm2LCOp8UyiJCPJzCnzUx11tS7sVJkOit0vvU7j6CBs8gm9i
	 /h/SeJcU75RxPhG0hBCqkkfqBnfHd25um/YN6Xy6I1X4Eks9FmBwjKwHZ67yWSkaqJorM
	 4QASw0lMZFH4IkEz20/sF8qOXhC42Zo9BEXNy38UEw5cvhtIUlIzckrccFk2G2TvSxNuU
	 2MO3yx5nDRQ+GlJ+3QwxWeQPevW2SwLw9XTs9NZppOrAbqbJIrBR+vMMP2Ujqn3ydzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795772061;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=ZCkXVoC3SMGDxaQVGjQt1ZsXPslPf2vI/gx469RFFa8=;
	b=jYjJaoh1ztWLg15dlWybhaxhce6r3Jb7aIji6AKjDuoh+8hg25imN5y8QYjTsLHp2YjM
	 +vywyueK+4EAuNAcpGPDDxrUVXZnAdEgVt7YBV6JkU60Jc6AqTw5YYIuwHs+ok6Z/qzO5
	 P9g5L2bLIaimPvI3E2yKjv+/8pQBfuHt9ZqwMA0SjTpC0invqpaB6qkr2VUR00JLrJhT8
	 NvxVemDxQAwWEke3TncIThkCVJPLUOsLOGCW60pLVXT63uJAM8H9bInH3NTvh0BOFLfNE
	 CxFTp57IiKa2LBoEL0FzHsrAjuAUn6p0lp3D61DQfKbtoTS0kX7SdLqsOo2e1NQEBFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=oMsIuB7H;
	arc=none smtp.remote-ip=44.202.169.37
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D90A606A321
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 09:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D90A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=oMsIuB7H
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id WjdVxBn9GV16IWsLOxPPGe; Fri, 27 Nov 2026 09:34:14 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id WsLNxjBc3SeuLWsLOxt3dG; Fri, 27 Nov 2026 09:34:14 +0000
X-Authority-Analysis: v=2.4 cv=NYvm13D4 c=1 sm=1 tr=0 ts=6b094e96
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=vOf806ianDT3JLFn31AA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZCkXVoC3SMGDxaQVGjQt1ZsXPslPf2vI/gx469RFFa8=; b=oMsIuB7H8gMlqOssW3wHuzDY/C
	CfAuJoUzgmm3kX6zmrueGcrsXyoV7kP+FZpmsAIsI7u0MEnrjgbBZ+SW4QZDY28aLU6haHYbz2CEQ
	a41h6hiUu0iMPBY61q2dy3tJCWsIkQS/VrRDflp88y9D7jr0eZt6ybdQROsJVt56dPsUeWNKxc7wV
	xZf/O/6liYNPksEpt7Bhtt4uC8+kxSPmsvCm22WAiZA0dqeLC44fT5Ia1EP7nQPZL8zjjkeoPzTvL
	4QjuvsusxqCgWs1FV4Kn4ALVo91JX5FyXpkNDmvDhdZfxFeq/YStSfzEFPSZq1Xnbk80qLEMcY9Tw
	FXa618oA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:53926 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xWsLN-000000009X7-03JE;
	Fri, 27 Nov 2026 02:34:13 -0700
Message-ID: <7f9018c9-2422-4a2e-b437-44cd587a153f@w6rz.net>
Date: Fri, 27 Nov 2026 01:34:11 -0800
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
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261126105729.110697432@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
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
X-Exim-ID: 1xWsLN-000000009X7-03JE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:53926
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBBEN9GmehxcYu6A001S2A0smsTy1n9i+Hia9EdBdMR+7gQ29XmIdyCbnFzePkXMR3jFnuZtOGbxj3EfxsMIjwDSQKV+vC+JeuitHvKw2yBapexHLom9
 FJSB1P5K+NjP3TXpYAfMCjE56uceDazCgdSPWGhNINvy2kWXl1ltrdBJ6JjsZmjuBC1mlTVqhsQizQ==

On 11/26/26 02:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

