Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.89.44.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793888564;
	b=EQDWVP92FQRMT3CPuMw01GNBtNHmccFSAk8NSpn90tbP5q7N5J0omcu4rVX/aHN8BayJ
	 6eusoawP+h3QSFKp3zURwPL1b5d4Ots7DJbnZij/T/PISXWy6XMZf+e1D85wK8UK9ivs/
	 NpNlp7rWaLqinVP7vU7636I1Z6D16P9fITjp9kjuEnH+cU4iot2QtopHH24R7JKlZymD1
	 zYk/Vlcm6EZKc8QZxw0zA7VI0VpUh8n2eNN6wxtprSk82q66pKON+NLM9mYavfGKmGEv4
	 jX0Ic9QQkE00mhvMQQPxY4iHVvFzSUqD/nliTq4xss0zcqehUn+dX3aWx+x7WIr09jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793888564;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=R9DxwFLYIJqDVvBQ1nVU7YyZL8dG/41aua4Y+2jjDZQ=;
	b=07gDJXKAH7fBZ5UyWaiSQMvNSEnd0URlXkEx/ix8U4WQVzd+TLDvIiXvjdRXF/o6NxAS
	 aAtff7gfS/nHgImSXhv6kRWudbS8ybvKsMcx4/tzoZLD0p70K8HW3sr5soTS12rb4KUOz
	 8nJX0XvB9ON3A6Ypkt/DdMqD3kr0ifvlBq5n11QWx9X1H2ZGboRlpKUNDsgiio3ebt41F
	 TGzsumG65sSVZyixgNIVAOHwlK9h0sQHrvxp55DwC6VV+YqB5JOPgYGj3VFtRkpgrRACv
	 rXlqHE8O4F6raoE5xbdL4rZ0gGEi4Xn4dlYJXbhjis24Qn5hO41/2G2L5EdlqevO+HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=gEfQR5+7;
	arc=none smtp.remote-ip=35.89.44.33
Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E4F606A329
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 14:22:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52E4F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=gEfQR5+7
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id OIFcx0q4eAR1iOyMVx2qhH; Thu, 05 Nov 2026 14:22:43 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id OyMVxb99Y0w3mOyMVxRA9m; Thu, 05 Nov 2026 14:22:43 +0000
X-Authority-Analysis: v=2.4 cv=ZtntK87G c=1 sm=1 tr=0 ts=6aec9133
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=R9DxwFLYIJqDVvBQ1nVU7YyZL8dG/41aua4Y+2jjDZQ=; b=gEfQR5+7JtwGZMQ01+H7dCX+lb
	SqmGldBJwfL0sxfAnBe9nv2mt3a5PyeB9NhzDlyjUz+OaiLJgpwRe9GHg7UWns4IMybGEBBG0EmKf
	JnhZzOF+31+Uh4uAv1YoY1ODrRQbmJdcN9NrK8zjUK/Lh/c4Q862lsGtOnOJSwrKNQTtv3FFtUgdi
	FH30eVw5jYMZN0xp/zRCO+EbvBSEb4C0utT10ESiB/RThAmsE7oOIUg0mqwa9t+CmW62zM/kk+rjQ
	AEwbORZf613yBV+GdrrG9L20mtjk22oBBT2BSRsDw2dPrF0x2mjVhAbYzPMbAV0TQ2+3bw0tCRF9c
	WycX47Fw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:45296 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xOyMU-00000000Xjh-1su0;
	Thu, 05 Nov 2026 07:22:42 -0700
Message-ID: <4fdc073d-5895-4caa-bfbd-2f29be825f5b@w6rz.net>
Date: Thu, 5 Nov 2026 06:22:40 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261104211043.516122098@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
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
X-Exim-ID: 1xOyMU-00000000Xjh-1su0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:45296
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPPe6uZ3asP6eVmrB5aHOtePkg/JRgW/GwFZTaLJrME5DbWQdr5ftgO1olNdEWvJjmvNwZMzBPjzqJwzWSuBeIETXkkjHGHsuJzEIFF6t7Hj4Wv1TP73
 BYcK1/6E5PAuVzFfDP9szOb3bnu0vS/HvFi49MQHLLkBOJmTjZaZyPM0ovAf9X8zWvjce4fHVVMHSg==

On 11/4/26 12:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

