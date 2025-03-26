Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96811DC19D
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 11:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742988921; cv=none; b=PvA93agsmXDOdgTmSir91CIiqyG3dVeUDFlDZUOWMpoYSXKVXIBPOzPq8qfZ1m2JUddBpueQ8dseMcpBwJqiVWiAJzohPnJM6poC+Cr9weYLEmWsskYHgr4R2Sp2T4AMlgw/S1ML+RZFvd1dgHAgWTsQiHSL1HgyFDbY0VhsRos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742988921; c=relaxed/simple;
	bh=Co6ldSq2KPXZ4G8ckS5gr4x660q4tzm9e+9W6fGV5dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YRbGYvXxtC6QR3Pb6o8Ag4ArXUuXe4DY8xGYa7wVLajrA7tt7HZY9FGbXOOzGmTSV455QtSS8mDaUGTHJ3laEq0iOX6QDMQUvPGFhoAwMA5NnX2Q620kkIHkACEo2kbRH3Wtwoy5jPifi+owv78rkN9tFwWxEMUX1J2LEUQrins=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=mVEHmoaG; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="mVEHmoaG"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id x8ZLtfPzWWuHKxP2NtyzE5; Wed, 26 Mar 2025 11:35:11 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xP2Mtke8HGFuBxP2MtB1vw; Wed, 26 Mar 2025 11:35:11 +0000
X-Authority-Analysis: v=2.4 cv=I69jRsgg c=1 sm=1 tr=0 ts=67e3e66f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=qYArT0GPYVF3d3sY_YMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1Z2lRGIqASy3kC8DPqPOXy/EJfprWW4mk6E0VHwrdxE=; b=mVEHmoaGGKJWReUbZI73aE7cgh
	9Jt6mk4K6Kvfraub6WVYv0bL+3/qc0AnnyyYTECSWHXpPyRC4C3vsCLUFrcS53jTPWH2G+PAaITUP
	MF4syAoU3celGyzFz6DWTCN/n3uUe+8D69js5lSDhJT1YBjsWrvfPkvLD6zvlJ+DT7+cHW4E0+3uy
	9hW+6R1ZsBV6ZGV9auDUf5z3EeSahONr/5XCowv2RZznVaN9F1RZjYrFKvglRSnzrqXs6pBmuPIXP
	TARqsuX9S6zQhXj0zmA4MwUFddpCnwhqeJasntzLTn74pjAmvAkw2cn6BUHqmfrlDJO0SYI/lR+gJ
	CnysZSTg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59954 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1txP2K-00000000FHa-24z8;
	Wed, 26 Mar 2025 05:35:08 -0600
Message-ID: <44107919-ef6f-4602-866c-db496370fe56@w6rz.net>
Date: Wed, 26 Mar 2025 04:35:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250325122149.058346343@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
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
X-Exim-ID: 1txP2K-00000000FHa-24z8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:59954
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfI8x3sEnZFh4o8YPtIU7cjcEb69N1uxtuL00J7DIPZ7D+qRDtJee4jqmiUvPjBkPtH0e6Wkz2xXHUbuKT72kFOKcCG720415pP6Jx4lE2g7x/W0qEwil
 zk+AJl0qTYlAzpjsMy6c4OwJzmqIr8YD7Ki2GWO2CFN3+1JqNbDqV7aX6lg2h8ztT7SQM0GO6wgKLg==

On 3/25/25 05:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

