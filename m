Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16E91EB5F8
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771482794; cv=none; b=dgoQX1ZwRPJI8G/So5zLQVOxKjqwtITbRC0xfTpP2F6dTXm1PEyDEdlzIStFKPDWXID4Sk/b08OgEPVJf4tlR+W818+0B2ZpBqfbGoupYxoN0DRujRhZL84MkpVb8sbsUH3fgc8gN6k1qngZq/Z5JQrwk9QjNymFhscP3V/uctM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771482794; c=relaxed/simple;
	bh=XsoFlvxp6FxxRhHi1sZ2WwyobapliiEI8wypnbAhFbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o6F18NMxPv069Wy+5uaxk6+z9qwjhYAOAvquJyp3WUJFyZn3X8YDbqKX3faxMDqCoPFmHu0rgxbC4gmGZRgqJ72KH9dmkYhtTkSZplvB0lYDvu55wcksJECK6skmq6r17M/O/tohv03nVm3uDn1n0JiOKTVxsq2GJlMukNH+Ii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=A1yovqF4; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="A1yovqF4"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id sx0YvrrPQipkCsxb6vuUPs; Thu, 19 Feb 2026 06:33:12 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id sxb5vQ5bKhoT4sxb6v0acL; Thu, 19 Feb 2026 06:33:12 +0000
X-Authority-Analysis: v=2.4 cv=XZyJzJ55 c=1 sm=1 tr=0 ts=6996aea8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=x6Ducos6UYMGwXt6jLcA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+43DTqjt6IbB1Ibo0/tSHYQRMKqcF5sPAef5OGLnNDU=; b=A1yovqF40SumacUma1lVsOK0Rh
	n2VlPfYYPRgk2Xz7lXxNd/f5PX06dRghDoz7awq+WP7aNyhoqeEN7j4TNPhAx6wFyX+cHzVrz4BQX
	JU3w5aqC5aXxGcCzvqFpfdwR5IrAKuYyhTA3rhbNk0JPp6iE5AWUji5tJbbzLS/xlEMyX1vMHKKat
	697Shqzh05rE1xDefgVE2pFHaAaTha9IzEhOsnpkeHJ2NSm2SYdKRirx8RS+QRshoHHPZYQM9qJnm
	kNoqctF+RvWqxpj50P7PXafDr+FPjUdN/zj2T7AOs+GU6qUwZHadBun/H0KuRhIzxuHt6KZBIxdfK
	s6FpW8OQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:45174 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vsxb5-000000029v8-2E7Z;
	Wed, 18 Feb 2026 23:33:11 -0700
Message-ID: <8135e1ff-c51e-458a-8b58-facfdd40328a@w6rz.net>
Date: Wed, 18 Feb 2026 22:33:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200005.998240758@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
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
X-Exim-ID: 1vsxb5-000000029v8-2E7Z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:45174
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBO1i6BEPbaVvQFRuVajcfyjk3yChaX0MFN+3i+uTt0AU409Iwc2eGATL30qJhU0ydvba3H6BMyv8kfREQDE8ZwIHc2WXtzbLFbYA5IdsSd4kKsn7WVA
 uwAfw+RDgaC0m1O9729kQ/6DdzKf+dDMTuR5/m1yxgobG4RfFgNRX/6Uhv3BqKv/6AO9Rrw5hmYNjg==

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

