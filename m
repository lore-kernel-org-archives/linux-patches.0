Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01019476
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 06:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707979181; cv=none; b=syM40lBBppVo0Tk/z125GhHe26VQ/YZC2MV3H/kn0IOVyVhrsD2UsNp6wHeWdh4Uh9UwDr1WRYYSPzH97+VgOMUjdZa21rnXpDxJMw/Jz4UxR9CMRKoFyU2kCph+Zwi14C77RIqYZqLGtCKPqGD/opNhVm2eW2G9vI3P8hId7SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707979181; c=relaxed/simple;
	bh=1gkUi6COoC9DQ7DB1drOA/2WM2Ok78X0ZX/VjQPBJCQ=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=dQah+nPOlbF/QerEVdeZF9DkejxuukU2VZUsuCzTORNaVDmpy+cVAaWRyEGAcgvkTGJebcPrC63OnKJlw8GVsUf9n1nDW7BXnS5hb4wHMBmj+gbFceKvgsyN3TBqGh4QoH3i/+3t++mWe8NQNVYQoV0nmQLnuvxBuZzmSGCwgYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=1W1McJwk; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="1W1McJwk"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id aJuorbu628uLRaVPAr3g6I; Thu, 15 Feb 2024 06:39:32 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id aVP9r0KSMVrhCaVP9rA67W; Thu, 15 Feb 2024 06:39:31 +0000
X-Authority-Analysis: v=2.4 cv=b8kR4cGx c=1 sm=1 tr=0 ts=65cdb1a3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6ytFLZOhYlRQG2VRWKEbQOPhZo25opp6CrAy/AURA3Q=; b=1W1McJwkJcolKW0QGTYrdJ3xqj
	KIPhA5dGh1/hDOC4O/3rmf6jdmYYGJa9k/kjTAHh4I79tAZitnT4ygPAN48dFu8K2BfUCn1SUDf9R
	orL5lnm4Cz4pww3U/8+1bPNjpZUfoXXIfpQgUFtXLna3kEUJF9lgoglQ+wvstI0o/fmkF28pX8cCf
	0UAH+X67GeX/XniEcJkOIutsDw/uKsqR2BgDa6/bDr9BJHQFaojROZ7ZtMJs1qZ2KP3Cus+m/IQY5
	AhH6XH/UcH1fCV1uG76UiqEb+k6FwcS2tJPs5CK1cKWrtPl0c1ViWmq8ggR3fRhoRB9MK1uYBR35S
	w5Gbt25Q==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:46142 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1raVP6-003NI9-38;
	Wed, 14 Feb 2024 23:39:29 -0700
Subject: Re: [PATCH 6.6 000/124] 6.6.17-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240214142247.920076071@linuxfoundation.org>
In-Reply-To: <20240214142247.920076071@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <707e2e4c-a8d7-23de-6606-5c53276550e4@w6rz.net>
Date: Wed, 14 Feb 2024 22:39:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1raVP6-003NI9-38
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:46142
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfND1abyiqZJ+4Pjoig4zY6ONqCeoGDMKrMRugRbeITFQFM/Q8f/XkSdyUprM+qwBbFer1bCzTRh05k9mBxTtbpM4BeDDVClqEPVViaI+nA24UeEsZO07
 qf1R035XX79dnK9xwfnK/9HFAylruI38yw0CMFKwC2JjjQvVQUmgHdXvykYB0CsA5izD0Brsrbh2dw==

On 2/14/24 6:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:22:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.17-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

