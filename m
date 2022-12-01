Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A0B10798
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 23:09:59 +0000 (UTC)
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
	by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 9AA0B8033B6E
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 22:46:18 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
	by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 83CD3100455B4
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 22:45:42 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id 0sJKprUW4WeeU0sJKp5AV7; Thu, 01 Dec 2022 22:45:42 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=TIeA93pa c=1 sm=1 tr=0 ts=63892e96
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=sHyYjHe8cH0A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2KJtrLILN+pT1iLsHsrn8W96EsY6GQ6YuMVEiFFxtEQ=; b=I6V+si9giEis4Q40SlPGd4sMWl
	YW/dAdCzoRMAlbzXHhWbjG8E2VfdHyXID3DVDeE9nwi0AJFNm7NnlxgUlVYVyxAzOoK9TwCjLqjkg
	SjggyFkQc2zHsniJ3wCbmJfqdk9+nN5BJ5KZds20lNQlDQGGO+TLFxMwFAOslNwoACnL4+F/wi7cq
	JGMr+TNtEA3EXp8Je5VoC1rLxNE5XEHX6O8F1Z/hSYy8cM1OdHSFmNLe/qbonOWZot72xiLSM05oe
	tE44/cj+x7/WzxfXFsTaSqEIMvRQStwplOtbv+D1Lgy6yHVnbtzbTHHr3tMz7TVkP5hauNxjouSGh
	K8r/OTIg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:59700 helo=[10.0.1.48])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1p0sJI-001rT7-OE;
	Thu, 01 Dec 2022 15:45:40 -0700
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221130180532.974348590@linuxfoundation.org>
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <466967c9-afc4-2bff-a7f2-3b3b00cf6153@w6rz.net>
Date: Thu, 1 Dec 2022 14:45:37 -0800
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
X-Exim-ID: 1p0sJI-001rT7-OE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:59700
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 11/30/22 10:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

