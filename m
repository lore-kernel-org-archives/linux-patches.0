Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6DE32B988
	for <patches@lists.linux.dev>; Sat, 17 Jan 2026 06:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768631811; cv=none; b=K4eOv9/8TSbYTuIy11u/ekRClmAfYU9QjsJOuTOJ5+PzuM5RbzI6I6ONdxaFBnkbsDtmtxiz4WiWNGz06QFLVVNcMQqlJ0WaDUB8NbbRLulbLbqWoIB36FBb/lFiSbtTCFjktudHsDWkep6ve0zjBXcdfg46UbviQ/9EvTLaIls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768631811; c=relaxed/simple;
	bh=gyCcFtdJHPJem3oNGt3wp97tqgsyCX56glmrv1tzNyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TxJ/docqTcIdk7RFtloXErR5cOFM4yE5BT3GF+bq0ClWrixXq0D/V+TJSMVMH77I9vDveaP8miZd4rb5/FjUM99AJQtrkdZlEeE+Aav6g3YRD10M5ZihWlocgr9bXNfbxtj/lzy1lfldGV/EzSABpF2iewH4Np9ibrtz/dKJ9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EktMTpjD; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EktMTpjD"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id gwlEvs1SXKXDJgzvNvpl4J; Sat, 17 Jan 2026 06:36:41 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id gzvMvQvKvSqlVgzvMvwcj3; Sat, 17 Jan 2026 06:36:40 +0000
X-Authority-Analysis: v=2.4 cv=I7FlRMgg c=1 sm=1 tr=0 ts=696b2df8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=-Qcm0AZxhyoZnww38z8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mjIv8paN164TU+Lcl1WTAXTIsSMb8XQmjuh9TgIP1Eo=; b=EktMTpjDMFIr/0izhrq0Nq+6Rx
	S7vK9t9R3aKiuD4qBMlL0VxWm5nsblClW0dNEOt73Wl1HrgF/If5ufweu6tzvW16n7rRSetgu/jrX
	nNef5XKhfGGvPtg0wa8YUIaiK3F+36FTXvQZ9yvi9BTyYMMThu4bYksk2E7HbJHLTBpMm+ZTXQGG2
	BYE1ni+Bs8U4TqFoaRtiWtejZ9ozjHF6gLXfyKFVO2fC5wAsEcfKPXORhvMaRvWu/Eajw2/pfquzL
	W5b/wAnS60XCeY25HQHo1cPxg3Ysh+ySN8bpTzzB+/OuTsh+mhrbzVhHhrHHoydegopzCUOUTw+b2
	j0Wd/JIQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:45768 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vgzvL-00000003fDs-3rj2;
	Fri, 16 Jan 2026 23:36:39 -0700
Message-ID: <2aaa124e-4322-43cc-b155-2011b94b449c@w6rz.net>
Date: Fri, 16 Jan 2026 22:36:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/551] 5.15.198-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260116111040.672107150@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260116111040.672107150@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vgzvL-00000003fDs-3rj2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:45768
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLnqikXjSSUqVieIxMvqcvPLPa1yf5Ic43jXS5jaNSD5YU8WcSrK4ZppOnCIUwvv7JX4ysqX51uOShlrqIdmVkdc+i95YK+kEz+kT7vR8KpB8UapHfak
 48uEj3+fzUkLDXYpVwkKxyNzrBHNbkpqv0jXsTVSSoGwcArZ58D8C3n5eWkmTwgzQ8/7IBfcjm+LzQ==

On 1/16/26 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 551 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Jan 2026 11:09:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

My HiFive Unmatched target (which has a Cadence Ethernet controller) fails to start the network interface with the following messages:

[  121.778662] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
[  122.373760] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
[  122.383421] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
[  122.389481] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
[  122.610641] macb 10090000.ethernet end0: inconsistent Rx descriptor chain

Reverting commit "net: macb: Relocate mog_init_rings() callback from macb_mac_link_up() to macb_open()" 
f934e5d7caad6ae0a081352e91cbd7f0284ad9b3 solves the issue.

