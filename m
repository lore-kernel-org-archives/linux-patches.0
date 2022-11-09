Received: from gproxy3-pub.mail.unifiedlayer.com (gproxy3-pub.mail.unifiedlayer.com [69.89.30.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837992CA8
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 09:04:06 +0000 (UTC)
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
	by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id DFAC11004624C
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 09:03:53 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id sgzxoFnv3ovtqsgzxoyyWh; Wed, 09 Nov 2022 09:03:53 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=PshW0yA3 c=1 sm=1 tr=0 ts=636b6cf9
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
	bh=XF9yyKrz5CgvEO/mCLtvKhJ7/hpe/DZmnh/fTLbwhvU=; b=CMImFe6PvahZ3kiz7lHSi1Tamm
	NOAjZXdGyqu/Y6t2NbZnz37aD+zCHHo8Az5fzkNIf6+3c1V7QsGPY8QjiFhb3Lj0x4nxeq5+Is5tO
	euoJWW+JV/8KGQBxxMgKRKpM2FldAz0S9ZBaZmNv/zOTda8+OYFN+uI0MUyxJPLt+6mXX0l4Im3ga
	Y1IU7IDstMMekgw+HgMcMHQo3Rl7SvSgU52Pb5wroMCicTY4c8TV9IeAObArFUSPoOiwXq+jL8HUa
	PN+U/Kh4FTBkb/43Jrob4JEbsT5Dg1V4yP7/+9fxHMc+VwFwF0e25xJeF4u0T9qoMBX8S5mkzpt4e
	klOGxZnQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:57196 helo=[10.0.1.48])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1osgzw-003QVI-P6;
	Wed, 09 Nov 2022 02:03:52 -0700
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133345.346704162@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <9aa147b7-32ba-96b0-4f58-da25ab09e1de@w6rz.net>
Date: Wed, 9 Nov 2022 01:03:49 -0800
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
X-Exim-ID: 1osgzw-003QVI-P6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:57196
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 11/8/22 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

