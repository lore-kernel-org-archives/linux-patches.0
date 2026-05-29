Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3263F39D6F2
	for <patches@lists.linux.dev>; Fri, 29 May 2026 05:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780032517; cv=none; b=un46/ErFUc70pf3XPxQKKrMt7w7/jzb+/x+U57Dhe10Gd95EQgz2Tfdx49V95llkyerCkj2PpOBGzQA99AeJRfXyp8paAGBcG8Ip8mbmtkoGan3zNSufHu2jvOC/QaV5zbwyPQdIu4UlxqCxpaEtlJHQgCBPYs+WSv1fMVpei3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780032517; c=relaxed/simple;
	bh=umRKgTKv/mlaA2hQOauf4O84QeKfa7tACY3ArzybTy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CbeSD2A4WJxR3RWYQofLxvtVGIE5zrQgxVZ+55OAmQ6eWWkOT3T/omNcoOYvZ30TNYG96DY5EsZNRgZCiifgxgD+9hPGwUd6dxyDP4SYJuM4NNHG3gQdarTJMFm6T6haU78+v/TQ0BgLEYM6xFc/yPrRUen7QOPrFVOVq10tJLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=eu3kTtlO; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="eu3kTtlO"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id SeGJwnlmMlPo5SpkKwXcQH; Fri, 29 May 2026 05:27:00 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id SpkJwyunMcYN5SpkJw3f6k; Fri, 29 May 2026 05:27:00 +0000
X-Authority-Analysis: v=2.4 cv=QN5oRhLL c=1 sm=1 tr=0 ts=6a1923a4
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4qGJOhxj/tobj71wXIacd75nrfMEZAVXHSSvK+KaQ5I=; b=eu3kTtlOxZkKxBEwlxU0VgoGDB
	NtQ6q2B9BUDR6//aRo3RNy7i9phkeLFvKM70qAtq0kff6Fyq/i92YDoN5xjG8EfGU+QP3FAfBUCTL
	CmHYNqSj5w3cF/YrqLKeJzLfwA5e0NAgdLZKNdgZOuLPASUepU7sPCLuHg0DKTbXrPBLjhFNtZ8O/
	E3EdI8rq7WSIr84HLazDFsJzcIRTBM8jltVOl8jYoPAI1M7ibBFIsEqRSLNfQ1vUjDWPs2G4q8eOG
	G0RdYWp+A8t631dkq3RoZuOdU9O7vaFG5T6X/Wz4Y2I88sBuy+RwBlesi7yZfxT4ga3rm1p8ImENq
	+fV8xi+Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:54408 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wSpkJ-00000003rz5-0c7h;
	Thu, 28 May 2026 23:26:59 -0600
Message-ID: <e794102c-e0eb-452a-ac60-431af64beaaf@w6rz.net>
Date: Thu, 28 May 2026 22:26:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194646.819809818@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
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
X-Exim-ID: 1wSpkJ-00000003rz5-0c7h
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:54408
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNA4lTM2bW96nVuV9LzS8wpKHoKZwzvYNQGhyAV+jrNWXINybXGM2UzRwUMdlCOqpy/1t9MxqI3BZfEvSUA6yEXe9glRXBCLncfnT8htt+h0m2CTh0kB
 mnVV2HJifYh90HuGMyeBZDqt2M39J8E+eM6ksbisvEwKY1ar2Lo6RCHQraU3G1+d3A4VuRpxEN/ESw==

On 5/28/26 12:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.11 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:45:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

