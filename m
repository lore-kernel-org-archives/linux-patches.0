Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC73836D
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 00:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731715926; cv=none; b=ATUqXSfMheHqRlpcAbzRDtyxZZNbIQFA2IZlDC4owu2pKYcpSQ30JeJZe7oIz0M3srMrmsmhhS7PAtWdeeGIAFKE3YaXoQmZXlJKWb35QhX584uBxUj9WC3nR5AmGPWM9WtKadTEyyee3pGv90M4oWQcsWqFjSoJSBe26NoO/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731715926; c=relaxed/simple;
	bh=Y6ucSegMiZNxU0GjhASPfY1PY8RNWBlsE/zVcIgEAik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gsrGIbkif8NzNkpY51G81E+4frATwcT37/xaQFAq5fwKfcoKio1e4B0C4vHig/ieyJCKJ0esDoJz89PNf/yRNN+Xt2h1JbUp5ttJM2oJsGEj1TRe1ItK97gnQThcJeYvJovwiu7Cm7hQZkFqUcik9U4avkf3i7sZFRm8bnxFSow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dVNHcI8p; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dVNHcI8p"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id C1qCtIviuVpzpC6Q0tuGvQ; Sat, 16 Nov 2024 00:12:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id C6PztQhHg5BVrC6PztUcsX; Sat, 16 Nov 2024 00:12:04 +0000
X-Authority-Analysis: v=2.4 cv=Qv9Y30yd c=1 sm=1 tr=0 ts=6737e354
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=l_-f7-u7_j4nK6mRNekA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gP8lDwYQhs/yL6Aq9LMMJ1T/8YvadtJjp7zovNXWkvY=; b=dVNHcI8pMvCb7k+uwESbBS/kkf
	UqYRNLI5SA6Tc4qrhmGI2XBBoejH/9Sxi5MX3jlyVr2HuzAWBEyqRwb3UO0Als5rOJ4QenQANaQBV
	R8APRASu2TAp8mRFjha9lnhobeYzANNpcgzH9v/xEBLgp47FU9/8KPUhf0rp75D996vTQctiRSB/s
	/ZXZ8DCAsEstV0z/eovA+JXAr77+sLwWx5cgVIBUuzM6gSvkjUJRh59Cs+vOGTblyruNbnL7iyETe
	Lp2/lyqWk4vvJTosldPhXvZDqje64yiEqVrOVXNXnnKqD3qSSqZV3a/mNEAVV5G9O9QAGRnU4xQj5
	UfXfynGg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:52226 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tC6Py-002txU-1j;
	Fri, 15 Nov 2024 17:12:02 -0700
Message-ID: <20714abf-7249-4610-a59b-d87ab4b7fb16@w6rz.net>
Date: Fri, 15 Nov 2024 16:12:00 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/22] 5.15.173-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115063721.172791419@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
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
X-Exim-ID: 1tC6Py-002txU-1j
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:52226
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfB8Wt1+d9lloFbp5XKOgKx6UbCRDGpg/K5RGbLm601iDEsVwb7GzgSiOf9yFEWvPMnrthJgrKVarbItXRdNh/Sq9Kuib2C/TwLYGSFCBVZEJ1V3I5f4W
 gXJ8A6lyTaJFui5zfFZZUuvDT525EQeAsC4AzI+spR0F7bwAQyhVYWca3yf0GaE7J704X8/Tc8a9VQ==

On 11/14/24 22:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.173 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

