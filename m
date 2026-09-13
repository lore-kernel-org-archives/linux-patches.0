Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0063377EB2
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 04:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789275101; cv=none; b=FmWQD+VFVUIPyCM7/+FG5Hcig9vDs7dr/yuLXWC36tupLIr7/J51g8qzsk//OJROJnkMXg9PxwDBx4zME8qq2UqvLOb26Wb1Y0x7wm7pVB4ZwJFfB32xCnjMudBzSahMqJnzsBTBeHtOq7zZOi7AqsOalN1bSsq4KtQDSW7z0AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789275101; c=relaxed/simple;
	bh=riqhjdxkRBkvxB3LDmbneXn9/sVUuHNIXDRY5M7fZ7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cCuOrB/mCDoFgJlZ5XIkU0YnREcFULMF4R6FXnM2HqnxZ4SfrFzHlkgsdWeF4ra8Nc/uEuNFuY95leNUJQOpbDa0yhq5YwNnLLgRqlJ9VxuTq6/xDwfjP5MUv1SmqyxkAVkKEM+5IwmY0B+n5WZ5CtuKCdLxdZdKWj7UBAsSDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dxurdNaP; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dxurdNaP"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id 5IeZxAMjGuFzg5cBgxRF61; Sun, 13 Sep 2026 04:51:32 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5cBfx7U7dn6N55cBfxkWwh; Sun, 13 Sep 2026 04:51:31 +0000
X-Authority-Analysis: v=2.4 cv=LJJmQIW9 c=1 sm=1 tr=0 ts=6aa62bd3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=ce1hCls_XIKHtnsIUTMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HFYvZV0lkk5YLOyNX4ir+GTDpvVKyz1OJRjbRGZmw5c=; b=dxurdNaPhGR88mVAYxsmdbPY+p
	b+VGBI1FAsPwgp+FihCnYOViuCmAanKDJQ8Ss4iQ0Ub8LyMeFV6oPTMNDsbR3CKz4ZbPJtUvC8pot
	1UN1tlxB56EZKmRO1081v+9EzcpJQMcM0VBCnEfEoGJh1QKF8jz4WwdJve1a694QKj17mZWX2wwt6
	GdTXEZaR79qmeidUs+SvVdB6QkV405B8KbwHADPRDSluBP/7XBpUUKmLMVNCHYDHBnN74Pcu9EeSl
	UK9DE8rVTxts1xqriQIcTYoKViQD4Q4HQbROSZ0LMeVG1Ree+x6TPSKrQhaPitOx28RZozrqxqMPj
	oveiVYFw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:34500 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x5cBe-00000003rtM-387K;
	Sat, 12 Sep 2026 22:51:30 -0600
Message-ID: <aa7f30f5-5fdb-4d68-8adf-b70f1286067c@w6rz.net>
Date: Sat, 12 Sep 2026 21:51:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1424] 6.6.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065607.279695368@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
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
X-Exim-ID: 1x5cBe-00000003rtM-387K
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:34500
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHEgbC590YhqQdezmkftdGYfScl0+8vdjUtS3QDk5hJ3LxsBzP+gNG7WTzibSUF/TtTLVwt49gbQJFIOo28AfPwzKQEj6rrsgW5MITYqsJ4lpilG60xE
 T6JXxDZ3Vf8C+ZCim8TUqtXzvxKvhRXhChBrBBB85Y8LeP3EUpWsYhmM6O2KlA9uUkz6srSSNq2tYA==

On 9/11/26 23:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.157 release.
> There are 1424 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.157-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
>
The build fails with:

sound/soc/fsl/fsl_audmix.c:461:12: warning: 'fsl_audmix_runtime_resume' used but never defined
   461 | static int fsl_audmix_runtime_resume(struct device *dev);
       |            ^~~~~~~~~~~~~~~~~~~~~~~~~
sound/soc/fsl/fsl_audmix.c:462:12: warning: 'fsl_audmix_runtime_suspend' used but never defined
   462 | static int fsl_audmix_runtime_suspend(struct device *dev);
       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
ERROR: modpost: "fsl_audmix_runtime_suspend" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
ERROR: modpost: "fsl_audmix_runtime_resume" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
make[2]: *** [scripts/Makefile.modpost:145: Module.symvers] Error 1
make[1]: *** [/media/re/nvme/linux-stable-rc/Makefile:1885: modpost] Error 2
make: *** [Makefile:234: __sub-make] Error 2

This is due to commit "ASoC: fsl_audmix: rework runtime PM handling in probe" commit id d1bfda1ae2d648da3967ee969d65caac0e47fa81 and 
I have CONFIG_PM=n in my config.

