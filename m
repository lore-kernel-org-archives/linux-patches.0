Received: from omta033.useast.a.cloudfilter.net (omta033.useast.a.cloudfilter.net [44.202.169.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F2221859A
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 09:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756892214; cv=none; b=NrMQBHz44p2ysI6dRbhcfcnjcXpFebzUaIu15qO0Fpd4hX1WiBom3KAMGT0PZG0IrlMIdk24Um8vKBYn829tiSY3lRY/xkzkzVdZAv0RObE2NIDQ0dMi1eIeJxi/mWZDecDTZvZva+m5rcr2t343uTcsMp2DH3YmTCx71IO67Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756892214; c=relaxed/simple;
	bh=pUdFa52knLKwL8PFuwkmgpkKe6wBUNF8XwbGjbDbRYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VEUIF/AI3Q06C8KxC9vsenGg2eRanyoB2KBkGBDj5m+oiDi6YsvRH3Ii1+2uTuBRLSHJkrfcHoipZSZcVVtX5PhKA8pvZYGT5XtQfyGBeAGdBuIZC0IA/dkd6Gff+IhFlPQ67A6ORhzrZA7TyCCnaCaDtFweYbSLfpZWGZavkj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=oNkYfQUv; arc=none smtp.client-ip=44.202.169.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="oNkYfQUv"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id tfN1u2uVEU1JTtjv8uzPY7; Wed, 03 Sep 2025 09:36:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id tjv8uugOEMnOktjv8uQzrL; Wed, 03 Sep 2025 09:36:50 +0000
X-Authority-Analysis: v=2.4 cv=Z+/sHGRA c=1 sm=1 tr=0 ts=68b80c32
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=wQHQzwf_Hs2TCVCgcZgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MOcpY9KK+CIQKcsWynlbRCZJy1f28QPQndSNgyykgis=; b=oNkYfQUv6UdbcfCMOK9sX9oZvT
	QPD7X6whOFnuIykY8keUxytnHNMFkGhuxMvQ/YEsyUtPxhrULZrhWVbUivBmkwfFF1QLWBsF0+AaW
	faR8Kc4hmN7Z92evG8hxw72DmKcIYQow7dLA9iCmUUiJZQ8XV1kZDcCvUWyjWJdsQr9AcCiBUURip
	6RKpmmhzyy45jZ+bGA+6ySiTtrlGqLiP2kyYTqGe5Ug2cwNGUD1ejW7Fv33MTNzeMMmYP4BCokX/I
	2oUz58OlbCC4KedOKaEOlRFwaTo06UVhG1YoexDPdweYlNv3fY3gv0riugTPvSMXhXyispzAqBXao
	FzDBH38g==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39482 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1utjv7-0000000108d-2NlM;
	Wed, 03 Sep 2025 03:36:49 -0600
Message-ID: <d7fa61b5-a574-4546-ace7-c2ecaacff47f@w6rz.net>
Date: Wed, 3 Sep 2025 02:36:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/33] 5.15.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250902131927.045875971@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
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
X-Exim-ID: 1utjv7-0000000108d-2NlM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:39482
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDVGSyg+nd3HpUMBRfOH628wWpDgbSrPeyTbaVDFvWYpvwHHXLQNx23NdEGVmjXtMoS6ixlwB8NfWaoRKCpSY/FfOHuUl3erc+5CT6YfDmn3rdB26Dos
 xV3VHZsx6fbxVS7UUGlOYHgM2Q5M1O92H25Izh0fi+OQYkAd5Nn0WHm4dTNRatguMf8sD+X37daL6w==

On 9/2/25 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.191 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

