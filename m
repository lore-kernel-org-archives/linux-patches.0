Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774583033D2
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 06:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483493; cv=none; b=HO6Q28xxEZEBk/QMx7zikeciXye3M+HTnZAYTlLpNz0OLcEdH1M2q9jO9VluSFdMKLW/AfZAxKwqSUDYTQBuqJv4PrHtm8D7md8DipWn/K9tR0OXvR2iyDl8kKv8iyEg8z77BTWGTWTq3WJZ7ryWHe4WSyoCq+9YTK+c+mLjtQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483493; c=relaxed/simple;
	bh=rBl8K+ekStZdKDWhZjboEE9ZTxIXLFEuiqxo9S0mB/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KprkJwLr/SzHCHhGikahCy2+Qj4c/325hDeH5aSFMsV2JU4XjqZVBWQ5RwFvypPKldWeKeGwEFBHbeIdRfQyYReRT+CSTCNI/yUhoD6b0ayU/yNLD/2rcOAjhn7zc+EDWON5POtEB4Pv1sBvYwjg1lmp2/HA8/LVOFvRXcNFccs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=a9ikz/tR; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="a9ikz/tR"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id svCtvrTz6ipkCsxmOvuXrS; Thu, 19 Feb 2026 06:44:52 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id sxmNv3PfMHSQMsxmNv03vi; Thu, 19 Feb 2026 06:44:51 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=6996b164
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=x6Ducos6UYMGwXt6jLcA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vXEmJhYLIb160IgNGB3veP9r4naxQgnRScjCQNm2pi4=; b=a9ikz/tRtU0d7/LW236r28mn2c
	4KDvndArSungpa/7WinWKImCGtLROPmRmgQO2wlpI/5B/FTNmmQWAh7IH41UNZFE6lbvgN5UeBrSx
	ggWuLZ8VZ/x8JJBAVjvFe5FO/ZFc/ZaN3B9Wy6ooZrGIrk5H/8ZU3uOvTACCs45AUEBO9YsWoHwri
	EIiOQ7lZgrwAH2ixN3magMJ0WH3/lth5bFmpqlsAJwTeDJiuUgOwLPuCqguvW+SW2hhw4EQvC6sHK
	og/1XiFm32+/b1G4YUIA1CKEcHbOR2d76nKdqbq4tfTkGCjRKvvN1iivs9Eyc2we6HWwUyegw7+Tw
	EnXY9fJw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:34878 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vsxmN-00000002Ef1-0olR;
	Wed, 18 Feb 2026 23:44:51 -0700
Message-ID: <38125eae-5bb8-4829-8daa-6f39d63cd3ee@w6rz.net>
Date: Wed, 18 Feb 2026 22:44:49 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200007.505931165@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
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
X-Exim-ID: 1vsxmN-00000002Ef1-0olR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:34878
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKzgELozUYIPnNourK/DDZ/lcAahjvPLJCZOEYL3CrOioPSC/2j3CDKGHCfDrUW4IxnPma90y5f/b2/UvaSp65y7A2ycvAc+IQJCPrIU7KqjGO6wiRPv
 ZMpJcEnHNmGF8WK3kQk8CobU9yPfdmP5rNtFKockVLlxJObIymd6UmL4UNF01/zbbLHGtlZGqCXuRw==

On 2/17/26 12:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

