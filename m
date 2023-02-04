Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8BC7F
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 08:55:42 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
	by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id DE56C10049CDA
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 08:55:40 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id OEKipmeuxMMgoOEKipAIF6; Sat, 04 Feb 2023 08:55:40 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=SuFVVNC0 c=1 sm=1 tr=0 ts=63de1d8c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=m04uMKEZRckA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gYy1Q2bXS39MClsk3KgCHi5jX7KhWTU2o29KMyE2kvg=; b=iUd9gTOpQYs6mCJ+YAqAbCLdeI
	bFl94R2Xy2mVnOLFy3MXL9/iGUPURP8xbmUO4waI0T03CSrMP4vefIvMTbHR0hsEQALuSY53pt4k8
	vmcfz4mTcaqV4NDd0tRDsce3ePdWH44HL3p1HEl2HwA7oz8tpNt3Yk3zlu5ha518bWjLsUm62Uw93
	8f+WfTaFE8BwJkUmC4CSk+lzg2MRDKYyNAYBN2wqZqOV1gjD2CihYxXhZRUUY2vSb6NMR9QardlRe
	fnL7NpQyylu35MfGegZrePJ8yYcZZWX4wPq4W/Oqg2CMD3HhA3Q+P8Ya6O27w0ZrkbzhM49R5t3RI
	PArbwhzg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53464 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1pOEKh-003UY0-Lw;
	Sat, 04 Feb 2023 01:55:39 -0700
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230203101007.985835823@linuxfoundation.org>
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <de146bc5-50b8-f347-31cf-70b5e93a4541@w6rz.net>
Date: Sat, 4 Feb 2023 00:55:36 -0800
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
X-Exim-ID: 1pOEKh-003UY0-Lw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:53464
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 2/3/23 2:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

