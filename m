Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC62C69B
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 21:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ko98/PP6"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id LQQ2rDJMF9gG6LVWrrepBZ; Thu, 04 Jan 2024 21:45:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id LVWqrf2A5Yjq0LVWqrjlfU; Thu, 04 Jan 2024 21:45:28 +0000
X-Authority-Analysis: v=2.4 cv=afxyIDkt c=1 sm=1 tr=0 ts=659726f8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=dEuoMetlWLkA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tdfoI9PX4746k4ujIk8HyNvg9qc8ieidSwbK0BVB3Vo=; b=ko98/PP6Rxy6jRu06D3Ukebsuz
	grDhvYu1B0BJrl8zJxcDFxV+YkNH0hZc8U19OMUldXNeSTix1puJ7nS4dch4eRLsx7LWSi3Mm/W6K
	2N4Weuey7uci1FUilEK7CAtvRzPV4eTn17W5T6WtITsMavipyAjhX2M8HVhrHBi+f5Ofrk+2EZCP8
	ctNdjWeMoP3S6Ukh09+ur1qsq9uj+SQKAN9J/ZirbmnyTtHyaz4l8ubnCHW17gEzpgF8avCybnZrv
	IOSr/gsKST/6nDrMv70D57Lusy4C6ln9VYDXe38VFTpm5VsOInRn4PVO6Rh4ghwr46rf184qWQIxk
	9uLlJNZw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:34200 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rLVWo-003gb1-0G;
	Thu, 04 Jan 2024 14:45:26 -0700
Subject: Re: [PATCH 6.1 000/100] 6.1.71-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240103164856.169912722@linuxfoundation.org>
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <971a65d3-7d86-d332-d5c1-06b57e055c2c@w6rz.net>
Date: Thu, 4 Jan 2024 13:45:21 -0800
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
X-Exim-ID: 1rLVWo-003gb1-0G
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:34200
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNI8JMk8bLr5CW3sWRKTFDNiq1ofv0wZgL3Q/Vy61J3OH/nmsKnIUfDHWBRs1jOtJrFJwv9jUWd7mvyxNxwXIqTvey51O30SQRymWxWnTBL2I8sze66Y
 ewhkF9PifiUN8k/PTow6wq+cOIrFI142oQwEuidg0oanEvsI4ro8mYjPl2Awi63Ndnk5YGUREFeS0w==

On 1/3/24 8:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.71 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.71-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

