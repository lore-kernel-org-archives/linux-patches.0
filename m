Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4C64915B8
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052622; cv=none; b=La0T7pv7wUn7goSma3QVj6BTP85B/xI1Jc40iOGVoImE01gUXJgVSrLBXGzue3xtZrBxQVvjEGDjF5+DBlhFv3kUTpfPl6V7DMiOuVK/6glsCcAbDe/0st7tQYjm+3y0vZsvlO/Uiy1O/F4rNCt/W++ADBF0dLtd+gKMKynQrHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052622; c=relaxed/simple;
	bh=sia+yH3CHGj9Gti7q7j9Vccj/f2gUS1I8i8HAkDtFTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lsbNAh4eAUf8JtRKB42Ixm7hz0pzOfm2kdFOObqppkmzbmdgaelO1oa88D3eWp+h+KSNX6txt5gQzvHkRQskxJTmbnX5a6Qs9rszRJC0xGY5qTI/DfiV1HrCH9OTudli16mccsyy9RcL0EqcIVtpPxg2OWSMCRd8FMBAMB8c+B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=OMgFuSHh; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="OMgFuSHh"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id 4eNpxkmwUv0nd4gJLx9sHL; Thu, 10 Sep 2026 15:03:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 4gJKxahAr0FbV4gJKxfIK0; Thu, 10 Sep 2026 15:03:35 +0000
X-Authority-Analysis: v=2.4 cv=Nv7Rc9dJ c=1 sm=1 tr=0 ts=6aa2c6c7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Kvj5KHcnv2BMlMXb+ML0Cr1Gy6V4PmjUtl3Nd3nG9qY=; b=OMgFuSHhFxOuc0jE0i+r2dRFFy
	IYXTr1yJGDMCCaLeDaJKtjoiF15e1r6+LjVZR2rM/Hwwb/swhdooImA0dD2Oi5CYkF992rLjsMWul
	la6JuwBG8Rv9S8DoBKtR8kpBUNWOrlRGoOdNH4o0Xu9MKFpyjk8Ug0XlVtRUt53Sd20myCASFtulg
	podBST299kN7TYpVvMu63n9iIP/lneA9FHrYWH/ETzYsgKV0xyv7MoAbPIoEXYlBTpmGbTUE+OTGx
	J8YMeERPHF9odbq2P39DgwjsSZn6VwKiq3kKRdAfLe29esEx5JbvDTmTRFfDEt5tWMacgtFdjlKCH
	t68eOedw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:36334 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x4gJJ-00000000KjA-3X3B;
	Thu, 10 Sep 2026 09:03:33 -0600
Message-ID: <a0262797-a52c-4bb4-a0ff-cdd87e1d4bb8@w6rz.net>
Date: Thu, 10 Sep 2026 08:03:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260909134237.773280130@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
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
X-Exim-ID: 1x4gJJ-00000000KjA-3X3B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:36334
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFHPsNI2x4Tk0U5l369ymWTl3u1wi5A2j6N3HHF1Ho56dcz67uploLOAczh7pQ2gulu7fPDaxyIrUvqaDmt/LG1WcVksmamdEkUQmtVX3k99jIj12rTl
 M8niDHQWZEpGBF6hAZJ23j1J0rSm3nPxRF9vXT95lJqOI4xPnzf80Im/Ca0J7jEtYiKZ/IknuNDf0g==

On 9/9/26 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.51 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

