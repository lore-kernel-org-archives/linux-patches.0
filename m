Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6302F9DBB
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 10:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769682264; cv=none; b=u9MhxJWspG1FZzzCEKxka42XIu3zUeX5XkvKXiTCdNhuYxYMLDRYEHyczCgoQC7Z8BOWwmgn8xdUajJ+up6vStKW8HTOnM8/fnVyCIaqf1oF6JPTpsqZPb31ALhLnj/zO8SSdcq52CynX2um7SDKEXW74SVZJ0INgedorBfkJU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769682264; c=relaxed/simple;
	bh=2tx41fei3nw6jIMj8Q10SFMXiSy3Z9pHZBRpBKPpkWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PAHXWZiFpv2pYaVkxtaVvSWsA6h+NNiHAmbZYjtxAYOWEcG/ZIgHdUG4c24he37xtnRwpN0ryXfuW9XAlH0S/xRK1elCLZklqWbB3+rb71sG/fgTK+FId/5tEPN2G2UT20AA43zAsNhdnTqibb8YqXAQJ1Q+7gAp0Yb/KG0lmw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=45G0FpAj; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="45G0FpAj"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id lL4Vv3UqbKXDJlPCHv5ALq; Thu, 29 Jan 2026 10:24:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id lPCHvo1rBcu11lPCHvYbPK; Thu, 29 Jan 2026 10:24:21 +0000
X-Authority-Analysis: v=2.4 cv=bKYWIO+Z c=1 sm=1 tr=0 ts=697b3555
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PqBRw8ZxDWxnVXnuiMPCoF6lYKtNFi9Dy0ic0lzcP6A=; b=45G0FpAjFmp4ZRAAwNxpxfirOm
	ArrSgdBi4DloqQXpdnD1Kme9rwAX9Mkf4Oxmva+beWe0X31q6zNTYMjhXo0wER+yLvyd9o0E0yapM
	X0K51Z1XyKa8tVvb+3xHWoEMA+L1fRdY/FiIq4XvlpecN26Vkz4iy/W+XkoJnNKRFzwuD5NGG92FB
	/HW6hvLpNGaitEeLZYGLttBXB0xWV7k/ss+TEzopjzTffZnUxzCJyIE3h6m/1eSVjORThNK6YxXyL
	asNM106OFBPndLfdT+yxY3ERaxH63zUGTKHxRyj/kP9BIc108Ox0H6LRAtiWBuO1uYWZ7S2slYvK2
	NcFPfuBg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:45364 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vlPCG-0000000406A-3lbn;
	Thu, 29 Jan 2026 03:24:20 -0700
Message-ID: <6e94fddc-ea39-4c30-8b2d-411e016fc903@w6rz.net>
Date: Thu, 29 Jan 2026 02:24:19 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260128145344.698118637@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
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
X-Exim-ID: 1vlPCG-0000000406A-3lbn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:45364
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBP/LDc88C/HTbifnqPimzxybG8+9DAJcN4+0lu8wLOxEoUlffQMCkvzJROhgkMWYbHDrlAEE8qFPabRsH7PTYcvFOn2Vk8aXLsw50AxhKOSg8BRxrI9
 FtZDiDlYhl5lASsiK28mC3QjEC8h0Si0LrULCmQ6IW9qdzb8fKF6P+sd4CweMjyVl9ljTAnZ3p9WQA==

On 1/28/26 07:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

