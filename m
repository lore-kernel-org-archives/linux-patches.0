Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DA9284690
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 06:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776754336; cv=none; b=R/U4n8P7G5fjOvooGQ1C9zsulwaxhaDBliFz8GqeWxqRvpck0fZP1W8zVVHi6Vc3PBQwIrwYxNdLB0FGP6uGfHZD1PNz4EoNwJy0ozm3BPdMTrVAKF4v9/sogpLY5lmgKwYi4U7o+KYedIEb7UOgNYUxwFm7SuebIqfprDqyoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776754336; c=relaxed/simple;
	bh=vMgoTzHzM0lFb9KMeTCIFNjt0O9iOBH7Rn/5Cp14R1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RFoCitP90YQlVan8tcO+qxbMIX/VIo1HHwT4YC9TfMezAHJIpDBYD3A+mnJQ5Jbyn66qucF6THiZe7dGIdo/xE7cwru0yjeX+LDEz86oibVGtcep5qKRT5XY+2u0X/65vK8NdRc3/4nmg+Rfsj6wHcVrDfdMT3jdFX6I5ouFmWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Y54OII1o; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Y54OII1o"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id EryiwEmQP4RkpF4xxwGZGs; Tue, 21 Apr 2026 06:52:14 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id F4xxwbDH0FeDMF4xxw4Zqm; Tue, 21 Apr 2026 06:52:13 +0000
X-Authority-Analysis: v=2.4 cv=aq2yCTZV c=1 sm=1 tr=0 ts=69e71e9d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=oNRziAQT0M2QRRDl_VAA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dUoQbK6fbpNCYS0cxkoS3WtBOnv0U4eznJXOMKsLuEA=; b=Y54OII1oQs0t1CnRLD4NPmu68o
	JdvWzncWVJj/0WtKG9PrjB/ITEZFrFa6uMFaTBnDEm7whA7ik7rvyUStVLdi/B5Qjzt6O7fx8iYyD
	ais0Zkes7YTfqf3bQTEuY6XtviWwNIbjrIxV5oXz/SITPvZOh5AKKZkrnP8AzMUhO2VKZLEntWJMy
	RvQTurxygPIKKtIiuKU9WcjCAzFj+tH6w4jgG7ZCT5iibow4pUGCUybxJg8RXYOT9sbQxSOimDdQC
	/7Iu/zTITga6by9wGLefU3HsZwUQq/GNVaHsj/6uGz73KjmvZMaDCd49yt3mQpPeTB9JeeeFxbrWl
	tZmKKBGA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:33028 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wF4xw-00000002AkW-2TWd;
	Tue, 21 Apr 2026 00:52:12 -0600
Message-ID: <e50b973f-fa58-4558-976c-84b01f86245c@w6rz.net>
Date: Mon, 20 Apr 2026 23:52:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153910.810034134@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
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
X-Exim-ID: 1wF4xw-00000002AkW-2TWd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:33028
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPSX5PplfaDKaurW9wSEERyhZNDNLcbdCm0tMFRDc9j7JWcvkRpyPxMF4zqcPKiKOtJElTOTBneEmiLZOo7S9dZ34h00SeNthT53hxACLyyirh7vihLb
 iMWJQqsW1VRnMpBz37H6sBtKzByAdMYeaAnqxR5iQPYeD3r6f+QdlHEN6UJ+BjowzKx29zRjYqwTvw==

On 4/20/26 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

