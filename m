Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4014383A5
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 04:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709181745; cv=none; b=pAMyMKfQHNCzIDHgHIjyiz0kz4tS22fBJoh/Z+PJ4b6tZYq20z7ft45PRw1OhNsWyP1ggwnUTMI6LNn3jVXtsXqid9tAn6LwLJS7BTF3Jp4cAVDGz4MjvdmwSOFLmV+e1GyMmw691GAuQeDqyXIrKpPOatzBBUvVGg5vYZnEMtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709181745; c=relaxed/simple;
	bh=7MdowiYFtd1YVdbQPrEzPUsEd/NWiP+n7PYwa3sOkvQ=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=miGNQObU1yePepsWW1MH4E/E/Zj+YLkTszVXFdvKBZXJULODAzpZ4r3KOUjwhT+PlC6oseJQI7bJVNUV+g+ml5ocV5T0gPGlfyphlqrLBTu5ZkuXUstsy+RfYYmf2kWT2ktv4nvgzC5ablA4V9ZC7Aj5L/XoYx73gQhcc6td3RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Vlse2Mbf; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Vlse2Mbf"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTPS
	id fSS5r4OGCs4yTfYFQrjgLi; Thu, 29 Feb 2024 04:42:20 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fYFPrTaN3pZ2hfYFPrwcyq; Thu, 29 Feb 2024 04:42:20 +0000
X-Authority-Analysis: v=2.4 cv=EZvOQumC c=1 sm=1 tr=0 ts=65e00b2c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=KyoLkmSyMt9Nb96WE4AA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TqFmvHG+z+uzSLFLtBkJ2F44Thyw1ppS6+xzDkfk1W8=; b=Vlse2MbfSBM27PGyIBxpZjHGEm
	oVkHIefNnEiXZLm02rVvzHsa4tT44fyy9Yz61F3jAQXRkS0Os7PECmol2zqTIngQXqy/T47yAIIKh
	pgH/bG+Mzw9qU0IHse/1hddYnq4ymyg7NIwUXRZlyPcTms6s1/Nx17Fx5AE3PVIumlE4w9z8kH7Gc
	8UkOCe2a8ZNwTzmOu76hRxzz7COyZ+Hk+5518UV/L7HaO5XrydVsZ9Swg/c1dWQtN8GVez+F5t0+G
	knhEFjdXasODBFd7AJ/ATe14kNViFtCkkNegExKSCqqfHEKZvwqk/FjuAyG8V2hm4Wl/ibG1966es
	bd/3UIdA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:48354 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rfYFN-000KVl-1E;
	Wed, 28 Feb 2024 21:42:17 -0700
Subject: Re: [PATCH 6.1 000/195] 6.1.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240227131610.391465389@linuxfoundation.org>
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <1cfaf521-fef8-bfb6-060f-8f69d96396d2@w6rz.net>
Date: Wed, 28 Feb 2024 20:42:14 -0800
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
X-Exim-ID: 1rfYFN-000KVl-1E
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:48354
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNqHaNl6JN+d4FCBBHgv/Mid2ve5+gfigmtTi+Pu/WWjsNtGSuIhskCBk/qa58L7UX2Lj37LoldDlIqYUVGPhK985S+YgsJpqZJAOKOuOy99rqRbM1X7
 NJYuYF0js0RCBoGmeYcnJe4HqTmfmKONl6GdaJUTMg51EXHLIdYp2D62OPnyRb7m8GaJBLLotfMGNw==

On 2/27/24 5:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.80 release.
> There are 195 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

