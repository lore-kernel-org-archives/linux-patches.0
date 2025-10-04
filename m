Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA8A18A6A5
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 21:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759612842; cv=none; b=rmI+HkDpJXoAJHAZC0cjxTh7inRmGpygcHX3URQ6TOL6OQY+ufyPq4n3fRgwL3E8SYBGAKmHVOW3CmV4YVkhEZcfMBd7wpxRTldTWufgpc/3m/8Dg3n4RMGuQ8oR/VMt6CYgu8KJ3C9SiWGbHiLpfjFUzO4EiaI7i4Yar6/K2Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759612842; c=relaxed/simple;
	bh=COLxfDyHpjGR3dBeC7gJMCb+6mGu+U7P/OGkDjUNmME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L3Hr5kUjjNjiw2FcenlI0oS1hISPjP0cHL6ej9mqHZ0DabbepP4cI3MlPjdqY9bUZ+A4hQ3/I0J1E++ybmkYITptg+BT3GsjhXYTeqVdAMMVNxFdE6Zf7WRq1B4iIGrvMTm0FWuIXzTmqlc+XpGNOvvs8n3HX1JXBXXdESWeUw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=0DfeYr56; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0DfeYr56"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id 5937vFTcOjzfw59gGvZbYQ; Sat, 04 Oct 2025 21:20:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 59gFvVn3oFT7u59gFvwUwr; Sat, 04 Oct 2025 21:20:39 +0000
X-Authority-Analysis: v=2.4 cv=Du5W+H/+ c=1 sm=1 tr=0 ts=68e18fa7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fDHG7mFvgcZnLnLDiW3pDEXNbsGY4vBmEK3sYL6MFY4=; b=0DfeYr56wPZNna9g7pNnNSn1/J
	M1LoXG/8x4jiF134Bbm5X3mrQoBeAEWzzl7vS9QzE8RmtgoremMyDxd3tZhuAGEnTnYZM3EqrPdmJ
	iz5imjhTf6SxYSlRUvUkIE+I/da+qBOchBqht5LljSQm31vqlRV2UJbY22qofdkCbH3+DDVZh6cmm
	yMIxM7ZACb+yb1dx9NXi4dWNfX/yKeX3ZoRTf5p2xC8oEOPzPin2Igq6P9tY62JzJlytaA4RCKQAV
	QYO47GmDmStIzgLK/f8lKoiAuP0q+PBHCjOiKBzXUnsZ/S6bo9fWteerI8MNXN6llJjVFH7VXt9hb
	2bJTW+Hg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:49978 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v59gE-00000003q9C-1sDd;
	Sat, 04 Oct 2025 15:20:38 -0600
Message-ID: <3cd6ebc1-b89c-4db0-b234-3b474a53cf62@w6rz.net>
Date: Sat, 4 Oct 2025 14:20:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160338.463688162@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
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
X-Exim-ID: 1v59gE-00000003q9C-1sDd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:49978
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNFCjwhsyK2ESGv5QGSlKAEzViWXpJ4npPjp6Ej/5gVe/kTizvTI2tzViqZE9Q++ui/HOJKz+KfjlbDntthkHI5KmD/5OjWVLC7JTy4mIvY+kHr8SmUh
 gTAYJRFX9B3ReKW+MSX7LBXY5ifO8+Ym+VzKVI8dTxjf9LpJvqAhxhuQZ3X5wyJPPmdlNKs//GkJOA==

On 10/3/25 09:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

