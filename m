Received: from qproxy6-pub.mail.unifiedlayer.com (qproxy6-pub.mail.unifiedlayer.com [69.89.23.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECDCDDAA
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:23:58 +0000 (UTC)
Received: from gproxy4-pub.mail.unifiedlayer.com (unknown [69.89.23.142])
	by qproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id 2BD4D8033047
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:59:19 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
	by progateway6.mail.pro1.eigbox.com (Postfix) with ESMTP id 37E8F10044F61
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:59:10 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id w8swppGi2THoyw8swpzdAh; Mon, 08 May 2023 21:59:10 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=bviJuGWi c=1 sm=1 tr=0 ts=645970ae
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=P0xRbXHiH_UA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=r3Jmxcqcc3DIO9A5aFMIFvI7/rxGHvUUiUpF43sWHTQ=; b=AyDB7wo/Sdft/VJC+0Q+Vn4ZEV
	C/lEtrvwwX6Cgf6b2L9Nqy+BwBj1UYfQk7A0vWYKjAlaBYXnFLHHGgU0PrM/V1Fg0/CKk4Z9vYxyc
	caRCUo7n5hIic/1Asnvoxp4g8N+gTnOoEl66o9ySmnuucvZDcP0wLOTMKyiYpg8J0P74t5DMCykAu
	Il3UD2FQUweDNo8c/ze/fnde5cDVuRk78U5v9Qy8mkyWLq/fh6fnguvNQ2K6w+hxmGKvfucfxMhbs
	+kgqG48Su4mx8ICMPLSBTdOP5Rg//pc8qcGkeXGsvjmtUFf2uc7WKeEO1iFErt8WGcmuj/NHO9HRQ
	SjQ2+vNQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:37580 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1pw8sv-002wDA-BW;
	Mon, 08 May 2023 15:59:09 -0600
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230508094432.603705160@linuxfoundation.org>
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <41870c68-f577-0f43-8d55-977e93d44dbb@w6rz.net>
Date: Mon, 8 May 2023 14:59:07 -0700
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
X-Exim-ID: 1pw8sv-002wDA-BW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:37580
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 5/8/23 2:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

