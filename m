Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0219B360EF4
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 06:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783061175; cv=none; b=V+CzNQ5303p9ScO2vzAAmqxf0+UiVJygq2zAyoe9L1rD2pQjicXuw7JK9TUh4D8lq1LXQfw4Xhu88+h/nlXA7y3scZ7QpZH6p5xs1NFHmGEJRaBFX9T1tUtOiSL72rqFIH10NHe3uyvHtPDLqLyGU6l7+/mRse8G5xCZvVwGHCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783061175; c=relaxed/simple;
	bh=k38jnddNnUzVIvvhaTXkexVYvVuvZeVblg42ctx6FJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KvSWhYU+wFMsjMYkehGWyyIu+kMr1zPzQaQejcQQed1lEulhiQgvJUpH+isxF7jlOuWzJUz7U/KVYh7IA94eLR+bBIy9qkt4OPlZHOJLAojLOmfQJWK3y06M40kt+0h7deRlrgg3OOpDun8hmLfCpyCDYgW2A9X+Zx/pkph0KjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=KFnHNxwd; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="KFnHNxwd"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id fOVwwMPEtMFEgfXfBwkBOp; Fri, 03 Jul 2026 06:46:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fXfAwX3ihFb3lfXfBwZ6dG; Fri, 03 Jul 2026 06:46:13 +0000
X-Authority-Analysis: v=2.4 cv=Xo36OUF9 c=1 sm=1 tr=0 ts=6a475ab5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=QUYbzp3p0A3I4yDEf8UA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nZ5D3d78yLBbic6m+GY4XdImQCewPQ/EC8ilIeuUbU8=; b=KFnHNxwdG2jWSqpJOpnQrOi6EI
	UJQuwekYTgEra9pCXeeey83k3IU+A9/VQ9G7bY2Gmcpv2qfi2ow9pbqXQCvJgp0PTbzy4BXh1/Bmy
	UijfMF0gp527vIGJCeyVk0/oxXnjE0dDTxsHDoMdBxlhDcmXwfzVXU97V1dpZMt7vvdIRD3mV0LNO
	dRCy7hIrxsfYFNS7VS5XMVggycXXGhMyA+0eF/825GRU3nY9hWhR2S3gsZo1RY4CVg+BMwf/o2O8u
	VihcRoEwp3/vDFj+czLGqRBmFlMDezfdQjaCbYQ48HYSWcaCxlYDS/wZqQ9R1OkK2qtnsZTrIux/P
	ggJ/YG2Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:47754 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wfXfA-00000001B2S-1xnZ;
	Fri, 03 Jul 2026 00:46:12 -0600
Message-ID: <0fa47988-5c74-4cb8-8617-9e3902fee162@w6rz.net>
Date: Thu, 2 Jul 2026 23:46:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/95] 5.15.211-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155109.196223802@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
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
X-Exim-ID: 1wfXfA-00000001B2S-1xnZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:47754
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMqmPHhC82ul8nVohr9+Sl+8SREE/P/+s3ymmRrbGW0znTD7DKZCt8GQdBO1odCsuhzMPM3IwPx9aD4LWPQ5OWx9YsgUgDc6H4QkE7xavtt4MTwOHj8w
 x+W0rnI4ODXxETXgv0jRPuEHDZnhk7KilIa9YzLG8fh/xAhnpWr7gS03I36mpC9mwMtHwFKcYo+rLQ==

On 7/2/26 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.211 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.211-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

