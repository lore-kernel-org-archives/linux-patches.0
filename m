Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6389EEC2
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706020427; cv=none; b=qTEEgXIH5pJpGpTTqQnR3CpUhHuh6Opiake6O0lwzhHwir3TemKqLtToNRyrL1rHCEEZfIw8X9M35VR5P1n3aN099iS3UhCCmGmN7TKqWUz5Ll+5+VluoSHktNw47jj8nF5mjqSpj35jZj3zCxZLe474qeVzvWu461jZVGiHY1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706020427; c=relaxed/simple;
	bh=3mXdbmbZ+YHndnkHsHyyt2OtKuuJDhdZwwY3P3f+pYw=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=Ls85uOt0Vsg43Ue7gnZ6lHjp/rhXLZxSSDVeyA8si9Xzc5lGOHVCVweCO6UBShVaNfCtqpK7aeETUfq405f8pxsqOdmd9RSxaBk8tj6y96tgh6EDEmr6ZIaim3Jm04dL/qhoJSvOZUdSNgWNWVcbKZty1D+vq7kwr9cpnP3Gggg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=0ryTnrSS; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0ryTnrSS"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTPS
	id SHK9rVi0iAxAkSHqjr40wT; Tue, 23 Jan 2024 14:34:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id SHqQrWLylKleDSHqRri2aL; Tue, 23 Jan 2024 14:33:43 +0000
X-Authority-Analysis: v=2.4 cv=KcbBDCUD c=1 sm=1 tr=0 ts=65afce47
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dEuoMetlWLkA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=WDs_JM5VsrR4o8Qk1JsA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jrJLpiSrOO6NjeIfLfhdPqBjSqk6LOfDMkioxBUpNBk=; b=0ryTnrSSsyZr1DDi/+MASkc+NH
	N9/U2OSr6YL4t4YcjtaiOuLPBinhm15iiWVbIB4NV3SSd5VXLxXTnFNFu7BgNRiN9siP3RriCL+nq
	Yr4ZqTFskv9vKYY95NKvOUl53fh+KP2Bn1BraDfP2Swky3l6OthMe6d2Ur5EQ0R9tc4DLLMuwRlz3
	rcabFM6Hd9pLG+R6Fe7GHtQ4W2QkP4047XqSXoZS/I6fBeKW246Zna66AAlv2yJ/tDx78g45Tvo3Z
	hy8+mguIORnYIfSQW0buVc2R1dnNVLLA6eUfPanhwNwKM9h16XXp93TsE4ud39Nub484/jWLM3Bfi
	4QWTzoAg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:36662 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rSHqO-0049d5-18;
	Tue, 23 Jan 2024 07:33:40 -0700
Subject: Re: [PATCH 6.7 000/641] 6.7.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240122235818.091081209@linuxfoundation.org>
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <3a6e56d2-9c7a-6b80-e19a-1cca89bdb82a@w6rz.net>
Date: Tue, 23 Jan 2024 06:33:37 -0800
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
X-Exim-ID: 1rSHqO-0049d5-18
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:36662
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEaRQAAhFIKv8qORdHdEBoXcq8AcWW48E+2eDYmk9EtFzMYdpKsn+lflfC5PbnaTq3/IAdiCShQhCSD58NcRZw2JB2Y6HcXafRYBYN60anYHEI5OWHsM
 ZmkECZ7wUbzyFXug2Frq0ba7x5gm/GQzsPPs5y4oWKTLD96v5ZKyJWtN5mbaLtnWofPYPCdOT9Vj+Q==

On 1/22/24 3:48 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.2 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

