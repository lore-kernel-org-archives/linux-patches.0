Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E5F1FDE
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 10:14:54 +0000 (UTC)
Received: from alt-proxy28.mail.unifiedlayer.com (alt-proxy28.mail.unifiedlayer.com [74.220.216.123])
	by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id A255F803410B
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 09:50:49 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
	by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 9FE2C1008A0B9
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 09:25:14 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id oLc1oDJ75Bj1koLc2oUZHz; Fri, 28 Oct 2022 09:25:14 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=cfMXElPM c=1 sm=1 tr=0 ts=635b9ffa
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=Qawa6l4ZSaYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=0oICYUvbRubpdfELCN0A:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ac3xIBIBoop+J+Z8129aC1dDGZl7tyu8mfy2myC8Fvk=; b=x4owMx0QRsyeFEIHd5Umik1fLo
	DEUBUI/0mWXS4KjrdBc5SI7JMHLO6kNcdJ0gazLZraNWe/3bL8GkqLuJQfhXD+YARovn8qQq6Gmqc
	+K6iC+FxrULohocw/HIg09Vj9WG9xVMob/J8dOXtLxdN/lxYoq18QscnrQcntsYuzB63jeITyDjPo
	KCEdt/B6Y9QbPOzBX5AIabvxHDdSJ4fWTVizA+iJ6EPfEEGLfvphKR/6fv6cL6dnLXWNZ2oQKqEOf
	xIl+EDA0eecjRSq58ptzTK87iKTi7q3Fucectm0zYrAFCihfZjOZeg7VagsG7oCw3bAotrib4LGzP
	Ny6k+s/Q==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:55666 helo=[10.0.1.48])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1ooLbz-000rNV-KF;
	Fri, 28 Oct 2022 03:25:11 -0600
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165057.208202132@linuxfoundation.org>
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <afa3559c-09d7-2328-73dc-88bad4f4b374@w6rz.net>
Date: Fri, 28 Oct 2022 02:25:07 -0700
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
X-Exim-ID: 1ooLbz-000rNV-KF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:55666
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 10/27/22 9:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

