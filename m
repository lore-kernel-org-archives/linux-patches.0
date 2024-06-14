Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E10190477
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718365488; cv=none; b=NuCBsfpF6tXNuPD9p0x8I78oyzyzLcPNIeR7/iK2bEJzLvV06EYownQTEluOGNkytDL7RMcQBqoH7kvl6PmtHD/x0R6XOcSx6TMv6iAS9FsQYk9Y5KPV++IFjy0fvQTRIDD3YMN3q0gcMzeB8f7XKlck0cpQLmQ1xLIK90ymqGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718365488; c=relaxed/simple;
	bh=fYb4u50L3P31n+UyNTCqpah9W8V2rkKVOAWOx6LNu1M=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=RcaL95MnHzen/r0EEi4zgyX5d3p1voaj1/vXr3TW8Rvp79+6czpCMni2UniUBEv62qGWww/h5XdPkGV/ZUfeOPkZzWHcO7izzMJh8N51DcYXKy/CCxZU49ABP9ZT4J9PIDQkBD+LbpCymixtnrIQx1WVwzcOTCTP/JsbmuvTjYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=TtFFUG4C; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="TtFFUG4C"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id HfLFsrVrxkQe8I5MGsfgbX; Fri, 14 Jun 2024 11:44:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id I5MEscUqLWKFuI5MFseymx; Fri, 14 Jun 2024 11:44:39 +0000
X-Authority-Analysis: v=2.4 cv=P6I8hDAu c=1 sm=1 tr=0 ts=666c2d27
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T1WGqf2p2xoA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=k_VYlBbNjbJsBR3UXVkA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3uSRK6CMMEXrBzX5luVH6ZdIxBG0z+mPmM4erLGdKmw=; b=TtFFUG4C1pfnpg+4gElsI7Rrug
	2dxd2AgwWxD/1E0n/cjL8GS+NqOQzZ/keqtaXmSVfeReKc8xquzkcgqbwdBUtk7h2KhwT4wwxAI6W
	jd9scZ9a94K9nuh3qPUxiGNecipkYT8/TIsee7E79xh/LLGJLu7zio0QiOB1+cHtn8ENBK/SwF3Vs
	k7ZIKY3bqSO7ys8yLPWhnQOdh60TWvlFQQCJTLUr+ryOcZlR2mGRwEjLuuoHSvvz/Pgjt1klPeidD
	gCzcT5gLxBF6kbW0QlPwPQUE1kjCrhVoC+uftlWlYwY4FXQBMF4KF+qQeiwviiTJmVdHnD93eZtLC
	fS0a7UyQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:43670 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sI5M9-001dSa-1t;
	Fri, 14 Jun 2024 05:44:33 -0600
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113227.389465891@linuxfoundation.org>
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <04785734-64e3-9d73-5ab6-bb0fc6186459@w6rz.net>
Date: Fri, 14 Jun 2024 04:44:27 -0700
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
X-Exim-ID: 1sI5M9-001dSa-1t
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:43670
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKCVCvqFGuDhRt9TmaV0dCWHBa7aH3X00VSfN0uY63SzLQIkdVNnabe6NYJhZ5QEtoVpWtX+yimZmLDLu8eZkTmV5UnGcfr4v1rm/tNeW37N/AFpLyhr
 TG0lwZLocHdi1cVMcvbFrRt2+eChsByoeobFYGbAtOc59GmB8yEyNlq2ZW0qwKtTKSOIU4VZ8RW/hA==

On 6/13/24 4:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

