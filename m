Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9B6175A8D
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 03:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790221651; cv=none; b=QssMIab3CJ+RpXQwg80HY57QSeEajxosYywPxO4K2OlDJGFu7N8HFnTFNkmLV9+TiUMfdE9yEAng9xpHyu8zIU/zHxEnd5MYB5C/Of6F6I+QNWfUWeGpY6dxPjCR9Kdl8AnARNnaDjUvJsxnaglL/+DjfSVdG0nfgkGCnHqe604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790221651; c=relaxed/simple;
	bh=UJpuC6kL96Fm6TTcxJ7pVWPBLdTbuI0enD37TKsdgsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cDOaZxwiGLHs+VpruaNMK7QzYEVXHCyXNYSx7YUtKCw7ov3MGcYVyXqkhxqO0PpmYzeeMpgXkQXsR4cvr+WF58OASytqO84pWzXJZhuz0YYvuLUuijGjqU9FOe9LZHm/TWt0GF3CV48T54nCM7g3PAXWMZeBS1u+cwA6vqsN8PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=k0expePR; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="k0expePR"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id 9ZK5x9YAwJFmF9aQixwFs4; Thu, 24 Sep 2026 03:47:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 9aQhx23R4irxP9aQixm3V8; Thu, 24 Sep 2026 03:47:28 +0000
X-Authority-Analysis: v=2.4 cv=FqoF/3rq c=1 sm=1 tr=0 ts=6ab49d50
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dxQna+mJyCla1tbONGbUxmkkAani4WnRs543EJziQnU=; b=k0expePRDgGz/eivSlUsqIl+31
	gCYjdQAvPoHcnMpLEXGeHKyncU32sM62e4c1RsxtvQWQXM/G48q+pTCNI0bSgrzjHNjzocZAGoMQz
	x9fVks4CHwbpcQXGvbWoAAPSJTfTdpJW08P+g/VM8H1sWo8qQJwpRqs1g8mWTQ8yN6q5sNRK0lHUE
	ondN0va92iDLVJE7J94tW6sHnI02p3ymxcnSGvDRoxv/P4oEfxT9DO1wtvKs+WQmg3kzjj8R1blrJ
	bIT1y5DGXjvph+t7jd9ZGPyw6y6fv+vfRnBizkf8gkdu4rMtttkuroSsn5GnfYFmXLjoDP8b6z0x8
	UdUqgg9Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:42298 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x9aQh-00000003oT7-0PYV;
	Wed, 23 Sep 2026 21:47:27 -0600
Message-ID: <2d6ba581-d9ad-4ca5-b850-2be01780014b@w6rz.net>
Date: Wed, 23 Sep 2026 20:47:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260923140644.756254324@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
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
X-Exim-ID: 1x9aQh-00000003oT7-0PYV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:42298
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMNz8+wqGa4xY7w2/CZmTOohJNurcYbZpyun/dvFQL687StvhnIxl2TkGHsm0bVTUwHeBfz36cpB9BqvNoYtRg2HKxZ12nPWKav9DETc+f6j9Bh2QOxb
 mm6iwpT9k83VToCfGRTphcl0OS6qeQHFKm7zEwqTEnaug16xEqkGE9fWt+ILOphcbljxnX8ifAItVg==

On 9/23/26 07:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Sep 2026 14:05:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

