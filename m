Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.89.44.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792888629;
	b=GsQWPmsjTC8D/tzozrGJIjweyKHV0Is1/4rgrFwEohGtiUQRMY6F0KSEvwOSbIL+O+UY
	 isGrrLzQR2GEZVY4sttdgolnLRy0XJfyXS4YdZWw8seUiXmqullGyk0rP0pwb89AaIHZq
	 K1/hwjdGOG4C8m0HncKQqGoCFkGPDr+6FYmkFpUw431XWwyXyfF241+0QwaG/DktvHxb6
	 5E5bE7BQID2mnlbZ/jDGoF2JuK4JVyYdi/kg7MxdoBuHoiJl5VkMOSQTwclXJNI1VvjBb
	 r4zO0/T85/T5zWVjZaNKa+mFfBvxTF/MXG4hiBvOxaxmUvwnJUSptbMHXhmef+pLzYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792888629;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=y0J6f+7fz9qiuM+nKAPfCcyE4UpIjVqLueVjidOj29M=;
	b=aepVj1yrQ5ufOYDfdQJMq/uqE91QmUWRTL/3V62OxYbhsncV5I+KGNA0jm6Cs52AcaUr
	 TkqQdS1QJHQrwPRbRzBLLWrr8uJOjZ00n990um0JUJaB+Irku9oZalYMH/c7QPPD5/u+a
	 eBm58RWaft6m982u+XfoAu9bjE69aKLesbbduR0OccfiPpEiZ0MgtZye8WDmr/eZnJixH
	 fsNfEKts2xdpx3Wkr3TcOkiLDxwzKtk8cSZuWUcqU9F+yRDDKgj3j/hjhqUM9I4oaDBWb
	 Jw+jIXINyxw82i78xr4ztgKXks7Kc4lOsO7bQCgGiIaHIXPSvcnUBEU5SScfrXkQmCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=l7Pi0M1o;
	arc=none smtp.remote-ip=35.89.44.35
Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FB7606A31A
	for <patches@lists.linux.dev>; Sun, 25 Oct 2026 00:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9FB7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=l7Pi0M1o
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id KdVTxbsT4usRSKmEWxgD7w; Sun, 25 Oct 2026 00:37:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id KmEVxFmzoP7wgKmEVxduPo; Sun, 25 Oct 2026 00:37:08 +0000
X-Authority-Analysis: v=2.4 cv=NMzV+16g c=1 sm=1 tr=0 ts=6add4f34
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=6m-s6s55t6cD9z_nMwYA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=y0J6f+7fz9qiuM+nKAPfCcyE4UpIjVqLueVjidOj29M=; b=l7Pi0M1o1eL5xp7giHgphqSqqV
	IDdfjo8e29J0r8hNPso6l3gU6U2S9y7CCWwXpyXegh29BpA/paBbRiiFVl2lMRHbRR6xLoWBaZHKZ
	6fe9UyDCupD0Q5xSrWhCK9RDPUZrb8C0bZIoA3Oqnw7hBBJvPEbUL0zI6sjByVhXaSTRVWx1Z33ZV
	VeZ2gEx55XQ7kpK+H9kVcWwTmSzDCfkCcYzVmYM8Ca5aAIiCshHjMOu2QCHTUYCev/WW10yXfyhjK
	s1hgCaOW56+MHGwptoiZAiA6r+Zy8lagcvQEq1IdCS7ITPNqSV+7qFKwjV+souGcinARnuEwTD1Ch
	mf0ngrCg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51622 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xKmEU-00000003BgT-3Vzq;
	Sat, 24 Oct 2026 18:37:06 -0600
Message-ID: <f6d268fa-e8e4-462c-86ff-58c0eacbea5b@w6rz.net>
Date: Sat, 24 Oct 2026 17:37:05 -0700
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261023163714.201276352@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
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
X-Exim-ID: 1xKmEU-00000003BgT-3Vzq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51622
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLETUF/dEdpFm1czHuAl3YV3nJxYX8T8Qz6ONlyE8YOX2N7RKg7VKz4Xibau4j7aSYlLjgjMbBUysy7WgHT3kooDLQoEhCoUJSCvVREO3gzOhKwKgCKR
 rz7PZkdKgab3GlqINNnh1tEgvR5ONIWfFo1R0Wbwg1rvFhV9isrOKiPdr2lDnnxkC8aNfWUH9z6sGg==

On 10/23/26 09:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.59 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 25 Oct 2026 16:36:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

