Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA24913777F
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 07:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733558031; cv=none; b=c6+3BpLTF5oH3H3RYZ92QYjLi1ZM9ZEzIdFvNE5DoMcIm9Vx15EZfRetemLCtXiNpYtPsrOdNFnNEpILKZS2wOByydAitCClDRuTnqlCy9SDu7LH3bjI6MnqFpzdN4Pl6aWiMqhrc/RvdyJDtU2iqgB1IVy0mNXartxMzQW8Tdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733558031; c=relaxed/simple;
	bh=esN7QsntwI4AA1UJrsf/v0wSrB5LxUaOwlnCZFn0Rcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vff8vYvB1zfNPjwntr9GB7fi02+NgSxvgLDIojQcpTytBRoHGeYq8LIlEDuvxSUO2+jQgMPRwUiKo29wtl0UT8WubY04wkQn0GtMfhL0meFUrqVnLkFeWl4Y5TvNHU26ajwwuTuA7D0y32NnRv0HJQWIoJBVq5DV/hgwtP3bQzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DmHAHXMO; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DmHAHXMO"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id JpGOtvYtjrKrbJpdMtQkgf; Sat, 07 Dec 2024 07:53:48 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id JpdLttFGJmNYjJpdLtvCs0; Sat, 07 Dec 2024 07:53:47 +0000
X-Authority-Analysis: v=2.4 cv=fb9myFQF c=1 sm=1 tr=0 ts=6753ff0b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=28vsWALzorOhdgl1oEpWYzWCOsWhDTgvkf0wFHoptoo=; b=DmHAHXMOEOQMZpqS0neCTg9Pdz
	z7gD+QuNJY6CHnwzb/axj80jmxgy7Iu2UIp+y8tLH1v7mjYCaKievPdjHouSAvYuaOCqJ+EKTdPDm
	HfEzbamnICk6Y2OOwakVUkOVZcuaRaR+WrMfZ+ZrA6OxTNUdiXJ9F5W+sPSuz0vJtSGIriJCRwAAu
	svz7ozKpP26rf5I3reRftPuYYqyfejnJkE7a/q54QmjvwJxcRVYZ9Fv1BukX5R/kwKnorJb/bEvMM
	w3MN4mu2Be9i2PsRMtXEMQYHpTGUnzdxb2TKapVoxJk6fuGeyTEjwgosYd3zoatirRAWRY7fqPFhZ
	5AM+voiQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38480 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tJpdK-0032ua-0h;
	Sat, 07 Dec 2024 00:53:46 -0700
Message-ID: <ea363e0e-1072-4c32-bdca-0175ab90fb16@w6rz.net>
Date: Fri, 6 Dec 2024 23:53:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241206143653.344873888@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
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
X-Exim-ID: 1tJpdK-0032ua-0h
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:38480
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfA5gLGaP1UqIEK2RE9y6wWQmsTCPuTqi7aDMAclttzoscZnVPhffZrpbU2xPCypbn56isPgPGGZmq4ZY60wCUeB6MjQO0LhlPOwSIwJOZtqNkhfgowOK
 hFvCoO+oZSuFfG91KUsAehoD9MKDrbK9UDqS2UjwlMfShU/VqHvncgUFHEoyOJV+SZmcMpv1bChq+g==

On 12/6/24 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

