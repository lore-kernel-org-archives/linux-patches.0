Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8138F58
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 03:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753329340; cv=none; b=c5YrCiZSsFh10uarko44JOz8a3AOFG20UDxr2PrFiNHUIBG7Avj0DPGwUl70rAJrIMiLtgY4GgnH7bsDwc0IZOx5y+/MCYpui6vsfC4QFVbs0s9A+KwYZoOcsRvigPh3311uhT2AwQQtXXsjraWoOVKCTGkI5AUZZNVvLWiPAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753329340; c=relaxed/simple;
	bh=Oarvq+wQqiFzEyNJw/6RYDRteFE1q10gB5gGU70BGzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAK9iEbN80gGMquSSt6RJcplpV5YHw899UU+vNHs33EOtxwgtXlHaXdyRwpQyQX1pn9zV8WmSIBYzh7SDZcjj+zV3tvk/+c3aq6X6+bi0FF8XRNEGg0cqBYbAQjkb3V97+i0vDVTSc/VBAHAduLN+oSpqyRo/I9E5d7LYQrsMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=GMjQAnch; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="GMjQAnch"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id eZf8uFA42OFUaen3Lu1XGM; Thu, 24 Jul 2025 03:55:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id en3KujRYHItcUen3LuL5WU; Thu, 24 Jul 2025 03:55:31 +0000
X-Authority-Analysis: v=2.4 cv=F5tRdLhN c=1 sm=1 tr=0 ts=6881aeb3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CIo_2QJ3nJB9J6BkDI8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kF1JFqSObNDfCWx+LTptk98C2mGHZ7Lrf0dTfA2MK9k=; b=GMjQAnch/ncY4T+eOAxMyxMZES
	QzBEa6/f7SXIBZ3WmqpT8/bnsjyr5YwyFN99QCZxVQ5pEnJOS8w4W/+pNZZ6ACeFk9I8lEn4WaoZg
	c3BLo7NsVNfx9ugnsQv9ZEGvJi1gekfqeTn0owsATcz8DwuZlgH/ztUK+PRmDqmn1BhnjXPtsqUQS
	ZhVM0dd+8+YeNcimcUgmoyR5O4jUPVhZ7TzWhS071H/d3qsYyYjgafu2FA5hS5amq2e69jB62EiCb
	mEPTcjQejdJ5k5EIiyIG2x9gVW9p/L8RK8tLyLNMC8NPNevKE1QhjlRFcWnhmth5IDYqUVQmniK9S
	MF98Ta0Q==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:57774 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uen3J-00000000Eiq-2tGB;
	Wed, 23 Jul 2025 21:55:29 -0600
Message-ID: <b8ba5911-650d-4a52-8eac-104dee740770@w6rz.net>
Date: Wed, 23 Jul 2025 20:55:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/79] 6.1.147-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134328.384139905@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uen3J-00000000Eiq-2tGB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:57774
X-Source-Auth: re@w6rz.net
X-Email-Count: 74
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNrA4xu8FmJTq5XtO0rWA62ba3Q5zq1wWs/jFgLsd53HdkB3ONTYlH6JayJhf5Bkz5lAl0fuJzlY0zrIEtk8PArXnV51Zn8hsuWJJkAn5+BwZLHRqrqZ
 qsyELRJDYk3LnPdQydPNu5duPBkCgZi1YyK7G4LNNDkmX4xlIVAyLuhgrwxZfeJFql0QeDGeo+EkuQ==

On 7/22/25 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.147 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.147-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

