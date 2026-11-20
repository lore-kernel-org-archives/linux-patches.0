Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795146025;
	b=piBCTz+ExAFTjCF2kkOH+NciqMK9zQFkfgsc+l0ZkkPqTMp6i9yVFPaU8ZWqFpq99Ai1
	 e+1e4Q3L7rpM+bJohnvl1fnmpxpC2TQeK7shSumZJ8Egd/IRcdCR/RjB3xOj3EjhsDOGF
	 SX5vI67wz6Me51OJ7kveYCxounIqDb5l1wBbJgj+O90MpE03JeohCma+XgxZL+v8iKUx+
	 UdKI8vCoTavoNIfVNO9KE9cY+kPkorqxls9OmaFQM/O657U7y0ef6B2zKwptYOmgCcdaA
	 SYUUmWpVMrCPnu7NlS4JtZBgxPIQyYdK6e93j1qPn8V6Bm0pf6oM12fXrfPAn4QoO6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795146025;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=xFEuU+Ig2XWSeIveBUY4FuqtWKaIuk8y+p/wf34XVVc=;
	b=AqyTgNK+pq/yLpQFv88h8Gtm6Zll416SAqGRQsJrrEvLIpCF62jZWnTvlvcgc1/eII2v
	 HAer8GiXXF88tR76wo6fSFiaRNfSxQ65cS/B6IfcoI8G69INQpsK7Q+W4CAt0QrSjdwtK
	 /sfC5Qp4aMYJt6lwvSxhue0CR5QYPKdVEn2VEyLHbb7YhmhK/KEDxmTg8nr7ievrgh0jr
	 VKL1Rt3ybpjeB/+bEh2QOmbZ9In5WAopN42kYK32ueq4J5iYB2r5/BZFC8GZe01k8NNYg
	 3OOAhUFH+jwidA4Lpd8DR5B9/iI42yUyqoPOysBUTmsEHF3oaF4xg1hbn56kCtaqYIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=e+AOtmR9;
	arc=none smtp.remote-ip=44.202.169.39
Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46280606A326
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 03:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46280606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=e+AOtmR9
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id UBBNx3EKFOOJnUFU8xi8Cq; Fri, 20 Nov 2026 03:40:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id UFU7xq4Pmxmi7UFU7xi1z0; Fri, 20 Nov 2026 03:40:24 +0000
X-Authority-Analysis: v=2.4 cv=KuFN2XWN c=1 sm=1 tr=0 ts=6affc128
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=uPKWhRKihB2-fsaYkyYA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xFEuU+Ig2XWSeIveBUY4FuqtWKaIuk8y+p/wf34XVVc=; b=e+AOtmR9kjpy8RYN0RrliqALDF
	Ej8CpKgTzaTFvsnm2kFygS1Wmg6EwWWZB1Z234Dzs4ucBrHaBnR2HrA5tpkFPM1eDOSHiP87N//FC
	8Pq9fYqANmqJgJNADZvHo8QIUCE9FjKDVrqMRQjaAp/TuJxDM+AoiFYOjQdIeApRZEwV7GTmmx/VO
	JS04XJENot0CePJsd73VnPzVZMc5I2QeA/8Lx3p/Y8H6TDT6eL26ESwF4E7Y9bQSvWJ9jzMSUemoq
	FXS/83DCP/Woo0lCTgisa66ZIezwt7m7bIxLr+uZng/u+2H+kKEp8RizUJSLu7hO5HkUqy4t13OKK
	epTec/yQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:56318 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xUFU6-00000001Gjg-3Vnf;
	Thu, 19 Nov 2026 20:40:22 -0700
Message-ID: <c27462a9-17f5-4638-bff4-1189ba5fca00@w6rz.net>
Date: Thu, 19 Nov 2026 19:40:21 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/3318] 6.6.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150313.527275416@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
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
X-Exim-ID: 1xUFU6-00000001Gjg-3Vnf
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:56318
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGdvz1lyrtj+mtY2kFUs6rpmS8uPAiay/RB4eji3mzD6g4ThxtTJMCAt9wvO40xEJVHA0WVAJJXHYusNHvOEIzGzC7ki9Mcpmp4RO5xac5Ga60Ng0xjH
 JKGZGgDgb78JJxT2NS3QC9MQttDvxuk+nBXwbOEM12ylAFbqFrTLBAnWKufzzUB5MHYsyiHngW0Isw==

On 11/18/26 06:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3318 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

