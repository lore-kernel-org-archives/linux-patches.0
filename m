Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571A31AE01B
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 23:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731715043; cv=none; b=O2gl8s++qDvRJEnxxqxytXbq6FT/Gcvooy1riCP0mk+CP24jHqVfg+CL1T/iosap/uo1aKXh55+H6ICzJ73lA5pVi43eO2I7G7mm/gFmyMGVH5kgXo7XPfBVBrFesM3n4vS8nQOp6qvLrrkTvK4XsiMR0AwC6WaCcfkaVqqx/+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731715043; c=relaxed/simple;
	bh=MPxIYm1wVylMR3xqKvdsdPbWPkn9o/GoDtJWt5N66Fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bvCoXGKyGQY5TDrLJxGZZ3MjD6/LiuJLWujoLXvNZs+n+UlbwkHJP8KiGeUA4jZg7MsyQZHxxetArvlIDQ4xrMM+/PZXOE3QFJg7jL2yYM87qMstFX7EoXvTVMtym2zhvj2x75OnxFl3RIlqGtTLgJxbna67vAIYqmC1ggYbBQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=UwVw0d3I; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="UwVw0d3I"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id Bvq7tUbqViA19C6BdtjcUm; Fri, 15 Nov 2024 23:57:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id C6BctVmc5vRBzC6BctqZJc; Fri, 15 Nov 2024 23:57:12 +0000
X-Authority-Analysis: v=2.4 cv=dubdCUg4 c=1 sm=1 tr=0 ts=6737dfd8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=hkF7UjICvhDUN6hEiEAA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dkapjoVJ0WU74GDhuFZZzH48sSH5zSYOqOWax4GKqZg=; b=UwVw0d3Ikx5OBlugjuDmdEvY5Z
	CRTw27V+IEB00qsC0zA2rAxzBemeHdILeRcvp+EGcC5Gop4zNCdkVUmmswbXFycMV8ZrjnQ1D0yRF
	aQXSGIleO5n/l5/PRyPMwTF69AKKYY9mJfo2pxK5bupbPPBd+6VRPCJsicpuNNR4X1IRIIQhWkGyM
	AzCUc/pygGIw3306KNVCEVpBEgWm4mwHbrKjX4s1/y33b+4ILJOhb3FlN80jm5JQ3fFm7HYUz4g7Q
	Z90rFv+Qo+ZkUJaBaV4R1IctHJjDMx0QE4wxrBs+lAxPnWxETXOLMGiMpJJTmkJCx6wXFcE+wiyZ/
	LqGD+78w==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:33900 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tC6Bb-002oS4-0L;
	Fri, 15 Nov 2024 16:57:11 -0700
Message-ID: <def7c75c-4a32-4cb2-b70f-64f12405b0d3@w6rz.net>
Date: Fri, 15 Nov 2024 15:57:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115063722.962047137@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
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
X-Exim-ID: 1tC6Bb-002oS4-0L
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:33900
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMFuSpZguh4sSBX10t1Qlli0jfIvrN5IIw+uGS+YMMxTDC7iBJLdAO5FF9FEmDWV6FLrwDQwYbaLWifkjGB1bR/bAjVJ9BVjErfiwX9rDc7PNYJ2mll3
 kmsQwoVpmH0onLmYsJ+SgyZ0yBCCgFEWbgmtZjDpD1EHECuWy+k4VmfVA3abm2Nf3OgPLPyW/sQ9eA==

On 11/14/24 22:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

