Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69738C8CA
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 09:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="fy3PsvTL"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id 3QQ1rB7iaL9Ag3YaLr2jQf; Thu, 16 Nov 2023 09:22:53 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 3YaKrzQ9zkTVW3YaKr4G2u; Thu, 16 Nov 2023 09:22:53 +0000
X-Authority-Analysis: v=2.4 cv=a58jSGeF c=1 sm=1 tr=0 ts=6555df6d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=BNY50KLci1gA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=F7X9mGda89njDp2BEcwA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NM8jkVwrFZLWiI+4u2fyE7GqD81oaTJvochMnd5GERE=; b=fy3PsvTLfv+cuiMFikKSTkyrU4
	sKJktMJhra/FHv3E1/nl0PSVrTDqktI4ZpLgySDOJJyIsnaIC2psXpf3/s/f5e/Iqb8dcxOeODKWz
	SVV3tpSI24rSblJccE3yndO1hOSPg/jP3FZa7DJ0o4OnEUP7Lzw1YgKp7Sl6No9uXMQpLdQp87hMM
	00If9KdnxtPpiF+UnfgGsMJ14TOj7X4CisVTll60tdLQTYwhqzbv1eTr9aCido183eLMuebGXClBH
	mEGZpSe/OyBfVEXCLT4+TIAGUyCJHnrBz+K+XScl++7S7bYz3Jr6Awkrpeb56v0dfrcRdyCQ+ckj6
	KE6m8QzQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:55394 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1r3YaI-0047JX-0g;
	Thu, 16 Nov 2023 02:22:50 -0700
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231115191613.097702445@linuxfoundation.org>
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <a9c00e1d-2703-b178-aa09-11ab07790f2e@w6rz.net>
Date: Thu, 16 Nov 2023 01:22:47 -0800
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1r3YaI-0047JX-0g
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:55394
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDSLXDxPfrcRsihxSU6JkFonVnze4wDKYUfvA5PJbG2GU7vsFZ0R/B0WeISTqIVytYNZ0xCeuEDL/0EjHwboRs1yP72P4NQ5aarfrXjBgK+5QAQMhJnD
 KccjT85dYwasSHN31ojT0oWMU4oZOh2UxMxJpRxmdwl1oc3UYwXLi6aM4wgQL7W08ZSY+8cLSn8ZLw==

On 11/15/23 11:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

