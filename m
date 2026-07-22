Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A3340F757
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784717402; cv=none; b=gztiHM736qd1DklPk8+j4ZTsuvB8VImuGsgSBZv0s9E1NE30QQUwKezDHGzzWStBBJdZMx5O/mdgQQRI9gHfAwKWU/k3atMv053dMQDqY4vQsO+LAkPl8kA7mKUVmTiijhhRNDRgyC9NMiELXdEXR1I6HjF9JnpFGLXV53Hm3SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784717402; c=relaxed/simple;
	bh=1Qvx3OzXCOP9MnhUqJVTqxlMIapqlpWh4VKytE6thxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ei6Rx2m7q3vMjXBuDJeWboueRczqQpJVt53zEFknbTD0rxRDycAtfQx+GL4GKTOxiGv3lNSZpOwv8gU0uNstd3jXqbdOxHhnhqfwlbUBsYfcQSxPlmpfWbWWP+khbUyjgT0Ov1RcV83dve16wcRG276SGLG7r964ugB793esch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=RrewM8UQ; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="RrewM8UQ"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id mIVOwamoDhJKMmUWPwOB4Y; Wed, 22 Jul 2026 10:49:53 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mUWOwWTAwtyQ7mUWPwZwcs; Wed, 22 Jul 2026 10:49:53 +0000
X-Authority-Analysis: v=2.4 cv=E5LNpbdl c=1 sm=1 tr=0 ts=6a60a051
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=q1FuMKGBw0a8ScfmOLkA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9W9CfMEz9skf36c/KPQPlEqrviuxILfTj+63nRdD8iU=; b=RrewM8UQfK1+K+1Je1uTrxAXqj
	OA/K2/PqZDTX8n2HcP5KFI59xIzsA7jvDRHP/InJ0mSyJBbq2n3C3350RgKfRb7P7XAFiSJCmQl1K
	foW46eswLLrolsN837X7VEOba9TCht8L/Ktq3+FKr2oxhDL/Bri/AJslHm0wTxiA6ZTE3GVNONx6I
	0EyiCbC3x2iQh6aNOADoufdVn4RAsksJj3RECc0IQyfKE5EIx3g418fra0INxW2uALNBDQZ16l2Qk
	J9BrjZ+DV2UwHEenWpahY8H/oq4kmVKSxL0Z3GUsgjYDeXtEn/qJpeEowfCAXwS+oWBxQNG7HHlnM
	LkfxHmRQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:36458 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wmUWO-00000001DX8-1ZCl;
	Wed, 22 Jul 2026 04:49:52 -0600
Message-ID: <9c471f71-325e-47de-83df-0aa2db7988f3@w6rz.net>
Date: Wed, 22 Jul 2026 03:49:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152446.065700225@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
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
X-Exim-ID: 1wmUWO-00000001DX8-1ZCl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:36458
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPXVmtllAtuHUAsoGqX2f2hYsLAZRqlybOTBb1rFHb0LbSsB+WN4x9/xFKp6FlDyO6MQJWvlFzk4XjtG+t8W7hdZde0DliW0juV6KmIZEi32CTxKmHPv
 6trpLg3fHIzNVI4RAiY9TifyZbX/lc8tWlfw/WFQgWiOu5ZgHjo1TJ4iBnZpXfPUCOSi6QA3jne7hg==

On 7/21/26 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

