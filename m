Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22517464
	for <patches@lists.linux.dev>; Sat,  5 Apr 2025 02:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743819111; cv=none; b=kYa8pRwW9UTZXWIQxd+O1fgxHkxXB2jVpTIEX4g95e2LjdNTxkhRwh0A/sFmMD5HBcxW0s6AfAaS81uhYA3iVLNM8LZngIjOQRikDuI4XZ1Pfkk3ILCUw6eluNaA8J3OEvxT1pjD/wJXTbPYzgRG8xtF03qTF0spxNfAhpHAELk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743819111; c=relaxed/simple;
	bh=i28rsqTkL0yCxQVdtr1WhAy4rZHhalYgykYNnCQYrEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fL5+NrFf4D8lycMkk3ws2oDR8l4k/hfFrGXtbHUTlvGBHIEwjIwtJALbyfkn2cMX0211/wsCpthHpXkzMRQ5LgvSQBpeTbh1OiCJ8bPA765umZO9/AfhmIFS5pT9Cb21sG7QjRHbJ79csnOEGCkIzmhMZb+NDlGpQ5A+E3acDqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ZmtxkZ6B; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ZmtxkZ6B"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id 0rRiu6vmQiuzS0t0Yu6GXg; Sat, 05 Apr 2025 02:11:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0t0XuyxP735Dw0t0XuztUM; Sat, 05 Apr 2025 02:11:42 +0000
X-Authority-Analysis: v=2.4 cv=IeWBW3qa c=1 sm=1 tr=0 ts=67f0915e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CTIpb7JmY0c5bVNJeN8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=aGMqSPDx75PlOjA9guoqkzJBHGzvYNjkN5Ly2HoZxH4=; b=ZmtxkZ6BUgOp9TbQmnTTm+wfN1
	eQoxfqi7shbOVbpk4kImVj7mFwhR3cg0u+HB0huEXGEthNBvhdsQgXGh1nGqz8IaUd39maBYHwD0s
	6bprzRjxX5oeC9Ysr/2nzFL5PrdlHN5W4Op8V868JVBNeDhEukai/b+GSjHKdsUWjwehZyBbZmpJ1
	uThv9cTkwZCDbYXDuyIRC2nXAfbNMcdITbWFABpn5vY/+U3oMgPbJGxBUllgdYfBunZVGwbMepr5I
	9Eud5NMyNAWFQOKaXvmPVcSdAdR67o+CQWHOxKYa9kQyT1VIaFrGDBxBwyWQd30BCP7Mu05Usd0VT
	Jib+dvyQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:55020 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1u0t0V-00000001U71-1b78;
	Fri, 04 Apr 2025 20:11:39 -0600
Message-ID: <816d0ebc-fd6f-451d-81ba-8059d3098f22@w6rz.net>
Date: Fri, 4 Apr 2025 19:11:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 00/23] 6.13.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151622.273788569@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
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
X-Exim-ID: 1u0t0V-00000001U71-1b78
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:55020
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGU+bTvbhKeMjkZo08MEo5jKB94XL3s8CMCGiW1qVq8Xj2iJwPM244NoKdrssbwt3v5AsUbPqy/v6RuPrkV7eTU43MrG4vsel6oViQ0Iz72Gz2JmtlEa
 JlsfpZU6F1OwHZwy7itaiE+5Es4g7+89nzbZz87TidEF8RJ9OJM0RPi0VQTgbfAme5t2Do0yXeDdIQ==

On 4/3/25 08:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.10 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

