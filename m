Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB9A15573D
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 06:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504572; cv=none; b=JyUIduySkH7xNnb3ueLnRcB898Ua2qEEPThxGuOfwXt2B3uEaVjtYntcYmWkvY0F8Dz1dkXOXLrizDE6xnfEVQjlBeZbKMopWdf93aw49uohwbqyGarHlyYOnaRRPy8jGd5a+kB1ss7edwZH/j00zPP138lPTMeuYyKHNyNBzWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504572; c=relaxed/simple;
	bh=s0SIoWZdjf/Ox79tVyNTf4ySmd4bEN8l9y72XJYFqkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JUayA0/dsMUQeOHZfCyKiPgABNtlvzgHI2x8NRKiX3x1wLydVKyCWxySIzEm77pousjsLjZOnp/rsX6IJiywUd+SwBkBVKeE1tjyPIu1u4BcnjL2Tf8AB20fA29rhZHuIkBM25eWY1ZqpRP7OOXHT14ihp0oICnCu6Lzwtd+r/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=nj0/fgcP; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="nj0/fgcP"
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id NE1Qt0opTnNFGNns9tdMbF; Wed, 18 Dec 2024 06:49:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Nns8tsy0FZTzLNns8tXxiq; Wed, 18 Dec 2024 06:49:29 +0000
X-Authority-Analysis: v=2.4 cv=L+wbQfT8 c=1 sm=1 tr=0 ts=67627079
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=HPvIB9lQppeJS2B-OsoA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2u2NzoJZZHVA/i2pZn4BxZ3ktX4Ex9Pw3pl8yo2CFA8=; b=nj0/fgcP5/V3CH/H3XhmijNKck
	16KT+Lf25me2ItcJB22tg4GMyc2JUD4Juve49CJFu9W7m4A0rFLrkQL1iEdaDeV/l8T4GgUsW3qGD
	R65dWC9Q5e9NAC4lIg5w+hTZz2T6k1Qf+Irc5ZGfc+XOaLC9dvrx3zLDB4t88r77pnxwiiz2JtfOB
	1GBVBU2AdbQ4btxV6dDcHlfA2wd1zjHHkPGN/NacPwZEC7EgNSIOJOlUYjSWaHr8hDJlNj/3/L4HX
	dxfQhNfrIVRnobu4DZgfEtUtsiSLXphoDvgovT/V/HxkBnbvBeyPaiYpUXdpbYr8AZhzOF49QsQTX
	13hvITJQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:52170 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tNns7-0004rh-1V;
	Tue, 17 Dec 2024 23:49:27 -0700
Message-ID: <f0bc49ec-c69f-4b51-927f-5ae29968536f@w6rz.net>
Date: Tue, 17 Dec 2024 22:49:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170533.329523616@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
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
X-Exim-ID: 1tNns7-0004rh-1V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:52170
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLu1MFZwoyadDhHbocwKWoHMNK5wYgpVRbKOO5+4Yl2HDh31/nfdgK1E33QVnJ2D3QgRTqJJ8PNamQuyJlN9BYq5EITl8bQxAww3zY3gz3cyIquBOxJT
 3yNg8StOuNJfjP2KNNYRHo/bKM4V/xffZf1XUYNkKWjgAcJtmluTBtzICfBtFkbuIuq8R/iw633O+Q==

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

