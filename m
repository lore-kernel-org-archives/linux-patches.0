Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBFA22615
	for <patches@lists.linux.dev>; Sat,  5 Apr 2025 02:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743819526; cv=none; b=lQXvSdoi55iUlyJZcitj9H1IPyBbeFCu6RDSU3jyEzAECzCr/KcF4EMJd7042bIoPq7jkWPf/S1guOz9B1TitJ/tNiksdivddPid200UieutUq8De4JeAnLAXqnFw1ku8iCLMSGH3r+SdFAdcr+xNJcyKOSK15tOZRuHRkl7uTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743819526; c=relaxed/simple;
	bh=tL6Y9qmvcxyn/LsTfyM8rCyrD3xip76vYoFJg3NxL3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjFVm9H1yVpbJ+XiaffrwHYfbx1zEUpasNq3bYLlKcSlK8+gq8pFIMe0CxSJOmYl2kKqPjFmOoiWridQAYIm7YIagUkA3saKfLxSY6r8WGZaJ17mCohrfBmaRy1RdFzqGfC/xJxeaPNupHIXT6icJhuNhQueXDcfAalZVNMh0dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dhqezE9r; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dhqezE9r"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id 0qxBubSbKXshw0t7Buy80W; Sat, 05 Apr 2025 02:18:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0t7AuF2d8h1RE0t7AuLQMg; Sat, 05 Apr 2025 02:18:33 +0000
X-Authority-Analysis: v=2.4 cv=Su+W6uO0 c=1 sm=1 tr=0 ts=67f092f9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CTIpb7JmY0c5bVNJeN8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Cm0EM2xr8C9VS00Wvi5AtszKp3lmAnEqG6ungAW/deM=; b=dhqezE9rREld9XKyhXwFzbD73J
	O5Wq0qdZzK6YGeyR8r5Aj3cXCTc6lroa5PaG42CETfKYsfW91kBmxOexP1uqEK0x/0e49SH1x8nmV
	sXNhnkTMhbyMRSiBeqA9wtLY3kJ3DstdA2EZ/eatGrwATX0CRp4CApkAmNFwzx9unIlHDYVsSv93e
	45PBxP33TFC+IYRW+PXNkp1geQ9LtkKMj4XjjpX/u1FhM/pF7JkzrNh0l9w2BgyeKeZBYUx9hRyIX
	jUUO5XZi2CNdeK8+qjGT0GWoLethmIwKrRel7fXjFfGVL9NeWAGDmn5gNtEuoz6iqKgCT0PNsyd0C
	BC50ToZQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:47296 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1u0t78-00000001X5z-2Ffv;
	Fri, 04 Apr 2025 20:18:30 -0600
Message-ID: <7b6512c4-8943-4c03-9541-32dd4d444f7a@w6rz.net>
Date: Fri, 4 Apr 2025 19:18:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/22] 6.12.22-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151622.055059925@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
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
X-Exim-ID: 1u0t78-00000001X5z-2Ffv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:47296
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfN34cumpeiblVhFkEz/ZuYK7PyFIcZPS+arbXC0Sy0ux6nw12mYD1c4g1xK3KyNZQv02DtNXrtWuQyRVLOjgBjJlmqCQs1zymjV+DSAY74Pi5Y8JgUlz
 t9Hln6nElye6KOMPN2y1MRHuQdpiWJCF8tcsS72At7VPUsmwo7hXG/uQQp/ADPUVXWIr2aKupGiVZw==

On 4/3/25 08:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.22 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

