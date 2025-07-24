Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7EF1DF24F
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 03:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753328180; cv=none; b=Kpj2GFpvd32nN0Y6w9x2qH+l0SG9H3U5WQjfLBZYun4/sSLEbKSvtzwtUOlGNP1wtWqUXjJyHFQErbsCeJrOjWTr0Sykd7v5FwvkxCxQFX4qTkq+875rnhq2qLlvgeFH4eqptQhDV/wTfo/GHhv4urEFCX2gTw8ILxZKwny7XD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753328180; c=relaxed/simple;
	bh=6RGZZzwq1RVcl552iNQdR3Qa3UKwnf49Lhs6Z+EddBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K4WuCPYTc4S5KxnxId4J9R8lf5jISB2ptlIrgKU9qK4pe8o6fgMqO7Vg12aM5NKbwpGcpN0M1qbooCvaMeWiW8anG1BRBMiJV9wCKrEPaInQLOSuwI/miiW4TSr0RF30Hbonir5Dn0QbBmG3JcbKk3szCrd7s507b4Q83h7tDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JFKjFrQ5; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JFKjFrQ5"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id efK7uUF9vf1UXemj9uL2u7; Thu, 24 Jul 2025 03:34:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id emj7uXc3KG6h1emj8uQso1; Thu, 24 Jul 2025 03:34:38 +0000
X-Authority-Analysis: v=2.4 cv=H/MQwPYi c=1 sm=1 tr=0 ts=6881a9ce
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ScgFMeR7n2JIvPbK2CgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=y5LIDLyJPqcD/dy7AI+rdWrOWNWHHviMXkH8I49vgOA=; b=JFKjFrQ5b+Me+O9IIIoHIXBo3j
	KxYbrSkJglzfidy52guqzu9ZPWWfksstOK8BbBSqhT9ZQPhcfN3riDfsAleC16JAo234FEQQmeOku
	TvyOpbvixy+AmIH4JGqO1FbMqm6rPDHyXGAnH5lGNaHBLhURn/fLMOkUAfqVIUAkSBLIjCWnxZGLn
	v6C5nBL/fjigmykfcJ/thUToyxxKx6SoSyJJlSmEL5KDy6o51ZMipRhnfkX4ivJA+P356/ekPRzMA
	DirDqGUyUgqXy7c8NznbMkCNOLnZALw0798J7EGaVxBfhr98cy0QOl+5HGCdqb3pHtFxZxeuYp8VF
	0tUu8TsQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:37616 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uemj6-000000006a5-3kZo;
	Wed, 23 Jul 2025 21:34:36 -0600
Message-ID: <0a54bcf5-e5ca-4841-abbe-89739243837d@w6rz.net>
Date: Wed, 23 Jul 2025 20:34:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134345.761035548@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
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
X-Exim-ID: 1uemj6-000000006a5-3kZo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:37616
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGIhRjvUL5wVSzFXSTPyWaulE0hrVIabcbHgiZmAXHGWmFLq9iBJbBpOMXWg/5aggbq7t01BS2TOWNu6Q08wuu+gA+SWhRaphhoPuuDAbFEaPOnv51CB
 iF2Nkhd+Jf9RDsFyF5EvKhB32k2KYqvxPbtnD6rEmYEahkY0M5wy8vU9fV8TNMgE7xkthu8HtpdVsQ==

On 7/22/25 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

