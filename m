Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D301CF5CE
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 23:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727998884; cv=none; b=GkPHQG9+0vAvGamhOd0+LSFqw6yR8Dw+va88gaVXlqbiGZtGSNaJFvtc7hItd3K8i93Xk1lBDgDb1PX8+KAuS8v5ouUKhxarr3XXUkzM3bSAyE8Ul3hBwPdkUxkzUWiPtAtHd3rRFZOjswefiTWUJO00vAk8v60X18hrBAyj+6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727998884; c=relaxed/simple;
	bh=8mCObbKltHbvwBg/B6nFSJyLAQaTEvfhHx4vslZ5KOs=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=BeHUvVcZJ6zYKuoSRrqKolYC0hMGe4RN2VrYjeifoNtMRgwLzsiYW2CFsRQ0IhGdCcTCz2bl3qwN4NSxWnZbAPCQLl6/+IIASS1XxQt1WkoK0eGbuIM5KZUdX3qOHOwthWd8f0SJk49sTZ/c5WqHGIgNNdXs8IY/oWXslRR8/Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=AihTVg/U; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="AihTVg/U"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id wOXdsDGDQVpzpwVRisbkYy; Thu, 03 Oct 2024 23:41:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wVRhsMd5XCgT6wVRhs7SBV; Thu, 03 Oct 2024 23:41:21 +0000
X-Authority-Analysis: v=2.4 cv=XvwxOkF9 c=1 sm=1 tr=0 ts=66ff2ba1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=DAUX931o1VcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jmpvIFUU7xsSjFCdoVTPCOR1EqyFQg0MhzYccYxOwr4=; b=AihTVg/U/jButLf6StyBA13zo3
	P0WhiqVlCf+9itZSeK5Po9yX6tC25XTN3zHDbFAdDnqeDJmbwWa0IQpkaISNhdEB72ofM+JhNDh5p
	LIpg/9yWwShA6yxXYbCBHO8tvwOWv7H6u2LW8eFW8PC6radxse2AvpdaQ+RfEqBIjP6vHgZ6f+dXM
	EfLRhVR79Vdk3uGxhFvORHjgihjCEwmzRk8Q8U4R4M2X9Pp0eEoXQIMK611xUHmj4gb5ENt4Kn5r3
	j5XemZVz9BXVIA4HTCHkd1JN3oLIW8j/8LZlLluhU5kp7WAjVCMciCzgbI2qnGx4UL14Me9kwjp6+
	YH95niFQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:44452 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1swVRf-0011uL-19;
	Thu, 03 Oct 2024 17:41:19 -0600
Subject: Re: [PATCH 6.10 000/634] 6.10.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241002125811.070689334@linuxfoundation.org>
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <eddef45c-03fd-dd05-7712-4c40f58ed9dd@w6rz.net>
Date: Thu, 3 Oct 2024 16:41:17 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1swVRf-0011uL-19
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:44452
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCKoEhLG0/RK58Bc3m0LudpriaZi4fjNhSwhNN8zfB8zHO8l7xamebk7ON24fClpiJ04CSGQd8usvffqnOxkRi0BNRRHQkf4RPw1H0UKF0LGMoMthT7t
 MBKRzxFSTHqIV3Fii/NteSWGNK8Y+3gj/5fV16mur98W66iJKIKuJqa+vtUfP4UsmI6PjfXwOtU7Fg==

On 10/2/24 5:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.13 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

