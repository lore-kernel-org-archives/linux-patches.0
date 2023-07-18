Received: from qproxy2-pub.mail.unifiedlayer.com (qproxy2-pub.mail.unifiedlayer.com [69.89.16.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C6423BC
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 10:59:39 +0000 (UTC)
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
	by qproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id CE31D8027A85
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 10:59:38 +0000 (UTC)
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
	by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id 07C3D1004959F
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 10:59:32 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id LiQVqME9GNX2aLiQVqmocm; Tue, 18 Jul 2023 10:59:32 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=Zt4ol/3G c=1 sm=1 tr=0 ts=64b67094
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10:nop_charset_1 a=ws7JD89P4LkA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=d5lI99YLm0d/LNFjltWNEnBVtKyeA7OaEk8346W5IIM=; b=v+I2ulIN8T99Kz++/4cCKI06aQ
	C7E3mvGPrArNIDaMI8/+pVh+tW2keVA3pfPzOqikX3PfkzQVpo6O4nqOkaB3TMmARqe/ISUJyhYQm
	zmFx012L22QGtV7A/f3C5bo5TFOhjc7DeU8HWuDudi8TDU9i2+IIKX/WwaTSTR0J9oWHuP7W0lD2w
	izTX6T2MmMkZHGmBHpD9/Fcf6pRmdWLqxvR596xOY43XhdCrTCyOUf6zQjF2OC8Ctg7gpmOP4AJJK
	kkVFIGkbuxDluB/DfFaO6SMh0Hh4ZPPoVJAuxp+TfU2Z0hZM02F6vxx1Rz1jMQlgQLPunDj2a7AwA
	L4cUhpSg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:48330 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qLiQU-001k1u-2L;
	Tue, 18 Jul 2023 04:59:30 -0600
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230717201547.359923764@linuxfoundation.org>
In-Reply-To: <20230717201547.359923764@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <06132b8d-6df0-17b0-bc5d-5ac748367661@w6rz.net>
Date: Tue, 18 Jul 2023 03:59:28 -0700
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
X-Exim-ID: 1qLiQU-001k1u-2L
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:48330
X-Source-Auth: re@w6rz.net
X-Email-Count: 20
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 7/17/23 1:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

