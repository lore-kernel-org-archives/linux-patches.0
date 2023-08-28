Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647661856
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 22:37:53 +0000 (UTC)
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTP
	id aNtyqiMrQOzKlakqGqriYm; Mon, 28 Aug 2023 22:36:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id akqFqmWCmgXu3akqGqtXOG; Mon, 28 Aug 2023 22:36:16 +0000
X-Authority-Analysis: v=2.4 cv=D9JUl9dj c=1 sm=1 tr=0 ts=64ed2160
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=UttIx32zK-AA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=o9+P6fCbD8VCllGnyBTCQCE6h4voI3rfT2ANK4Dkumk=; b=Q52wgxSe5zARX6JpCDhU4gh408
	3duq3UaGA66+Fvot4aZ0n2+Cu7BV8rTc7vMXoVr2G8fm+raSO/NrIPBpRWff+axmBIr1KW65j1FU5
	nh8VZTOTfGgStQIVZzWVzL/WJO2WG8wbtH5mrFD3zKVgccdFnMqM9LJ8uBOvTyUlf4JOyp/9pJQct
	90v570wVvXDjuXDnWsrAnUi0rEqxqrR/6ejFQKHI9d6nBNcaDmbUxBDZbTFPfp+PZeLdCl7XKWCNG
	NO9bgEUftXvzUYOAncjHEsbnhA/Jhw9Gye9so59gBOhd0fqlgeXKBMih+Zj6Joky55hIbz5ELrK+X
	C8IEAYAQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53442 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qakqD-000L4C-1u;
	Mon, 28 Aug 2023 16:36:13 -0600
Subject: Re: [PATCH 6.4 000/129] 6.4.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230828101157.383363777@linuxfoundation.org>
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <26308695-25e9-34ec-bcf4-5d3df1ab7b90@w6rz.net>
Date: Mon, 28 Aug 2023 15:36:11 -0700
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
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1qakqD-000L4C-1u
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:53442
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH4TwK021vmXE0O3bz9zI45XgBplOnkxrEwSXz5ZzoOZEUBjsbvJaWoUQRJZQdd3mtPEr3zdoa33FzeSKsv2wwoKVZn8TUNADjjjcKJ8GaiG8/z32PXH
 quFeFR4nQKFHIcQRtd0vfRILmt/8Bosy3A5pYXOuj0aao+B8IFtHwUFGmTMy43RTsOi0muF8JYYnoQ==

On 8/28/23 3:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.13 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

