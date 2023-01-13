Received: from gproxy2-pub.mail.unifiedlayer.com (gproxy2-pub.mail.unifiedlayer.com [69.89.18.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FCEBA57
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:39:51 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
	by progateway4.mail.pro1.eigbox.com (Postfix) with ESMTP id 14D1210048266
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:39:48 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id GTeGpGyRJLXXpGTeGpa7ZM; Fri, 13 Jan 2023 23:39:48 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=KvyIZUaN c=1 sm=1 tr=0 ts=63c1ebc4
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RvmDmJFTN0MA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=uJXoyXs2SWzOjiTBKGkA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Q/TqADxC6PTV7Ir/FsnIJMnQKHjYOnHI4KqFm9zQaag=; b=rE9dAZrA6QlzOfUIfKNg11Ji6I
	9Oi9DkNkhOdC0GU0Uup4gmY/FZIwHwDyABuWiVyEgZzCH3cZinjUeGA4VDrkdSi/UkRr5FSoD3cOe
	hZVH2r4zWck2WIGJ4N0BFMn3I/Lxj57BLhzy+VxctmmjwRmtf7P7Q4h9L9BIvLH32OCVt9cG+gyyw
	bYpcMQgveqaJvaJtp1s4VsT1Br44ICvXXTTm8t8FeFxhdVeXKAN9xI/Rh/5cmvSny4nhwfe0zk2td
	+Y57Aai0sDPToUCZv9YA3rTtDfT0hb58eEF7kDO9c8oAKB7IBxLpNqI5pNl426wABNNYngVTt3lvZ
	XCs+QNBw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:51390 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1pGTeF-003Z6t-Ip;
	Fri, 13 Jan 2023 16:39:47 -0700
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230112135326.689857506@linuxfoundation.org>
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <f8bca4b2-2da7-a6ee-fb21-bd7f34c2b452@w6rz.net>
Date: Fri, 13 Jan 2023 15:39:40 -0800
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
X-Exim-ID: 1pGTeF-003Z6t-Ip
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:51390
X-Source-Auth: re@w6rz.net
X-Email-Count: 35
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 1/12/23 5:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

