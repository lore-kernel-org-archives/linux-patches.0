Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBABA13DDCA
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 21:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717795664; cv=none; b=e9VwAXlCo9JRWq87ldtN28ZMlSJFilzlT4b4cgt9t6bKCHeQWiXbMZwgvBWafF6GszsbI/ik+i1JwsJCDmMRq1wXg8kV1L/40sBkuT1EdGO7pUzD85dCoFjxXKJb/MGIXtep2CrK4P0Vu/E28YjtSSzy+mjDh+AVyZf/cKjc1lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717795664; c=relaxed/simple;
	bh=ZPuFZKttfZPulV5IaRPANoOhqXpJ70gy/fKhUuaahTs=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=FKTRi3IiY3vKOZ12GUu0GVoVw+aKvu0yh3RK7QQ6mZeuU3Ec4Xs9n6mwnbIl6USeuYoM7kH/ccUzigxhAxYzgI0r7+wGa0cQ69kjQJ4CTf7/3v02jV7vp/C6U+HwRB0dh6g5TGLxWPPZPLv6zOM/bGLqjz6lG2uKS4i0Um6vaL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=iRxgpEEt; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="iRxgpEEt"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id Eusms8XCqAidIFh65slHhB; Fri, 07 Jun 2024 21:26:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Fh64sWkkUT4CbFh65sgpfL; Fri, 07 Jun 2024 21:26:05 +0000
X-Authority-Analysis: v=2.4 cv=DPKJ4TNb c=1 sm=1 tr=0 ts=66637aed
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T1WGqf2p2xoA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=3U1NTj930rUM-GEF0QgA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5LHh8fR0sES3yiMjx4HDlmOjuaAq21T/2pjAOVMpoBc=; b=iRxgpEEtjLWEugBtH3LOh2yAMe
	aKUBO4XRcXk80J+Cn0rjlQ0r5uy7GojX1/LY4dMRGy6JNAm2BRyRlS7DgZ/Kprtf0XZ6gGuFQ5nS4
	+OzsAfK0zsVdmkIpCCTgrpMJtwleonRIHc9j+ym0/tz3KKdGfxQb3lvOsJsNIgJFWD+1S7/gfSNDB
	fYdegESGn8f7FKlC8Ap0QjclRBErbCwS02+VYnTzgore8bahxk+BtS9HW00i8R/U60i4zK4vfyGwM
	xcmej7semBJmr86qTYHOlNXoNdQdYC5JQTZQ7PuRcdL0+RPcM1fkm6RR+4Plv5TjpPI5bI8OMIxtP
	rYJhPVhA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:42382 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sFh60-000pSF-0o;
	Fri, 07 Jun 2024 15:26:00 -0600
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240606131651.683718371@linuxfoundation.org>
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <d5e4d0aa-438b-7f76-0bdb-471d6569baef@w6rz.net>
Date: Fri, 7 Jun 2024 14:25:54 -0700
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
X-Exim-ID: 1sFh60-000pSF-0o
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:42382
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfO2/7643hJqe1L76OUZ0uAv+4sA2FweCRvbrb4FTgXRTksjp5kdBx/K41qTF/QOFFOEAUEaPVI9tHl1OLj9tso4nxzZystRPpItwZQs7/WKOhq9/NRmp
 suArfcsnK4oVDZUb7wEEszlGed7zrkwZ1KlwXiq4hgAMFsJ4gSLwzaRZQiXHJDtPoemWlb3oFZGuGw==

On 6/6/24 6:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

