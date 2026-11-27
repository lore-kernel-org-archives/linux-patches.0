Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795772656;
	b=Irc5jLAQLnkTfJw+REQuRGzeqW/1qVXQi6pPdwUAQ9VJHHknJwLdSEQ/t5PSKKS/LVmv
	 t+JGSNleLLnpBGVygYlLvU3PF3RIlIavxIKn57kADHNR13JHU63LurVfBlI9KMSSftr9p
	 sUa/a9c5HEwu4y4LbE2lYjf3n7xkn3f6hRMTsB9gWHttYEmFZVyAZy9ANfompV2OLstoy
	 /dw9YuyjqNhJqzuDYmNgQog8zIvnE6pvgYuuc2B87P0wfKRbQqr4s2pJpdBC0O+poZpJc
	 O930+7VE4jHeelBWDnieoeSFgo9NAo5j9aHhRJNSUo3mkoiSbd7fuXz0bobrrEB+ZqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795772656;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=+9+B4NgeHP976IS9q9jOuz9OR60GxoPPYSVbjQZz/cQ=;
	b=k7kbpTTqsYGFmt6HQ4YS+3zJ22WsSkNZ27bP3S67RqYbiy3huzv1WOOr+yQ1QOa2WLPp
	 hk/xCwzriuWuFCBjQjfmaFI9qqGio2PUixLHBvTZywE01qGQY3657pRNxHPhgWQBV1263
	 o1FbyMfEhbv0RrN8ysf6IxGM9EO8NRGms/27OwRLfu24vgKnCOL/GhK2/z29B2G1n3Gnu
	 l5iiUqhWkBsr/vHHTZzzsC8XIzYeO6kROty+PspfCcqwzFDha8eC6a3DZDtct1Qh7Q2FH
	 1em2XBAxRgeYhdWfBIAiHze2OsLNYJhoCjMqkXynPvr4eVqlnVcluhRU9+AEzj87n0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=pCqHfHXL;
	arc=none smtp.remote-ip=44.202.169.39
Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3597606A32F
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 09:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3597606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=pCqHfHXL
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id Wo4ixcQ0NOOJnWsV5xfXem; Fri, 27 Nov 2026 09:44:15 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id WsV3x2dj4YskhWsV3xUhbb; Fri, 27 Nov 2026 09:44:14 +0000
X-Authority-Analysis: v=2.4 cv=CKMqXQrD c=1 sm=1 tr=0 ts=6b0950ee
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
	bh=+9+B4NgeHP976IS9q9jOuz9OR60GxoPPYSVbjQZz/cQ=; b=pCqHfHXL+VIHsrUZJZjyoKv2pc
	YjHD+Ncm7dq7sfckIHh3NkM0MERTEdtFsiPuv7tnIuruMpPyF7Sb7dTbEcU5aS4Ipm3JD5+VTQvTS
	Usy19NByHxOgWy3c/CrTEY/bwV9DgyG/23SqdY1XNxC+3iMi9DqNtGKWxgmy1zK/21JcZ2EgAcGqh
	aIoKwTLexgIekze506P82wUQwq/pOCdryvQsAWLJVYINpeoCpbTWegCAIGZw1uU53Lf+p7020MuKM
	VPJK/AZfwOoMoxyPP6dO45Q6BGkMGooMgsCAQsC4tUcItXU1Qorz2eCdPQmIgLzMY8w++LiFqjvq6
	SKZ4kdLg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:57234 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xWsV2-00000000Gc5-2VJR;
	Fri, 27 Nov 2026 02:44:12 -0700
Message-ID: <5841dfdc-36a7-416b-9839-56f83db286d4@w6rz.net>
Date: Fri, 27 Nov 2026 01:44:10 -0800
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
Subject: Re: [PATCH 6.12 000/815] 6.12.120-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261126105709.009001842@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261126105709.009001842@linuxfoundation.org>
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
X-Exim-ID: 1xWsV2-00000000Gc5-2VJR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:57234
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGaXiB3xfB1+LInDcxtGlzGfrcaMlLN1noyfQFpYcX+vwdmYABVAL66Vz0pSG4+5BKfRqJ74+CBhlx3iyv41BZxeLsqhS3lzcLeSctFeWybXdlU0WRIf
 YXx94vJaK3My8sd7nOl3PTaxDXw4lS89KVOJTCZnRMS2rpeAQn+caI/AkHRtqhW7MEoKnDHMlFJYqw==

On 11/26/26 02:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.120 release.
> There are 815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

