Received: from qproxy5-pub.mail.unifiedlayer.com (qproxy5-pub.mail.unifiedlayer.com [69.89.21.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFF02912
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 22:56:50 +0000 (UTC)
Received: from gproxy4-pub.mail.unifiedlayer.com (gproxy4-pub.mail.unifiedlayer.com [69.89.23.142])
	by qproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id 93D008034CE9
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 22:32:35 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
	by progateway6.mail.pro1.eigbox.com (Postfix) with ESMTP id 1AF4B10046527
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 22:31:59 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id xyHeo698HmSzkxyHeoQ9WX; Wed, 23 Nov 2022 22:31:59 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=PKDKRdmC c=1 sm=1 tr=0 ts=637e9f5f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=9xFQ1JgjjksA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=v/xOKGW0BsQAx53NFGgIhs2QrUVPKgaTLEUW5GUX404=; b=o1YnRX2GE7ySqkg9w9gFB4BQRk
	lshwkgQUMLloT4L5K10Sl3bDwrQcMriMe60VcC4zaug4iA2BU7pVYuOSznmtn9KfI/qVcX0GiQwdf
	PSS2OJxpm4KnvLOnDipM8Mdau58MLOr/y4pwh3BgJ6shimcsxtRP1aV0FZKruoLgzvaAtEHCW2FA4
	hNUmZoa0r9PDQpyFK5iD2F0rFp5QCZpV57Lr9CNw8ZMq/LPhvKAK5Nbie25b6Mk9suGtaNzs7nuxw
	PbyVkok1jjTaYoS0OogwY1yVqqZTz1d2rSQulfYeKTfcueCnVc5vWqnmbqvdfb/roTGqJX5tXWQJT
	8bPKYR3w==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:58836 helo=[10.0.1.48])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1oxyHd-000NoE-Rb;
	Wed, 23 Nov 2022 15:31:57 -0700
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221123084625.457073469@linuxfoundation.org>
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <d10b8119-0324-4798-76a3-e34a1ad23608@w6rz.net>
Date: Wed, 23 Nov 2022 14:31:54 -0800
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
X-Exim-ID: 1oxyHd-000NoE-Rb
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:58836
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 11/23/22 12:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

