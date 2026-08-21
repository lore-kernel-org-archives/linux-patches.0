Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10DF3D3D14
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352247; cv=none; b=RXAusKgu9H5bm2pqBc/q8zGCRmoQPYOlxBhkVkc/Im2vwn4OnvKxCAz0Ovv0FEIvzlm3rFX1Pn3kGwz24l3DhmORiEuXEhSR0AQ+MlRh3d/sJBlDMd85uOLZctJf5Nt35P7IySapr7/8oiKkKlKrD0uNKfqJ03o31+Xk3VxOloM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352247; c=relaxed/simple;
	bh=BPcQxXt5l1xHpagScOu4KGPZqjZdyg3NFcWWpLplYJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I1ieuuthYYcUNk1iws2VaszcCCvuoLDftBhrLbleqytmD/38rS2DwuqhsJXlP3Lj5v6OiKUNBNlf1YvjZ+LD7GiWe61bY22X0o1EOabJKo2ksPj7kiA3S2LeWuYOo8vCN3x7niQJi8L38ufh0CybxEjNjCPvnOsMQvGCjKKH0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=LeXo/YiV; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="LeXo/YiV"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id xMjDwkNEjJFmFxXxzwcEuk; Fri, 21 Aug 2026 22:44:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xXxzwLRANtyrGxXxzwlysU; Fri, 21 Aug 2026 22:44:03 +0000
X-Authority-Analysis: v=2.4 cv=JaK8rVKV c=1 sm=1 tr=0 ts=6a88d4b3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=9znkghA2arZQ6fEvHFMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NiLO3zIdabf8mwOPaDrJzBEtIO6T1WUbo5xsOakXWl4=; b=LeXo/YiVKe/F8fU1FPtjL/HD5T
	CRUx1AjEIC3sRr9DAgIw7GCzS7LZnG1Z1BijRbNZhR+corbLBrDXqpgHOsrYn+SsMUZkFsd2LGwK8
	aKjYu1d9n1gdupIsSCt9js3T0ZEERiUxz0M5/V2ZnygeLkd1t7r37lyPhItjLVkMdDbXCmUu1wkbJ
	XO+9k21el8qynDzi8EtAJbwJcUOwHj4JAFZ/Lz9IyH4lgqj4L0d6cTG9eOE3oXjwpEdcVCXiHIfrC
	SyR5OxC4SPrbKyI3SZkw101aaxkbExeKjk6c+EXxfsF+ANvEb7qCPJlaIETzKzibdzJwwRGRiHhBg
	s4HWXkKA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:35834 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wxXxy-00000002HdN-37XC;
	Fri, 21 Aug 2026 16:44:02 -0600
Message-ID: <47bf243c-9f42-4aff-af63-54af8718aa4d@w6rz.net>
Date: Fri, 21 Aug 2026 15:44:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145237.531699751@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
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
X-Exim-ID: 1wxXxy-00000002HdN-37XC
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:35834
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfITVqUX/XqshbLDMN4mEPFb6KeJhjwiQCFTXzDL2E/lItFeq6WgyRGu/tld0IUw69SZrjcRNeJ/rhcdRDj+v6TIbUP5YcPFarPE0kHcmX1NKyNGPJ8S2
 I5hrtMTYRDbb5k19vpmhYVZryuLITGAynsgJQLmL/ywMNKzputurFcXMjQ7kZPG0KkdMI5p/rw4eqw==

On 8/20/26 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

