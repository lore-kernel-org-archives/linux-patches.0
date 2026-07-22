Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C39385509
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784716843; cv=none; b=SCWWD7vI62YiYQ1h/XKodeMa5A4JJg07Y8JiLTvpHyKSue1DmZZiUFLaXR1iYYh6RUhVaj5VsDqZ4hKpabUwCrGzcGxYb8tcyl13aiN9TeRN7q4kgQdr+S+EeAX+zvNlWUlzVcQ0z3CkKmohhHUu0q6BNE/huM6nDu5dm2MN1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784716843; c=relaxed/simple;
	bh=8ZsiCUDb/nlYznnS1GfY66bdWDGuPxr1dgqGsMmXJ4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATLM+9XYXqhoCo6dKDbqaulL8W1RzZSlqyR4IuQCB4QdNBHdMd+fz6edj9ckmoXQC9VkkW16PzZbVVWAW2pA2lhCygp+rdXO+zgtgV80gQdPACZ1GTQCt7Pwhyu+/YHKuvK/q0PPVUZLZbr85FXihMs2/JxlD3KCy/j2wAryQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=AidyjRYy; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="AidyjRYy"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id mKNZwL43xusRSmUNOwIqHN; Wed, 22 Jul 2026 10:40:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mUNNwp1H5WDCxmUNNwvkDe; Wed, 22 Jul 2026 10:40:33 +0000
X-Authority-Analysis: v=2.4 cv=Qpte3Uyd c=1 sm=1 tr=0 ts=6a609e21
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=btLXYk-BEA0ieRnlDc8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Kgx/OkRXPUEOJAcyUMD9nCgFGQet2bBuI5FYrDUaHGk=; b=AidyjRYyGhFGU0MCLTSxeXaFCi
	IjTCPuJQjLsQRw7Dt97tnZGS0YA614h0UiCg8mEiZKcnZo9jbhEvM+Q5zR8vchQueMmAHMRKnKjWV
	xa+uGDeHohL6X0lnifmiT2nBNPzypWaCVOFJUqjVjCuXU8suqCDGpopsE84T8HyM6W2oX2UAmeiYi
	dpEKB6QgojDyALNX0+tBH4X+5cUWL3IdnK+4E8VByKjruYYAvS/sxaH3MlqXQI0JzBnv43C7IXss6
	DnOZiPLUzZfihopQIlPLH/2kKTSIWsZ20Dj6WpOZF3NXZ2DTaCbEBhKEB+yxNVfNWQwNYYkkc2p8H
	jSWeTaFA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:58490 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wmUNM-000000015QD-2m3V;
	Wed, 22 Jul 2026 04:40:32 -0600
Message-ID: <3093d16e-9ccd-4edb-9fbf-8cbe9274ced2@w6rz.net>
Date: Wed, 22 Jul 2026 03:40:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1611] 6.18.40-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152514.750365251@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
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
X-Exim-ID: 1wmUNM-000000015QD-2m3V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:58490
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfL0MGW8zmiwCXljdOhoMmm29rHw7wthK2K5v9LEK2TCQ2bRX6rA6fF47NgR4t/PodAhVKYDPNlJgb2JioDXJ93mEDJIpVvh8aYN62FF/liz4+PxRX8bW
 NzUyNRclRRtkGaAPRtyMv2nm015a+SsO0RcTUjFAmIcCAdNrIbkRBZHnwUJ1g1BoU8TrnlLKcrRpEw==

On 7/21/26 08:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

