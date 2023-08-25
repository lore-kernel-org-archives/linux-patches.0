Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB481FD3
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 08:13:23 +0000 (UTC)
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTP
	id ZKF9qkZjhEoVsZRv1qTWl9; Fri, 25 Aug 2023 08:11:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZRv0qwvMGTpvbZRv0qwCOo; Fri, 25 Aug 2023 08:11:46 +0000
X-Authority-Analysis: v=2.4 cv=JcqvEGGV c=1 sm=1 tr=0 ts=64e86243
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=UttIx32zK-AA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=-AzgORsN3iX8tt9mf90A:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SCiWYzsVolO7w3Wa+gemxZXSn/MaqliOj3WbUz/Gx98=; b=LPSeodhK9q21GrZsAs44/bozZv
	EkesParxpwODw878cGIEu78ujaMZzrVaj7Bx3LREfelEI4/ja+LB9yXmEEoMttQHf/MMxnv0pss2G
	lYeCCEvexpGg2sF03N6TvfOj3xrjIDvWEPqljaZWTnx/1t+ALXXeKh2C931XoROFLYYYq0676mHXf
	fL2bcVYdmtYrqsJXZW4LRWz09kljcNFBgpivqUkMiB6bfxGY53pURkSGkglDk4TmD9xNcW7bX5UEK
	hLZZCVF6jeFs6DR5JsHuJDfW/ecJK6dJ1OzaUkpmA9+uA19yjJTuhasQNSDza41T/f32cTqy/PH85
	rhfnORmw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53070 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qZRuy-0014FF-0W;
	Fri, 25 Aug 2023 02:11:44 -0600
Subject: Re: [PATCH 5.15 000/139] 5.15.128-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230824145023.559380953@linuxfoundation.org>
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <90797d76-4a3b-8e39-62f0-f7da1d61e47d@w6rz.net>
Date: Fri, 25 Aug 2023 01:11:42 -0700
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
X-Exim-ID: 1qZRuy-0014FF-0W
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:53070
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBpdyLpLCPN2j6uEh7w+c9k1aWrXnzsuMLPkkGaEA6Qmnm85Jye0gXHJGYGGO1IVumHJzzjSokvIN4aBScKz5MqscmqJaikQbwkNiUFeyl8XLkNlLLEH
 yyTnek1a3SmnZ/r95r4kVytrGGW611hF+t0s27gKL5kLeJBYfVOBKUP8ec9fBAangaSb9ohGxQTnXg==

On 8/24/23 7:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.128 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 26 Aug 2023 14:49:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

