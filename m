Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C820622
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 01:16:17 +0000 (UTC)
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTP
	id j76yqWwLPOzKlj8IdqwmDW; Thu, 21 Sep 2023 01:16:11 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id j8IbqYnuGM2thj8Icqlket; Thu, 21 Sep 2023 01:16:10 +0000
X-Authority-Analysis: v=2.4 cv=IN8RtyjG c=1 sm=1 tr=0 ts=650b995a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=XNLVCjSSWbVrjixA0bgA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PZ4vBUkC/xVBSr++6sHD+qEJULVjjozCngo4jWWFAYU=; b=KY/MmFOPz7/07paIfh8cMuB+gO
	0uOSw+k29jK/MEsiXALOrdj8zegi7Kn4fvvA6dsz+KJA7dYAWVtS3DHkBwcmhL8lGQ7qDvRzYykW1
	N4gBPhVoP14jPn0OAXkr8+2oWmsyW/PnSM2yXQo8hdsK37mm3CahqjALvC6baumtVAb8x098L2ofS
	rbKEsG92C2y0h47vjx69DbvA6zI36n7GEcNFnpVsgS+9mXu0t8g8PFB1EytJBICGgowu2kJHiod9A
	I6O3cxa63lLAiZjnnVeyXbb0zW2wqCFHvIXhPqxeUu7qH2NELQaRqoHj8tBYeBsUa+3jio4ry1kE4
	yIC+NFwg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:41372 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qj8IZ-0028iK-21;
	Wed, 20 Sep 2023 19:16:07 -0600
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230920112845.859868994@linuxfoundation.org>
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <b5ce6624-e434-7d41-4abb-8d911188f0a3@w6rz.net>
Date: Wed, 20 Sep 2023 18:16:05 -0700
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
X-Exim-ID: 1qj8IZ-0028iK-21
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:41372
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJM0cWsYmBBZs0t133379C5+syYU4kxEFDQVbN3tqsz1VYyZFpfwUzCaxWhuNBFqV7NM7j+AkXJoO31UQK7MQ9oVnb7qzGpKHbhuoyt/FxwjmDGDtn/M
 zHcDsBD6HYlB05iR1V4IIV0jk4XczQ8dssnbXbwZEs4J5exx61QBPQo2+XiOkYv4udu5ZmND9dyPTA==

On 9/20/23 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

