Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEE31A4F3F
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868511; cv=none; b=BCbpS7C6qUCM0eqIxoy8MtqKNJ7oK9HORnFm5h86NIqalVAPM4xH6utQHGcC3K3OiWIXZZg/hPpXNBOXqkiGsUjHKRywc7RSw0wQsmeUBWGC1cwvWTnk7LXB129KJgU4bTSrjSiimEBHeJ3ohSzUvWfnIYKECYsH8AxOhoVzKOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868511; c=relaxed/simple;
	bh=SCLV8wd7X7ckBXak/0X6ibU6CYrjKDscx+KQsbhVC+A=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=NRsq4iRvgpvgEX1h+MmxGof/XouoVrSu53XWgChsE0QBCcAo59NklnftUMmVy9VfHbF2FLV9BorGnxMuns6Sxm6/eiQjZ9Ko7rP5rXMiYHnLHc2ani6Ro0BlBLVEn76jmkk8ezmZLmxu7AoRyQy99OeU6/i9vUVQcHJeWUYA3po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rL4ULSGf; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rL4ULSGf"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id jJDPsKniJg2lzjN5nswxv6; Wed, 28 Aug 2024 18:08:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id jN5msuIJxX56wjN5ms5Tqd; Wed, 28 Aug 2024 18:08:27 +0000
X-Authority-Analysis: v=2.4 cv=MY6nuI/f c=1 sm=1 tr=0 ts=66cf679b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=pvbMRhK_gA1k-AccEgoA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hfsNqh9p0Ut36mnWdHM7bvapJh+juYxlaROAU5v0Zr4=; b=rL4ULSGfzapvEmO3a+sfxHiYSU
	EYNSHtgQfLyevf016rYXHLZ5OIyrBNqCmfZSkmDJTG+zO17MkNCQCxvMZ9f8Q/FAul564mWh/EaLh
	GQC7oOXgkdmXYs/ZdZ1pap0SnJYCkNplwVe5ayZFhdytBQ0DA7y2LIdw/aaR4VwkEQoUmS0Kkr4Ap
	B3MmkwzxlsOKyw7Xw/8wJn+wdSdZhxO1DpTfGv/5lp56op86jz7zzEAwLgUoQEcFufjIDOs0GQFiW
	B6PdwNkkmPrM4Z6a+qrIZ4vIAmHy1BVZZhOCIsxGMsYXEpqFATS4sdzxq8V9lTIuWQvLVprwY8sQV
	k/2+BLZg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:37086 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sjN5h-001FJE-1j;
	Wed, 28 Aug 2024 12:08:21 -0600
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143833.371588371@linuxfoundation.org>
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <108efbde-9cab-1c96-4143-bb80fe72d796@w6rz.net>
Date: Wed, 28 Aug 2024 11:08:15 -0700
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
X-Exim-ID: 1sjN5h-001FJE-1j
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:37086
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHsZCwkXVVbmUvyViUwkTII808JAlT43gqG0fu5qEyZf/Sp2XQNhIUmli3ifQTKxm0a92pvcxlAuL1RkS6R7MWghivrvc4qRpohk6nVIwyHR5rzK9+7t
 dmQu+Om1eeWjtyNYTCfm7pZhcQRIc6F9zi1IaWm3eLycEeGI8t+wSRDCz50jDgAuOtcHmSiAn7xnHA==

On 8/27/24 7:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

