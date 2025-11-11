Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D4430E82E
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762867696; cv=none; b=YAi7gFKp5jEoLQ7GbCOQyE1c1sZwRhJv1y3JsFS76r1pH6/NWCxEBrh3TKINq5Xl0GzavgOufpn4292pRihtWE3LQvbjg4EZ7p51bNi93/rdRGlneckSM85Iczwn/kODGBwa0cy6AS7yEOCKAc4hgkPBLY6BZW/QSelt29OuRw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762867696; c=relaxed/simple;
	bh=c7hoMpsZ/baVmjPyu5d2MW13scjJuNdlGhc8XNhuo2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eCWeQMDyosn2uF+zXxh+A+iDlqlDUTIU7+2x4LGSxyrqtsn0kB7XHbSFPLN+sPo18AorV/Tm3AKBKy+rvjzJNJvyrZZnz1GSC+lw4AzT+naPldJpzDc9aM5quGVLoB2HbOAlUyRcYuUBZI91TrYnVI10bn4FM6zwjn/WPPHzC7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=eMH7JEr8; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="eMH7JEr8"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id Im6WvPIKbKXDJIoPsvVvYW; Tue, 11 Nov 2025 13:28:12 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id IoPrvYdmK74Z0IoPrvem3o; Tue, 11 Nov 2025 13:28:11 +0000
X-Authority-Analysis: v=2.4 cv=BuidwZX5 c=1 sm=1 tr=0 ts=691339eb
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=PvfcHcKs8vLJRUA1CEIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1nc8SKrnLXmD//D0Rk4ZCLqJKHJMABP0TbWA7r0yOH0=; b=eMH7JEr8ETFiBRX7p6jcZwOC8O
	fYli8+6MWQs/50JgiHfAXsXSKWSdLNsnMzRtUlpsPwh1yl4+lPdRWr9Jam328enF53Sdvixd0CIo/
	fcB80SLfz53/NU3RRu/7nPrCk+GK0nx/nockKda6mkbZw4f2Ykvsbjy6PIFmse34zbJCrgxk5u1SC
	qcQelPi0ca/FmUQwGOTccFwCUoNd2QYBLXTXeLrkjEYRaBU+4ormNnZgMaChbKU44BQI+iyhkDDkB
	qgHO8YMAqGTaqkAH6I7OrwxlzbVpf7EYK9/Xj6Jh+nMY1lylQGja4OGAgB5W6n3/p3W9o6si/n33i
	5G5YvpAA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:36292 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vIoPr-00000002Ewj-14oO;
	Tue, 11 Nov 2025 06:28:11 -0700
Message-ID: <e3b75b12-5306-4515-bf9b-f3605a11bec4@w6rz.net>
Date: Tue, 11 Nov 2025 05:28:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251111004536.460310036@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vIoPr-00000002Ewj-14oO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:36292
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLvhcHFMmoWOeDJh+TjiqVg2ERsxtnjuLpIL1nhXTp8Yx03H53KHwinTozCLzB5EfvItmUESXnxGU8F7nby2JikBdoorpaimdlyhKF0WuC/8CjiGJHrd
 uHZcPdbY9sWC3uWQWMtTKdGhOAE6Un4rg7tKWJLpXeY9+70IdxWgoNVX/BNcuS+KjLhNPxTCh9tSNQ==

On 11/10/25 16:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

