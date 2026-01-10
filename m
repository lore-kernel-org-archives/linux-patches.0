Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C913126B6
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 06:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768028383; cv=none; b=q2b5Pn/FlY6OXItOETA0mdd4nXTTE0vgfvo+exIJ7gOACvduKZVyENuxLLQZpv6AinTB9SK0fi/N7dWQcTPrNfnh3fJjiKzb8Olb+bP2v8IrzeiJa0sJ0xzzSWdhvimq4LUs/EIrc3M1hrWi4vKJ7ox3OdRGOKon8FKJEACLBE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768028383; c=relaxed/simple;
	bh=/shlJGYEA0xYOZ1tFtpmb/V7ZYXkfb3Z3cAlF9aBWJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQh8VUvDXNBgj4AghTaZ194LBzZ1i1YOmeLuRrv8OhvwjVc1sA3m7N7cEcpfuEtygmQ4dm8izO+981G9BxR122MKO60LohcQ8Io8FSmlz8XubUmJ737A9TSSXc/8dRxLR0jjoolC4o1b/cagsfScA1CknmCHEof6Mq6oITqCDUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=XecAkxsT; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="XecAkxsT"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id eS3gvAt0GKXDJeSwhvcvHT; Sat, 10 Jan 2026 06:59:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id eSwgv6UoUN3K1eSwhvzrHl; Sat, 10 Jan 2026 06:59:35 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=6961f8d7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EPAX7UjPDkCswNbf/h/soepg9GqGs4jn7bLN/8CMRuw=; b=XecAkxsTWK8VUPSHBIAeCeaQb9
	i3OGzwa0pGYbJWL+1WC0YFGdDtnr7WJ3geohng1J8pslftHC8EQorI2PRFJOuLjxcBTaRn0OzMVcE
	ATKV6TDbJx04NZj/p84LC60TQxOBzHKkzfI3vajVq5fcMRvDFt9rLJ1y4GP7/w1RUoXABpb8wgziK
	ORSoGIwiyqT70jwh1qPWyszzRqSdF91nvwl4aLEj+iGpFPqgJINwSbULt1TX5GURu/3A5ZVhYQBwO
	YhQp/2fVN+woIuOH5Y1zGw2rCZ8BTNw8rw5f1bveqEd305O6dPCRDJF8oguivxePFEVlWn1/QqmHM
	zOGqZNPQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:33242 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1veSwg-000000011xC-1seQ;
	Fri, 09 Jan 2026 23:59:34 -0700
Message-ID: <4843c592-1586-406f-86a1-bf3ec268b7db@w6rz.net>
Date: Fri, 9 Jan 2026 22:59:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109112133.973195406@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1veSwg-000000011xC-1seQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:33242
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBDEQdrOgsLFYzypKTFI+anrxz1LBk5ecLwhCB+sQ68CHLzaUXyszvf4QtOo/7ADQivpSm/mOQWAE7YOiI82vv9Yp2ZpGytTQPwCwPg5SqIY4BOcfyKA
 xusTClre+DgmB2KZUCRy7hpNcDdMwBycSPrPsz64Ny6B92VRwS+XQgTbMdiLrA+25A7IneuhZlxEww==

On 1/9/26 03:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

