Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842C5329E40
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 08:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770713732; cv=none; b=sbhjOD+KoytA8En6k5iYfL07aDVro+QYTQiT/OFQoRhgwI8zKaPq345ePsFjP7PEbnGTXmtFdQjYN6C+oTRbR5gsK7YpGRqSi6CNUR43vqU45hbQa53Nv8VjVT8Dpz9jbaXVi9/FKeIuRXi8efwCYGYok0UsNhbEoCO+ofojqYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770713732; c=relaxed/simple;
	bh=bWuW8A//YShuTXHPUwzvMwJr+2cZY0AFlBFHtKbEz3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMKRlXmvZa9J1FhOTbm7w1Bjd1G+G3uTTIbFQxn1ESp6BGJLHdcmKEEX9j2/g1wi1Ce5D1uK6rEZZQz63VTq4T1PlfCx2GNWQHUL706hA7sFUdkTliu3ayacL0Wx/lT7rJcCOnzFefe2ZJBWm/tJhGJEu8zhNu0b36hoTgXNcfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=su8fl4ql; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="su8fl4ql"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id pgQBvDiByaPqLpjWtvhKE3; Tue, 10 Feb 2026 08:55:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id pjWsvsDqCvXvHpjWsvH2k8; Tue, 10 Feb 2026 08:55:31 +0000
X-Authority-Analysis: v=2.4 cv=e4IGSbp/ c=1 sm=1 tr=0 ts=698af283
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=-Qcm0AZxhyoZnww38z8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MljNIwuBjtm56yXxQp+lCzhvVFK7kJFfM3Qf7jtw6EM=; b=su8fl4qlBv09s7TwW3YZTLqphD
	FRDhyocZDxe2uOuSK8NeoSLVah559RRchooo8sgsbvS3tCW7sJYCjE87W97YGgThcxzt2fnqp692h
	1MbCmjCQIC2LAxy4cDkcsX0mu+83CUpgKQLk5oVtJNZZdxL6yA+XLdqwY5JSEAeonJWDo0sAFozv3
	cnRKluaGDGLbB7+I5RDK8wUBZOMkMC/3KBCTdscHjIHb74XGswi1zfhNyaaSDnNusyQkYz/f72FN1
	ptJfnW9LGf6kMCYHxOMJhmr5+BtiShhXeETcJUsQnZOaZOmF2FVTlsYr2vi753gS3PUM1dCdFP8oo
	soGMNwxg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:49842 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vpjWs-00000000L4b-1Y3f;
	Tue, 10 Feb 2026 01:55:30 -0700
Message-ID: <4542559a-ed5a-4ab9-bdae-0978b2dc4b49@w6rz.net>
Date: Tue, 10 Feb 2026 00:55:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142301.913348974@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vpjWs-00000000L4b-1Y3f
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:49842
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfB6gyu7j5Mh0JXAb37UgR8koN7dkuCCVlZqUv4fRk00mxp97yK64B74e0FknbLt7cGK4JH/CEZlcEP+dxJo+5JhUI+A5ofeaSKp9J754sMqMv8lTwUvI
 emrzCR8R6fhS3/qLIGc2/suh2SviZ/5TBC0x8RnKT1GF8dpj//HTTVYdOwLDv4VFNHJHadTORFSMUg==

On 2/9/26 06:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.163 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

There's a build warning on RISC-V.

arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
arch/riscv/kernel/probes/uprobes.c:164:23: warning: unused variable 'start' [-Wunused-variable]
   164 |         unsigned long start = (unsigned long)dst;
       |                       ^~~~~

This can fixed with the fixup patch that I sent for 6.6.121.

riscv: Replace function-like macro by static inline function

commit 0b1ac9743f3d9cfced2ac3cb9f274c0675bd4189

The cherry-pick applies cleanly.

