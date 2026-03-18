Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA583A1A3B
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773824595; cv=none; b=V6t2EmNbgbO9yTwi21Bqm69IWXoQBS4lpV/4Bqmoj+FiEOn66W4BDcQIThk9Gm1Dh5XFrN44Tt3l1l0jf9m3WLhVslw339aZaPif/x3FX0VaM1HKVlkh/3zSj51sSzeQGPyG+K7oztpoto5eLTbVyFCYL/yMAcH7fwxawQjCgZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773824595; c=relaxed/simple;
	bh=exVemooZkaSRWzOz7nRqkuuu6N4CeiBqS1BopFfioHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=je2u4k02cWncUuXVBcT//GksM/0o5G69rznFUKJCnbZ4TV3VteZQbraJ89iwL4GZZc97uqWGIsbIQXtfgNiBruQlCK4pO0wpeQmnPC937ezlMm2H4A4ux5aS2jNhXLwbkcVqNTHmgXrRNKtrCfvoCW3A76N74QVUN517W7pNlKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=FaBKuT18; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="FaBKuT18"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id 2cU6wvllYCxrG2mnzwc6Sn; Wed, 18 Mar 2026 09:03:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 2mnzwiw0VPL322mnzw9tPN; Wed, 18 Mar 2026 09:03:07 +0000
X-Authority-Analysis: v=2.4 cv=MqhS63ae c=1 sm=1 tr=0 ts=69ba6a4b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=YlFsy8CyaHjNQos-U68A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/ahkZYHC9gDIbXTR2QuPpJYkGH8ULN0jjs5bsrk/PkA=; b=FaBKuT18Oz8xLMvZL+IP5lTgOV
	TMD515yOPNkucV4fdxMm3U1T83BGuLVp/ajUGnWFcFYCixAXuqBG4RwOQTrKG2r1DkC2VHwWpyc2L
	2itvQILruhC+TgQqGR4NT3BuS4ultczjxD8nQesqcrwhPOrDBTkOYKPD+auctwIlVtx1kl13SceFV
	5RPTXLbqtRNSZbeCo25rfo7SEHTEim9Gjd4qBTzip2Egk9xIVhI/nSZsUb4xyYHB7YhHB1tQG2Dpr
	I1wxUDZ9/FQ2rGQ8JXbf6j7q1NNrmoiMYYn+klbPBb/mZYX4x9zLRwzgVihNYZn6PYRT/bOTa5ONw
	9klbr2Ag==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:56728 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w2mny-00000000QSm-3Dxt;
	Wed, 18 Mar 2026 03:03:06 -0600
Message-ID: <f2c6b9f6-04b0-4e55-a474-c875ea267fa6@w6rz.net>
Date: Wed, 18 Mar 2026 02:03:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/333] 6.18.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260317162959.345812316@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
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
X-Exim-ID: 1w2mny-00000000QSm-3Dxt
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:56728
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCgfhqFfMBdKfhV9cPGDSdsTQcz5SGx1rPwJgi+S3/4t0efr6rBom+7ql9rLq+z8JLb1Jc+b6SMvKr4og6+IvRDK15xAP5qYxOAyA5R8YeMuUPNXdXKH
 H0ZUy6bPkShiHzhlgy8hOZJvMcCTRwrVpfg2PjiBUlhKD+Zp27a4hRimcSGXECtzCCWoHgGWgGHaPg==

On 3/17/26 09:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 333 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

