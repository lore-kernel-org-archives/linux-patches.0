Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143991105
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 04:15:02 +0000 (UTC)
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
	by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 231738033201
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 03:50:57 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
	by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id E473510047C08
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 03:50:14 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id AjvqpYCDxCmv8Ajvqp5Il5; Thu, 29 Dec 2022 03:50:14 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=OtqKdwzt c=1 sm=1 tr=0 ts=63ad0e76
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
	bh=5tnlVhL78zq2H/P2d2I9irrZW17dmc8mkbxFmjTrz78=; b=TBaJ6MUHpmlA3FvwXDCNibtzPr
	JszNf1nYu4e3uRVSRkpHkJIJDXwzARCRie89kVax9vkwdJyPQZkFzO9P8vckft9k0VUeyBHMqM0aC
	y9YglyUlMnYUkf2++2GEUy5vqtBveLk097EUJ3vA6eCA5nwqD9TM/QEOdeT26S2gVzVn1YJTtbyjD
	7zVJFfHvknfScxQl2PuIh6glCj9cQE1SX03aAtfFouHAIA/UiTZo6aQ/UWaZwysora43imoJ4+0ik
	YkYjPU0chpeysqoKyh8mEkaw1gPwy2E20sAO3ysUXT7nH6wjYkUvB3RtC8rGF4nNDBvVzVX13+Hx2
	cBtBcscw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:38754 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1pAjvo-003TXf-QA;
	Wed, 28 Dec 2022 20:50:12 -0700
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221228144256.536395940@linuxfoundation.org>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <2b8a8df5-f588-02be-2ec7-d685cae2f8bc@w6rz.net>
Date: Wed, 28 Dec 2022 19:50:06 -0800
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
X-Exim-ID: 1pAjvo-003TXf-QA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:38754
X-Source-Auth: re@w6rz.net
X-Email-Count: 35
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 12/28/22 6:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

