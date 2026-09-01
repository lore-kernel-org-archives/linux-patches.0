Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB4335BDDB
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788303595; cv=none; b=hwssBRPSusbmE/ycCN981wpOZ+ZBRugByxHuItKnw+XcVj9Fz4pC0YvDgwXw9VXKBDh8XPYa9xQuPr5p3NeOfX6UTEvdHwfU67w+awLdLYp6/DuEhJWIuVR+LQHLlCSqxxW0RWLjSM7UgwXu2oncy4cumJXZZzBrWBiJ7USI6xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788303595; c=relaxed/simple;
	bh=4GMS+/yBL/lJXcjtveSASb4XRsIUTAywoH0nVOmZOp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HqJYu6qltY9OQNAvWXQyk1rTvoLZC9nOgLVhrYuNFFlQeXVl+u3vSXuelcOgmMnUqrGHQqpqjsiEpkbT/aFw94AUhOL4d0U60lv0BbgjtyMGCBdjfCPXiKHLXhKKPG3CSPMzYDO8xnhLdpvdzhcrQP1/x4HIdZGaD6Ih6rTH3pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=AWic3lz7; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="AWic3lz7"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id 1TiHxRFaJuFzg1XSFx0jcY; Tue, 01 Sep 2026 22:59:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 1XSExQ0ol9tXG1XSExfF3Y; Tue, 01 Sep 2026 22:59:46 +0000
X-Authority-Analysis: v=2.4 cv=KK1aDEFo c=1 sm=1 tr=0 ts=6a9758e2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=y2ERv7ko0hlTFnYyMTsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=iXNZetiU/q/ap1rhP6NZk7Y9tyvDwvMyrxKwCTccJGg=; b=AWic3lz754FRJknq3+4zE9j3DF
	roUgnU59DKSA8FerByaELF35WjLoeuH41PAnhUI7GbclPMDVD6lISXjhdty1PdgAgjEtJo3Oq2cQs
	Jcr2Ni9IMYxKSVMpQY3wfId4goAFzRysamnRuXMMycTEOXyfbbPwK89dHa15siZ8ohND0F11iTwLb
	YmXLaNo0tVuulFFIwHTlePRVRO4fnDxh92dAhPiBHGSkQiiYbYa909eSJyZwYJxDyF/3WFE1EETak
	8um03KaG7OPSN+ff+l28tOgqADc7etH95pE7+iOxP8S9mGgPApKOPpcVzoAY2uqKs4Apajr2vxZRC
	FvR5nPpw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52242 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x1XSD-00000002ANl-491M;
	Tue, 01 Sep 2026 16:59:46 -0600
Message-ID: <77ea1387-4712-4289-a1a8-d2d849884908@w6rz.net>
Date: Tue, 1 Sep 2026 15:59:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.185608553@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1x1XSD-00000002ANl-491M
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52242
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDf3kRhvjfUcjp0bFRgZZgDqdqwB46rjQj9VUyflRjT/jLDTnb8DM78Jbikdz3pd1AQl6uZhIKQnTdM79g4HPdxWTNaWX9HZW9YVePFqXrz4RTQHuT6C
 qIeqjyP/N8OHKldftSQz7rCD2vBKq4iNJ4qPH0Obomopi98ypsdiCeSvaqVeToRNsdYb9NzjXSRkFw==

On 8/31/26 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.13 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

