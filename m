Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3033D196
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 00:56:27 +0000 (UTC)
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
	by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 91B8B80258D1
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 00:31:35 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
	by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id C805510042F98
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 00:31:28 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id J1HsqR4gh5FhmJ1HsqdVwt; Tue, 11 Jul 2023 00:31:28 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=Vpnmv86n c=1 sm=1 tr=0 ts=64aca2e0
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
	bh=6xjQCxcbpo9Lr0TBgzc0qHnozptu/wWKmOm+qvGvczI=; b=U/4+UWLY9lpvufz7upMy93Hx+u
	tZWRh8+NKzjFc7BtThtXj+7vc/Ub6BVE3h7tCugDqF2icVXEo9taATX4nZJMrWVw228D7uDkqSS9m
	HtvvCp86p6c8GZdE6IqedAsr0kiUY3yxyMJJmxczZzjUmNhksJ/+xaL+7XIE07+BZ6ug1Nkqu8dJD
	ZC6ppRrzd+TVGgNUydq3KWnCAQ9B3GEDI1ygFXmRKkgzQ/2lpkhqhlQl464GsQrzvYMgk9bB5+oTj
	XSwYQdZQDZQmHDu3JeJgTSOQyXpv1YCzbfDxyNu4Lem7ixIfIltzMcnQU4k0jsW+9ME/DlOm04jR0
	hlJauq7g==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:47342 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qJ1Hr-001z2t-0d;
	Mon, 10 Jul 2023 18:31:27 -0600
Subject: Re: [PATCH 6.4 0/6] 6.4.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230709203826.141774942@linuxfoundation.org>
In-Reply-To: <20230709203826.141774942@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <5a89404c-16f5-7ec2-689b-756527d25265@w6rz.net>
Date: Mon, 10 Jul 2023 17:31:24 -0700
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
X-Exim-ID: 1qJ1Hr-001z2t-0d
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:47342
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 7/9/23 1:45 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.3 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 11 Jul 2023 20:38:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

