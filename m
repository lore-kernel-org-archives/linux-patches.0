Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDDF63BD
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="IgAc+G9V"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id 09VjrMzhr8Hte0HperMdoC; Tue, 07 Nov 2023 08:53:10 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0HpcrHw9UoIDw0HpdrwrJe; Tue, 07 Nov 2023 08:53:09 +0000
X-Authority-Analysis: v=2.4 cv=TP1W9npa c=1 sm=1 tr=0 ts=6549faf5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=BNY50KLci1gA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=q7c2SjLRtcTvZR/AkJ4bUasgUJ/2vDguBz4oEY9Bg5g=; b=IgAc+G9VgpHnTZUu/nvops3n82
	CvHVGbnMhQsd4xl42QSFqX5cYhoHVEL03EQxq+v/FjjxmX3DgpEVU/DaMoOznuqvp8iup4osF3pjz
	q1hUdIjLMfUGRO5WwSS/f05fjwLWvN8sAeQkrfFpEIb4sF6mFcZ3F9gFg+vbstRt5UR2itTsKSSCP
	uZS/vP4MU6Ygx99TzFgHXSKw6aeZZ0oO2rrb9bM6SM9re0J8MZ4cTY5LC/lv9rtOY9mQoNVQ4zds5
	21F4uBwzpSg4LBpwChNtJUGD0O6lMV3MXojLXMPgKRdkyQhg9JOAolIoQgAJNfzLx9VtJ8s+4X46r
	0kXLyrEQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:54214 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1r0Hpa-0006wZ-2c;
	Tue, 07 Nov 2023 01:53:06 -0700
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231106130305.772449722@linuxfoundation.org>
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <899472bb-300e-b976-7942-39457ab13476@w6rz.net>
Date: Tue, 7 Nov 2023 00:53:04 -0800
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
X-Exim-ID: 1r0Hpa-0006wZ-2c
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:54214
X-Source-Auth: re@w6rz.net
X-Email-Count: 20
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNITRrFN2YsFZsttvaaS4rqSHuDIavr/hDn6eIUMr15iTW+dPxWUD9QOltAq3A+fGXXxYwMW4BP/wnW2mjxDjZ/ONOq+NkSSYGMw+Tm48ti57tboUb72
 MtWRgnE3/Vi9aPSg5igb8YPhjLKWFVlHNDG7UjCDLnEXfI2HmRr2rPLqsarG3pnLqLk4EB1A3+I2Cg==

On 11/6/23 5:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

