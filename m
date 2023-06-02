Received: from qproxy2-pub.mail.unifiedlayer.com (qproxy2-pub.mail.unifiedlayer.com [69.89.16.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA7310E5
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 06:36:13 +0000 (UTC)
Received: from gproxy3-pub.mail.unifiedlayer.com (gproxy3-pub.mail.unifiedlayer.com [69.89.30.42])
	by qproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id 898048028B49
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 06:15:55 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
	by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id 331E410047D70
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 06:15:48 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id 4y4iqlYR1mjMl4y4iq0kr2; Fri, 02 Jun 2023 06:15:48 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=KfEXDSUD c=1 sm=1 tr=0 ts=64798914
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=of4jigFt-DYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=tq3W9Zwk1ITRXLIn4wcA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Z9YACtn3APw63uNJMrXQcH1Znn82RQampwROBRfCZhg=; b=afI5Xlr8U0JgoiP3z4jpnUHeLY
	kTKS79kAK20W07hq+aIiIEEHwgoBCcV26e6AX9m4KTo8LVP5eTG4ZWYbzQGcFWIjSucqTs0y4h5OD
	7642CIZAUEeZtcPRpDTXL+zyi8d4wm3FhPU4Z6Y3HRVA7AbpEULkXQ3G5/ReLlGfbe//Mc9tDuAOd
	NGuTp8tBSTWegYP+6b8EMYcghLYVALl+A/ejmLI3PwxmEjccuU94kSNEUvrz9kSRxv6qWJ8/focF8
	nPc4WVG3Kb4747Phyd6z3r19w8jVuiLIOeAGSWU2vpOb03zMrfUH2KH0dpNKbjIhaHfc5s+/gJiMZ
	sxgaBJ1A==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:42506 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1q4y4h-001JeX-2U;
	Fri, 02 Jun 2023 00:15:47 -0600
Subject: Re: [PATCH 6.3 00/45] 6.3.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230601131938.702671708@linuxfoundation.org>
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <153fa9ca-776b-088c-b4ba-49e143f0e59e@w6rz.net>
Date: Thu, 1 Jun 2023 23:15:45 -0700
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
X-Exim-ID: 1q4y4h-001JeX-2U
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:42506
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 6/1/23 6:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.6 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

