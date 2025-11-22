Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726BF23D7EA
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 11:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763809751; cv=none; b=Emulc2uvdDP4a18xETcLuhc+QhnF6dO0t5MZEewi/QBd8UpvzDBPG0R05CuEHdtfVzAo3tk3q18ZKhgfovhnaxONJDjZVkCsD8FPNX9LbwkdHxsD20zrMfPOUEszUHYZS1FriHgsElW2IibhWBsLcpYlnzcEI3AIdb50z4ubd9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763809751; c=relaxed/simple;
	bh=3sGDLSi5edWvR5+D2/T1My2P6dStRymMsjhuCbOH7es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hxbZy/uWs8MvmkSkMevGsB+/nqx3tvqE1FRnLnRi387vOEHYpr7KJJ1lSCz4+Wwj6rahUbPo6wNk+djnzqNI7NPL5bl1v7gKSBhW6hqb8kwwoKiItcGeDpxYHx9JJDWxaCvQbqSKQlWMqnx7kTh5antwg6JAwLL4eRFUffKvr9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ZjM5f/ZF; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ZjM5f/ZF"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id Mi8evCaugaPqLMlUKv4zFg; Sat, 22 Nov 2025 11:09:09 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MlUKvjYwDV6WMMlUKvV4UQ; Sat, 22 Nov 2025 11:09:08 +0000
X-Authority-Analysis: v=2.4 cv=E//Npbdl c=1 sm=1 tr=0 ts=692199d4
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=RtE_W7dyFrC_6H2CQ6oA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cE1toj5EHJikeq5aG6Yqi8hdOLnhz9ClhzJaOibsFak=; b=ZjM5f/ZFTMsnqcq865oq8psG9h
	XjpmNvwWToSXNKVXIwU8Mu4AfWoIlHevxOY3Iqd+4DdxfdTb+nvi2r3dAvDiBQfVXZCm6k0TAg9sh
	FhTQW7qIwYuaRoIMLhxaNPjtJJhaOlk4lReDpipG9Bwj98okrkctBgpLxyfhSprugm3yc91Ccl2Ss
	MlXoi9Q3uoiS47JByjxQsEnCbh6nmWMMMjEVuyPM8LGuxKDPIHnkLXhIWiI8dSksvDOQn0tar3ABe
	JLKpj39uZXWf7sFzN830/WFg6Z0GL2/bZkYIsXLHm8tEFiGIyegB5enrtmDKbfhzjQtdeg8Cphh2X
	Pr2ix5Bw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:46632 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vMlUJ-00000001HCV-2wpk;
	Sat, 22 Nov 2025 04:09:07 -0700
Message-ID: <21167ff8-d90d-4c21-bef5-79638f4b5de4@w6rz.net>
Date: Sat, 22 Nov 2025 03:09:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251121130143.857798067@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vMlUJ-00000001HCV-2wpk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:46632
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCUj9z3UtRi5ZKoKqr7Q2Aa5xKQDA11qUPuB16AI39c/d6/eUN5akHNwk6FA/8X29Gs1nlOiSQ7OgA16kLFRaYVg2tYh2wsgQjfYFRtZKYz1tJ3Wx4SZ
 73yynvsc2RirpM2vRHeGehouRsMpsnfdaIrLd5hT3ZIfVCmAt6kCx6c1TbAp1ZEqG+sROkkk8bnzCg==

On 11/21/25 05:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

