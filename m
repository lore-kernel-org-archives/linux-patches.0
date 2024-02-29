Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BB315BA
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 00:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709165218; cv=none; b=WuKqzniaOwX36xqEcElEGrZM/z8RqXsENm1LlnQpr+XQ+iglwULH4jSNBRci+SPkiLyu8t/U54oenDFPezwhbLLu3FR4M2gyX//FAofbgTi7ze6eOdorcxNf8hxP/nJTuofhXN9fiJWg9A1cpRM3NCX72zHNTMrS+7/leeFfcF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709165218; c=relaxed/simple;
	bh=Hnv/otnAsfc6vNy+N/u39sTj2ipyfCftgZFmMPzENQw=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=QirfHUeYuso6vh5GBXdlzTloo9K7NPflOg/EuI+36eBXVpL8nff/Z7gqs7AIw23zfes4ohJOHahjyldYQ5wamhLCPTvnQxRD3Kw3Lz7GCzpPFHX4N5UNwgpxMyUAJm/o4wPeF3NJxoEX5nj+17B2m0zGHsjGH+xcHdnYc/6nXrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=zZ9VfmoK; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="zZ9VfmoK"
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id fNSNrp0xCl9dRfTwnrFJBp; Thu, 29 Feb 2024 00:06:49 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fTwlrHdO1z4nNfTwmrNIjg; Thu, 29 Feb 2024 00:06:48 +0000
X-Authority-Analysis: v=2.4 cv=bPgQIu+Z c=1 sm=1 tr=0 ts=65dfca98
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=KyoLkmSyMt9Nb96WE4AA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=g1vl0B9haMY9iM8RKMvJ67dO1Zo7xoSVRan/r6FUn88=; b=zZ9VfmoKaaNjuaZHADX4QbixOb
	BGcOnUy7Q2CIf8G0pJM1m38mUgdB8vDDkJ7KO1BCcyrMRhBH9cB7V1//qpd/KDWXhnPcGlm9rGzh2
	BK3v8aXK15JkGeExTdh5xqh4AWpklqC54GCO6VeKfEQV3CZVwQUJzwBUlsHXDZm3Zk/Hz4wtRIpes
	zPu7vW/ZK0KDPGAonBKdup/UM+vwDF0b07nnvgMJaAxXzQD35TNsEffUl9nT+jx8gJaAFrKC9cb9O
	eJmrFlCaXakN4faIbFBKw+kSnbV3c69uFLwIWVFFtAGkFo6T6bfq9IU1TmbTnJw7hxMakRJFCLM4P
	Ms+/y19Q==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:48316 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rfTwj-0035q7-27;
	Wed, 28 Feb 2024 17:06:45 -0700
Subject: Re: [PATCH 6.6 000/299] 6.6.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240227131625.847743063@linuxfoundation.org>
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <d63582e3-5480-e50c-fbad-95bbf639f9e1@w6rz.net>
Date: Wed, 28 Feb 2024 16:06:43 -0800
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1rfTwj-0035q7-27
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:48316
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCWkqzwdnYZv+cvvAoBbJf6wk10is0YetD3cL23a735QR8/lBPv2jBj1ZtOYYSpbl1xWzvlVMDHXEtmQw2FmsdSGIek79KYMJEHY2MMhswpeJJGC3rYP
 DuZ9Jq2fWvgpa9gHuCtZtfnmoTx0KApJw0qeeItwlt2836gMNs7ANoyZc4Ebrwe66ZRAfaVuIe0+ZQ==

On 2/27/24 5:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.19 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

