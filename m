Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B5D1802D7
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223423; cv=none; b=s58/x//NBTztwK3hNZUfxfxs9TS/aG+ltswh6rbM3r9n3uJH4pAgmIvd6i2cO3wWZw2tjcR9qBSDhx29odTrXeiZYwdWmcE2WxD1sWWgMdPXEF0G4dbukShShqf6HVijzSk0YJcA/s1B9zCGtRGpFonOOMwTdH6WOUBF9j78sxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223423; c=relaxed/simple;
	bh=gFc25+aTieHILquz8TZBMxHk141z6MjGAqix5s+Bb6s=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=GBpOqaQ6igyUIJovRGI7KS52xOPGuYqmPRhbKr700uUVfSs2wwaqIzFm0cZEnE65Vmmh1uccp0gYe9Wn4/lxo7lTuGtP/zDEKbYtO8JmYIUfTEM8lEVpEB/u18Uhrl2ftczoqZyI9T/GytT7DUOxWTGHLWfzU1JsP2W1h091f1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=C/jFbqPR; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="C/jFbqPR"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id U2Das3QDy1zuHU4q3sGkYK; Wed, 17 Jul 2024 13:36:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id U4q2sJZThJYlLU4q3sICnp; Wed, 17 Jul 2024 13:36:59 +0000
X-Authority-Analysis: v=2.4 cv=CKIsXwrD c=1 sm=1 tr=0 ts=6697c8fb
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=a20dnE9ujfw65UJe39jtGgA9aWrGKfkl1W7y0XVG0OA=; b=C/jFbqPRpw7NnxUAW6hL2mr1j+
	M2i3yD0T3Da6lKk8B3xFCMmHk2doqy0+8GsqStLZrcH8+md0+5UZK5AuB8XCq6ayDMU4rvqWT3YtG
	tqyGa1eUEgN+ydfYiZyxS4PZu0cM9J9XzvlDNWaisly4fYnMF3dE8C8f8ytAknTbymAqhr/i9hbug
	8rguBBw0hgzwMcMU2FPMLK/ScM+YQAlrb6OK4oZlm3pF+K2D1VxMYJm6u9/iA3QgEabPSaBTOFGfK
	2V3uY6VaWSUQnQOElWAX5ELCxiVCpyxxtas+W6dMbdLGE9tEZa4/qNWgH3QTnaHy08IH7ZAOwhM/w
	wxUGb19w==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:57968 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sU4q0-000UZm-2F;
	Wed, 17 Jul 2024 07:36:56 -0600
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063758.086668888@linuxfoundation.org>
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <190e51e5-c279-ec7b-90c5-8c32523321ee@w6rz.net>
Date: Wed, 17 Jul 2024 06:36:53 -0700
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
X-Exim-ID: 1sU4q0-000UZm-2F
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:57968
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJxSj+2BYf8PEyXN7JIKK9CWYXgyrjf3X7Vv7eoZSu+t9NLNnNsc3rUbWxPnG9P5KdK/ZNYIbouaMpj09ZOmwHh4UgCoXEHbTESLAwBgMjio9+hAwa+2
 E3VlIyZ0QiMsvp2xnU0Nopegou9uB9XyRz0nA8NHmQECIawdIJUoZ0XZtx0IkgBttTIwSpOmIIj3zQ==

On 7/16/24 11:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

