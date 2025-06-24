Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35511C84CF
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 08:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750752892; cv=none; b=oY+L+4/rKPtcfIMgPN86cAUklE36IsSa+MKGbuh17aJkE+7/VIH+4KPsM8IFTiUpCV7TfEytMcSdsOpl/CSGS/R7jWIGxqDBHd81v104aEgJfwRlxVAJ0cV63tJaC0dUvZgmEhPNVeHXERK2sFQy+M71XYtm8Xm+Lm2NhCh0bbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750752892; c=relaxed/simple;
	bh=RkBf4nk4I8KtM3ZkoAWYf2hke9fkRxO44SbopsToU6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VqCzrbgpwCpPHVewoaoyMzBMZKni4NfoT+XDEyyetba/d1+5HbnKnCYzffeYszHBiE0Lby3MHl8KmG8xDkMP4aRUD6TBmrlR9ymCbvEae5LGz1g2ScBhI2i0XpTGdx5tREstZk7ofoOEkQqgPaq9SjIW+mNCIUll0rhs/aVjhbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=o2YHCizk; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="o2YHCizk"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id TZHouTvhqMETlTynjuglif; Tue, 24 Jun 2025 08:14:43 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Tyniu4dAzrsgDTynjuseX4; Tue, 24 Jun 2025 08:14:43 +0000
X-Authority-Analysis: v=2.4 cv=TNGOSEla c=1 sm=1 tr=0 ts=685a5e73
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ggxXCZzoyZzpBF6JAq1N0F4D1piByx1D18khDkcCG2g=; b=o2YHCizkW1Anl8FTlVJE+ldGkt
	INBjDEFp9gDkn6MKBnQX7uH2GdeXw8VaCtpDRFASPm/GCqYDC8kPyIeN2pi5YZG9hJycHziGXV1VI
	suAiIpLyIjtM8f5Sx5KmEKSGZ75Qw/ZfsAJliD+80keYYM5ibIINjMDPaoi5QKnwKUZgH/LqzwJbr
	efT4gKq5EB45atkhdQN1vVG51tPkL9eJXbHHxikjuvJHvuzsA4A931Bhh3XcA/xH4QLEUnylLo/+d
	JPzNVBICyTmxbj/aJbgg7LLI79++yUocjwkGwsEZE1OddfFCcDT77frb9iP2PNhjPhUzgZ1LN+wBC
	s4ldrxrg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:50842 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uTyng-00000002Fxl-1IcI;
	Tue, 24 Jun 2025 02:14:40 -0600
Message-ID: <c8508b09-97e6-4cda-92d9-e11f27d7d73b@w6rz.net>
Date: Tue, 24 Jun 2025 01:14:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/414] 6.12.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130642.015559452@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
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
X-Exim-ID: 1uTyng-00000002Fxl-1IcI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:50842
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCXHfNMvihJeXiQ35tMUnXZaY6kMy/FQCsjdCoBeqByovXRzRlA2jXMrNZdPxzZOFCOI9BzNzfsGnI6yXwjDiBZK5tKhNDwioCdIIolyKo+pnUIijnKG
 R2JZoY7N92PxVeczzlWMObdbnNuZLKF/W9/qUpTqJRt4uSxj+ZftjlS7lL2//lJJ4z2v2UOOOBANTA==

On 6/23/25 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

