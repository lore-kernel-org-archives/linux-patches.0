Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0F243AB0
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723578135; cv=none; b=DDVYc3sChX8X7fijGIK3OkE8OvuRr14TRp2j5Xe14u+RESCRCh+J9O57yPDtah2mg+SVsLX/mnuU2RZ2LW5rzjdF5QF4CH6C3xCXC7IbAuTKhqiX42HM590B79MxM7JuDfnK4Bk5n8KQuBNVOFeAEEAIjKJXQjWeXWXiqaitTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723578135; c=relaxed/simple;
	bh=n3BKIAMwW/k7u9jJ2Br6awULA6z0UrnTHCVhnCZxAxY=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=WxUqlz2lXo+Q/RYZBf589bhB+/kww58ZcF69tLF0xmRukyw/TsLcQ8joMFITO6Pn6Dcz2N+p/ki0q+tCbLDSuVjVKeVVFglj1nDMEVPm5CZQXTnZAIPzev0eCM1pnxJZNNezgxpaiQ8sf5hdNhybvzUozhDF4zW5PP9KlM9Nt+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=D9m5Cx42; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="D9m5Cx42"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id dpYWsxyU6iA19dxPCsuGuK; Tue, 13 Aug 2024 19:42:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id dxPBsEJ7E3wMIdxPBsE8Pm; Tue, 13 Aug 2024 19:42:05 +0000
X-Authority-Analysis: v=2.4 cv=V4V70/ni c=1 sm=1 tr=0 ts=66bbb70e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=L77ZF+dgOMyz8eIBfIoH5lLrozH6GjQOVZCmGJn8IWE=; b=D9m5Cx42XYENGeQ4S4GW1SKUlZ
	LUKa2txW3/Q6Oy3UHcXSBL8HP4pSyJUmreppNkVXmZB87SnTcZSHPW5+TWyzKmLW0rvIM76ZrtTEN
	d+7vvFCEj2zxfaF4ldgMJkQiPd9HvC4OPQwZF8QM6DIVkaeeWVDh4bo+bJU8wGFH2FM399uBc6OTK
	iWQh3KSaaXNifCMNeS5dmEhp/yodosksEUamEI2n6FGzQ7FSUMyh+IxU1u8OS7ZWEE1zNMIGO5Gmd
	hKoG6Lk/vtf6jrADkf0UeC3NN3MAjgKdRnhxuAMrRLNPXhiHWMBeDXt4+MrifWXdIq5M2G5VIlBI5
	9/CLgAEg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:34484 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sdxP6-0007AZ-0y;
	Tue, 13 Aug 2024 13:42:00 -0600
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240812160132.135168257@linuxfoundation.org>
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <7192d9a2-d857-0201-d864-74393d34d959@w6rz.net>
Date: Tue, 13 Aug 2024 12:41:54 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1sdxP6-0007AZ-0y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:34484
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfN5LVHROmxo3h0Gahxeq7PLsUvGIueBMpIoMFvi7k5ouTLPE8RGty+FAsbJI3ztAiTGq5vCg1fR/birlwnJ2sTkJKIV2Ohunz5Qm2NDPuZZAmKb0nhu2
 Md8YweLwqptmJtzzXnm+LfISWCNnf8Tuyob+2MMy/+uXIw1n2MjhEI21Nw7ODzfHFN4YRlhJmQtklQ==

On 8/12/24 9:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.46 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

